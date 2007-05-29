From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] update ext4-nanosecond-patch comments
Date: Tue, 29 May 2007 12:08:37 +0530
Message-ID: <1180420717.4339.8.camel@garfield>
References: <20070529054822.GA14186@skywalker.home.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:35875 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXE2Geq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 02:34:46 -0400
In-Reply-To: <20070529054822.GA14186@skywalker.home.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-29 at 11:18 +0530, Aneesh Kumar K.V wrote:
> Also can we have a description of why s_{min, want}_extra_isize
> fields are added in the commit message ?

The i_extra_isize for each inode should ideally be s_want_extra_isize
after inode expansion. If expansion by s_want_extra_isize is not
possible, then i_extra_isize must be atleast s_min_extra_isize.

Thanks,
Kalpak.

> diff --git a/ext4-nanosecond-patch b/ext4-nanosecond-patch
> index ceaf339..02d00b7 100644
> --- a/ext4-nanosecond-patch
> +++ b/ext4-nanosecond-patch
> @@ -1,8 +1,8 @@
>  This patch is a spinoff of the old nanosecond patches.
>  
>  It includes some cleanups and addition of a creation timestamp. The
> -EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> -s_{min, want}_extra_isize fields in struct ext3_super_block.
> +EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> +s_{min, want}_extra_isize fields in struct ext4_super_block.
>  
>  Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
>  Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
