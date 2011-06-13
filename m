From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd: Make jbd transactions come from its own cache.
Date: Mon, 13 Jun 2011 16:41:21 -0700
Message-ID: <20110613164121.d2ca952e.akpm@linux-foundation.org>
References: <1307784961-1485-1-git-send-email-mkatiyar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab1FMXl0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 19:41:26 -0400
In-Reply-To: <1307784961-1485-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 11 Jun 2011 02:36:01 -0700
Manish Katiyar <mkatiyar@gmail.com> wrote:

> Allocate a slab cache for jbd transaction allocations. It may help to test
> various memory failure scenarios.

This doesn't seem terribly useful to me.  That's truly ancient code and
the change rate is really low.  If there were problem in there then
we'd already know about them.  And the allocation frequency for these
objects is very low.

If you had some deeper reason for making this change, please describe
it.  For example, were you chasing some bug?

> +static int journal_init_transaction_cache(void)
> +{
> +	J_ASSERT(jbd_transaction_cache == NULL);
> +	jbd_transaction_cache = kmem_cache_create("jbd_transaction",
> +			sizeof(transaction_t),
> +			0, 0, NULL);

We have a KMEM_CACHE helper macro for this.  It proved useful at the
time, when we were changing the kmem_cache_create() arguments fairly
often.  It's less useful now.

