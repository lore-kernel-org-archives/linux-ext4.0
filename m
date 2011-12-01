From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize
 < pagesize
Date: Thu, 01 Dec 2011 13:13:04 -0700
Message-ID: <4ED7DFD0.8020503@linux.vnet.ibm.com>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55485 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1LAUNO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Dec 2011 15:13:14 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Thu, 1 Dec 2011 15:13:13 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB1KD72G2625710
	for <linux-ext4@vger.kernel.org>; Thu, 1 Dec 2011 15:13:08 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB1KD6iO008577
	for <linux-ext4@vger.kernel.org>; Thu, 1 Dec 2011 15:13:07 -0500
In-Reply-To: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/23/2011 02:15 AM, Yongqiang Yang wrote:
> If there is a unwritten but clean buffer in a page and there is a dirty buffer
> after the buffer, then mpage_submit_io does not write the dirty buffer out.
> As a result, da_writepages loops forever.
>
> This patch fixes the problem by checking dirty flag.
>
> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
> ---
>   fs/ext4/inode.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 755f6c7..20a1d17 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1339,8 +1339,11 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>   					clear_buffer_unwritten(bh);
>   				}
>
> -				/* skip page if block allocation undone */
> -				if (buffer_delay(bh) || buffer_unwritten(bh))
> +				/*
> +				 * skip page if block allocation undone and
> +				 * block is dirty
> +				 */
> +				if (ext4_bh_delay_or_unwritten(NULL, bh))
>   					skip_page = 1;
>   				bh = bh->b_this_page;
>   				block_start += bh->b_size;

Hi Yongqiang,

Thank you for looking into the punch hole code, I know there's been some 
recent bugs reported, so I am looking at it too.  I've applied your 
patch and ran it through an fsx stress test, and I notice there are some 
failures, but it appears to run longer with the patch then with out it, 
so it may not be the cause of the errors I'm seeing. I think maybe 
something else may have happened between now and the last time it made 
it through 24hr of fsx (at least for me :) ), so I'm continuing to look 
through the recent code changes.  I will keep folks posted on my 
findings.  Thx!

Allison Henderson

