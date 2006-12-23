From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] ext4-delayed-allocation.patch
Date: Sat, 23 Dec 2006 14:59:07 -0800
Message-ID: <20061223145907.c7e09a8b.akpm@osdl.org>
References: <m37iwjwumf.fsf@bzzz.home.net>
	<m3tzznvfnz.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbWLWW7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Dec 2006 17:59:10 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3tzznvfnz.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 22 Dec 2006 23:28:32 +0300
Alex Tomas <alex@clusterfs.com> wrote:

> +/*
> + * With EXT4_WB_SKIP_SMALL defined the patch will try to avoid
> + * small I/Os ignoring ->writepages() if mapping hasn't enough
> + * contig. dirty pages
> + */
> +#define EXT4_WB_SKIP_SMALL__
> +
> +#define WB_ASSERT(__x__) if (!(__x__)) BUG();

This is unused.  Please kill.

> +#define WB_DEBUG__
> +#ifdef WB_DEBUG
> +#define wb_debug(fmt,a...)	printk(fmt, ##a);
> +#else
> +#define wb_debug(fmt,a...)
> +#endif

It's tiresome for each piece of kernel code to implement private debug
macros.  Why not use pr_debug()?

In general, this patch adds a mountain of code which I suspect just
shouldn't be in a filesystem.  It should be library code in mm/ or fs/. 
It'll take some thought and refactoring and definition of new
address_space_operations entries, etc.  But burying all this inside a
single filesystem is just The Wrong Thing To Do.

I am not inclined to review the code in detail because the lack of suitable
code comments would make that task much larger and significantly less
useful than it should be.  Please spend a day or so commenting the code in
a similar manner to other parts of ext4 and jbd2.  When doing so, put
yourself in the position of an experienced kernel developer who seeks to
understand what the code is doing and why it is doing it.  Skilful
commenting is essential if the code is to be maintainable and it has an
immediate impact upon the code's quality.  Every non-trivial function
should have an introductory comment which tells the reader why this
function exists, what it does and, if not obvious, how it does it.  Don't
bother with kernel-doc comments - for some reason they tend to be useless
for code conprehension.

I shouldn't need to sit here scratching my head and wondering why the heck
a writepages function is running __set_page_dirty_nobuffers().

Thanks.
