From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH v2] ext4: ext4_ext_convert_to_initialized bug found in
 extended FSX testing
Date: Mon, 16 May 2011 08:09:21 -0700
Message-ID: <1305558561.2610.9.camel@mingming-laptop>
References: <4DCE1B19.9070503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Theodore Tso <tytso@mit.edu>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50512 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1EPPJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 11:09:43 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4GErKuO007483
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 08:53:20 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p4GF9TYK152562
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 09:09:29 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4G99OE8001782
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 03:09:28 -0600
In-Reply-To: <4DCE1B19.9070503@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-05-13 at 23:03 -0700, Allison Henderson wrote:
> Hi all,
> 
> After applying this patch, the fsx test has been able to run ok all 
> day (about 12hrs). So I think it's safe to send it out now.  Thx all!
> 
> Allison Henderson
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>

Looks good to me.

Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> 
> ---
> :100644 100644 e363f21... 5f243da... M	fs/ext4/extents.c
>  fs/ext4/extents.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e363f21..5f243da 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2818,8 +2818,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>  			/* case 3 */
>  			zero_ex.ee_block =
> -					 cpu_to_le32(map->m_lblk + map->m_len);
> -			zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
> +					 cpu_to_le32(map->m_lblk);
> +			zero_ex.ee_len = cpu_to_le16(allocated);
>  			ext4_ext_store_pblock(&zero_ex,
>  				ext4_ext_pblock(ex) + map->m_lblk - ee_block);
>  			err = ext4_ext_zeroout(inode, &zero_ex);
> @@ -2842,10 +2842,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  					goto out;
>  			}
> 
> -			allocated = map->m_lblk - ee_block + map->m_len;
> -
>  			split_map.m_lblk = ee_block;
> -			split_map.m_len = allocated;
> +			split_map.m_len = map->m_lblk - ee_block + map->m_len;
> +			allocated = map->m_len;
>  		}
>  	}
> 


