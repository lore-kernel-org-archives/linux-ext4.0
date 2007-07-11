From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 8][PATCH 1/1]Add journal checksums
Date: Wed, 11 Jul 2007 07:01:08 -0600
Message-ID: <20070711130108.GB6417@schatzie.adilger.int>
References: <1183275505.4010.136.camel@localhost.localdomain> <20070710231601.798304e0.akpm@linux-foundation.org> <1184154399.3867.44.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:34572 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761219AbXGKNBL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 09:01:11 -0400
Content-Disposition: inline
In-Reply-To: <1184154399.3867.44.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 11, 2007  17:16 +0530, Girish Shilamkar wrote:
> > > +	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
> > > +		jbd2_journal_set_features(sbi->s_journal,
> > > +				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
> > > +				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > > +	} else if (test_opt(sb, JOURNAL_CHECKSUM)) {
> > > +		jbd2_journal_set_features(sbi->s_journal,
> > > +				JBD2_FEATURE_COMPAT_CHECKSUM, 0, 0);
> > > +		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
> > > +				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > > +	} else {
> > > +		jbd2_journal_clear_features(sbi->s_journal,
> > > +				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
> > > +				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > > +	}
> > 
> > Some discussion of the forward- and backward- compatibility design would be
> > appropriate.  Also a description of whether and how fsck can be used to fix
> > up these feature flags.

It is forward & backward compatible to enable COMPAT_CHECKSUM.  That just
means the commit blocks will have checksums in them, but older kernels
will just ignore them.  Hmm, I suppose there might be an issue with "upgrade,
downgrade, upgrade" in that the commit blocks would not have checksums
even though the superblock says they will...

Does that mean we should accept a checksum == 0 as being valid (which
is not very nice, given that 0 is an oft-hit bad value), or that we need
a flag in every commit block which indicates if it actually has a checksum?

The INCOMPAT_ASYNC_COMMIT can't be handled safely by older kernels, since
they would assume "commit block == complete transaction", which isn't
true if the commit block didn't wait for the rest of the blocks to make
it to the disk.

I don't think e2fsck can be used to individually clean up the feature flags,
but it is always possible to remove and recreate the journal...

> > > -	/* AKPM: buglet - add `i' to tmp! */
> > 
> > Damn.  After, what, seven years, someone actually fixed it?
> > 
> > >  	for (i = 0; i < bh->b_size; i += 512) {
> > > -		journal_header_t *tmp = (journal_header_t*)bh->b_data;
> > > +		struct commit_header *tmp =
> > > +			(struct commit_header *)(bh->b_data + i);
> > >  		tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
> > >  		tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
> > >  		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> > > +
> > > +		if (JBD2_HAS_COMPAT_FEATURE(journal,
> > > +					    JBD2_FEATURE_COMPAT_CHECKSUM)) {
> > > +			tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
> > > +			tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
> > > +			tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
> > > +		}
> > >  	}
> > 
> > And in doing so, changed the on-disk format of the journal commit blocks.
> > 
> > Surely this was worth a mention in the changelog, if not a standalone patch?
> > 
> > I don't think this is worth doing, really.  Why not just leave the format
> > as it was, take the loop out and run this code once rather than eight
> > times?

Well, we aren't using the rest of the commit block in any case.  I think
the original intention was that we'd get 8 copies of the commit block so
we would be sure to get a good one.

I don't know whether we'd rather have 8 copies of the commit block, or
more potential to expand the commit block?  I don't personally have any
preference, since the checksum should be a more robust way of checking
validity than having multiple copies, so we may as well remove the loop
and stick with a single copy for now.

> > > @@ -328,6 +360,7 @@ static int do_one_pass(journal_t *journa
> > >  	unsigned int		sequence;
> > >  	int			blocktype;
> > >  	int			tag_bytes = journal_tag_bytes(journal);
> > > +	__u32			crc32_sum = ~0; /* Transactional Checksums */
> > 
> > We normally use __u32 for visible-to-userspace stuff.  Kernel code would
> > use plain old u32.
> Ok.

Since the checksum is saved to disk, it seems more appropriate to use __u32
or maybe even __be32, though I'm not sure if the crc32 functions do that
correctly or not.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
