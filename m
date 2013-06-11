From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock
 to incorporate all users
Date: Tue, 11 Jun 2013 17:54:13 -0400
Message-ID: <51B79C85.7000800@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com> <1370892723-30860-2-git-send-email-paul.gortmaker@windriver.com> <20130611021230.GA23966@thunk.org> <20130611173824.GA29033@windriver.com> <20130611175345.GA6449@thunk.org> <20130611184851.GB29033@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:53694 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3FKVxm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 17:53:42 -0400
In-Reply-To: <20130611184851.GB29033@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13-06-11 02:48 PM, Paul Gortmaker wrote:
> [Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock to incorporate all users] On 11/06/2013 (Tue 13:53) Theodore Ts'o wrote:
> 
>> On Tue, Jun 11, 2013 at 01:38:24PM -0400, Paul Gortmaker wrote:
>>>  
>>> +#if defined(CONFIG_JBD_DEBUG) || defined(CONFIG_JBD2_DEBUG)
>>> +static inline void __jbd_debug(int level, const char *file, const char *func,
>>> +			       unsigned int line, const char *fmt, ...)
>>> +{
>>> +	struct va_format vaf;
>>> +	va_list args;
>>> +
>>> +	if (level > JOURNAL_ENABLE_DEBUG)
>>> +		return;
>>> +	va_start(args, fmt);
>>> +	vaf.fmt = fmt;
>>> +	vaf.va = &args;
>>> +	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
>>> +	va_end(args);
>>> +}
>>> +#endif
>>
>> What's the difference in the overall size of jbd.ko and jbd2.ko using
>> an inline __jbd_debug compared with one where the __jbd_debug is
>> defined as a function in fs/jbd2/journal.c (or fs/jbd/journal.c; that
>> will be the problem trying to solve this problem for jbd and jbd2 at
>> the same time)?
>>
>> If gcc was competent at optimizing inline functions with varargs, this
>> might be fine.  But I'm a bit concerned whether this might cause a lot
>> of bloat if CONFIG_JBD2_DEBUG is enabled.  It would be nice if the
>> impact was small enough that people were willing to enable so it's
>> available when we want to do debuggin.
> 
> There is a small delta for inline vs non-inline, but it isn't anywhere
> near as big as the off-vs-on delta (with gcc-4.7.3):
> 
> JBD[2]_DEBUG off:
>      text	   data	    bss	    dec	    hex	filename
>     48072	    113	    128	  48313	   bcb9	fs/jbd2/built-in.o
>     36862	     50	     32	  36944	   9050	fs/jbd/built-in.o
> 
> JBD[2]_DEBUG on, __jbd[2]_debug as two independent real void functions:
>      text	   data	    bss	    dec	    hex	filename
>     55261	    115	    132	  55508	   d8d4	fs/jbd2/built-in.o
>     43752	     51	     52	  43855	   ab4f	fs/jbd/built-in.o
> 
> JBD[2]_DEBUG on, __jbd_debug as a shared inline function in jbd_common.h:
>      text	   data	    bss	    dec	    hex	filename
>     55862	    115	    132	  56109	   db2d	fs/jbd2/built-in.o
>     44353	     51	     52	  44456	   ada8	fs/jbd/built-in.o
> 
> So it looks like you can choose whichever solution you like
> better.  I don't have a real preference either way.  The

The more I think about this, the more I'm inclined to go with
the two independent real void functions.  It gives smaller code
(albeit only slightly) and it probably is a tiny amount easier
to read vs. trying to be clever to share ~20 lines of code.

Plus I can then separate the ext3 content from the ext4 content
and create appropriate CC (i.e. add Jan Kara) for those parts.

Paul.
--

