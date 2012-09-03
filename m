From: darxus@chaosreigns.com
Subject: Weird filesystem corruption from wayland / radeon / chromium
Date: Mon, 3 Sep 2012 18:02:13 -0400
Message-ID: <20120903220213.GE19158@chaosreigns.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from panic.chaosreigns.com ([64.71.152.40]:54355 "EHLO
	panic.chaosreigns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2ICWJY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2012 18:09:24 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[732715.730069] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0: ix (10742) != EXT_FIRST_INDEX (0)
[  496.347230] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0:ix (10742) != EXT_FIRST_INDEX (0)

Same search_left... argument?  Same inode?

$ sudo find . -inum 21374007 -print
./home/darxus/.cache/chromium/Default/Cache/data_3

My post about it to the wayland mailing list: http://lists.freedesktop.org/archives/wayland-devel/2012-September/005201.html

This happened running wayland with xwayland (X.org running as a rootless
wayland client) using RAOF's modified Radeon DDX (X driver).  I was
running chromium this time it happened, there is some possibility I had
not run chromium since the last time it happened and did run it then,
I'm not sure.

What is the significance of this file?  What does the error mean?

It seems like this shouldn't be possible.  What could be causing it?
Someone mentioned this could be the result of something "scribbling over
kernel memory".  Do these errors, and their similarity, provide any
insight into how to track it down?

The errors were three months apart.  They corresponded to filesystem
corruption.  Because of that I didn't run xwayland for the three months
between.

-- 
"When we remember we are all mad, the mysteries of life disappear and
life stands explained." - Mark Twain
http://www.ChaosReigns.com
