Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DBC81732;
	Sun, 29 Mar 2026 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774792521; cv=none; b=XUr/HCya+misvWeriyE64vwTiPa7aL6of1ytHPqCsHfccjx5SLDmnwYxe4Xx0O8Kb/QqQvQYVccO1czNNBFgQvs1bf0Xg/31/tnOup/TQkCUq15/81280xXcitHWqcISF4fGBECynWNEbca4GMXL+GQlB606uJ9k9Y3U28Y757Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774792521; c=relaxed/simple;
	bh=a73ID5dguLR9GnZWuHo35iBz0uDRmfDJROb8ob6LISQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Up+VPyc8EcixnnZrb955nLpkQqkJubENT7HopWiuHJVZTG1Emb1cUyClRw9RbYF49LOJk+x/stKxd3//oNYUfMBXUsMnJtMyVkArRqWD8GjCFzD/XHwHtEjriu8lMUNf/Y8nHFYspOyVHiZVcaMWF/dZv0ilFYkUjO9FtUbi6pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=xj+M8VDD; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=4mTxwXMe; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="xj+M8VDD";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="4mTxwXMe"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 7E32126F768D;
	Sun, 29 Mar 2026 22:55:10 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1774792510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIltfUA5+2NK3wdSivLBU62ecJ7gsJtG2EiE1X57dBI=;
	b=xj+M8VDDMDYKnn0BJ+hNu63xwfdh96i8SzbyNPO5WVD8WO4XjKjtELvGfOzW7jb+BH9uof
	KCKAEUdpjs7NKMXdiZ7771WfWUp6fYxK/zTu6kmli8JxLRGrQ6VechGHojzdVyK4komlfR
	EMOqLFsFYoZl/dOphKK4iUSPzQArLpWSJ5jHPquS/W0LADwfyuX5/zQJrKXZJPcXNLSeO5
	ZWnZAG6w/9mKgThTrvGOtDu3nGuTLIISot9XQN4y2QhNjO5WG6GYoI0f75rK/WiACFoiLw
	mV323nsWGwcSr8xmLW5PZvuCGdwNGj0xQuk4gGxAiytp37umZPMuc1DooTrNZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1774792510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIltfUA5+2NK3wdSivLBU62ecJ7gsJtG2EiE1X57dBI=;
	b=4mTxwXMeeuLuGk+hT0eoHS+aiarZC147RAzUWMn12DyWrPq3K33cLpx1j3joSVY+LQsOGz
	OgcvTa9LfZSIbDAQ==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 03DD5E0029C;
	Sun, 29 Mar 2026 22:55:10 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id E9EE322001A4; Sun, 29 Mar 2026 22:55:09 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,  <linux-block@vger.kernel.org>,
  Christian Brauner <brauner@kernel.org>,  Al Viro
 <viro@ZenIV.linux.org.uk>,  <linux-ext4@vger.kernel.org>,  Ted Tso
 <tytso@mit.edu>,  "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,  David
 Sterba <dsterba@suse.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar
 Salvador <osalvador@suse.de>,  David Hildenbrand <david@kernel.org>,
  linux-mm@kvack.org,  linux-aio@kvack.org,  Benjamin LaHaise
 <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
In-Reply-To: <20260326095354.16340-57-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
Date: Sun, 29 Mar 2026 22:55:09 +0900
Message-ID: <87ldfazqo2.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

> There are only very few filesystems using generic metadata buffer head
> tracking and everybody is paying the overhead. When we remove this
> tracking for inode reclaim code .evict will start to see inodes with
> metadata buffers attached so write them out and prune them.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fat/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 3cc5fb01afa1..ce88602b0d57 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
>  	if (!inode->i_nlink) {
>  		inode->i_size = 0;
>  		fat_truncate_blocks(inode, 0);
> -	} else
> +	} else {
> +		sync_mapping_buffers(inode->i_mapping);

Hm, why do we have to add this here? For FAT, if buffers are still
dirty, buffers will be flushed via bdev flush?

Thanks.

>  		fat_free_eofblocks(inode);
> +	}
>  
>  	invalidate_inode_buffers(inode);
>  	clear_inode(inode);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
