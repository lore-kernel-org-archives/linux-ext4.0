From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] jbd,jbd2 : Fix __log_start_commit for both jbd and
 jbd2 to return 1 instead of 0 if target transaction is actively being
 committed.
Date: Tue, 17 May 2011 12:32:11 +0200
Message-ID: <20110517103211.GB24728@quack.suse.cz>
References: <4C88517147624A459A766BC451FA1BA4049532CED2@EXCH-MBX-4.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>,
	'Jan Kara' <jack@suse.cz>
To: Edward Goggin <egoggin@vmware.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab1EQKce (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 06:32:34 -0400
Content-Disposition: inline
In-Reply-To: <4C88517147624A459A766BC451FA1BA4049532CED2@EXCH-MBX-4.vmware.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 13-05-11 06:54:47, Edward Goggin wrote:
> __log_start_commit for both jbd and jbd2 returns zero even when
> the actively committing transaction has not yet completed. All
> current callers of both __log_start_commit and its wrapper
> function log_start_commit ignore the return value, but
> ext4_sync_file does not. Unfortunately a return value of zero
> from the call to log_start_commit in ext4_sync_file causes
> ext4_sync_file to not call jbd2_log_wait_commit.
> 
> If jbd2_log_wait_commit is not called it is possible for the
> calling context to return from ext4 without having persisted
> the updates to the meta data (assume a write to a previously
> unallocated region of a file) associated with the current ext4
> operation. If the context calling ext4_sync_file is an nfs daemon,
> the daemon has the potential of acknowledging the nfs write
> request to its client before the ext4 meta data (assume journal
> mode of (data=ordered) is persistent. Data corruption (lost write)
> is possible if after the reply for the nfs request is sent, a
> power outage, kernel panic, or other similar unorderly shutdown
> precludes the actual committing of the jbd2 transaction required
> to later retrieve the data written to the file.
> 
> This issue appears to be addressed for ext3 by
> http://kerneltrap.org/mailarchive/linux-ext4/2010/4/26/6884343.
> It is not clear why similar changes were not applied to ext4/jbd2
> at that time.
  Thanks Ed for spotting this! Your fix sadly does not solve all the issues
in the code because when transaction commit is in progress, we do not know
whether a barrier has been already issued while we were writing out data
for fsync or whether it's going to be issued later. So we could miss
sending a barrier in some cases.

Also we prefer to keep ext3 and ext4 code in sync so I've ported ext3 fixes
to ext4 and sent them to Ted for inclusion.

								Honza
 
> Signed-off-by: Ed Goggin <egoggin@vmware.com>
> 
> diff -uprN linux-2.6.38.5//fs/jbd/journal.c linux-2.6.38.5.fix//fs/jbd/journal.c
> --- linux-2.6.38.5//fs/jbd/journal.c    2011-05-02 16:30:53.000000000 +0000
> +++ linux-2.6.38.5.fix//fs/jbd/journal.c        2011-05-12 21:27:04.000000000 +0000
> @@ -452,6 +452,16 @@ int __log_start_commit(journal_t *journa
>                 wake_up(&journal->j_wait_commit);
>                 return 1;
>         }
> +        else if (journal->j_commit_request == target) {
> +                /*
> +                 * Return 1 so caller will wait for actively committing
> +                 * transaction if they depend on this return value.
> +                 */
> +                jbd_debug(1, "JBD: requesting commit is current commit %d/%d\n",
> +                          journal->j_commit_request,
> +                          journal->j_commit_sequence);
> +                return 1;
> +        }
>         return 0;
>  }
> 
> diff -uprN linux-2.6.38.5//fs/jbd2/journal.c linux-2.6.38.5.fix//fs/jbd2/journal.c
> --- linux-2.6.38.5//fs/jbd2/journal.c   2011-05-02 16:30:53.000000000 +0000
> +++ linux-2.6.38.5.fix//fs/jbd2/journal.c       2011-05-12 21:26:53.000000000 +0000
> @@ -494,6 +494,16 @@ int __jbd2_log_start_commit(journal_t *j
>                 wake_up(&journal->j_wait_commit);
>                 return 1;
>         }
> +        else if (journal->j_commit_request == target) {
> +                /*
> +                 * Return 1 so caller will wait for actively committing
> +                 * transaction if they depend on this return value.
> +                 */
> +                jbd_debug(1, "JBD: requesting commit is current commit %d/%d\n",
> +                          journal->j_commit_request,
> +                          journal->j_commit_sequence);
> +                return 1;
> +        }
>         return 0;
>  }
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
