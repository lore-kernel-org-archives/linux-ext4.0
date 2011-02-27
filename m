From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4:Make FIEMAP and delayed allocation play well together.
Date: Sat, 26 Feb 2011 23:57:55 -0700
Message-ID: <5B306456-0ECB-481A-9AA5-FD04FC71C216@dilger.ca>
References: <1298732709-3212-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30983 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1B0G55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 01:57:57 -0500
In-Reply-To: <1298732709-3212-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-26, at 8:05 AM, Yongqiang Yang wrote:
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

You can also add Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> @@ -3782,38 +3783,162 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
> 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
> 		       void *data)
> {
> 	if (newex->ec_start == 0) {
> +		pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		if (pages == NULL)
> +			return -EFAULT;

This should be -ENOMEM.

Cheers, Andreas





