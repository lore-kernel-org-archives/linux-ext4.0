From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/2 v2] Fix O_SYNC AIO DIO
Date: Fri, 30 Aug 2013 16:53:01 +0100
Message-ID: <20130830155301.GB13318@ZenIV.linux.org.uk>
References: <1376471456-11966-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:34211 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3H3PxE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Aug 2013 11:53:04 -0400
Content-Disposition: inline
In-Reply-To: <1376471456-11966-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 14, 2013 at 11:10:54AM +0200, Jan Kara wrote:
>   Hello,
> 
>   this is second iteration of patches to fix handling of O_SYNC AIO DIO.
> Since previous version I've addressed Dave's comments:
>  - slightly expanded changelog of the first patch
>  - workqueue is now created with parameters allowing paralelism
>  - workqueue name contains sb->s_id
>  - workqueue is created on demand (I decided to do this to reduce the overhead
>    in unnecessary cases)
> 
> The patchset survives xfstests run for ext4 & xfs so it should be sane. Since
> this touches several filesystems (although only ext4 & xfs are non-trivial),
> the question is who should carry these patches. Maybe Al? But since xfs and
> ext4 changes are non-trivial, I'd like to have a review from their
> developers...

Looks sane, except that I'd probably put destroying the queue after
evict_inodes(), next to ->put_super() call.

Said that, there's another interesting problem in the code affected by that
sucker: generic_file_aio_write() might very well sync the wrong range.
Consider O_APPEND case; __generic_file_aio_write() will call
generic_write_checks(), which will update its copy of pos, and proceed to
write starting from there.  All right and proper, but then we return into
generic_file_aio_write() and sync the range of the right length, starting
at the *original* value of pos...
