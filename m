From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] jbd: use a single printk for jbd_debug()
Date: Fri, 2 Aug 2013 00:19:44 +0200
Message-ID: <20130801221944.GF31857@quack.suse.cz>
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
 <1375383668-8072-5-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375383668-8072-5-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 01-08-13 15:01:08, Paul Gortmaker wrote:
> Backport of jbd2 commit 169f1a2a87aae44034da4b9f81be1683d33de6d0
> ("jbd2: use a single printk for jbd_debug()")
> 
> Quoting the original:
>  --------------
>  Since the jbd_debug() is implemented with two separate printk()
>  calls, it can lead to corrupted and misleading debug output like
>  the following (see lines marked with "*"):
> 
>  [  290.339362] (fs/jbd2/journal.c, 203): kjournald2: kjournald2 wakes
>  [  290.339365] (fs/jbd2/journal.c, 155): kjournald2: commit_sequence=42103, commit_request=42104
>  [  290.339369] (fs/jbd2/journal.c, 158): kjournald2: OK, requests differ
>  [* 290.339376] (fs/jbd2/journal.c, 648): jbd2_log_wait_commit:
>  [* 290.339379] (fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: want 42104, j_commit_sequence=42103
>  [* 290.339382] JBD2: starting commit of transaction 42104
>  [  290.339410] (fs/jbd2/revoke.c, 566): jbd2_journal_write_revoke_records: Wrote 0 revoke records
>  [  290.376555] (fs/jbd2/commit.c, 1088): jbd2_journal_commit_transaction: JBD2: commit 42104 complete, head 42079
> 
>  i.e. the debug output from log_wait_commit and journal_commit_transaction
>  have become interleaved.  The output should have been:
> 
>  (fs/jbd2/journal.c, 648): jbd2_log_wait_commit: JBD2: want 42104, j_commit_sequence=42103
>  (fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: starting commit of transaction 42104
> 
>  It is expected that this is not easy to replicate -- I was only able
>  to cause it on preempt-rt kernels, and even then only under heavy
>  I/O load.
>  --------------
  Thanks. I've merged the patch to my tree.

								Honza

> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  fs/jbd/journal.c    | 18 ++++++++++++++++++
>  include/linux/jbd.h | 15 ++++++---------
>  2 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 166263d..f45f0a3 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -97,6 +97,24 @@ static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
>  static void __journal_abort_soft (journal_t *journal, int errno);
>  static const char *journal_dev_name(journal_t *journal, char *buffer);
>  
> +#ifdef CONFIG_JBD_DEBUG
> +void __jbd_debug(int level, const char *file, const char *func,
> +		 unsigned int line, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (level > jbd_journal_enable_debug)
> +		return;
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
> +	va_end(args);
> +}
> +EXPORT_SYMBOL(__jbd_debug);
> +#endif
> +
>  /*
>   * Helper function used to manage commit timeouts
>   */
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index e45b430..d6d3ae0 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -56,16 +56,13 @@
>  #define JBD_EXPENSIVE_CHECKING
>  extern ushort journal_enable_debug;
>  
> -#define jbd_debug(n, f, a...)						\
> -	do {								\
> -		if ((n) <= journal_enable_debug) {			\
> -			printk (KERN_DEBUG "(%s, %d): %s: ",		\
> -				__FILE__, __LINE__, __func__);	\
> -			printk (f, ## a);				\
> -		}							\
> -	} while (0)
> +void __jbd_debug(int level, const char *file, const char *func,
> +		 unsigned int line, const char *fmt, ...);
> +
> +#define jbd_debug(n, fmt, a...) \
> +	__jbd_debug((n), __FILE__, __func__, __LINE__, (fmt), ##a)
>  #else
> -#define jbd_debug(f, a...)	/**/
> +#define jbd_debug(n, fmt, a...)    /**/
>  #endif
>  
>  static inline void *jbd_alloc(size_t size, gfp_t flags)
> -- 
> 1.8.1.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
