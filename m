From: Andreas Dilger <adilger@sun.com>
Subject: Re: What to do when the journal checksum is incorrect
Date: Tue, 03 Jun 2008 15:27:40 -0600
Message-ID: <20080603212740.GI2961@webber.adilger.int>
References: <E1K02Jh-0002wf-2e@closure.thunk.org>
 <1212488533.3272.23.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Girish Shilamkar <Girish.Shilamkar@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53628 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYFCV1t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 17:27:49 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m53LRnlQ000517
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 14:27:49 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1W00I01MZF8X00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 03 Jun 2008 14:27:49 -0700 (PDT)
In-reply-to: <1212488533.3272.23.camel@alpha.linsyssoft.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 03, 2008  15:52 +0530, Girish Shilamkar wrote:
> I went through the code and also re-ran the e2fsprogs tests which we had
> sent upstream for journal checksum. And found that if the transaction is
> bad it is marked as info->end_transaction which indicates a bad
> transaction and is not replayed.
> 
> if (chksum_err) {
>      info->end_transaction = next_commit_ID;
> 
> The end_transaction is set to transaction ID which is found to be
> corrupt. So #4 will be set in end_transaction and in PASS_REPLAY the
> last transaction to be replayed will be #3 due to this:
> ----------------------------------------------------------------
> if (tid_geq(next_commit_ID, info->end_transaction))
>                                 break;
> -----------------------------------------------------------------
> 
>      if (!JFS_HAS_COMPAT_FEATURE(journal,
>                                  JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)){
>            printk(KERN_ERR "JBD: Transaction %u found to be corrupt.\n",
>                 next_commit_ID);
>    brelse(bh);                                 
>    break;
>      }
> } 

Girish, thanks for following up on this.  It definitely eases my
concerns about the patch we are currently using.

> > Worse yet, no indication of any problems is
> > sent back to the ext4 filesystem code.
>
> This definitely is not present and needs to be incorporated. 

Yes, it seems that skipping later transactions definitely has some
drawbacks.

We had discussed on the ext4 concall a change to the format of the journal
checksum code, having it store a small per-block checksum in addition to
the per-transaction checksum, so that in case of transaction corruption
the good blocks can be recovered and the bad ones skipped.

The proposal was to do an adler32 checksum of the block (using
the transaction number and filesystem block number at the start of
the checksum data), and then store the high (or low?) 16 bits of the
checksum in the high 16 bits of the journal_block_tag_s.t_flags field.
The full 32-bit per-block checksum would also be checksummed in order
to generate the 32-bit transaction checksum.

While a 16-bit checksum is itself is not very strong, we have the full
32-bit transaction checksum to verify the whole transaction, and we
only care about 16-bit per-block checksum in the rare case when the
transaction checksum is bad.  Having the transaction number "seed" each
of the per-block checksums avoids the risk of having an old journal tag
block in the journal with "good" checksums, and having the filesystem
block number in the checksum avoids the risk of single-bit errors in
the tag block resulting in the "good checksum" block being written to
the wrong part of the filesystem.

This new per-block checksum would be recorded as a new checksum type
in the journal superblock.  The reason for using adler32 instead of
the CRC32 we are using now is that adler32 is significantly faster
when implemented in software, and is equally robust for the blocksizes
we are using for ext3 (adler32 is not as strong with very small buffer
sizes like 128 bytes or less).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

