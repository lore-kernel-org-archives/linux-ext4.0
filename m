From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fslibs: fix llseek on i386
Date: Thu, 24 Jan 2013 14:51:58 -0500
Message-ID: <20130124195158.GC9477@thunk.org>
References: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45309 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3AXTwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 14:52:00 -0500
Content-Disposition: inline
In-Reply-To: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 11:21:56AM -0500, Phillip Susi wrote:
> ext2fs_llseek() was using lseek instead of lseek64.  The
> only time it would use lseek64 is if passed an offset that
> overflowed 32 bits.  This works for SEEK_SET, but not
> SEEK_CUR, which can apply a small offset to move the file
> pointer past the 32 bit limit.
> 
> The code has been changed to instead try lseek64 first, and
> fall back to lseek if that fails.  It also was doing a
> runtime check of the size of off_t.  This has been moved to
> compile time.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

How did you find this?  I've done a quick search for SEEK_CUR, and it
looks like only place where this could cause a problem is with
e2image.  And a quick test of a i386 version of e2image with a large
file system is that it does indeed blow up with an "Inappropriate
ioctl for device" error.

Is there any other potential problems that are caused by this bug?  I
like to explain the impacts of bug fixes in libext2fs for folks who
are doing bug fix / code archeology.

Thanks,


					- Ted
