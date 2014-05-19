From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: content of file lost after fs went 100% full
Date: Mon, 19 May 2014 12:07:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405191143430.22064@localhost.localdomain>
References: <53773836.9000907@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, irssi-dev@dragoncat.net
To: Andre Reinke <andre.reinke@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbaESKH5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 06:07:57 -0400
In-Reply-To: <53773836.9000907@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 17 May 2014, Andre Reinke wrote:

> Date: Sat, 17 May 2014 12:21:42 +0200
> From: Andre Reinke <andre.reinke@gmail.com>
> To: linux-ext4@vger.kernel.org
> Subject: content of file lost after fs went 100% full
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I may have run into some kind of a bug and looking for help.
> 
> I shutdown my machine and fired up a live usb, done some backups. I did
> 'dd if=/dev/windows_partition of=/dev/ext4_fs' and while this file had
> been written the filesystem got filled 100%. Because this step took so
> long I told my machine to shutdown automatically in about 2 hours and
> went to bed.
> 
> Next morning I fired up my machine (Gentoo btw.) and opened irssi. All
> was as usual, except of some weir behavior, because there was no space
> left. I didn't recognize this from the beginning and so closed irrsi again.
> I started irssi again and my config was lost. I found the config file in
> the irssi dir with 0 bytes. :(
> 
> So, fill the drive, open a file, close the file and open it again leads
> to loosing the file?

There is no way this could happen, so the problem might be somewhere
else. Do you have any logs from the machine from the point when you
filled the file system 100% ?

Some applications do not rewrite the config files in place, but
rather create a copy and then rename it when it's done. And I
suspect that the problem is in irssi itself when it can not copy, or
write a configuration file. I suggest to file a bug with them.


I took a quick look at their sources and I can see this in
config_write():

open(fname != NULL ? fname : rec->fname,
     O_WRONLY | O_TRUNC | O_CREAT,
     create_mode != -1 ? create_mode : rec->create_mode);


and from the callers of config_write() it seems that they are in
fact not copying the file first, but rather overwriting it in place.
What's even worse is that they are using O_TRUNC to open the file
which means they are truncating it to zero size and then if the
write fails due to ENOSPC they will end up with 0 size config files.

Adding their mailing list to cc.

Thanks!
-Lukas

> 
> This is reproducable on this machine. Any help would be appreciated.
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJTdzg2AAoJEH3Z8Qq5aI95O2kH/1ANTajziJSFJRO5Q0j52eY+
> rR4/iE/g9sWaBl+/LCsuIQSTkpw02Ghml7VALxSwCgcBJB/yf5vRkdzeGKvJvgUI
> qzQJgrCmUxpXNynmCcYSOUXKm1qJZMZOYLdRovSLnwqDYHOfmLjJcB9SCjGzAksh
> qt/50FrhUjbcFk+rGAbrEb45F36N8ehML88A54ojYYKerVl4YlZrQMzHVYYjbdwk
> j3QsFhrFenkKd4ugdYwlBt9W4RfVyHJ9xxZQc3eHkEC5myFzBTiniicTzpAFvulc
> iiXZfrY0q3uCq0n+dFEmzDxZJJtaJSr6+ybobM/32iyS2ay4kEnYsxPb+GORLeY=
> =Sgjz
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
