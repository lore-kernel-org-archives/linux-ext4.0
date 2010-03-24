From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: try fast merge operation in
 ext4_mb_free_metadata()
Date: Wed, 24 Mar 2010 22:34:39 +0530
Message-ID: <87bpedd520.fsf@linux.vnet.ibm.com>
References: <ac8f92701003240632t2bcdb0b4l1d7543e3b1ffc9e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50542 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0CXREr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 13:04:47 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp07.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2OH4kxN026204
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:04:46 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OGwf9B1573004
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 03:58:41 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2OH4j2I031113
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:04:45 +1100
In-Reply-To: <ac8f92701003240632t2bcdb0b4l1d7543e3b1ffc9e7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Mar 2010 21:32:39 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Wed Mar 24 21:30:22     2010
> 
> There may exist fast path for merge if merge-able.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc7.c	2010-03-24 21:27:24.000000000 +0800
> @@ -4385,6 +4385,24 @@ ext4_mb_free_metadata(handle_t *handle,
>  		}
>  	}
> 
> +	if (parent) {
> +		/* let's try fast path */
> +		entry = rb_entry(parent, struct ext4_free_data, node);
> +		if (n == &parent->rb_left) {
> +			if (can_merge(new_entry, entry)) {
> +				entry->start_blk = new_entry->start_blk;
> +				entry->count += new_entry->count;
> +				/* and info the caller that new_entry is
> +				 * not used yet.
> +				 */
> +				return 0;

return 0 on success so you may want -1 here 

> +			}
> +		}
> +		else if (can_merge(entry, new_entry)) {
> +			entry->count += new_entry->count;
> +			return 0;
> +		}
> +	}
>  	rb_link_node(new_node, parent, n);
>  	rb_insert_color(new_node, &db->bb_free_root);
> --

-aneesh
