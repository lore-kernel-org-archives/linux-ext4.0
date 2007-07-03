From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Tue, 03 Jul 2007 12:25:14 +0530
Message-ID: <4689F2D2.7020809@linux.vnet.ibm.com>
References: <1183275465.4010.130.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:58677 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbXGCG40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2007 02:56:26 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l636vg0w3539138
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jul 2007 16:57:44 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l636xg6F087178
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jul 2007 16:59:48 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l636tNck004657
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jul 2007 16:55:23 +1000
In-Reply-To: <1183275465.4010.130.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao wrote:
> This patch is on top of i_version_update_vfs.
> The i_version field of the inode is set on inode creation and incremented when
> the inode is being modified.
> ta));
>  	ei->i_dir_start_lookup = 0;
> Index: linux-2.6.22-rc4/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/inode.c	2007-06-13 17:21:29.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/inode.c	2007-06-13 17:24:45.000000000 -0700
> @@ -3082,6 +3082,7 @@ int ext4_mark_iloc_dirty(handle_t *handl
>  {
>  	int err = 0;
> 
> +	inode->i_version++;
>  	/* the do_update_inode consumes one bh->b_count */
>  	get_bh(iloc->bh);
> 

If we bump i_version  in ext4_mark_iloc_dity then we should be removing the i_version update
at other places. A simple grep of ext4 dir shows i_version being updated followed by 
ext4_mark_inode_dirty.


-aneesh
