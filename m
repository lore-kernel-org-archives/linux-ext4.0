From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/5] ext4: improve ext4_es_can_be_merged() to avoid a
 potential overflow
Date: Sun, 10 Mar 2013 20:43:58 -0400
Message-ID: <20130311004358.GA10090@thunk.org>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52327 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3CKAoG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 20:44:06 -0400
Content-Disposition: inline
In-Reply-To: <1362579435-6333-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 06, 2013 at 10:17:11PM +0800, Zheng Liu wrote:
> +	if (ext4_es_status(es1) ^ ext4_es_status(es2))
>  		return 0;
>  
> -	if (ext4_es_status(es1) != ext4_es_status(es2))

Did you have a reason why changed != to ^?  

It's identical from a functional perspective, but it's less obvious to
future readers of the code what's going on.  I tried checking to see
if GCC did any better optimizing the code, but it doesn't seem to make
any difference.  I'm going to switch it back to !=....

> +	/* we need to check delayed extent is without unwritten status */
> +	if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
> +		return 1;

I'm not sure why we need to check the unwritten status?  Under what
circumstances would we have an extent marked as under delayed
allocation but also unwritten?

							- Ted

This is how I've restructured this function for now mainly to make it
easier to understand;

static int ext4_es_can_be_merged(struct extent_status *es1,
				 struct extent_status *es2)
{
	if (ext4_es_status(es1) != ext4_es_status(es2))
		return 0;

	if (((__u64) es1->es_len) + es2->es_len > 0xFFFFFFFFULL)
		return 0;

	if (((__u64) es1->es_lblk) + es1->es_len != es2->es_lblk)
		return 0;

	if ((ext4_es_is_written(es1) || ext4_es_is_unwritten(es1)) &&
	    (ext4_es_pblock(es1) + es1->es_len == ext4_es_pblock(es2)))
		return 1;

	if (ext4_es_is_hole(es1))
		return 1;

	/* we need to check delayed extent is without unwritten status */
	if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
		return 1;

	return 0;
}
