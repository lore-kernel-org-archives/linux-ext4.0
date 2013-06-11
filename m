From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock
 to incorporate all users
Date: Tue, 11 Jun 2013 13:53:45 -0400
Message-ID: <20130611175345.GA6449@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-2-git-send-email-paul.gortmaker@windriver.com>
 <20130611021230.GA23966@thunk.org>
 <20130611173824.GA29033@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57023 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3FKRxs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jun 2013 13:53:48 -0400
Content-Disposition: inline
In-Reply-To: <20130611173824.GA29033@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 11, 2013 at 01:38:24PM -0400, Paul Gortmaker wrote:
>  
> +#if defined(CONFIG_JBD_DEBUG) || defined(CONFIG_JBD2_DEBUG)
> +static inline void __jbd_debug(int level, const char *file, const char *func,
> +			       unsigned int line, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (level > JOURNAL_ENABLE_DEBUG)
> +		return;
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
> +	va_end(args);
> +}
> +#endif

What's the difference in the overall size of jbd.ko and jbd2.ko using
an inline __jbd_debug compared with one where the __jbd_debug is
defined as a function in fs/jbd2/journal.c (or fs/jbd/journal.c; that
will be the problem trying to solve this problem for jbd and jbd2 at
the same time)?

If gcc was competent at optimizing inline functions with varargs, this
might be fine.  But I'm a bit concerned whether this might cause a lot
of bloat if CONFIG_JBD2_DEBUG is enabled.  It would be nice if the
impact was small enough that people were willing to enable so it's
available when we want to do debuggin.

Regards,

					- Ted
