From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] ext3: abort ext3 if the journal has aborted
Date: Mon, 2 Jun 2008 14:49:44 +0200
Message-ID: <20080602124944.GM30613@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com> <4843D009.9010200@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42219 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753222AbYFBMtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 08:49:46 -0400
Content-Disposition: inline
In-Reply-To: <4843D009.9010200@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-06-08 19:48:41, Hidehiro Kawai wrote:
> Subject: [PATCH 5/5] ext3: abort ext3 if the journal has aborted
> 
> If the journal has aborted due to a checkpointing failure, we
> have to keep the contents of the journal space.  ext3_put_super()
> detects the journal abort, then it invokes ext3_abort() to make
> the filesystem read only and keep needs_recovery flag.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
...
> @@ -2373,7 +2374,13 @@ static void ext3_write_super_lockfs(stru
>  
>  		/* Now we set up the journal barrier. */
>  		journal_lock_updates(journal);
> -		journal_flush(journal);
> +
> +		/*
> +		 * We don't want to clear needs_recovery flag when we failed
> +		 * to flush the journal.
> +		 */
> +		if (journal_flush(journal) < 0)
> +			return;
>  
>  		/* Journal blocked and flushed, clear needs_recovery flag. */
>  		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
  It's a bit scary that LVM will start creating filesystem snapshot when
journal_flush() failed but since there's no way to propagate error further
up, I guess we cannot do anything better.
  You can add:
    Acked-by: Jan Kara <jack@suse.cz>

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
