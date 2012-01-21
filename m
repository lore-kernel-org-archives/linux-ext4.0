From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: Ext4 bigalloc and sparc ext3 16k blocksize
Date: Sat, 21 Jan 2012 10:14:10 +0800
Message-ID: <CAFZ0FUVwQZ8OG586RZoQJP6YTGnHgwSqbN75NtucU_H3W-7DMw@mail.gmail.com>
References: <CALbEkhsi=Nqz=rfOApPsFi_Bk+cR5NE-VXcvVEZB3nC2MxebVA@mail.gmail.com>
	<A412940F-4D2C-4849-83B6-53EAF75262A7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bluflonalgul <bluflonalgul@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61299 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab2AUCOL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jan 2012 21:14:11 -0500
Received: by obcva7 with SMTP id va7so1425277obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2012 18:14:11 -0800 (PST)
In-Reply-To: <A412940F-4D2C-4849-83B6-53EAF75262A7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/1/21 Andreas Dilger <adilger@dilger.ca>:
> On 2012-01-20, at 4:20 AM, Bluflonalgul wrote:
>> Some (misleading?) article on kernelnewbies.org said the new Ext4
>> Bigalloc feature was about supporting block size up to 1MB.
>> I tried to use this feature to read an ext3 fs with 16k blocksize ma=
de
>> on a Linux Debian Sparc (NAS).
>> But I couldn't read such filesystem with the Linux 3.2 kernel on x86
>> PC... It fails to read fs structure (as it used to fail with previou=
s
>> kernels).
>
> The bigalloc feature is not intended to be disk compatible with a
> large blocksize filesystem, or no "feature" would be needed at all
> besides increasing the blocksize in the superblock.
>
> What it is intended to handle is efficient block allocation for large
> file IO, by increasing the size of space allocation/tracking in the
> block bitmap, without breaking the kernel paradigm of keeping block
> size <=3D PAGE_SIZE.
>
> This gives many of the benefits of having a large blocksize without
> needing to change the whole kernel.
>
>> Could someone point me to some documentation, or give me some clues:
>> I'd like to understand what's wrong and if I can hope to read such f=
s
>> with Linux on x86 (natively, without fusefs tricks or additional
>> tools).
>
> There was some work done by Robin Dong (2011-11-18) that would get us
> most of the way to just handling large blocksize filesystems directly
> by the kernel. =A0This might be facilitated by denying mmap access to
> such filesystems, but for media/big data filesystems (as opposed to t=
he
> root fs) this is probably not a serious limitation.
>
> I'm still interested to see a continuation of Robin's work, taking it
> to just be disk compatible with large blocksize, even if it is not
> possible to use mmap IO on such filesystems (always setting MNT_NOEXE=
C
> on systems where PAGE_SIZE < blocksize and not supplying f_op->mmap
> should work).

A great idea of extended version of ext4_extent was mentioned by Ted
(2011-11-19 http://www.spinics.net/lists/linux-ext4/msg28999.html)

I am happily to buy this story which might solve the concerns of
TAOBAO corp and Andreas as well.
Therefore I will send a RFC later to continue :)


>
> The reason that this is desirable is that it allows bypassing the 16T=
B
> file size limitations, and it also allows mounting filesystems from
> SPARC, PPC, and IA64 systems that were formatted in this manner and a=
re
> getting old and need replacing.
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
