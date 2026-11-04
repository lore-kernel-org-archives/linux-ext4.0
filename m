Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753392;
	b=3jhdYC39RDOE4GxxaIQYrjx18Qru55KvIQIm4Z5tNnMJWlNtV5ItHl6tuF1IE9mdQ8Ue
	 kjwcDg9FU5lfheJJBnDP42H+1kXqKRm6j3DvIeGZ02QbEa8M+xr/XGLwydxg2QHRfbajT
	 hwDuprtQF8HNn7dpTGdv+lXldGEiEhAmJUzWpln96zG76+R9MNah/DW0LobihudS2eYbk
	 W41bHt3eJwBvsLMQ7AzQCA/9IB2vGZBj5KrJ/DKq+qr4SOiXtAqPUfU+TEHfKPq6jAval
	 bPIBihS+tnTnG9nrhrsOqVhomxP+QiWEwyVADgslrGkmzld1yyfbihHbXmubX/fMvcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=O34GTqTsR+Ya/nY44s2c6aCLHNP5efqwLgOwoLgmm4d5QBJ0+vbFm8QNh8AVd66WnDsO
	 Ou8iaDGDrG4vJ/U4b1KhrEkHfqF+W+8FlTsr2WJM+SmsECu3ByrOMw2hG2ivWze1IWMt5
	 0P/990rWv3I4/a6TrvF4px7VLGpDFD+dTLkiEaDSk0ARpd7iamPi2SIIJwYU6ciuflCQ4
	 ozJ5VjLESd5Z8SbUZ6EZOtRP6RfWwyY1gL545V9ezqjV9h8/2R0+CS/ko8exVOWpowAi8
	 3vhukDp+y9E54X1dggfRJzGG9HKnwTXZG1gQZpVn0CU33+OZtcErCZ28mpa4ey8jizA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A98C606A330
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 00:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A98C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdab6ae1ee9so87343a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=VT+pUP2NwuZcLnfpE6RBehWP9rj7p+v+tKoR/WVHOzz1v7CJgJGu6gqjY1V/YGEdmw
         igNrVOnPTFLv9xvYK2tnZhcPD4jqAzwLjDlQ2iFsJIT0vgZOsXkUB60qRSrv68Heg2+2
         k5XkKmMrKWtBUKDoGvgF6CjyKJx7mmzehyXgiMW8Z51NtcdDEa4LvP5GkI/GPk/JWdX0
         E0pyc83t8pyqA1wDQ4YMhv4IP3UIHbsnnJtT4+s3TyxuI9ePzpN8dD0BzwPhXNBIUBNN
         GS4KAdHBqzLrJ9upnMsWdUfiG2GuZuR+cDGx90+hJalABWpp8S3bPmquj5j2mZuikn7l
         6bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=JWW+EYx+S0Fl2omw6XrEzTJat3v9T3jiw9YXeJRzCBardncU9cm4e/x83SWzJvUpkD
         dX6hvzWijJYJM+pJZo7XKwUsYUA4/hMyFAjP1118tvD8CuCADD4gy0zQqZRGruLDAgQT
         IAIMqVILXQRaEYNZreaTz1jRCrSiFF2OHGSMGuHZW8JMrhjWqhsj+s6O4jiNY4bMXJ37
         k8z4zpI/pEKfPT9OyQnwo7NSC/2AE4Xbt3HqQZ1Sk+hAmO0YjkuxgRBwd6cV5vzQPNjp
         xHxGvvHZx16fBjxxBxcK5eY/w0wzRlof7se/7BgctFKTqSKlunqDt+jy0TI8SfiYn1vC
         9Emw==
X-Forwarded-Encrypted: i=1; AKwUvBxdl8Gwg/9+2Nz36XZhq0PAU9t+QBJj4e4WhyilYcVEJOWPNWZNncwLZjBwsie7tNFKA+0rApAvxSEN@vger.kernel.org
X-Gm-Message-State: APuU4Z/C+F5wmddpZIdt0TPq3Sk2P9Q/B7PLkadkn7NjmHVnRhhxx+xo
	v7tB5CBElj6cg34RgLjTMP33c9PIKm7/V3c6/xq2is4IN0Ra/ICKHRPj
X-Gm-Gg: AYBFou2zKj+9jTqzmgp/s+xiNK4alqH35/dPHQj5T8jiW4TXE+Xa9q4jNisyAVpztqd
	F75udVitnBNXHn8oRVw8wU3hPIxBK9bRelScMoxQ2WatPpclY09prnPbIIZaeGFgRZ0oZyARvRp
	CPT6hkgsq+LZI++nJPSywLTvomLvVIhqzsICHchxWYcs+Xn8/8bHu43xmp/16ebGT0w7nGaUUrW
	6JeI4Der/O9k/5SudoizJh5DG6P3YmI4hVH/6jyWJSyMwvnxZAgFNKqfpiDjI8C3Wcqqpje+a0M
	/YA8N/G8v7NeXwo+r/ChpMx/Yq18R1+cuBrW7Dbf6d71LpdIEOvjlkQGnZazuA4E88u8hsLwAZv
	MEZ0XabeTF/EJLEXia1Fl5m1E4em4/YNH9pcHQmBWFGPaTFbN5Nwst4Ti6brFj+3q6seSQ/m/yE
	HIWVsgv+mPFg8Sy65BgWXGXY59hPRVYO15AV0xYGBxd5JiZGtwU2DoVKPrppD8AhSlYZzov7ob/
	o6lgaewra08sObHQGlGpp4W4ZFXifZ0zT74xM3YvWweSajPuajxNQ1GCcu5dlx+Qf9P2cgDidyp
	ZNeUstHc93wj7bdayUIN5r6LSAywkSmQkQaqEN0=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
