From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: merge uninitialized extents
Date: Thu, 20 Feb 2014 21:23:38 -0500
Message-ID: <20140221022338.GC31047@thunk.org>
References: <1390285023-23133-1-git-send-email-tytso@mit.edu>
 <24F1EAE7-6E6D-4411-9092-D159E0BE3A9C@dilger.ca>
 <20140121213943.GE31769@thunk.org>
 <20140124013721.GC8973@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60653 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaBUCXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 21:23:46 -0500
Content-Disposition: inline
In-Reply-To: <20140124013721.GC8973@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 23, 2014 at 05:37:21PM -0800, Darrick J. Wong wrote:
> <shrug> fuse2fs would use it, but I don't know that anyone cares about fuse2fs.
> 
> Well, here's a patch for all to enjoy.  xfstests didn't blow up when I ran it.
> 
> --D
> From: Darrick J. Wong <darrick.wong@oracle.com>
> Subject: [PATCH] ext4: merge uninitialized extents
> 
> Allow for merging uninitialized extents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I've merged this into the ext4 patch queue, but I want to do a full
xfstests runs on multiple configs (i.e., including dioread_nolock,
etc.) before I push to Linus.

					- Ted
