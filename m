From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs (device loop0): panic forced after error -- bug or not?
Date: Wed, 2 Dec 2015 08:41:15 -0500
Message-ID: <20151202134115.GA3356@thunk.org>
References: <565DAD0A.6030305@oracle.com>
 <20151201153202.GA3179@thunk.org>
 <565DD1DB.4060803@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33833 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbbLBNlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Dec 2015 08:41:20 -0500
Content-Disposition: inline
In-Reply-To: <565DD1DB.4060803@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2015 at 05:59:07PM +0100, Vegard Nossum wrote:
> Strange that you get EACCESS, without errors=remount-ro I get:
> 
> open("/dev/loop0", O_RDWR)              = 3
> mkdir("/mnt/ext4", 0755)                = -1 EEXIST (File exists)
> open("ext4.0", O_RDWR)                  = 4
> ioctl(3, LOOP_SET_FD, 0x4)              = 0
> close(4)                                = 0
> ioctl(3, LOOP_SET_STATUS64, {offset=0, number=0, flags=0,
> file_name="ext4.0", ...}) = 0
> mount("/dev/loop0", "/mnt/ext4", "ext4", 0, NULL) = 0
> open("/mnt/ext4", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
> getdents(4, <panic>

What is the source code of your test program, and what version of C
library are you using?  On my system, opendir() is getting translated
to:

openat(AT_FDCWD, "/vdc", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 EACCES (Permission denied)

(It would have saved me time if you had sent me the source of your
test program, BTW.)

Cheers,

					- Ted
