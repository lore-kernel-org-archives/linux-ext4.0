From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: remove duplicate `\n` in jbd_debug
Date: Tue, 6 Feb 2018 11:43:54 +0100
Message-ID: <20180206104354.ei3dot6f26rxqudx@quack2.suse.cz>
References: <1517836881-31775-1-git-send-email-wanglong19@meituan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Wang Long <wanglong19@meituan.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517836881-31775-1-git-send-email-wanglong19@meituan.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 05-02-18 21:21:21, Wang Long wrote:
> The current jbd_debug output as the following:
> 
> ```
> [180397.891399] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 718): JBD2: Submit 4 IOs
> 
> [180397.891417] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 821): JBD2: commit phase 3
> 
> [180397.899183] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 863): JBD2: commit phase 4
> 
> [180397.899189] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 886): JBD2: commit phase 5
> 
> [180397.900321] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 923): JBD2: commit phase 6
> 
> [180397.900327] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 1092): JBD2: commit phase 7
> ```
> 
> Every jbd_debug call in kernel will append `\n` in its
> fmt argument, so remove duplicate `\n`
> 
> Signed-off-by: Wang Long <wanglong19@meituan.com>

Makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 3fbf48e..93016bb 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -114,7 +114,7 @@ void __jbd2_debug(int level, const char *file, const char *func,
>  	va_start(args, fmt);
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
> -	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
> +	printk(KERN_DEBUG "%s: (%s, %u): %pV", file, func, line, &vaf);
>  	va_end(args);
>  }
>  EXPORT_SYMBOL(__jbd2_debug);
> -- 
> 1.8.3.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
