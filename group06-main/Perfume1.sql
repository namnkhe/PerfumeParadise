--remember to run sql before running java because if the database is in use in servlet, the script cannot be executed
--for re-run, save again then re-run to avoid lag
USE [master]
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Perfume')
	DROP DATABASE Perfume1
GO

create database Perfume1
go

use Perfume1
go

create table Admins(
ID [int] IDENTITY(1,1) primary key,
username varchar(20) NOT NULL,
[password] varchar(20) NOT NULL,
[role] int NOT NULL,
)

create table Customers(
ID [int] IDENTITY(1,1) primary key,
[username] varchar(20) NOT NULL,
[password] varchar(100) NOT NULL,
[fullname] [nvarchar](50) NOT NULL,
[phone] [varchar](10) NOT NULL,
[email] [varchar](max) NOT NULL,
[address] [nvarchar](100) NULL,
[gender] [varchar](10) NULL,
[avatarUrl] [nvarchar](max) NULL,
isActive bit NOT NULL
)
go

create table Categories
(
[ID] [int] IDENTITY(1,1) primary key,
[name] nvarchar(50) NOT NULL,
)
go

create table Brands(
[ID] [int] IDENTITY(1,1) primary key,
[name] [varchar](50) NOT NULL,
[image] [nvarchar](max) NOT NULL,
)
go

-- Table: Perfumes (Depends on Brands, Categories)
CREATE TABLE [dbo].[Perfumes] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(MAX) NOT NULL,
    [price] INT NOT NULL,
    [quantity] INT NOT NULL,
    [size] INT NOT NULL,
    [image] NVARCHAR(MAX) NOT NULL,
    [releaseDate] DATE NOT NULL,
    [bid] INT NULL,
    [cid] INT NULL,
    [description] NVARCHAR(MAX) NULL,
    FOREIGN KEY ([bid]) REFERENCES [dbo].[Brands]([ID]),
    FOREIGN KEY ([cid]) REFERENCES [dbo].[Categories]([ID])
)
go
CREATE TABLE [dbo].[Orders] (
    [ID] INT PRIMARY KEY,
    [cusid] INT NULL,
    [orderdate] DATE NOT NULL,
    [address] NVARCHAR(100) NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [paymentMethod] NVARCHAR(MAX) NULL,
    [paymentStatus] BIT NULL,
    [totalAmount] INT NOT NULL DEFAULT 0,
    FOREIGN KEY ([cusid]) REFERENCES [dbo].[Customers]([ID])	
)
go
CREATE TABLE OrderDetails (
ID int IDENTITY(1,1) primary key,
oid INT,
pid INT,
quantity INT NOT NULL,
FOREIGN KEY (oid) REFERENCES Orders(ID),
FOREIGN KEY (pid) REFERENCES Perfumes(ID),
)

CREATE TABLE CartDetails (
ID int IDENTITY(1,1) primary key,
cusid INT,
pid INT,
quantity INT NOT NULL,
FOREIGN KEY (cusid) REFERENCES Customers(ID),
FOREIGN KEY (pid) REFERENCES Perfumes(ID),
)
-- Create Feedback Table with reference to Customers, Perfumes, and Marketer
CREATE TABLE Feedback(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    cusid INT REFERENCES Customers(ID),
    pid INT REFERENCES Perfumes(ID),
    rating INT CHECK (rating BETWEEN 1 AND 5),  -- Rating between 1 and 5 stars
    comment NVARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    marketer_id INT REFERENCES Admins(ID),  -- Marketer responsible for managing feedback
	[status] varchar(50) default 'Pending',
	
);
--CONSTRAINT DF_Feedback_Status DEFAULT 'Pending' FOR status
-- Create Sliders Table with reference to Marketer
CREATE TABLE Sliders(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    image_url NVARCHAR(MAX) NOT NULL,
    description TEXT,
    link VARCHAR(255),
    is_active BIT DEFAULT 1,  -- Boolean status for active/inactive slider
    created_at DATETIME DEFAULT GETDATE(),
    author_id INT REFERENCES Admins(ID)  -- Marketer responsible for the slider
);

-- Create Blog Posts Table with reference to Marketer
CREATE TABLE Blogs(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_by INT REFERENCES Admins(ID) NOT NULL,  -- Marketer responsible for the post
	updated_by INT REFERENCES Admins(ID), --Markerter edit
    created_at DATETIME DEFAULT GETDATE() NOT NULL,
    updated_at DATETIME,
	status bit NOT NULL,
	image varchar(255) NOT NULL
);

