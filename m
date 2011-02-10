From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/4 v2] ext4: Speed up FITRIM by recording flags in ext4_group_info.
Date: Thu, 10 Feb 2011 13:50:14 -0800
Message-ID: <E9EB058B-97B5-4CF8-951E-48258E1754BD@dilger.ca>
References: <1297231048-3458-4-git-send-email-tm@tao.ma> <1297323206-9874-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:41184 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1BKGBi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Feb 2011 01:01:38 -0500
In-Reply-To: <1297323206-9874-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-09, at 23:33, Tao Ma <tm@tao.ma> wrote:
> After I delete some big image files and re-run the trim,
> it is still much faster than iterating the whole disk.
> /dev/sdb2             108G   25G   78G  24% /mnt/ext4
> 
> [root@boyu-tm test]# time ./ftrim /mnt/ext4/a
> real    0m0.513s
> user    0m0.000s
> sys    0m0.069s

Excellent results. 

> +#define EXT4_GROUP_INFO_NEED_INIT_BIT        0
> +#define EXT4_GROUP_INFO_WAS_TRIMMED_BIT        1
> 
> #define EXT4_MB_GRP_NEED_INIT(grp)    \
>    (test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
> +#define EXT4_MB_GRP_HAS_BEEN_TRIMMED(grp)    \

For consistency, it would be better to call this:

EXT4_MB_GRP_WAS_TRIMMED(grp)

And also add and use:

EXT4_MB_GRP_SET_TRIMMED(grp)

And 

EXT4_MB_GRP_CLEAR_TRIMMED(grp)

> 

In the code. Then you can add Reviewed-by: on this patch. 

Cheers, Andreas
