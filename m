From: Peter Uchno <peter.uchno@gmail.com>
Subject: Strange behavior when attempting to convert a file to extents using chattr
Date: Thu, 28 Apr 2011 16:14:59 -0400
Message-ID: <BANLkTikHomLCTM307W0ergoOX8PH5x_JBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1D1UPB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Apr 2011 16:15:01 -0400
Received: by wya21 with SMTP id 21so2376704wya.19
        for <linux-ext4@vger.kernel.org>; Thu, 28 Apr 2011 13:15:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
I recently converted an ext3 filesystem to ext4 in the hopes of
performance increases. However, I ran into a snag:

In theory, chattr can be used to convert a file to extents using
"chattr +e foo". However, on my system (Archlinux, kernel 2.6.37.4),
the behavior of this command is unexpected. Given a file baz created
when the filesystem was still ext3 (and thus not using extents),
"chattr +e baz" returns zero but "lsattr baz" reveals the file is not
using extents. Run "chattr +e baz" a second time, the same thing
happens. A third time, however, it comes back with:
    "chattr: Input/output error while setting flags on baz"
and an error in the kernel log:
    attempt to access beyond end of device
    loop1: rw=0, want=204802, limit=204800
The file is still not using extents and remounting the filesystem
doesn't seem to change much. Running e2fsck on the filesystem after
unmounting it comes back with some errors. Letting it fix them and
then mounting the FS up again shows that the file is now using
extents.
I attempted this on an Arch system with both kernels 2.6.37.4 and
2.6.38.4 and was able to recreate it by creating a small loopback
filesystem using dd, making a few files on it, converting the FS to
ext4 using "tune2fs -O extents,uninit_bg,dir_index /tmp/fs.ext; e2fsck
-fDC0 /tmp/fs.ext", and then mounting it again as ext4 and attempting
the conversion to extents with chattr. However, on a debian system
with kernel 2.6.32.5, it works as intended (chattr +e bar; lsattr bar
reveals the file converted to extents). I ran strace on the chattr
command on the Arch system and came up with the following:

http://pastebin.com/EpwhLF3t
for the first attempt at running the command;
http://pastebin.com/qB7DiDgF
for the second try; and
http://pastebin.com/jjAdPtBr
for the final attempt.

After doing so, running e2fsck on the filesystem revealed the following:

http://pastebin.com/83q60Wik

And after mounting the filesystem again, the file is now using extents.

My kernel config, if it is of interest, is at:
http://pastebin.com/uk1Hs53P

I'm using e2fsprogs 1.41.14. The Debian system (where it works
normally) has e2fsprogs 1.41.12.

I'm not sure what would cause the filesystem to behave in this
fashion. Does anyone have any insights?
Regards,
Peter
