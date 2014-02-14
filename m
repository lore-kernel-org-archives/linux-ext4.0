From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Thu, 13 Feb 2014 20:13:33 -0700
Message-ID: <6E255D1A-534A-4039-9102-CF8CBE2FBE25@dilger.ca>
References: <20140203182634.GA28811@shaniqua> <20140203185633.GA22856@thunk.org> <20140206210844.GA4335@helmut> <87sirnp2m3.fsf@openvz.org> <20140213145323.GA6296@helmut> <20140213211831.GA11480@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52149 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNDNd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2014 22:13:33 -0500
Received: by mail-pb0-f52.google.com with SMTP id jt11so11737704pbb.39
        for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 19:13:33 -0800 (PST)
In-Reply-To: <20140213211831.GA11480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 13, 2014, at 14:18, Theodore Ts'o <tytso@mit.edu> wrote:
> one question: was there a deliberate reason
> why the file system was created with parameters which allocate 32,752
> inodes per block group?  That means that a bit over 8 megabytes of
> inode table are being reserved for every 128 megabyte (32768 4k
> blocks) block group, and that you have more inodes reserved than could
> be used if the average file size is 4k or less.

This is fairly normal for Lustre metadata targets, where the
inodes typically do not have any data blocks. We typically format the
MDT filesystem with an average of 2KB per inode. 

>  In fact, the only way
> you could run out of inodes is if you had huge numbers of devices,
> sockets, small symlinks, or zero-length files in your file system.
> This seems to be a bit of a waste of space, in all liklihood.
> 
> Don't get me wrong; we should be able to handle this case correctly,
> and not trigger a BUG_ON, but this is why most people aren't seeing
> this particular fault --- it requires a far greater number of inodes
> than mke2fs would ever create by default, or that most system
> administrators would try to deliberately specify, when creating the
> file system.

That said, Lustre also doesn't allow online resize yet (no way to pass
the ioctl() from userspace to the underlying ext4 filesystem), so
we haven't hit this yet. 

Cheers, Andreas
