Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243163;
	b=GGrNVIub7px4MeNmZNCNaJ6d9tbqkX6zPJdPsd6aKWO7mL5HxZbjdAJ1b/GFY9M1sH8o
	 Jk2LWli2DRKvF2nW011M0p5etXLYhVNjjF8cmkPOejMIzFDF4jyIr+AyThEgrP0PrBbHU
	 VC9ZjTrrJuC/PrZ396auXZ642J5SOTBhxbsfqrclcBhPpy059JL6mKar+CjE0lYQkbhO4
	 nX45LOg7JRmU1XTb/A5v9j7J5c9PZETdild0oRxFUSGTA5Nlj0vJbfSNnRi8cjICjqpQE
	 giO+m/DtPzyLvXgLjRyATdJ6yYJi1UYgX3UhsiqkZA1mMY6l615VbttVZvhLp0xa8vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243163;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=VV5sZu7HAn8OqTXywict9YirfEOKz65cbKvAvUqDyA4=;
	b=FVkYXoT0PR3xh7NZYA3/7ccBSrLfp0gUE5U69nx+SGcG+86lAOAm0yoBpe0h7GHZ3MiY
	 CBnHeLvPAtrhYd8F8fE7TidfoMTeNHS13N7VhjvJgRu5KdfeJo2fAC1NnK7zCo6P8Unwf
	 WhJB2sRaGzC6ACkk8W2EvZCtRQKz5eV6/rM5XHyJO/m80zUikxJRlCH3NfldA8PJCkW50
	 4icBVOq8Ez4crlsyLOeqxAWvwGVtoj/wvMaTRGPflGA3XDOinVyOSKm1/CTBon3uAlsqH
	 9Z6aEWwDNS7fqgUn2yV8V1vsAY2n1c2NqEhhheYV9Wsl1LLomT9DClkpXJ/DwK+MYvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePtQbRFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2F060A5BE5;
	Mon,  9 Nov 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePtQbRFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9401F00901;
	Mon,  9 Nov 2026 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243162;
	bh=VV5sZu7HAn8OqTXywict9YirfEOKz65cbKvAvUqDyA4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ePtQbRFkddoe5mK1lwXB/YHTr90o2ywe6fKkN5KTYEH86VvAGuuYRVD48cYOinBYt
	 JrgHJM/vXgOa1xzHPRAlS41J8ygQHW11XAHc6Zx+Vt1QwaFtRlNuqiofALgOrie48Y
	 +mitr+rYP8PZ7QIRnlQwFoPKXqbGpLUqVauQ3llKy8GNLXor8/4LQmJhHXXDcfkOmG
	 J/xo0TjOtZTqFceYvJe+ezRC7cgz+4MdMC/pdQFQ79o1bYpWSPKdBHUty77/jncB4i
	 GFFipgGuU9+qxZv23z9be5Pj18JS3SBoO70vuYwZKYkksmgvfPWm7G8MdqTAb005xv
	 UZ4OI/y+z7f+g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:29 +0100
Subject: [PATCH RFC v3 14/14] fat: drop mmb_sync() from fat_evict_inode()
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-work-inode-metadata_writeback-v3-14-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Namjae Jeon <namjae.jeon@samsung.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=874; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0pBaJR7Roi5MNLiktOFzPel0sGg6J6q+ZvKW26fBTd0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/KUq+H/RBibZXXJSHjstF12WS+usulLYGu/M/m7Lw
 ZZNJc0SHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPp/8Xwm4WLX/FI9+zpOzJs
 Hpx7vIjDKkv1gfffZWkG5iy3/4rNeM/IcL61d/ZHicSnD43ERXfrHXptvO39RYUZIv51a9aHG92
 4xgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

evict() writes out what I_METADATA_WRITEBACK tracks before it calls
->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
includes the tracked metadata buffers. So there's nothing left for
fat_evict_inode() to sync. The write-out happens before
fat_free_eofblocks() updates the directory entry again, so that update
stays as asynchronous as it is now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d85c8fbdcca4..243b18949164 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -693,7 +693,6 @@ static void fat_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
 	} else {
-		mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
 		fat_free_eofblocks(inode);
 	}
 

-- 
2.53.0

