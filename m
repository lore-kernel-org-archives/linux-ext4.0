Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EDF3093A6;
	Mon, 11 May 2026 14:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509977; cv=none; b=uCTraiTDm5t3I/WQTDbljNGeTyZJranV5iSnNt6Y2LUl7BupSRKSP0PLS1dHm7Ha0PygxeeAHnXKWL8IyZBjV3Qf44IXBVNJG3wQdJkUy6y8Ybk6XyZK/atUoaHBJtGWMfhjyx2+k+h//brc7eXoKTblayJ/txQHjVOzLpdGBTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509977; c=relaxed/simple;
	bh=o3ggYFqJFP/ijHj/gPqwaUGDpd0BFzhrJOAK/cQU1cI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kStwB4y6EEzbxb6ZA0ZnlXL5iPaPT/4TNSWkghHQN0Tqz/cqLGMVlXrCAqdQHJ9SIwZA07a3+VYBcCVofgcYroDWZ7YS52EMeSMEzZLTpGE8cb/nRkXvhVG1mBE3QalJZZqNLgnDRhjD3Gics0q8kekRyD5oqvyGV4bYhaTzhrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=LJEs4vUg; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=8zRjJ4K4; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="LJEs4vUg";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="8zRjJ4K4"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id EBC8A26F765A;
	Mon, 11 May 2026 23:32:45 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1778509966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bCGZSoUsjwrgl5SZeZ48jPOeuX0g2G5mRVNmQZvx0gY=;
	b=LJEs4vUgzv6kdhgUrnJyguoKxhjc3+nS3EK8lXMWTrM7T+b6Uj8lnzHPFxoIuAh7sBVGG5
	06ZydK5dP35uV5DFjd54oL+tHJa/SdWVdBt0hItb2sPlFAblk/4ZmXuKrwXtuOoiLWiWVy
	WModI+UShp59kuaJGbd64QW9su1eb17BAVVV6tNbrJzBnTs1XUHJwndttVHKhLrkP0qbwd
	1SVSwfy2zXsP1qLABs/Y64hLsM5ZJJW/8u2z4s5ISa8GMWnpd88r/ypGFAzVC6Zwv36WT6
	x8bP0hRMYo0wBhdU/oe76oz0MUwRzg9zgVCjYs7D2zBNe8kczCSBzvOfz5O7cw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1778509966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bCGZSoUsjwrgl5SZeZ48jPOeuX0g2G5mRVNmQZvx0gY=;
	b=8zRjJ4K4IFOZV/dp0qbUSTxARHytw+G81cyqUeWJc+nl2/I2IUivsyO9QMIelAFk4q8Qts
	kC3TOArbbgppIHBQ==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 36295E002BE;
	Mon, 11 May 2026 23:32:45 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 2C7772200101; Mon, 11 May 2026 23:32:45 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,  Christian Brauner
 <brauner@kernel.org>,  aivazian.tigran@gmail.com,  Ted Tso
 <tytso@mit.edu>,  <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
In-Reply-To: <20260511121356.241821-15-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
	<20260511121356.241821-15-jack@suse.cz>
Date: Mon, 11 May 2026 23:32:45 +0900
Message-ID: <87pl32yq2a.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

> Use mmb inode buffer writeout infrastructure to reliably write out
> inode's buffer on fsync(2).

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fat/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 28f78df086ef..4ca00b7a618b 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -907,6 +907,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
>  	}
>  	spin_unlock(&sbi->inode_hash_lock);
>  	mark_buffer_dirty(bh);
> +	MSDOS_I(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;

When inode position was changed/removed, this will point the wrong
block. And maybe sync a unrelated block and wait.

>  	err = 0;
>  	if (wait)
>  		err = sync_dirty_buffer(bh);
> @@ -925,7 +926,7 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
>  		err = fat_clusters_flush(sb);
>  		mutex_unlock(&MSDOS_SB(sb)->s_lock);
>  	} else
> -		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
> +		err = __fat_write_inode(inode, 0);
>  
>  	return err;
>  }

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
