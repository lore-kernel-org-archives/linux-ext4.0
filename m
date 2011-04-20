From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH RFC 2/3] ext4:Add two functions splitting an extent.
Date: Wed, 20 Apr 2011 12:13:06 -0600
Message-ID: <2C83027B-2CAC-4599-883E-3A683411CB7E@dilger.ca>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com> <1302759651-21222-3-git-send-email-xiaoqiangnk@gmail.com> <4DAF1635.7070406@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61853 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1DTSNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Apr 2011 14:13:07 -0400
In-Reply-To: <4DAF1635.7070406@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-20, at 11:21 AM, Allison Henderson wrote:
> I've been working on trying to get the punch hole patch to work with with these new changes, but it looks like some test cases are not passing at the moment, so I'm trying track down where the issues are.  I had to make some adjustments to this patch to fix one of the test cases.  Here is what I did:
> 
> ---
> :100644 100644 ee2dda3... c7d763d... M  fs/ext4/extents.c
> fs/ext4/extents.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ee2dda3..c7d763d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2717,12 +2717,12 @@ static int ext4_split_extent(handle_t *handle,
>        ee_len = ext4_ext_get_actual_len(ex);
>        uninitialized = ext4_ext_is_uninitialized(ex);
> 
> +       flags1 = flags;
> +       flags1 |= EXT4_GET_BLOCKS_PRE_IO;

Can you please use normal C style: "flags1 = flags | EXT4_GET_BLOCKS_PRE_IO;"


Cheers, Andreas





