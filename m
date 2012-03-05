From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4 v2] ext4: Do not discard group with BLOCK_UNINIT
 set
Date: Mon, 5 Mar 2012 14:12:48 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203051359290.4797@dhcp-27-109.brq.redhat.com>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com> <1330690318-22627-4-git-send-email-lczerner@redhat.com> <20120305124154.GG6643@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab2CENNR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 08:13:17 -0500
In-Reply-To: <20120305124154.GG6643@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 Mar 2012, Jan Kara wrote:

> On Fri 02-03-12 13:11:58, Lukas Czerner wrote:
> > This commit is an optimization for FITRIM implementation. If the group
> > has not been initialized yet (BLOCK_UNINIT flag set), we do not need to
> > discard such group. This flag is set on mke2fs time to speed up
> > subsequent file system checks, because it says to us that there is
> > nothing there in the block group.
> > 
> > Because the BLOCK_UNINIT is only set on mke2fs time and cleared when
> > allocation from that group takes place we know that when set, there was
> > not anything allocated from that group, hence there should not be anything
> > to discard from the file system point of view. Of course there might be
> > situations where even if BLOCK_UNINIT is set the underlying storage is
> > provisioned. This might happen for example when the user disables discard
> > on mke2fs, however I think that this niche is not enough to not to take
> > advantage of this optimization.
>   This patch is correct but I'm undecided whether we really want to do this
> optimization or not. It might be unexpected we didn't truncate block group
> which was completely free (from user's POV). I don't consider FITRIM too
> performance critical and I also don't think this will be such a massive
> speedup...
> 
> 								Honza

Hi Honzo,

on small SSD's it certainly does not bring any significant speedup. But
consider huge thin-provisioned storage and you'll immediately notice the
change, but not only because of the storage size, but also because (from
my experience) those thing are really slow with discard.

Moreover ext4 would not be the only one not discarding the whole file
system on FITRIM. See btrfs which does not map the whole storage to the
file system at creation time, but rather allocate smaller chunks as the
demand for space grows. It also means that they will not discard the
whole file system, but only mapped chunks.

And lastly, FITRIM is supposed to be a way to notify the underlying
storage about the space which is no longer used. In conjunction with
full device discard on mke2fs (which is the default), we can skip UNINIT
groups just because from the fs point of view we are sure enough that
this space is not mapped. Note that the only case where this is not
true is if someone overrides the default mke2fs behaviour, or move their
file system with dd.

But I am certainly open for discussions about that.

Thanks!
-Lukas

> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > v2: nothing changed
> > 
> >  fs/ext4/mballoc.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 8f817f2..9ea1065a 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -5033,6 +5033,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >  	ext4_fsblk_t first_data_blk =
> >  			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
> >  	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
> > +	struct ext4_group_desc *desc;
> >  	int ret = 0;
> >  
> >  	start = range->start >> sb->s_blocksize_bits;
> > @@ -5076,7 +5077,14 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >  		if (group == last_group)
> >  			end = last_cluster;
> >  
> > -		if (grp->bb_free >= minlen) {
> > +		desc = ext4_get_group_desc(sb, group, NULL);
> > +		if (!desc) {
> > +			ret = -EIO;
> > +			break;
> > +		}
> > +
> > +		if (!(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) &&
> > +		    (grp->bb_free >= minlen)) {
> >  			cnt = ext4_trim_all_free(sb, group, first_cluster,
> >  						end, minlen);
> >  			if (cnt < 0) {
> > -- 
> > 1.7.4.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
