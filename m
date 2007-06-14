From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/6] Separated 64-bit i_version patch
Date: Thu, 14 Jun 2007 13:58:43 -0700
Message-ID: <1181854724.3883.14.camel@dyn9047017103.beaverton.ibm.com>
References: <1181835073.7779.9.camel@garfield>
	 <1181836574.7779.43.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:46138 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbXFNU6q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 16:58:46 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5EKwjnf016138
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 16:58:45 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EKwjZK238930
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 14:58:45 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EKwjnn006708
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 14:58:45 -0600
In-Reply-To: <1181836574.7779.43.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> This patch converts the 32-bit i_version in the generic inode to a 64-
> bit
> i_version field.
> 
> Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> 
> Index: linux-2.6.21/include/linux/fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/fs.h
> +++ linux-2.6.21/include/linux/fs.h
> @@ -549,7 +549,7 @@ struct inode {
>         uid_t                   i_uid;
>         gid_t                   i_gid;
>         dev_t                   i_rdev;
> -       unsigned long           i_version;
> +       uint64_t                i_version;
>         loff_t                  i_size;
>  #ifdef __NEED_I_SIZE_ORDERED
>         seqcount_t              i_size_seqcount;
> 
> 


I think u64 is better here. It seems uint64_t is not defined in some
cases and rarely being used.

Mingming