go
SET IDENTITY_INSERT [dbo].[Categories] ON 
GO
INSERT [dbo].[Categories] ([ID], [name]) VALUES (1, N'Woman')
GO
INSERT [dbo].[Categories] ([ID], [name]) VALUES (2, N'Man')
GO
INSERT [dbo].[Categories] ([ID], [name]) VALUES (3, N'Unisex')
GO
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Brands] ON 
GO
INSERT [dbo].[Brands] ([ID], [name], [image]) VALUES (1, N'Gucci', 'gucci.jpg')
GO
INSERT [dbo].[Brands] ([ID], [name], [image]) VALUES (2, N'Chanel', 'chanel.png')
GO
INSERT [dbo].[Brands] ([ID], [name], [image]) VALUES (3, N'Tom Ford', 'tomford.png')
GO
INSERT [dbo].[Brands] ([ID], [name], [image]) VALUES (4, N'Guerlain', 'guerlain.png')
GO
INSERT [dbo].[Brands] ([ID], [name], [image]) VALUES (5, N'Christian Dior', 'dior.jpg')
GO
SET IDENTITY_INSERT [dbo].[Brands] OFF
GO
SET IDENTITY_INSERT [dbo].[Perfumes] ON 
--Perfumes
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (1, N'Flora Gorgeous Gardenia', 169, 999, 50, N'gucci_flora_gorgeous_gardenia.jpg', CAST(N'2022-08-12' AS Date), 1, 1, N'Gucci là một thương hiệu vốn rất thành công trong mảng nước hoa nữ, bằng những mùi hương khai thác nét đẹp mềm mại, nữ tính của các loại hoa và trái cây. Flora by Gucci cũng là một làn hương nữ tính dễ chịu và đáng yêu dành cho các quý cô, thế nhưng thường xuất hiện khá “le lói” trên thị trường dưới dạng những bản phát hành giới hạn theo từng năm hoặc sẽ dừng sản xuất sau vài năm phát hành trên thị trường, rất thành công')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (2, N'Guilty Pour Homme', 151, 30, 90, N'gucci_guilty_pour_homme.jpg', CAST(N'2023-07-12' AS Date), 1, 1, N'Guilty Pour Homme là m?t huong thom m?nh m? và quy?n ru dành cho ngu?i dàn ông hi?n d?i. V?i s? k?t h?p c?a huong cam, o?i huong và ho?c huong, mùi huong này t?o nên phong thái nam tính và l?ch lãm. Ðây là s? l?a ch?n lý tu?ng cho nh?ng bu?i t?i, giúp b?n t?o ?n tu?ng khó phai.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (3, N'A Floral Verse', 384, 20, 100, N'gucci_a_floral_verse.jpg', CAST(N'2023-02-22' AS Date), 1, 3, N'A Floral Verse là huong thom unisex c?a Gucci, k?t h?p hoàn h?o gi?a các n?t huong hoa và g?, t?o nên m?t mùi huong say d?m. V?i huong d?u t? cam quýt và hoa nhài, cùng huong n?n t? g? dàn huong và x? huong, nu?c hoa này mang d?n s? tuoi m?i và ?m áp, phù h?p cho nh?ng ai tìm ki?m s? cân b?ng trong mùi hương.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (4, N'Gabrielle Perfume', 135, 20, 50, N'chanel_gabrielle_perfume.jpg', CAST(N'2023-09-10' AS Date), 2, 1, N'Gabrielle Perfume c?a Chanel du?c l?y c?m h?ng t? tinh hoa c?a nh?ng bông hoa tr?ng. S? k?t h?p gi?a hoa nhài, hoa ng?c lan và hoa cam v?i huong thom nh? nhàng c?a hoa hu? mang d?n m?t c?m giác sang tr?ng và tinh t?, hoàn h?o cho nh?ng ai yêu thích huong hoa d?u dàng.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (5, N'Bleu De Chanel', 150, 50, 100, N'chanel_bleu_de_chanel.jpg', CAST(N'2022-10-02' AS Date), 2, 2, N'Bleu De Chanel là huong thom c? di?n và vu?t th?i gian, phù h?p v?i m?i d?p. V?i huong d?u t? cam quýt và b?c hà, cùng huong n?n t? tuy?t tùng và g? dàn huong, mùi huong này v?a s?ng khoái v?a tr?m ?m, lý tu?ng cho ngu?i dàn ông hi?n d?i mu?n toát lên s? t? tin và phong thái lôi cu?n.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (6, N'Coco', 165, 50, 100, N'chanel_coco.jpg', CAST(N'2021-10-12' AS Date), 2, 1, N'Coco c?a Chanel là m?t huong thom m?nh m? và d?c trung, v?i các n?t huong ?m áp và cay n?ng. V?i huong thom t? dinh huong, h? phách và vani, nu?c hoa này mang d?n c?m giác sang tr?ng và quy?n ru, hoàn h?o cho nh?ng bu?i t?i và các d?p d?c bi?t.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (7, N'Oud Wood', 425, 20, 100, N'tomford_oud_wood.jpg', CAST(N'2021-03-22' AS Date), 3, 3, N'Oud Wood c?a Tom Ford là m?t mùi huong unisex sang tr?ng v?i các n?t huong g? d?m dà. S? k?t h?p c?a g? oud hi?m có, g? dàn huong và g? h?ng, cùng m?t chút b?ch d?u kh?u và d?u tonka, t?o nên m?t huong thom táo b?o, thanh l?ch và lâu dài.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (8, N'Black Orchid Perfume', 155, 50, 50, N'tomford_black_orchid_perfume.jpg', CAST(N'2023-07-09' AS Date), 3, 3, N'Black Orchid Perfume c?a Tom Ford là m?t mùi huong lôi cu?n, k?t h?p gi?a các loài hoa và gia v? k? l? d? t?o ra m?t huong thom không th? quên. V?i huong d?u t? n?m c?c den và hoa ng?c lan, cùng huong n?n t? lý chua den và ho?c huong, nu?c hoa này hoàn h?o cho nh?ng ai mu?n n?i b?t và gây ?n tu?ng.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (9, N'Néroli Outrenoir', 355, 20, 100, N'guerlain_neroli_outrenoir.jpg', CAST(N'2022-04-24' AS Date), 4, 3, N'Néroli Outrenoir c?a Guerlain là m?t huong thom unisex d?c dáo v?i các n?t huong hoa sâu l?ng. K?t h?p gi?a tinh d?u hoa cam, cam bergamot và hoa nhài cùng v?i chút huong khói, nu?c hoa này mang d?n s? bí ?n và thu hút, hoàn h?o cho nh?ng ai yêu thích nh?ng huong thom ph?c t?p và tinh t?.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (10, N'Shalimar', 372, 50, 30, N'guerlain_shalimar.jpg', CAST(N'2021-03-30' AS Date), 4, 1, N'Shalimar c?a Guerlain là m?t huong thom c? di?n và sang tr?ng dành cho phái d?p, dã chinh ph?c bi?t bao th? h?. V?i các n?t huong cam quýt, vani và hoa nhài, nu?c hoa này mang d?n c?m giác lãng m?n và quý phái, phù h?p cho nh?ng bu?i t?i hay các d?p d?c bi?t khi b?n mu?n t?a sáng.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (11, N'J''adore', 160, 60, 100, N'dior_jadore.jpg', CAST(N'2022-05-16' AS Date), 5, 1, N'J''adore c?a Dior là m?t huong thom mang tính bi?u tu?ng và n? tính, v?i các n?t huong hoa và trái cây. V?i huong d?u t? hoa ng?c lan và hoa nhài, cùng v?i huong gi?a t? hoa h?ng và m?n, mùi huong này v?a tinh t? v?a g?i c?m. J''adore là s? l?a ch?n hoàn h?o cho nh?ng ngu?i ph? n? mu?n th? hi?n s? t? tin và duyên dáng.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (12, N'Miss Dior', 160, 60, 100, N'dior_miss_dior.jpg', CAST(N'2023-09-19' AS Date), 5, 1, N'Miss Dior c?a Dior là m?t huong thom hi?n d?i và tinh ngh?ch, v?i s? k?t h?p gi?a các n?t huong hoa và cay n?ng. V?i huong d?u t? cam bergamot và hoa h?ng, cùng huong n?n t? ho?c huong và h? phách, nu?c hoa này là l?a ch?n hoàn h?o cho nh?ng cô gái mu?n th? hi?n cá tính m?nh m? và phiêu luu.')
GO
INSERT [dbo].[Perfumes] ([ID], [name], [price], [quantity], [size], [image], [releaseDate], [bid], [cid], [description]) VALUES (17, N'DIOR SAUVANGE', 200, 12, 100, N'462471195_122183192246200103_7445046097395521477_n.jpg', CAST(N'2024-10-21' AS Date), 2, 1, N'T')
GO
SET IDENTITY_INSERT [dbo].[Perfumes] OFF




