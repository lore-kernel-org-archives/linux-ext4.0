From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sun, 16 Dec 2012 03:39:35 -0200
Message-ID: <50cd5e9b.0839650a.221f.ffffc460@mx.google.com>
References: <kainf9$btc$1@ger.gmane.org>
 <20121216022753.GD9016@thunk.org>
 <50cd394d.0153650a.3b8d.ffffb917@mx.google.com>
 <20121216035150.GA6104@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:40000 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2LPFjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Dec 2012 00:39:41 -0500
Received: by mail-ye0-f174.google.com with SMTP id m6so963223yen.19
        for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2012 21:39:40 -0800 (PST)
In-Reply-To: <20121216035150.GA6104@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 15 Dec 2012 22:51:50 -0500
Theodore Ts'o <tytso@mit.edu> wrote:

> Um, really?  **Exactly** the same error message?  That doesn't make
> any sense.  The error message you quoted happens when the kernel
> complains that the block numbers in the inode in question are invalid
> (i.e., are too big for the inode in question, or point at file system
> metadata).

	Yes. The exact same message before and after:

EXT4-fs error (device sda2): ext4_ext_check_inode:462: inode #9311628:
comm less: bad header/extent: invalid extent entries - magic f30a,
entries 1, max 4(4), depth 0(0)

> However, debugfs is not showing any extents --- which would be the
> case after e2fsck repaired the file system (it would have zapped the
> extent tree for the inode).
> 
> So (a) you did run e2fsck on an unmounted file system right?

	Yes, unmounted.

> (b) Can you send me the output of:
> 
> 	debugfs -R "extents <9311628>" /dev/sda2
> 
> just to be sure we aren't missing anything.

	Here it is:

debugfs 1.41.12 (17-May-2010)
Level Entries       Logical              Physical Length Flags
 0/ 0   1/  1     0 - 4294967295  37333026 - 4332300321      0 

> Also, if you are using a really new kernel such as 3.6.x or 3.7.x, you
> ***really*** shouldn't be using an ancient version of e2fsprogs such
> as 1.41.12.  You really should be using e2fsprogs 1.42.x, preferably
> the latest e2fsprogs 1.42.6.  I wonder if you are seeing a similar
> message indicating that the file system had previously found an error,
> and which wasn't cleared because you are using an ancient version of
> e2fsprogs....

	Ok. The problem is that I'm trapped. I need to compile the most
recent version (1.42.6) but the needed file to
compile (/usr/include/dlfcn.h) isn't available (Input/output error)
because of this problem. 

	But no problem, because I used e2fsck from "Recovery is
possible 13.7" cd which uses e2fsck 1.42 version (so you can be sure I
used e2fsck 1.42 version).

	Any more suggestions? Thanks!

-- 
Linux 3.7.0: Terrified Chipmunk
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br
