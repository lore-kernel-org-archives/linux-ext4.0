From: djwong <djwong@us.ibm.com>
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata
 checksumming
Date: Fri, 18 May 2012 15:51:01 -0700
Message-ID: <20120518225101.GH6938@tux1.beaverton.ibm.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
 <20120428141933.GB29481@thunk.org>
 <FCF93AD5-A078-4855-BC8D-B7B046884411@dilger.ca>
 <20120429193921.GA7342@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57428 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030349Ab2ERWvs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2012 18:51:48 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 18 May 2012 16:51:47 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id A9D4BC90057
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 18:51:00 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4IMp3wQ26607664
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 18:51:03 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4IMp246023719
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 19:51:03 -0300
Content-Disposition: inline
In-Reply-To: <20120429193921.GA7342@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 29, 2012 at 03:39:21PM -0400, Ted Ts'o wrote:
> [ I've trimmed the cc line to avoid spamming lots of folks who might not
>   care about the details of jbd2 checksumming. ]
> 
> On Sat, Apr 28, 2012 at 04:58:12PM -0600, Andreas Dilger wrote:
> > 
> > I thought we originally discussed using the high 16 bits of the
> > t_flags field to store the checksum?  This would avoid the need to
> > change the disk format.
> 
> I don't recall that suggestion, but I like it.  One thing that will
> get subtle about this is that t_flags is stored big-endian (jbd/jbd2
> data structures are stored be, but the data structures in ext4 proper
> are stored le; sigh).   So we'd have to do something like this:
> 
> typedef struct journal_block_tag_s
> {
> 	__u32		t_blocknr;	/* The on-disk block number */
> 	__u16		t_checksum;	/* 16-bit checksum */
> 	__u16		t_flags;	/* See below */
> 	__u32		t_blocknr_high; /* most-significant high 32bits. */
> } journal_block_tag_t;
> 
> ... and then make sure we change all of the places that access t_flags
> using cpu_to_be32() and be32_to_cpu() get changed to the 16-bit
> variant.
> 
> > Since there is still a whole transaction checksum, it isn't so
> > critical that the per-block checksum be strong.
> >
> > One idea is to do the crc32c for each block, then store the high 16
> > bits into t_flags, and checksum the full 32-bit per-block checksums
> > to make the commit block checksum, to avoid having to do the block
> > checksums twice.
> 
> It's not critical because the hard drive is doing its own ECC.  So I'm
> not that worried about detecting a large burst of bit errors, which is
> the main advantage of using a larger CRC.  I'm more worried about a
> disk block getting written to the wrong place, or not getting written
> at all.  So whether the chance of detecting a wrong block is 99.9985%
> at all (w/ a 16-bit checksum) or 99.9999% (with a 32-bit checksum),
> at all, either is fine.

Hmmm, what about 64k block filesystems?

Anyway, I revised two of the patches quite a while ago and apparently forgot to
send them. :(  They simply enlarge the journal tag struct and adjust the code
to use journal_tag_bytes() instead of the constants.

I was going to send them out, but I rebased off e2fsprogs head and 3.4-rc7 just
today and saw new regressions about group descriptor checksums.  Oh well.

--D

> 
> I'm not even sure I would worry combining the per-block checksums into
> the commit block checksum.  In the rare case where there is an error
> not detected by the 16-bit checksum which is detected in the commit
> checksum, what are we supposed to do?  Throw away the entire commit
> again?  Just simply testing to see what we do in this rare case is
> going to be interesting / painful.
> 
>    	     	     	      	 	     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

