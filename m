From: "George Spelvin" <linux@horizon.com>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: 14 Nov 2012 01:42:25 -0500
Message-ID: <20121114064225.26084.qmail@science.horizon.com>
References: <20121114054347.GA20380@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:34208 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751217Ab2KNGm0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 01:42:26 -0500
In-Reply-To: <20121114054347.GA20380@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

First of all, thanks a lot, Ted, for the middle-of-the-night tech support.
I just fired off my discovery diary which I wrote before seeing your
e-mail.

Here are the basics:

I have a newer (Oct 14) version compiled but not installed, but git
reflog shows the version I installed (and used for this) was

commit cf3c2ccea647c7d0db20ced920b68e98761dcd16
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Sep 22 22:29:34 2012 -0400

    Update for e2fsprogs-1.43-WIP-2012-09-22


I compiled a Debian package using "make clean ; debian/rules binary"
in the git directory, and installed that.  The compiler is
cc (Ubuntu/Linaro 4.7.2-2ubuntu1) 4.7.2

The system is mostlu Ubuntu 12.04 LTS, but I am running an unmodified
v3.6.5 Linux kernel.  (Compiled using the Ubuntu kernel packageing tools
to linux-image-3.6.5_3.6.5-10.00.Custom_amd64.deb.)

Note that I currently DO have the "superblock ckecksum is
corrupt while mounted" bug in this kernel.


I have some faint hope that the inodes are intact, just the group
descriptors are wrong, and I'm trying to follow that up.  Becasue BG#0's
inodes *did* get relocated correctly.


One strange thing I did was I supplied both "-o 64bit" and "-E
resize=17179869184" when creating the file system.  To do that,
I used e2fsprogs as of 41bf599391faaf6523c9997eb467a86888542339
(Oct 14, "debugfs: teach the htree and ls commands to show directory checksums")
with a local patch described in an earlier e-mail to the list.

That may have caused some odd block group layouts to start with.


Can you tell me, in your test, where the various bitmaps and
inode tables are for the first 16 block groups, both before and
after the resize?  My resize appeared to not only move them, but
*reorder* them, and I'd like to see what it's "supposed" to do.


Thank you very much!
