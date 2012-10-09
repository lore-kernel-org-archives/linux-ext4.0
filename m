From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] libext2fs: optimize rb_test_bit
Date: Tue, 9 Oct 2012 09:18:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210090836370.11244@dhcp-1-104.brq.redhat.com>
References: <1349408695-11661-1-git-send-email-tytso@mit.edu> <1349408695-11661-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1210080952390.25096@localhost> <alpine.LFD.2.00.1210081016160.25096@localhost> <20121008181753.GA20682@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1682170325-1349767127=:11244"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2JIHSu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 03:18:50 -0400
In-Reply-To: <20121008181753.GA20682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1682170325-1349767127=:11244
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 8 Oct 2012, Theodore Ts'o wrote:

> Date: Mon, 8 Oct 2012 14:17:53 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 2/2] libext2fs: optimize rb_test_bit
> 
> On Mon, Oct 08, 2012 at 10:25:19AM +0200, Lukáš Czerner wrote:
> > > the patch and the idea behind it look fine, especially when we're
> > > walking the bitmap sequentially not modifying it simultaneously, but
> > > I have one question/suggestion below.
> > 
> > Also for this kind of usage it might actually make sense to have
> > something like:
> > 
> > get_next_zero_bit
> > get_next_set_bit
> > 
> > which would be much more effective than testing single bits, but it
> > would require actually using this in e2fsprogs tools.
> 
> Yes, I thought about that, and in fact we already have find_first_zero
> (which takes a starting offset, so works for both find_first and
> find_next).  When we introduced this, though, we accidentally
> introduced a bug at first.
> 
> At some point I agree it would be good to implement find_first_set(),
> and writing new unit tests, and then modify e2freefrag, e2fsck, and
> dumpe2fs to use it.  But in the applications is actually pretty
> tricky, and I didn't have the time I figured would be necessary to
> really do the changes right, and validate/test them properly.
> 
> So yes, I agree this would be much more effective, and ultimately
> would result in further speedups in e2fsck and e2freefrag in
> particular.  It would also allow us to take out the test_bit
> optimizations which do have a slight cost for random access reads ---
> and this is measurable when looking at the results of the CPU time for
> e2fsck pass 4 in particular.  It's just that the performance hit for
> the random access test_bit case is very tiny compared with the huge
> wins in the sequential scan case.

I agree, at some point it would be nice to have that implemented.

> 
> > > what about using the next_ext once we're holding it to check the bit
> > > ? On sequential walk this shout make sense to do so since we
> > > actually should hit this if we're not in rcursor nor between rcursor
> > > and next_ext.
> 
> Yes, I implemented that in the 2/3 commit in the follow-on patch
> series.

Right, but I think that the 2/3 commit is not necessary and the
whole solution is more complicated than it could be. Also we do not
really need the rcursor_next pointer in the ext2fs_rb_private
structure.

The solution I was suggesting is simpler and it is also one
condition shorter on sequential walk because we store the "next"
extent into the rcursor once we actually hit it. So we optimize a
little bit less when we're testing buts in between the extents (due
to ext2fs_rb_next()), but we avoid searching the tree entirely
(except the first time) on sequential walk, because we are moving
the bp->rcursor to the next node when we have match there.

So what about this ? It has to be tested to see if it really is as
effective. Let me know what do you think.

Thanks!
-Lukas


-- 


diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 55d78e2..f76f790 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -304,8 +304,8 @@ static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
 inline static int
 rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 {
-	struct bmap_rb_extent *rcursor;
-	struct rb_node *parent = NULL;
+	struct bmap_rb_extent *rcursor, *next_ext;
+	struct rb_node *parent = NULL, *next;
 	struct rb_node **n = &bp->root.rb_node;
 	struct bmap_rb_extent *ext;
 
@@ -320,6 +320,23 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 		return 1;
 	}
 
+	next = ext2fs_rb_next(&rcursor->node);
+	if (next && (bit >= rcursor->start + rcursor->count)) {
+		next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent, node);
+		if (bit < next_ext->start) {
+#ifdef BMAP_STATS_OPS
+			bp->test_hit++;
+#endif
+			return 0;
+		} else if (bit < next_ext->start + next_ext->count) {
+#ifdef BMAP_STATS_OPS
+			bp->test_hit++;
+#endif
+			bp->rcursor = next_ext;
+			return 1;
+		}
+	}
+
 	rcursor = bp->wcursor;
 	if (!rcursor)
 		goto search_tree;
--571107329-1682170325-1349767127=:11244--
