From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv4 3/5] ext4: remove unnecessary superblock dirtying
Date: Tue, 10 Jul 2012 14:52:38 +0200
Message-ID: <20120710125238.GF13539@quack.suse.cz>
References: <1341404514-13660-1-git-send-email-dedekind1@gmail.com>
 <1341404514-13660-4-git-send-email-dedekind1@gmail.com>
 <20120704131124.GA29954@quack.suse.cz>
 <1341916536.2963.61.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab2GJMwk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2012 08:52:40 -0400
Content-Disposition: inline
In-Reply-To: <1341916536.2963.61.camel@sauron>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-07-12 13:35:36, Artem Bityutskiy wrote:
> On Wed, 2012-07-04 at 15:11 +0200, Jan Kara wrote:
> > On Wed 04-07-12 15:21:52, Artem Bityutskiy wrote:
> > > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > > 
> > > This patch changes the '__ext4_handle_dirty_super()' function which is used
> > > by ext4 to update the superblock via the journal in the following cases:
> > > 
> > > 1. When creating the first large file on a file system without
> > >    EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
> > > 2. When re-sizing the file-system.
> > > 3. When creating an xattr on a file-system without the
> > >    EXT4_FEATURE_COMPAT_EXT_ATTR feature.
> > > 4. When adding or deleting an orphan (because we update the 's_last_orphan'
> > >    superblock field).
> > > 
> > > This function, however, falls back to just marking the superblock as dirty
> > > if the file-system has no journal. This means that we delay the actual
> > > superblock I/O submission by 5 seconds (roughly speaking). Namely, the
> > > 'sync_supers()' kernel thread will call 'ext4_write_super()' later, where
> > > we actually will submit the superblock down to the media.
> > > 
> > > However:
> > > 1. For cases 1-3 it does not add any value to delay the I/O submission. These
> > >    events are rare and we may just commit submit the superblock for
> > >    asynchronous I/O right away.
> > > 2. For case 4 - similarly, not terribly frequent event in most of workloads.
> > >    It should be good enough to just submit asynchronous superblock write-out.
> >   Well, it happens for every inode being truncated / deleted to it can be
> > rather frequent. That's why I wanted to have now == 1 case everywhere -
> > i.e. just recompute the checksum and do mark_buffer_dirty(). I'd just
> > remove the 'now' test in this patch and then in patch 5 remove the now
> > argument from the function and callers as you did.
> 
> I am a bit confused.
> 
> It seems you consider that 'ext4_commit_super()' is a considerably
> slower than just marking the buffer as dirty right away. But I do not
> really understand why - all it does - it just updates a couple of
> superblock fields and then marks the buffer as dirty (I assume sync ==
> 0). So from my POW they are almost the same. And when csum is enabled -
> re-calculating csum will probably be the longest part.
  Well, the part you might be missing is:
        ext4_free_blocks_count_set(es,
                        EXT4_C2B(EXT4_SB(sb), percpu_counter_sum_positive(
                                &EXT4_SB(sb)->s_freeclusters_counter)));
        es->s_free_inodes_count =
                cpu_to_le32(percpu_counter_sum_positive(
                                &EXT4_SB(sb)->s_freeinodes_counter));
  percpu_counter_sum() *is* rather expensive. At least for big machines.

  Also just marking the buffer dirty more corresponds to what we do when
journalling.

> More important is that we dirty the superblock on every deletion - this
> mean that with my change we will re-calculate checsum on every deletion
> and I am not sure it is nice. Ideally, we should be able to calculate
> the checksum just before sending the buffer to the IO queue...
  Yes, that would be nice but it's not easy to do currently...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
