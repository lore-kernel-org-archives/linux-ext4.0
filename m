From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: Mark the buffer_heads as dirty and uptodate
	after prepare_write
Date: Fri, 7 Nov 2008 15:15:42 +0530
Message-ID: <20081107094542.GJ25194@skywalker>
References: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1226050948-32221-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	vallesroc@gmail.com, Solofo.Ramangalahy@bull.net,
	cryptooctoploid@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53355 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYKGJp6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 04:45:58 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA79jpTf008888
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 15:15:51 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA79jgUq3346506
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 15:15:42 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA79jojq012495
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:45:51 +1100
Content-Disposition: inline
In-Reply-To: <1226050948-32221-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 03:12:28PM +0530, Aneesh Kumar K.V wrote:
> We need to make sure we mark the buffer_heads as dirty and uptodate
> so that block_write_full_page write them correctly.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 95d0d12..d986018 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2351,6 +2351,8 @@ static int ext4_da_writepage(struct page *page,
>  			unlock_page(page);
>  			return 0;
>  		}
> +		/* now mark the buffer_heads as dirty and uptodate */
> +		block_commit_write(page, 0, PAGE_CACHE_SIZE);
>  	}
> 
>  	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))


With this patch i am able to run the mmap program from Linus without
errors. Can you test the changes with rtorrent and see if the change
fixes the file corruption ?

-aneesh
