From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: journal_dev + metadata_csum issues
Date: Sat, 6 Sep 2014 00:13:20 -0700
Message-ID: <20140906071320.GC27293@birch.djwong.org>
References: <BAY406-EAS34578C88C7F39934F1D8730FDC50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIFHNZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Sep 2014 03:13:25 -0400
Content-Disposition: inline
In-Reply-To: <BAY406-EAS34578C88C7F39934F1D8730FDC50@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 12:14:32AM -0400, TR Reardon wrote:
> 1) tune2fs hiccups when presented with journal device fs.  Should it instead
> at least report "this is a journal device" rather than "invalid super block"?

Yes.  e2fsck/debugfs seem to issue the 'unsupported features' complaint but
without the 'invalid superblock' wording.

> 2) no way to create journal_dev with metadata_csum.  This would provide
> checksum for the fs superblock.

Not sure how useful this is since most of the SB is irrelevant here.  But I
don't see any reason why we shouldn't let users turn it on.

> 3) dumpe2fs should still display journal flags for journal_dev; currently it
> fails to display journal flags.

Ick.  Yes, that should work.

> 4) s_jnl_blocks in the superblock should be zeroed when removing a journal
> (ie ^has_journal) or when setting the journal to journal_dev.  Currently, the
> legacy (now dead) block list is maintained.  I'd argue that will invite
> misuse.

Seems like a reasonable precaution.

Now, does anyone know why ext4 reports a df size of 64ZB when I create an
external journal FS? :)

--D
