From: Jan Kara <jack@suse.cz>
Subject: Re: [bug] ext{3,4}: __find_get_block_slow() failed on 3.0.3
Date: Mon, 5 Sep 2011 14:59:40 +0200
Message-ID: <20110905125939.GF5466@quack.suse.cz>
References: <CANvSZQ804KZWhPG4JvzOPtkC02ibD6YmRnUvHCEhLB8DKEo7LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1IEM7o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 08:59:44 -0400
Content-Disposition: inline
In-Reply-To: <CANvSZQ804KZWhPG4JvzOPtkC02ibD6YmRnUvHCEhLB8DKEo7LQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Sat 20-08-11 01:51:49, Thilo-Alexander Ginkel wrote:
> while rsyncing a large amount (> 1TB) of data from an ext3 to an ext4
> on my machine [1], I encountered an issue where rsync and syslog
> eventually started consuming 100% CPU and my syslog was flooded [2]
> with error messages:
> 
> -- 8< --
> > kernel: [101543.047293] b_state=0x00000029, b_size=>[10ock01543.04>[101543.047321] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> > kernel: [101543.047330] b_state=0x00000029, b_size=4096
> > kernel: [101543.047>[10ock01543.047348] b_state=0x00000029, b_size=4096
> > kernel: [101543.047353] device blocksize: 4096
> > kernel: [101543.047359] __find_get_block_slow() failed. block=328204473, b01543.0>[10ock01543.047>[1ock01543.047404] b_state=0x00000029, b_size=4096
> > kernel: [101543.047409] device blocksize: 4096
> > kernel: [101543.047414] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> > kernel: [10154ock01543.0>[1ock01543.0492>[1ock01543.0492>[1ock01543.049>[1ock01543.0492>[1ock01543.0>[1ock01543.049>[1ock01543.049>[1ock01543.0492>[10ock01543.0>[1ock=01543.04>[1ock01543.>[1ock01543.0493>[1ock01543.049>[1ock01543.04>[1ock01543.0493>[1ock01543.04941>[1ock01543.0494>[1ock01543.0>[1ock01543.049>[10ock01543.0>[1ock01543.04>[1ock01543.04>[1ock01543.0495>[1ock01543.0495>[1ock01543.0495>[1ock01543.0496>[1ock01543.04>[1ock01543.04>[1ock01543.049>[1ock01543.049>[1ock01543.04>[1ock01543.0497>[1ock01543.0>[1ock01543.0497>[1ock01543.0497>[1ock01543.0498>[1ock01543.0498>[1ock01543.04>[1ock01543.04>[1ock01543.0498>[1ock01543.0498>[1ock01543.0499>[1ock01543.0499>[1ock01543.04>[101543.049967] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> > kernel: [101543.049975] b_state=0x00000029, b_size=4096
> > kernel: [101543.049980] device blocksize: 4096
> > kernel: [101543.049986] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> -- 8< --
> 
> These are not preceded by any other error messages (about possible FS
> inconsistencies) as has been the case in the past when bugs related to
> this error message were reported.
> 
> Judging by the block size, the possibly corrupt volume is the ext3 one
> (the ext4 volume has a block size of 2048).
> 
> A forced fsck.ext{3,4} of the source and target partitions did not
> show any inconsistencies.
> 
> Any ideas?
  Something has corrupted your buffer head structure in memory (and we then
infinitely looped in __getblk_slow()). bh->b_blocknr has been 0xC139000B9
which it should have been 0x139000B9 (5th byte has been changed from 0x00
to 0x0C). It might be a hw fault, buggy driver, or some other bug - hard to
say. You might want to run memtest for some time, or enable some kernel debug
options (DEBUG_PAGEALLOC, DEBUG_SLAB) which might catch the code causing
corruption (this assumes it's at least occasionally reproducible and your
are willing to take the performance hit)...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
