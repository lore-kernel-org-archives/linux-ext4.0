From: <paul.chavent@fnac.net>
Subject: What represent 646345728 bytes
Date: Mon,  1 Feb 2010 15:08:24 +0100 (CET)
Message-ID: <7618835.18201265033304935.JavaMail.www@wsfrf1112>
Reply-To: <paul.chavent@fnac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:61326 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0BAOOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 09:14:12 -0500
Received: from smtp11.services.sfr.fr (msfrf1101 [10.18.24.51])
	by msfrf2120.sfr.fr (SMTP Server) with ESMTP id 20FF47003129
	for <linux-ext4@vger.kernel.org>; Mon,  1 Feb 2010 15:11:27 +0100 (CET)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf1101.sfr.fr (SMTP Server) with ESMTP id 029BA17000091
	for <linux-ext4@vger.kernel.org>; Mon,  1 Feb 2010 15:08:25 +0100 (CET)
Received: from wsfrf1112 (wsfrf1112 [10.18.24.26])
	by msfrf1101.sfr.fr (SMTP Server) with ESMTP id E613D17000087
	for <linux-ext4@vger.kernel.org>; Mon,  1 Feb 2010 15:08:24 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I'am writing an application that write a stream of pictures of fixed si=
ze on a disk.

My app run on a self integrated gnu/linux (based on a 2.6.31.6-rt19 ker=
nel).

My media is formated with

# mke2fs -t ext4 -L DATA -O large_file,^has_journal,extent -v /dev/sda3
[...]

And it is mounted with=20

# mount -t ext4 /dev/sda3 /var/data/
EXT4-fs (sda3): no journal
EXT4-fs (sda3): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda3): mounted filesystem without journal

My app opens the file with "O_WRONLY | O_CREAT | O_TRUNC | O_SYNC | O_D=
IRECT" flags.

Each write takes ~4.2ms for 304K (it is very good since it is the write=
 bandwidth of my hard drive). There is a write every 100ms.

But every exactly 646345728 bytes, the write takes ~46ms.

I had the same problem with ext2 but every ~620M (the amount wasn't so =
constant).

Also i tryed to "posix_fallocate" with (eg 2G), and the first write ove=
rhead comes at this limit. I would like to avoid to preallocate.

I suppose it is a kind of block allocation issue. But i would like to h=
ave your opinion :
=C2=A0- what is exatcly this amount of bytes ?
=C2=A0- can i do something for having a "constant" write time from the =
user space point of view ?
=C2=A0- is it a "probem" only for me ?

Thank you for your reading.

Paul.




--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
