Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D547884D;
	Mon, 11 May 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778522539; cv=none; b=C+9gIWwN6T4qBKdI3fHhUBdaWHYMoYCE8Ui+1dhngxlCHKxfugN9cZ+W7PflCBDNI45o8yWgWUMarFuVu0i9HRgLHMJt8af93GtFRvbcLrBZNSrJapy8ofckZlqAE79eOZt1m2rXRTy+ej3/P5WZfGoEJi0EYMyP9JXHKCJ8Cw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778522539; c=relaxed/simple;
	bh=UqHq4fMlEkCJUU5nHfg+lDNRTxilEi80W7zCIYIcWSY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=A1qgDicsVjUqwx0/zHi5gIk8a0jL1Xf9HtcsC1WrzhIcKfx775osRt3QzBdHfWt4PTzHfYzN5QR0dFp9TBoAn50NfqY8io+NnPAHxg80MVwCXlhrrGtweyQOEIjn1/HBM8csaKk1vkawkE1ybHqIA+F2HDYCXJfP0wYDI+5HRVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=e6BNj2/t; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=AnSsVevU; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="e6BNj2/t";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="AnSsVevU"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 96B2C2051576;
	Tue, 12 May 2026 03:02:13 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1778522533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hjcheSdWjxuZ0G0iM+Fsp/Kg1bBBZlIqHDhm2B3aRvA=;
	b=e6BNj2/tKhCjEUVm4wytHddN97Bmi95OVttHD3+KVUI4E5JDFZj0n++/m3JazEMaHRGoF5
	N/ESs7G/ZvOs0tt4Rc+6eHRf3EQHe6uuS2QuciuvHw9jsP1cZwCqUlANSWZso0CYufN2nk
	SRWqZoIVLmOfaRBniQNRt449gwlGpDzHOugfvu0zg0UalXzK7EDTCCd1rkXzxU7GWAiNk4
	axs6SwwE5jxpZJX8xasCqUFcrAtpWzeW0TtLrZcepj8A9dO4BOLeHIiyFkzWUzyj20UXyz
	rLnn8SpjhgEN/RfeGhKF/i07ZmCU9dpNDH6w7BcmqAVOdktG1ocruRLemYIf0g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1778522533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hjcheSdWjxuZ0G0iM+Fsp/Kg1bBBZlIqHDhm2B3aRvA=;
	b=AnSsVevUxEJxoBqsGXkkEhPwozOkydYYmrduwJIH4pazZsYO3Nsia775T5gEkmBPEGPG+/
	Qt4oUD7MOyKOBrBg==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 285B3E0039C;
	Tue, 12 May 2026 03:02:13 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 200F72200101; Tue, 12 May 2026 03:02:13 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,  Christian Brauner <brauner@kernel.org>,
  aivazian.tigran@gmail.com,  Ted Tso <tytso@mit.edu>,
  linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
In-Reply-To: <rnl552jwa6x72ibx3sg2oeitn6sh6jp5tnfu7evycol2fopw7v@ahwlfjnuoiwy>
References: <20260511115725.28441-1-jack@suse.cz>
	<20260511121356.241821-15-jack@suse.cz>
	<87pl32yq2a.fsf@mail.parknet.co.jp>
	<rnl552jwa6x72ibx3sg2oeitn6sh6jp5tnfu7evycol2fopw7v@ahwlfjnuoiwy>
Date: Tue, 12 May 2026 03:02:13 +0900
Message-ID: <87v7ctddui.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

> On Mon 11-05-26 23:32:45, OGAWA Hirofumi wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> > Use mmb inode buffer writeout infrastructure to reliably write out
>> > inode's buffer on fsync(2).
>> 
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > ---
>> >  fs/fat/inode.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> > index 28f78df086ef..4ca00b7a618b 100644
>> > --- a/fs/fat/inode.c
>> > +++ b/fs/fat/inode.c
>> > @@ -907,6 +907,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
>> >  	}
>> >  	spin_unlock(&sbi->inode_hash_lock);
>> >  	mark_buffer_dirty(bh);
>> > +	MSDOS_I(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;
>> 
>> When inode position was changed/removed, this will point the wrong
>> block. And maybe sync a unrelated block and wait.
>
> So I didn't realize that e.g. rename does change the backing inode block.
> But given we set i_metadata_bhs.inode_blk on each inode write, inode_blk
> should always contain the current position where the inode was written so
> fsync should be syncing the right block. Or am I still missing something?

I didn't check the case of rename completely, just recalled it when I
saw this code, need confirm/check.  But at least, the case of remove
will leave it even after the block is reused.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
