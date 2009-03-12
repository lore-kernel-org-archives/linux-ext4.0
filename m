From: =?ISO-8859-1?Q?Jochen_Vo=DF?= <jochen.voss@googlemail.com>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Thu, 12 Mar 2009 11:40:52 +0000
Message-ID: <ef1cd66f0903120440q6e49b90dye92abfaa455055b0@mail.gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090312092114.GC6949@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

2009/3/12 Pavel Machek <pavel@ucw.cz>:
> diff --git a/Documentation/filesystems/ext2.txt b/Documentation/files=
ystems/ext2.txt
> index 4333e83..b09aa4c 100644
> --- a/Documentation/filesystems/ext2.txt
> +++ b/Documentation/filesystems/ext2.txt
> @@ -338,27 +339,25 @@ enough 4-character names to make up unique dire=
ctory entries, so they
> =A0have to be 8 character filenames, even then we are fairly close to
> =A0running out of unique filenames.
>
> +Requirements
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Ext3 expects disk/storage subsystem to behave sanely. On sanely
   ^^^^
Shouldn't this be "Ext2"?

All the best,
Jochen
--=20
http://seehuhn.de/
