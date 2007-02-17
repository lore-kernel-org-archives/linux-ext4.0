From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: data=journal busted
Date: Sat, 17 Feb 2007 00:52:15 -0700
Message-ID: <20070217075214.GD10715@schatzie.adilger.int>
References: <20070215204445.411d2760.akpm@linux-foundation.org> <20070216233108.GY10715@schatzie.adilger.int> <20070216154246.7b9a643c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36649 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946477AbXBQHwR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Feb 2007 02:52:17 -0500
Content-Disposition: inline
In-Reply-To: <20070216154246.7b9a643c.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 16, 2007  15:42 -0800, Andrew Morton wrote:
> On Fri, 16 Feb 2007 16:31:09 -0700
> Andreas Dilger <adilger@clusterfs.com> wrote:
> > We have a patch that we use for Lustre testing which allows you to set a
> > block device readonly (silently discarding all writes), without the
> > filesystem immediately keeling over dead like set_disk_ro.  The readonly
> > state persists until the the last reference on the block device is dropped,
> > so there are no races w.r.t. VFS cleanup of inodes and flushing buffers
> > after the filesystem is unmounted.
> 
> Not sure I understand all that.

Actually, the patch was originally based on your just-posted readonly code.
The problem with that code (unlike ours) is that it doesn't do the explicit
ro clearing in ext3_put_super(), but rather not until ALL inodes/buffers/etc
are cleared out for the block device by the VFS.  Otherwise, it is possible
to re-enable rw on the block device, and there still be dirty buffers that
are being flushed out to disk, guaranteeing filesystem inconsistency.

It allows multiple devices to be marked ro at the same time without problem.

It also works on all block devices instead of just IDE.

> For this application, we *want* to expose VFS races, errors in handling
> EIO, errors in handling lost writes, etc.  It's another form of for-developers
> fault injection, not a thing-for-production.

I understand that part, and I agree our patch doesn't include the "random"
part of the set-readonly code you have.  Both of the patches do have the
drawback that they don't return errors like set_disk_ro(), so that isn't
exercising the error-handling code in ext3/jbd as much as it could.

When we first worked on this in 2.4 the ext3/jbd code was far to fragile to
handle -EROFS under load without oopsing so we chose the "silent failure"
mode to allow testing w/o crashing all the time.  Maybe today it is better
to just call set_dev_ro() and fix the (hopefully few) -EROFS problems.

> The reason I prefer doing it from the timer interrupt is to toss more
> randomness in there, avoid the possibility of getting synchronised
> with application or kernel activity in some fashion.

Definitely this has its place too.  We chose the opposite route and have
fault-injection calls sprinkled throughout our code, so that we can create
complex regression tests that need specific series of events to be hit.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
