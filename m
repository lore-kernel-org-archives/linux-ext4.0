From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] ext4: init pagevec in ext4_da_block_invalidatepages
Date: Mon, 12 Nov 2012 12:12:58 -0200
Message-ID: <20121112141258.GA2496@andromeda.usersys.redhat.com>
References: <50A019AE.7090907@redhat.com>
 <50A01DAD.4080607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab2KLONC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2012 09:13:02 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qACED2Ml030206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Nov 2012 09:13:02 -0500
Content-Disposition: inline
In-Reply-To: <50A01DAD.4080607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 11, 2012 at 03:50:37PM -0600, Eric Sandeen wrote:
> ext4_da_block_invalidatepages is missing a pagevec_init(),
> which means that pvec->cold contains random garbage.
> 
> This affects whether the page goes to the front or
> back of the LRU when ->cold makes it to
> free_hot_cold_page()
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> 
> (resend w/ stable in S-O-B area rather than fat-fingered
> in email cc :/  )
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b3c243b..f89c0e5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1503,6 +1503,8 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd)
>  
>  	index = mpd->first_page;
>  	end   = mpd->next_page - 1;
> +
> +	pagevec_init(&pvec, 0);
>  	while (index <= end) {
>  		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
>  		if (nr_pages == 0)
> 

Looks Good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
