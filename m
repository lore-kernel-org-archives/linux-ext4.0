From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] mke2fs: reduce the range of cluster-size
Date: Mon, 14 Jan 2013 10:41:34 -0700
Message-ID: <4825A0BF-7505-4273-AD04-C3043BDAF414@dilger.ca>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com> <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:37635 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3ANRlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 12:41:19 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so1904918dak.25
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 09:41:18 -0800 (PST)
In-Reply-To: <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-13, at 2:08 AM, Zheng Liu wrote:
> Here we reduce the range of cluster-size and check s_blocks_per_group=0 to avoid 'division by zero' error.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bf4d7a2..f4140a1 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1384,8 +1384,8 @@ profile_error:
> 			break;
> 		case 'C':
> 			cluster_size = strtoul(optarg, &tmp, 0);
> -			if (cluster_size < EXT2_MIN_CLUSTER_SIZE ||
> -			    cluster_size > EXT2_MAX_CLUSTER_SIZE || *tmp) {
> +			if (cluster_size <= EXT2_MIN_CLUSTER_SIZE ||
> +			    cluster_size >= EXT2_MAX_CLUSTER_SIZE || *tmp) {
> 				com_err(program_name, 0,
> 					_("invalid cluster size - %s"),
> 					optarg);

Wouldn't it make more sense to change EXT2_MIN_CLUSTER_SIZE and EXT2_MAX_CLUSTER_SIZE?  Otherwise, those constants don't really
contain the min/max cluster size, and it is confusing to use them
in other code.

Cheers, Andreas