> non-inline version looks like what I've included below.
> 
> Paul.
> --
> 
> From d22a2bbe9108934ba3d1374f61f6e3a01aaa36e6 Mon Sep 17 00:00:00 2001
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Tue, 11 Jun 2013 11:46:10 -0400
> Subject: [PATCH] jbd/jbd2: make jbd_debug that won't split printk statements
> 
> Since the jbd_debug() is implemented with two separate printk()
> calls, it can lead to corrupted and misleading debug output like
> the following (see lines marked with "*"):
> 
> [  290.339362] (fs/jbd2/journal.c, 203): kjournald2: kjournald2 wakes
> [  290.339365] (fs/jbd2/journal.c, 155): kjournald2: commit_sequence=42103, commit_request=42104
> [  290.339369] (fs/jbd2/journal.c, 158): kjournald2: OK, requests differ
> [* 290.339376] (fs/jbd2/journal.c, 648): jbd2_log_wait_commit:
> [* 290.339379] (fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: want 42104, j_commit_sequence=42103
> [* 290.339382] JBD2: starting commit of transaction 42104
> [  290.339410] (fs/jbd2/revoke.c, 566): jbd2_journal_write_revoke_records: Wrote 0 revoke records
> [  290.376555] (fs/jbd2/commit.c, 1088): jbd2_journal_commit_transaction: JBD2: commit 42104 complete, head 42079
> 
> i.e. the debug output from log_wait_commit and journal_commit_transaction
> have become interleaved.  The output should have been:
> 
> (fs/jbd2/journal.c, 648): jbd2_log_wait_commit: JBD2: want 42104, j_commit_sequence=42103
> (fs/jbd2/commit.c, 370): jbd2_journal_commit_transaction: JBD2: starting commit of transaction 42104
> 
> It is expected that this is not easy to replicate -- I was only able
> to cause it on preempt-rt kernels, and even then only under heavy
> I/O load.  Ted suggested we make use of va_args to reduce it to a single
> printk() call to fix it.
> 
> This was originally seen on ext4, but since ext3 should suffer the
> same problem, I've taken the next step to implement the same kind of
> fix there as well.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 6510d63..5e046a6 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -90,6 +90,23 @@ static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
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
> +	if (level > journal_enable_debug)
> +		return;
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
> +	va_end(args);
> +}
> +#endif
> +
>  /*
>   * Helper function used to manage commit timeouts
>   */
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 9545757..6aa196e 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -103,6 +103,23 @@ EXPORT_SYMBOL(jbd2_inode_cache);
>  static void __journal_abort_soft (journal_t *journal, int errno);
>  static int jbd2_journal_create_slab(size_t slab_size);
>  
> +#ifdef CONFIG_JBD2_DEBUG
> +void __jbd2_debug(int level, const char *file, const char *func,
> +		  unsigned int line, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (level > jbd2_journal_enable_debug)
> +		return;
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
> +	va_end(args);
> +}
> +#endif
> +
>  /* Checksumming functions */
>  int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
>  {
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 6e5524f..bc12abc 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -56,17 +56,13 @@
>   */
>  #define JBD_EXPENSIVE_CHECKING
>  extern u8 journal_enable_debug;
> +void __jbd_debug(int level, const char *file, const char *func,
> +		 unsigned int line, const char *fmt, ...);
>  
> -#define jbd_debug(n, f, a...)						\
> -	do {								\
> -		if ((n) <= journal_enable_debug) {			\
> -			printk (KERN_DEBUG "(%s, %d): %s: ",		\
> -				__FILE__, __LINE__, __func__);	\
> -			printk (f, ## a);				\
> -		}							\
> -	} while (0)
> +#define jbd_debug(n, fmt, a...) \
> +	__jbd_debug((n), __FILE__, __func__, __LINE__, (fmt), ##a)
>  #else
> -#define jbd_debug(f, a...)	/**/
> +#define jbd_debug(n, fmt, a...)    /**/
>  #endif
>  
>  static inline void *jbd_alloc(size_t size, gfp_t flags)
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 9986ab8..8d95314 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -56,17 +56,13 @@
>   */
>  #define JBD2_EXPENSIVE_CHECKING
>  extern ushort jbd2_journal_enable_debug;
> +void __jbd2_debug(int level, const char *file, const char *func,
> +		  unsigned int line, const char *fmt, ...);
>  
> -#define jbd_debug(n, f, a...)						\
> -	do {								\
> -		if ((n) <= jbd2_journal_enable_debug) {			\
> -			printk (KERN_DEBUG "(%s, %d): %s: ",		\
> -				__FILE__, __LINE__, __func__);	\
> -			printk (f, ## a);				\
> -		}							\
> -	} while (0)
> +#define jbd_debug(n, fmt, a...) \
> +	__jbd2_debug((n), __FILE__, __func__, __LINE__, (fmt), ##a)
>  #else
> -#define jbd_debug(f, a...)	/**/
> +#define jbd_debug(n, fmt, a...)    /**/
>  #endif
>  
>  extern void *jbd2_alloc(size_t size, gfp_t flags);
> 
