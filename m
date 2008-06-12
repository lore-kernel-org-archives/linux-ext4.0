From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: return error when calling ext4_ext_split failed
Date: Thu, 12 Jun 2008 15:20:00 -0700
Message-ID: <1213309200.3698.15.camel@localhost.localdomain>
References: <484F696A.4070703@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60753 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbYFLWUG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 18:20:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CMK1Vh027512
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:20:01 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CMK1gN145302
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:20:01 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CMK1dQ009602
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:20:01 -0400
In-Reply-To: <484F696A.4070703@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have added to ext4 patch queue

Mingming
On Wed, 2008-06-11 at 13:58 +0800, Shen Feng wrote:
> ext4_ext_create_new_leaf must return error when its
> calling to ext4_ext_split failed.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  fs/ext4/extents.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ff609df..177345d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -981,6 +981,8 @@ repeat:
>  		/* if we found index with free entry, then use that
>  		 * entry: create all needed subtree and add new leaf */
>  		err = ext4_ext_split(handle, inode, path, newext, i);
> +		if (err)
> +			goto out;
> 
>  		/* refill path */
>  		ext4_ext_drop_refs(path);

