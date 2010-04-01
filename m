From: Jan Kara <jack@suse.cz>
Subject: Re: question on sync()
Date: Thu, 1 Apr 2010 21:54:33 +0200
Message-ID: <20100401195433.GB8401@atrey.karlin.mff.cuni.cz>
References: <1270052957.26517.24.camel@subu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Surbhi Palande <Surbhi.Palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40041 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753923Ab0DATyd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 15:54:33 -0400
Content-Disposition: inline
In-Reply-To: <1270052957.26517.24.camel@subu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> While looking at fs/sync.c :: sync(), I found out that:
> 
> 1) sync() first calls wakeup_flusher_threads() which ultimately calls
> bdi_alloc_queue_work() with WB_SYNC_NONE for every bdi in the bdi_list.
> 
> 2) sync() immediate then calls sync_filesystems(0) which does the same
> thing - it calls writeback_inodes_sb() which finally calls
> bdi_alloc_queue_work() with WB_SYNC_NONE for every bdi corresponding to
> every filesystem.
> 
> If it is possible, then I wanted to know why there are effectively two
> calls which ultimately call bdi_alloc_queue_work() with WB_SYNC_NONE
> twice?
  It's mostly a leftover from times when pdflush did background writing and
sync_filesystem() was submitting IO on it's own (i.e., not leaving the work on
flusher threads). Currently, you are right that wakeup_flusher_threads() is
superfluous. But the whole sync code would need a cleanup to properly reflect
the fact that know *all* the writes are done in background flusher threads.
For example __sync_filesystem() in wait=0 case doesn't make much sense
currently.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
