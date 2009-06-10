From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Properly mark the extent uninitialized during
	truncate
Date: Thu, 11 Jun 2009 01:13:18 +0530
Message-ID: <20090610194318.GA4686@skywalker>
References: <1244638557-13492-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49032 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZFJTna (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 15:43:30 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5AJfAcM012289
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 05:41:10 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5AJhVsV729320
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 05:43:31 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5AJhViF007114
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 05:43:31 +1000
Content-Disposition: inline
In-Reply-To: <1244638557-13492-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2009 at 06:25:57PM +0530, Aneesh Kumar K.V wrote:
> We should make sure we don't mark the non uninit extent as
> uninit during truncate
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f2a2591..764c394 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2083,12 +2083,16 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  	ex = EXT_LAST_EXTENT(eh);
> 
>  	ex_ee_block = le32_to_cpu(ex->ee_block);
> -	if (ext4_ext_is_uninitialized(ex))
> -		uninitialized = 1;
>  	ex_ee_len = ext4_ext_get_actual_len(ex);
> 
>  	while (ex >= EXT_FIRST_EXTENT(eh) &&
>  			ex_ee_block + ex_ee_len > start) {
> +
> +		if (ext4_ext_is_uninitialized(ex))
> +			uninitialized = 1;
> +		else
> +			uninitialized = 0;
> +
>  		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
>  		path[depth].p_ext = ex;
> 

BTW this fix is really important. It fix a data corruption when we write
to an fallocate space and later truncate the same file. So mostly a
stable candidate.

-aneesh
