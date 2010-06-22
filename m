From: Jan Kara <jack@suse.cz>
Subject: Re: Updated ext4 quota design document
Date: Tue, 22 Jun 2010 16:20:47 +0200
Message-ID: <20100622142047.GF3338@quack.suse.cz>
References: <E1OQg7e-0001mI-AB@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab0FVOVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jun 2010 10:21:11 -0400
Content-Disposition: inline
In-Reply-To: <E1OQg7e-0001mI-AB@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon 21-06-10 08:29:06, Theodore Ts'o wrote:
> I've created an updated quota design document here:
> 
> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4
> 
> No major changes from last time.
> 
> One new thing is a proposed (optional) change to the quota format,
> to use the 32-bit dqpb_pad field in the v2r1 on-disk quota structure as
> a 32-bit CRC of the quota entry.  This would allow the quota system to
> detect corrupted quota entries.  Jan, what do you think?
  It might be reasonable to checksum dquots so that we get closer to
all-metadata-are-checksummed state. I'm just thinking whether checksumming
each dquot is so useful. For example OCFS2 checksums each quota block. That
has an advantage that also quota file tree blocks and headers are
protected. Also it's possible to use the generic block checksumming
framework in JBD2 for this case. OTOH ext4 seems to have chosen to checksum
each group descriptor individually so checksumming each dquot structure
would seem more consistent.
  So I don't have a strong opinion which checksumming scheme should be
chosen. I just wanted to point out that there's another reasonable option.
Generic quota code can easily handle both (including leaving some bytes at
the end of each block for checksums as it does for OCFS2 now).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
