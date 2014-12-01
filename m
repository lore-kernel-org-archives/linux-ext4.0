From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfstests failures w/ metadata_csum
Date: Mon, 1 Dec 2014 14:02:09 -0800
Message-ID: <20141201220209.GS10043@birch.djwong.org>
References: <20141201202045.GR10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22986 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbaLAWCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2014 17:02:14 -0500
Content-Disposition: inline
In-Reply-To: <20141201202045.GR10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CRAP.

The real cause of the regression that Eric reported is: The first time we
enable journal_checksum on a journal, we fail to set the checksum seed because
the seed calculation is gated on jbd2_journal_has_csum_v2or3() ... before we
actually set the superblock feature fields!  Yikes!

The fix is to get rid of the braindead check and always calculate the seed.

I will have a regression fix for 3.18-rc7 out shortly.

(I'll also post a patch to complain loudly, but that isn't critical.)

--D

On Mon, Dec 01, 2014 at 12:20:45PM -0800, Darrick J. Wong wrote:
> Hi Eric,
> 
> Could you remind me which xfstests are failing in 3.18-rc3+ with metadata_csum
> enabled?  I think you said generic/034, generic/321, and generic/322, but were
> there more?
> 
> AFAICT the ext4 mount fails because it can't load the journal, and the journal
> can't replay because jbd2_descr_block_csum_verify() fails; the 034 test appears
> to drop all the writes related to the umount.  recovery.c doesn't say anything
> when the journal descriptor block fails csum verification, though it should.
> Not sure why we end up with corrupt-looking descriptor blocks.
> 
> The reason why this appears in -rc3 is because that's when we added the patch
> that forces journal_checksum on whenever metadata_csum is on, and I guess
> few people were testing journal_checksum with xfstests before that.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
