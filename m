From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e4defrag modifies folder's mtime.
Date: Wed, 4 Jan 2012 00:27:18 -0500
Message-ID: <20120104052718.GB13438@thunk.org>
References: <4F00BE34.1080006@gmail.com>
 <20120103203443.GC30502@thunk.org>
 <20120104045318.GA17026@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40892 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab2ADF1V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:27:21 -0500
Content-Disposition: inline
In-Reply-To: <20120104045318.GA17026@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2012 at 03:53:18PM +1100, Dave Chinner wrote:
> 
> xfs_fsr doesn't use these donor files to avoid mtime updates - it
> uses invisible IO (i.e. O_NOATIME|O_NOCMTIME) to do that.

O_NOCMTIME doesn't exist yet.  From include/linux/fs.h:

/*
 * Don't update ctime and mtime.
 *
 * Currently a special hack for the XFS open_by_handle ioctl, but we'll
 * hopefully graduate it to a proper O_CMTIME flag supported by open(2) soon.
 */
#define FMODE_NOCMTIME		((__force fmode_t)0x800)

I'd have to check, but it wouldn't surprise me if glibc is filtering
out all fcntl flags it doesn't understand, so for now, this is an
XFS-only special...

						- Ted
