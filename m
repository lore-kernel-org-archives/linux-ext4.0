From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Fri, 07 Mar 2008 03:17:33 -0800
Message-ID: <1204888653.3627.37.camel@localhost.localdomain>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60544 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbYCGLSJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 06:18:09 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m27BHMPV011948
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 06:17:22 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m27BI8N6215412
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 04:18:08 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m27BI7JJ016184
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 04:18:08 -0700
In-Reply-To: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-03-07 at 16:23 +0530, Aneesh Kumar K.V wrote:
Hi Aneesh,

>  static int init_inodecache(void)
> diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
> index d5508d3..96c0b4f 100644
> --- a/include/linux/ext4_fs_i.h
> +++ b/include/linux/ext4_fs_i.h
> @@ -162,6 +162,18 @@ struct ext4_inode_info {
>  	/* mballoc */
>  	struct list_head i_prealloc_list;
>  	spinlock_t i_prealloc_lock;
> +
> +	/* When doing migrate we need to ensure that the i_data field
> +	 * doesn't change. With respect to write and truncate we can ensure
> +	 * the same by taking inode->i_mutex. But a write to mmap area
> +	 * mapping holes doesn't take i_mutex since it doesn't change the
> +	 * i_size. We also can't take i_data_sem because we would like to
> +	 * extend/restart the journal and locking order prevents us from
> +	 * restarting journal within i_data_sem. 

How about we start a journal with estimated worse case transaction
credits  and then take the i_data_sem down? So that we could ensure that
whenever the i_data_sem is hold, the i_data is protected. That is what
currently DIO does, I think. It would be nice to avoid introducing
another semaphore to protect i_data for migration if we could.

> This will be taken in
> +	 * page_mkwrite in the read mode and migrate will take it in the
> +	 * write mode.
> +	 */
> +	struct rw_semaphore i_migrate_sem;
>  };
> 
>  #endif	/* _LINUX_EXT4_FS_I */

Mingming

