From: Jan Kara <jack@suse.cz>
Subject: Re: Possible irq lock inversion dependency detected in JBD
Date: Tue, 8 Dec 2009 16:13:32 +0100
Message-ID: <20091208151332.GA3141@atrey.karlin.mff.cuni.cz>
References: <4B0BD960.5040105@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755916AbZLHPN2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B0BD960.5040105@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> During testing I had the below trace from lockdep. After some googling seems
> it wasn't reported. The complete trace attached, it's almost 800K uncompressed.
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.31-scst-dbg #3
> ---------------------------------------------------------
> kswapd0/290 just changed the state of lock:
>  (jbd_handle){+.+.-.}, at: [<7826a6fa>] journal_start+0xd4/0x13a
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&type->s_lock_key){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
> no locks held by kswapd0/290.
  Thanks for the report. If I'm reading the lockdep messages right, it
complains that page reclaim can be run with sb->s_lock held but we also
start a transaction in the page reclaim path and we take sb->s_lock after
starting a transaction in some paths.
  The warning seems to be false positive to me since we don't really
acquire sb->s_lock in the reclaim path. It would be nice if we could
get this sorted out but I don't see an easy way out of this...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
