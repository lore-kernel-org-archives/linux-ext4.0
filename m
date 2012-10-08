From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] libext2fs: optimize rb_test_bit
Date: Mon, 8 Oct 2012 10:25:19 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210081016160.25096@localhost>
References: <1349408695-11661-1-git-send-email-tytso@mit.edu> <1349408695-11661-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1210080952390.25096@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1890076987-1349684722=:25096"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2JHIZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 04:25:24 -0400
In-Reply-To: <alpine.LFD.2.00.1210080952390.25096@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1890076987-1349684722=:25096
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 8 Oct 2012, Luká¨ Czerner wrote:

> Date: Mon, 8 Oct 2012 10:08:54 +0200 (CEST)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 2/2] libext2fs: optimize rb_test_bit
> 
> On Thu, 4 Oct 2012, Theodore Ts'o wrote:
> 
> > Date: Thu,  4 Oct 2012 23:44:55 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Subject: [PATCH 2/2] libext2fs: optimize rb_test_bit
> > 
> > Optimize testing for a bit in an rbtree-based bitmap for the case
> > where the calling application is scanning through the bitmap
> > sequentially.  Previously, we did this for a set of bits which were
> > inside an allocated extent, but we did not optimize the case where
> > there was a large number of bits after an allocated extents which were
> > not in use.
> > 
> >              1111111111111110000000000000000000
> >              ^ optimized    ^not optimized
> > 
> > In my tests of a roughly half-filled file system, the run time of
> > e2freefrag was halved, and the cpu time spent in userspace was during
> > e2fsck's pass 5 was reduced by a factor of 30%.
> 
> Hi Ted,
> 
> the patch and the idea behind it look fine, especially when we're
> walking the bitmap sequentially not modifying it simultaneously, but
> I have one question/suggestion below.

Also for this kind of usage it might actually make sense to have
something like:

get_next_zero_bit
get_next_set_bit

which would be much more effective than testing single bits, but it
would require actually using this in e2fsprogs tools.

Thanks!
-Lukas

> 
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  lib/ext2fs/blkmap64_rb.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> > index a83f8ac..c9006f8 100644
> > --- a/lib/ext2fs/blkmap64_rb.c
> > +++ b/lib/ext2fs/blkmap64_rb.c
> > @@ -314,8 +314,8 @@ static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
> >  inline static int
> >  rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
> >  {
> > -	struct bmap_rb_extent *rcursor;
> > -	struct rb_node *parent = NULL;
> > +	struct bmap_rb_extent *rcursor, *next_ext;
> > +	struct rb_node *parent = NULL, *next;
> >  	struct rb_node **n = &bp->root.rb_node;
> >  	struct bmap_rb_extent *ext;
> >  
> > @@ -330,6 +330,18 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
> >  		return 1;
> >  	}
> >  
> > +	next = ext2fs_rb_next(&rcursor->node);
> > +	if (next) {
> > +		next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent, node);
> > +		if ((bit >= rcursor->start + rcursor->count) &&
> > +		    (bit < next_ext->start)) {
> 
> what about using the next_ext once we're holding it to check the bit
> ? On sequential walk this shout make sense to do so since we
> actually should hit this if we're not in rcursor nor between rcursor
> and next_ext.
> 
> So maybe something like this ?  (untested)
> 
> 	if (next && (bit >= rcursor->start + rcursor->count)) {
> 		next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent, node);
> 		if (bit < next_ext->start)) {
> #ifdef BMAP_STATS_OPS
> 			bp->test_hit++;
> #endif
> 			return 0;
> 		} else if (bit < next_ext->start + next_ext->count) {
> #ifdef BMAP_STATS_OPS
> 			bp->test_hit++;
> #endif
> 			*bp->rcursor = next_ext;
> 			return 1;
> 		}
> 
> What do you think ? Maybe it is worth testing, whether
> the advantages are higher than additional condition ?
> 
> Thanks!
> -Lukas
> 
> 
> > +	}
> > +
> >  	rcursor = *bp->wcursor;
> >  	if (!rcursor)
> >  		goto search_tree;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--571107329-1890076987-1349684722=:25096--
