From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 barrier on SCSI vs SATA?
Date: Wed, 9 May 2012 21:50:56 +0200
Message-ID: <20120509195056.GH5092@quack.suse.cz>
References: <4FA7A584.5060902@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab2EITvA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2012 15:51:00 -0400
Content-Disposition: inline
In-Reply-To: <4FA7A584.5060902@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 07-05-12 10:35:48, Daniel Pocock wrote:
> 
> 
> I understand that for barriers to work, the fs needs to be able to tell
> the drive when to move data from hardware cache to the platter.
> 
> I notice various pages mention the SYNCHRONIZE CACHE command (SCSI) and
> the FLUSH_CACHE_EXT command (ATA) as if they are equivalent.
> 
> Looking more closely, I found the SYNCHRONIZE CACHE supports a block
> range, whereas it appears that FLUSH_CACHE_EXT always flushes the entire
> cache (maybe 32MB or 64MB on a SATA drive)
> 
> Does ext4 always flush all of the cache contents?  Or if the system is
> SCSI, does it only selectively flush the blocks that must be flushed to
> maintain coherency?
  We always flush the complete cache. Actually, there's no interface for
filesystem to tell lower layers that only some blocks should be flushed
AFAIK. And even if we could, journaling is designed so that we need to
flush caches for most of blocks because usually data blocks need to be on
stable storage when transaction commits.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
