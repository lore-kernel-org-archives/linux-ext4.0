From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Mon, 4 Nov 2013 10:14:42 +1100
Message-ID: <20131103231442.GM6188@dastard>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:29594 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab3KCXOt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Nov 2013 18:14:49 -0500
Content-Disposition: inline
In-Reply-To: <1383435930-29295-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 02, 2013 at 07:45:30PM -0400, Theodore Ts'o wrote:
> Add the ability for a user who has write access to a file to issue a
> discard request for blocks belonging to a file.  This can be done via
> a new flag to the FIEMAP ioctl, or via the BLKDISCARD ioctl (which
> previously only worked on block devices).
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

FIEMAP is not the correct interface for data modifying operations.
It is an interface that returns information about file metadata (i.e
the layout of a file) - it is not an interface for modifying the
contents of the file.

fallocate() is the interface used to modify file layout and
manipulate the data within it and hence, IMO, is much better aligned
to this operation. And to tell the truth, I'd much prefer such an
interface is guaranteed to return zeros to users rather than rely on
whether the underlying device supports discard or whatever they
return after a discard. i.e. if the user is asking to destroy the
data in the file, we better be able to ensure the data in the file
is in a known state at the filesystem level regardless of the
underlying storage capabilities....

For example, XFS already has a XFS_IOC_ZERO operation which is used
to return allocated blocks to unwritten state (i.e. always return
zeros) and could easily be extended to issue discards on the blocks
if the underlying device supports discards-to-zero or WRITE_SAME.
I've previously proposed this interface for fallocate() - old patch
here:

http://permalink.gmane.org/gmane.linux.file-systems/62449

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
