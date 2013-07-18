From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Thu, 18 Jul 2013 13:35:24 -0500
Message-ID: <51E8356C.9030603@redhat.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3GRSf2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jul 2013 14:35:28 -0400
In-Reply-To: <1373987883-4466-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/16/13 10:17 AM, Theodore Ts'o wrote:
> In addition to fixing a few bugs and addressing review comments, we now
> add a new ioctl, EXT4_IOC_PRECACHE_EXTENTS, which forces all of the
> extents in an inode to be cached in the extents status tree, and marks
> them to be preferentially protected when under memory pressure.  
> 
> This is critically important when using AIO to a preallocated file,
> since if we need to read in blocks from the extent tree, the
> io_submit(2) system call becomes synchronous, which is rather rude to
> applications which were expecting the AIO to be "A".
> 
> As a bonus, using the extent status tree to store the logical to
> physical block mapping is usually more compact that having to keep one
> or more extent tree blocks in the buffer cache.
> 
> (Should we do this all the time, instead of when the application
> explicitly requests it?  Maybe; there could be cases with very large,
> fragmented files accessed by an application such as "file" is only needs
> to look at a small subset of the file where this could result in an
> unnecessary work and memory allocated.  OTOH, 95%+ of the time this
> would probably be a win...)

I'd say yes, we should - maybe not in all cases but if you need it for
AIO, try to make it "all the time" at least for that AIO?

We keep telling application writers not to assume certain things about
various filesystems, or to write applications that treat ext4 differently 
han ext3 differently than xfs etc...

This goes the other way.

In the end who (besides google?) is really going to call this IOCTL?

I wondered if only doing this when files are opened O_DIRECT might make
sense, but Jeff Moyer pointed out that giant databases probably don't
want to read in their entire block mapping tree - OTOH, they probably use
preallocation if they're smart, and maybe it's not that bad.

Or what about tying this into POSIX_FADV_WILLNEED?  Hohum, that gets
into force_page_cache_readahead().  We need POSIX_FADV_WILLNEED_META...

-Eric

> 
> Theodore Ts'o (5):
>   ext4: refactor code to read the extent tree block
>   ext4: print the block number of invalid extent tree blocks
>   ext4: use unsigned int for es_status values
>   ext4: cache all of an extent tree's leaf block upon reading
>   ext4: add new ioctl EXT4_IOC_PRECACHE_EXTENTS
> 
>  fs/ext4/ext4.h              |  19 +++-
>  fs/ext4/extents.c           | 259 +++++++++++++++++++++++++++++---------------
>  fs/ext4/extents_status.c    |  52 ++++++++-
>  fs/ext4/extents_status.h    |  50 +++++----
>  fs/ext4/inode.c             |   6 +-
>  fs/ext4/ioctl.c             |   3 +
>  fs/ext4/migrate.c           |   2 +-
>  fs/ext4/move_extent.c       |   2 +-
>  include/trace/events/ext4.h |  28 +++--
>  9 files changed, 296 insertions(+), 125 deletions(-)
> 

