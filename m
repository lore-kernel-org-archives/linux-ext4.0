From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure
 delete journal blocks
Date: Mon, 10 Oct 2011 14:00:46 -0600
Message-ID: <20111010140046.546e3c67@bike.lwn.net>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
	<1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:51249 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab1JJUAr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 16:00:47 -0400
In-Reply-To: <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  7 Oct 2011 00:11:05 -0700
Allison Henderson <achender@linux.vnet.ibm.com> wrote:

> +	/*
> +	 * If the journal block was not found in the list,
> +	 * add a new pair to the list
> +	 */
> +	if (!b_pair) {
> +		b_pair = kzalloc(sizeof(struct jbd2_blk_pair), GFP_NOFS);
> +		if (!b_pair) {
> +			spin_unlock(&journal->j_pair_lock);
> +			return -ENOMEM;
> +		}

Here too...  that really needs to be GFP_ATOMIC.

I'm wondering, though...it looks like, over a short period of time, you
will create an unordered linked list containing one entry for every
physical block in the journal.  You'll take a lock and search the whole
list for every block that is committed.  Wouldn't it be better just to
have an array indexed by the journal logical block offset?  Less memory,
faster access...?  Or am I missing something fundamental here?

Thanks,

jon
