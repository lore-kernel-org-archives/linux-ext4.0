Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233455;
	b=qpfFCGYVovsT1adwwtuR9N9ljWYVQUErIn05KjRTwZD6o5+LLJ34hdBgyhg1iYDWQksr
	 9V5IIZSv7zpH1A/kNqtf4lkovdGByjiDqHZyQPgKDCwE1bHfEEsuF28kkbbnz/qjggU3D
	 llPQtVIxOw9Bejw+YUI1FdpDuLbu8oq3Ou9NScAPAXX4YD3cIz9CF25PfX0GWjUJdOlVI
	 5MHux5bsWnseFVsoIpDeaWJ2y2brNPah8/YBzCbTxaCpjPm8s5Yut6dMk2jzGhFKAbSUr
	 D65es6ghaiAcbvQ/CK4lWZUVNHN8tMfQFiXs/05SjyAfNl8nQgh67V5bSOG0kWHkdtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233455;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=yVtq2nS1pNBQLks32Ihq45xmwXelCBNqMEzzLtmVQRA=;
	b=GHZ/9NUVlpwX5D1qAHXGkhsIK43PW1CzVmX7fXBXA7MN990U9pQTcLHZtX3pRnM7ZaCT
	 iNmwnieJmnLojAw54Bq7avylX/HuEJy6VZleefIaaa3ciYKr+APFF6eBMhBhjcU4qPcfK
	 UIIftT0wwMD/s5hLk8oBFAARryJP+wmVNTxw8g6+poch2LXHmTFUDlFreL5GvMY0i8Nkw
	 e6oDEU7u5mvF5gynIZX1U/GuHonIar9h0ZstfIvFqj63EsbwhHcF7g2FmUHNf74I/eaOr
	 kQXybCM3G/xBQLRjWIcIUu504hDjbz3qpe7gA6KC5EqZRd8Cp3CzIIEFJrliBLeC27A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=MubioLQt;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41E7606A33C;
	Mon,  9 Nov 2026 14:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D41E7606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=MubioLQt
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 8D91320B7168; Mon,  9 Nov 2026 06:10:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8D91320B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794233452;
	bh=yVtq2nS1pNBQLks32Ihq45xmwXelCBNqMEzzLtmVQRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MubioLQtoV93Ztb6myuphui6K4IaqKbrqScvQ4g5Teu90SR5ZXVSW9/TWUS8AgYoY
	 GMaxMn7GPAAra5sRJ8GAP/P2h0kbZ4AQhKVw9lBy4sQ3k8TSLYKAFBm84fxO+VugWT
	 HefTVn4YU+xOi9eepfHQF1YnAP0YrdYdnvmSokmY=
Date: Mon, 9 Nov 2026 09:10:52 -0500
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, stable@vger.kernel.org,
	Simon Brakhane <simon@brakhane.net>
Subject: Re: [PATCH] ext4: validate inode block references during fast commit
 replay
Message-ID: <avHUbO6ep08U7b6S@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>

On Mon, Oct 26, 2026 at 12:48:53PM -0400, Hamza Mahfooz wrote:
> __ext4_iget() currently skips ext4_ext_check_inode() and
> ext4_ind_check_inode() when EXT4_FC_REPLAY is set in s_mount_state.
> As a result, an extent-mapped inode loaded from disk during fast commit
> replay never has its in-inode extent header or root extent entries
> validated before replay paths such as ext4_fc_replay_inode() and
> ext4_fc_replay_add_range() walk or modify i_data[].
> 
> A crafted filesystem image with a fast commit journal and an inode whose
> eh_max / eh_entries exceed the four-extent capacity of i_data[] triggers
> slab-out-of-bounds reads in ext4_cache_extents() and slab-out-of-bounds
> writes in ext4_ext_insert_extent() into adjacent fields of struct
> ext4_inode_info and beyond the ext4_inode_cache slab allocation.
> 
> ext4_ext_check_inode() and ext4_ind_check_inode() only validate the
> in-inode extent header and check block numbers against static superblock
> bounds via ext4_inode_block_valid(), not block allocation bitmaps. So,
> drop the EXT4_FC_REPLAY exemption in __ext4_iget() so inodes read during
> fast commit replay are validated.
> 

Ping?

> Cc: stable@vger.kernel.org
> Reported-by: Simon Brakhane <simon@brakhane.net>
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
>  fs/ext4/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..cf74c5014fa7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5582,10 +5582,9 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
>  		goto bad_inode;
>  	} else if (!ext4_has_inline_data(inode)) {
>  		/* validate the block references in the inode */
> -		if (!(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY) &&
> -			(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> -			(S_ISLNK(inode->i_mode) &&
> -			!ext4_inode_is_fast_symlink(inode)))) {
> +		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> +		    (S_ISLNK(inode->i_mode) &&
> +		     !ext4_inode_is_fast_symlink(inode))) {
>  			if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>  				ret = ext4_ext_check_inode(inode);
>  			else
> -- 
> 2.56.0
