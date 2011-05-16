From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4:Make ext4_split_extent() handle error correctly.
Date: Mon, 16 May 2011 08:08:25 -0700
Message-ID: <1305558505.2610.6.camel@mingming-laptop>
References: <BANLkTintPx6Tugitnodou++sLR1m6SOunA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39790 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab1EPPIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 11:08:37 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4GEvRpP012683
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 10:57:27 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4GF8Z7U096828
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 11:08:36 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4G983N1031566
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 03:08:06 -0600
In-Reply-To: <BANLkTintPx6Tugitnodou++sLR1m6SOunA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2011-05-14 at 15:05 +0800, Yongqiang Yang wrote:
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/extents.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e363f21..b7b667f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2716,6 +2716,8 @@ static int ext4_split_extent(handle_t *handle,
>  				       EXT4_EXT_MARK_UNINIT2;
>  		err = ext4_split_extent_at(handle, inode, path,
>  				map->m_lblk + map->m_len, split_flag1, flags1);
> +		if (err)
> +			goto out;
>  	}
> 
>  	ext4_ext_drop_refs(path);


