From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] jbd: abort when failed to log metadata buffers
Date: Mon, 2 Jun 2008 14:00:16 +0200
Message-ID: <20080602120016.GJ30613@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com> <4843CF6A.7090107@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39618 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbYFBMAS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 08:00:18 -0400
Content-Disposition: inline
In-Reply-To: <4843CF6A.7090107@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-06-08 19:46:02, Hidehiro Kawai wrote:
> Subject: [PATCH 3/5] jbd: abort when failed to log metadata buffers
> 
> If we failed to write metadata buffers to the journal space and
> succeeded to write the commit record, stale data can be written
> back to the filesystem as metadata in the recovery phase.
> 
> To avoid this, when we failed to write out metadata buffers,
> abort the journal before writing the commit record.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/jbd/commit.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.26-rc4/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/jbd/commit.c
> +++ linux-2.6.26-rc4/fs/jbd/commit.c
> @@ -734,6 +734,9 @@ wait_for_iobuf:
>  		/* AKPM: bforget here */
>  	}
>  
> +	if (err)
> +		journal_abort(journal, err);
> +
>  	jbd_debug(3, "JBD: commit phase 6\n");
>  
>  	if (journal_write_commit_record(journal, commit_transaction))
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
