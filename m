From: Andre Reinke <andre.reinke@gmail.com>
Subject: content of file lost after fs went 100% full
Date: Sat, 17 May 2014 12:21:42 +0200
Message-ID: <53773836.9000907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44804 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaEQKVp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2014 06:21:45 -0400
Received: by mail-ee0-f42.google.com with SMTP id d49so2148729eek.15
        for <linux-ext4@vger.kernel.org>; Sat, 17 May 2014 03:21:44 -0700 (PDT)
Received: from [192.168.1.2] (port-ip-88-150-7-252.reverse.mdcc-fun.de. [88.150.7.252])
        by mx.google.com with ESMTPSA id p9sm26475971eeg.32.2014.05.17.03.21.43
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 17 May 2014 03:21:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I may have run into some kind of a bug and looking for help.

I shutdown my machine and fired up a live usb, done some backups. I did
'dd if=/dev/windows_partition of=/dev/ext4_fs' and while this file had
been written the filesystem got filled 100%. Because this step took so
long I told my machine to shutdown automatically in about 2 hours and
went to bed.

Next morning I fired up my machine (Gentoo btw.) and opened irssi. All
was as usual, except of some weir behavior, because there was no space
left. I didn't recognize this from the beginning and so closed irrsi again.
I started irssi again and my config was lost. I found the config file in
the irssi dir with 0 bytes. :(

So, fill the drive, open a file, close the file and open it again leads
to loosing the file?

This is reproducable on this machine. Any help would be appreciated.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTdzg2AAoJEH3Z8Qq5aI95O2kH/1ANTajziJSFJRO5Q0j52eY+
rR4/iE/g9sWaBl+/LCsuIQSTkpw02Ghml7VALxSwCgcBJB/yf5vRkdzeGKvJvgUI
qzQJgrCmUxpXNynmCcYSOUXKm1qJZMZOYLdRovSLnwqDYHOfmLjJcB9SCjGzAksh
qt/50FrhUjbcFk+rGAbrEb45F36N8ehML88A54ojYYKerVl4YlZrQMzHVYYjbdwk
j3QsFhrFenkKd4ugdYwlBt9W4RfVyHJ9xxZQc3eHkEC5myFzBTiniicTzpAFvulc
iiXZfrY0q3uCq0n+dFEmzDxZJJtaJSr6+ybobM/32iyS2ay4kEnYsxPb+GORLeY=
=Sgjz
-----END PGP SIGNATURE-----
