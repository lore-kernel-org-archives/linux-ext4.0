From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Add invalidatepage_range address space operation
Date: Sat, 18 Aug 2012 20:57:27 -0400
Message-ID: <20120819005727.GA15763@thunk.org>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	hughd@google.com, linux-mmc@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2012 at 10:00:59AM +0200, Lukas Czerner wrote:
> This set of patches are aimed to allow truncate_inode_pages_range() handle
> ranges which are not aligned at the end of the page. Currently it will
> hit BUG_ON() when the end of the range is not aligned. Punch hole feature
> however can benefit from this ability saving file systems some work not
> forcing them to implement their own invalidate code to handle unaligned
> ranges.
> 
> In order for this to work we need however new address space operation
> invalidatepage_range which should be able to handle page invalidation with
> offset and length specified.
> 
> patch 01:	Implements the new invalidatepage_range address space
> 		operation in the mm layer
> patch 02 - 05:	Wire the new invalidatepage_range aop to the ext4, xfs and
> 		ocfs2 file system (which are currently the only file
> 		systems supporting punch hole) and implement this
> 		functionality for jbd2 as well.
> patch 06:	Change truncate_inode_pages_range() to handle unaligned
> 		ranges.
> patch 07 - 15:	Ext4 specific changes which take benefit from the
> 		previous truncate_inode_pages_range() change. Not all
> 		are realated specifically to this change, but all are
> 		related to the punch hole feature.

What's the current status of this patch series?

I haven't seen much if any comment from the mm folks and the xfs/ocfs2
folks.  I've incorporated the patches into the unstable portion of the
ext4 tree so I can do some testing (some minor changes to the ext4
patches were needed to rebase the patch series to the 3.6-rc1-based
ext4 dev tree, but nothing major).  However, I don't want to include
this into the ext4 tree for merging into linux-next unless we get
general agreement from the maintainers of the other trees that are
affected by this patch series.

Thansk,

						- Ted
