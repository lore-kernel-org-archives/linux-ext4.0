From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Remove extent tree purging from
 ext4_da_page_release_reservation()
Date: Wed, 24 Jul 2013 22:05:36 +0200
Message-ID: <20130724200536.GC27307@quack.suse.cz>
References: <1374099015-6829-1-git-send-email-jack@suse.cz>
 <20130719004439.GA21615@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab3GXUF7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jul 2013 16:05:59 -0400
Content-Disposition: inline
In-Reply-To: <20130719004439.GA21615@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Zheng,

On Fri 19-07-13 08:44:39, Zheng Liu wrote:
> On Thu, Jul 18, 2013 at 12:10:15AM +0200, Jan Kara wrote:
> > ext4_da_page_release_reservation() gets called from
> > ext4_da_invalidatepage(). This function is used when we are truncating
> > page cache for punch hole or truncate operations. In either case these
> > operations take care of removing extents from the extent tree. This is
> > more efficient and the code in ext4_da_page_release_reservation() is
> > actually buggy anyway. So just remove it.
> 
> I remember that I try to remove the entry from extent status tree here
> because at the end of this function it tries to relase the reserved
> space for delalloc.  For 4k block we can simply release it because
> ->s_cluster_ratio == 1.  But when bigalloc is enabled, we need to
> determine whether we can release the reserved space according to the
> result of ext4_find_delalloc_cluster() as the comment described.  If we
> don't remove the entry from extent status tree here, we could lost some
> spaces that could be reused by other files.  If I remember correctly, I
> have hitted a warning message when I run xfstests to test it.  These
> days I try to trigger it using xfstests but I failed.  Have you seen a
> prblem that is caused by this code?  Maybe we need to refactor out the
> code and release the reserved space outside this function.
  Ah, I see. No, I didn't observe any problem due to this code, I just
didn't understand why is it there. Also when blocksize < pagesize, the code
is wrong because delayed buffers to release need not be contiguous so
ext4_es_remove_extent(inode, lblk, to_release) may not free all the buffers
we want. But subsequent extent tree truncation in ext4_ext_truncate() hides
this problem.

So I think we might just change the condition:

if (to_release) {

to

if (to_release && sbi->s_cluster_ratio > 1) {

and add explanatory comment why cluster_ratio > 1 needs the truncation and
other cases don't. It will also save some needlessly burned CPU cycles
spent when manipulating extent tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
