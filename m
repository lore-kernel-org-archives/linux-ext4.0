From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] Support discard for multiple devices
Date: Fri, 2 Jul 2010 13:50:37 -0400
Message-ID: <20100702175037.GA26916@redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab0GBRuo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 13:50:44 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 02 2010 at 11:19am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Support discard for multiple devices
> 
> The previous code supported discards only if there was one underlying device.
> (i.e. multiple linear targets pointing to the same device would support
> discards, multiple linear targets pointing to different devices wouldn't).
> 
> This restriction is not necessary, so this patch removes it.
> 
> As we checked, barrier+discard requests are handled by the barrier thread,
> so it's safe to use these requests on devices with multiple underlying devices.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-table.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> Index: linux-2.6.35-rc3-fast/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.35-rc3-fast.orig/drivers/md/dm-table.c	2010-07-02 16:05:22.000000000 +0200
> +++ linux-2.6.35-rc3-fast/drivers/md/dm-table.c	2010-07-02 16:07:45.000000000 +0200
> @@ -911,12 +911,6 @@ int dm_table_complete(struct dm_table *t
>  	int r = 0;
>  	unsigned int leaf_nodes;
>  
> -	/*
> -	 * We only support discards if there is exactly one underlying device.
> -	 */
> -	if (!list_is_singular(&t->devices))
> -		t->discards_supported = 0;
> -
>  	/* how many indexes will the btree have ? */
>  	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
>  	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
> 

Removing this constraint means that a discard request that spans targets
will return -EOPNOTSUPP.

I'd prefer that we first make basic discard splitting work (like I
already have a DM patch to do that I'll rebase shortly).

But given the new-found desire for DM to return -EOPNOTSUPP as a means
to convey that a subset of the device does not support discards:

This change will start to force this issue with DM consumers higher up
the IO stack (e.g. ext4 and other filesystems).  So I'm cc'ing FS
development lists, if they don't care now they will at some point.

Acked-by: Mike Snitzer <snitzer@redhat.com>
