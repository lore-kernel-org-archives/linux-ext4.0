From: Jan Kara <jack@suse.cz>
Subject: Re: ext3 build failure: "log_start_commit" [fs/ext3/ext3.ko]
	undefined
Date: Thu, 12 Nov 2009 10:40:42 +0100
Message-ID: <20091112094042.GC14528@duck.suse.cz>
References: <4AFB5529.2010302@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZKLJki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 04:40:38 -0500
Content-Disposition: inline
In-Reply-To: <4AFB5529.2010302@s5r6.in-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-11-09 01:22:01, Stefan Richter wrote:
> Hi Jan,
> 
> I just pulled linux-2.6.git and got this:
> ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
> 
> I guess it is due to "ext3: Wait for proper transaction commit on fsync".
> 
> Is this log_start_commit() of fs/jbd/journal.c?
> 
> $ grep -e JBD -e EXT3 .config
> CONFIG_EXT3_FS=m
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> # CONFIG_EXT3_FS_XATTR is not set
> CONFIG_JBD=m
> CONFIG_JBD2=m
  Yes, thanks. I've already merged the fix.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
