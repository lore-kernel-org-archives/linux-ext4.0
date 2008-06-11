From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix the loop condition in
	ext4_mb_free_committed_blocks
Date: Wed, 11 Jun 2008 10:23:56 -0400
Message-ID: <20080611142356.GL8397@mit.edu>
References: <484F4CC1.3000109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46005 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbYFKOYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 10:24:08 -0400
Content-Disposition: inline
In-Reply-To: <484F4CC1.3000109@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 11:55:45AM +0800, Shen Feng wrote:
> 
> Since md is freed before the do-while checks it,
> it's better to change it to while(1).

This actually isn't a bug, since there is no problem checking a
pointer that has been freed; its only *dereferencing* a pointer which
is bad.  That being said, md is never NULL at the end of the loop,
since in the middle of the loop is the only break condition:

	if (md == NULL)
		break;

So the patch saves a tiny amount of compiled code, but it isn't really
a fix in any way.

That being said, if we're going to make this sort of change, my
preference would be to use the more common C idiom:

	while (1) {
	      ...
	}

as opposed to

	do {
	      ...
	} while (1);

The former makes it quite clear that any exit from the loop is not
going to be coming from loop construct itself, but from any embedded
break statements inside the loop construct

Regards,

						- Ted
