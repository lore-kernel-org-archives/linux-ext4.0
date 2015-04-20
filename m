From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Mon, 20 Apr 2015 14:34:00 +0200
Message-ID: <20150420123400.GG3117@quack.suse.cz>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
 <1429198977-5637-3-git-send-email-jack@suse.cz>
 <056F4994-DF7C-4780-A3BD-C2A818BEEE45@dilger.ca>
 <20150418011300.GE11592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbbDTMeF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 08:34:05 -0400
Content-Disposition: inline
In-Reply-To: <20150418011300.GE11592@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 17-04-15 18:13:00, Darrick J. Wong wrote:
> On Fri, Apr 17, 2015 at 05:53:03PM -0600, Andreas Dilger wrote:
> > On Apr 16, 2015, at 9:42 AM, Jan Kara <jack@suse.cz> wrote:
> > > 
> > > Ext4 orphan inode handling is a bottleneck for workloads which heavily
> > > truncate / unlink small files since it contends on the global
> > > s_orphan_mutex lock (and generally it's difficult to improve scalability
> > > of the ondisk linked list of orphaned inodes).
> > > 
> > > This patch implements new way of handling orphan inodes. Instead of
> > > linking orphaned inode into a linked list, we store it's inode number in
> > > a new special file which we call "orphan file". Currently we still
> > > protect the orphan file with a spinlock for simplicity but even in this
> > > setting we can substantially reduce the length of the critical section
> > > and thus speedup some workloads.
> > > 
> > > Note that the change is backwards compatible when the filesystem is
> > > clean - the existence of the orphan file is a compat feature, we set
> > > another ro-compat feature indicating orphan file needs scanning for
> > > orphaned inodes when mounting filesystem read-write. This ro-compat
> > > feature gets cleared on unmount / remount read-only.
> > > 
> > > Some performance data from 48 CPU Xeon Server with 32 GB of RAM,
> > > filesystem located on ramdisk, average of 5 runs:
> > > 
> > > stress-orphan (microbenchmark truncating files byte-by-byte from N
> > > processes in parallel)
> > > 
> > > Threads Time            Time
> > >        Vanilla         Patched
> > >  1       1.602800        1.260000
> > >  2       4.292200        2.455000
> > >  4       6.202800        3.848400
> > >  8      10.415000        6.833000
> > > 16      18.933600       12.883200
> > > 32      38.517200       25.342200
> > > 64      79.805000       50.918400
> > > 128     159.629200      102.666000
> > > 
> > > reaim new_fserver workload (tweaked to avoid calling sync(1) after every
> > > operation)
> > > 
> > > Threads Jobs/s          Jobs/s
> > >        Vanilla         Patched
> > >  1      24375.00        22941.18
> > > 25     162162.16       278571.43
> > > 49     222209.30       331626.90
> > > 73     280147.60       419447.52
> > > 97     315250.00       481910.83
> > > 121     331157.90       503360.00
> > > 145     343769.00       489081.08
> > > 169     355549.56       519487.68
> > > 193     356518.65       501800.00
> > > 
> > > So in both cases we see significant wins all over the board.
> > 
> > One thing I noticed looking at this patch is that there is quite a bit
> > of orphan handling code now.  Is it worthwhile to move it into its own
> > file and make super.c a bit smaller?
> > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > > fs/ext4/ext4.h  |  52 +++++++++++--
> > > fs/ext4/namei.c |  95 +++++++++++++++++++++--
> > > fs/ext4/super.c | 237 ++++++++++++++++++++++++++++++++++++++++++++++++--------
> > > 3 files changed, 341 insertions(+), 43 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index abed83485915..768a8b9ee2f9 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -208,6 +208,7 @@ struct ext4_io_submit {
> > > #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
> > > #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
> > > #define EXT4_JOURNAL_INO	 8	/* Journal inode */
> > > +#define EXT4_ORPHAN_INO		 9	/* Inode with orphan entries */
> > 
> > Contrary to your patch description that said this was using ino #12,
> > this conflicts with EXT2_EXCLUDE_INO for snapshots.  Why not use
> > s_last_orphan in the superblock to reference the orphan inode?  Since
> > this feature already requires a new EXT2_FEATURE_RO_COMPAT flag, the
> > existing orphan inode number could be reused.  See below how this could
> > still in the ENOSPC case.
> > 
> > > +static inline int ext4_inodes_per_orphan_block(struct super_block *sb)
> > > +{
> > > +	/* We reserve 1 entry for block checksum */
> > 
> > Would be good to improve this comment to say "first entry" or "last entry".
> > 
> > > +	return sb->s_blocksize / sizeof(u32) - 1;
> > > +}
> 
> Just to be clear, the format of each orphaned inode block is ... an array of
> 32-bit inode numbers with a 32-bit checksum at the end?
  Yes.

> Shouldn't we have a magic number somewhere for positive identification?
  We could use another slot at the end of block for magic number. The
checksum actually uniquely identifies that the block belongs to the orphan
file because it has the inode number in it but it's so much easier to look
into the block and see the magic there during disaster recovery / bug
analysis that I guess it's worth the extra space.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
