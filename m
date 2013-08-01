From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] jbd: use a single printk for jbd_debug()
Date: Fri, 2 Aug 2013 00:23:04 +0200
Message-ID: <20130801222304.GG31857@quack.suse.cz>
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
 <1375383668-8072-5-git-send-email-paul.gortmaker@windriver.com>
 <1375384865.2034.70.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3HAWXG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 18:23:06 -0400
Content-Disposition: inline
In-Reply-To: <1375384865.2034.70.camel@joe-AO722>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-08-13 12:21:05, Joe Perches wrote:
> On Thu, 2013-08-01 at 15:01 -0400, Paul Gortmaker wrote:
> > Backport of jbd2 commit 169f1a2a87aae44034da4b9f81be1683d33de6d0
> > ("jbd2: use a single printk for jbd_debug()")
> 
> Hey Paul.
> 
> > diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> []
> > @@ -56,16 +56,13 @@
> >  #define JBD_EXPENSIVE_CHECKING
> >  extern ushort journal_enable_debug;
> >  
> > -#define jbd_debug(n, f, a...)						\
> > -	do {								\
> > -		if ((n) <= journal_enable_debug) {			\
> > -			printk (KERN_DEBUG "(%s, %d): %s: ",		\
> > -				__FILE__, __LINE__, __func__);	\
> > -			printk (f, ## a);				\
> > -		}							\
> > -	} while (0)
> > +void __jbd_debug(int level, const char *file, const char *func,
> > +		 unsigned int line, const char *fmt, ...
> > +
> > +#define jbd_debug(n, fmt, a...) \
> > +	__jbd_debug((n), __FILE__, __func__, __LINE__, (fmt), ##a)
> >  #else
> > -#define jbd_debug(f, a...)	/**/
> > +#define jbd_debug(n, fmt, a...)    /**/
> >  #endif
> 
> It might have been (and may still be) simpler/better
> to use a single macro like:
> 
> #define jbd_dbg(n, fmt, ...)			\
> do {						\
> 	if ((n) < journal_enable_debug)		\
> 		pr_debug(fmt, ##__VA_ARGS__);	\
> } while (0)
> 
> and then use dynamic_debug to add the __func__,
> and __LINE__ when desired.
> 
> echo -n 'module jbd +pfl' <dynamic_debug>/control
  Umm, I like the Paul's way better. Sure we have to jump into
__jbd_debug() even if we won't write any message because debug level is low
but OTOH jbd_debug() is non-empty only when JBD_EXPENSIVE_CHECKING is
enabled. So there the extra call is fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
