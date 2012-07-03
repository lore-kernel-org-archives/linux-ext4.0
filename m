From: Zach Brown <zab@zabbo.net>
Subject: Re: ext4_fallocate
Date: Tue, 03 Jul 2012 10:57:35 -0700
Message-ID: <4FF3328F.3090301@zabbo.net>
References: <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com> <20120702031611.GB2406@gmail.com> <4FF1CD5D.8010904@redhat.com> <20120702174421.GM6679@quack.suse.cz> <4FF1DEDF.90105@redhat.com> <20120703174147.GA14986@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ric Wheeler <rwheeler@redhat.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:52089
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2GCSEu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 14:04:50 -0400
In-Reply-To: <20120703174147.GA14986@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> workload frequently does a uninitialized extent conversion.  Thus, now
> we set it to 256 (1MB chunk), and put it into super block in order to
> adjust it dynamically in sysfs.

It's a bit of a tangent, but this caught my eye.

> +	/* If extent has less than 2*s_extent_zeroout_len zerout directly */
> +	if (ee_len<= 2*sbi->s_extent_zeroout_len&&
>   	(EXT4_EXT_MAY_ZEROOUT&  split_flag)) {

> -		if (allocated<= EXT4_EXT_ZERO_LEN&&
> +		if (allocated<= sbi->s_extent_zeroout_len&&
>   		(EXT4_EXT_MAY_ZEROOUT&  split_flag)) {

>   		} else if ((map->m_lblk - ee_block + map->m_len<
> -			   EXT4_EXT_ZERO_LEN)&&
> +			   sbi->s_extent_zeroout_len)&&

I'd be worried about having to verify that nothing bad happened if these
sbi s_extent_zeroout_len references could see different values if they
raced with a sysfs update.  Can they do that?

Maybe avoid the risk all together and have an on-stack copy that's only
referenced once at the start?

- z
