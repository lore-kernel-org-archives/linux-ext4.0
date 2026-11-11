Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389692;
	b=IzVZ3rwtoTzWD1THW7J+j0nJQcGnE35RDsoM4gK3560IWaulV/cSQ5LX0k23xNB+iD5J
	 TrwzUY62XAiQTykG2LqWFmbyEUD0G0NclOTbqTSDqCJw/WBxvD5sJOvLZ83ASL/NF1LcK
	 NJ+DCaXyadZwpkuXoXnr/wTzt/vaUFKMUeySsWRKFyW3MYAiYiajgPFtdYtgM+nKeDeyu
	 9HsomEXjJazZNjvAX1F5DMeO8HfyJoQldMn+uOdjSaDHVglkFqu8bLPXcn/A9YU+PoVlY
	 h+k0Ppe7ECQE2SJZ//QW8Z62d6wC0RHCab7Fvf0Kab5T3K0vb0PI92g7drqUhXxcF1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389692;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9oT8mJ+Ro9B5pT3ilEOpm07E7nXRbdqUWub1X6gjjq8=;
	b=KZtsII5NaXbO+pLuoMM+IH+lKvqUDGYjFDVlaPzJ9f9ZJ9/OQ+qyLagpKhljK1Ak6HVd
	 SPDHaH9qLAIVqvmYprrhE958sNXRtCXRhm91m82h9+WllQnPnGUtq/Ricy2K/ldqgKqO2
	 wp+ZzASbeUAm9fw6q3Kt93AyW1+IlL2t0lGtU9AO30olk4TsfF9NAxyVmL82BYK1HC/oX
	 pbco4CQmU+KOQqiZeypuPy6W5ejOhFfOe/8x+hyWwf3UTaY05fCXTETc0t+8ZxBoquZZQ
	 uJ4eJL/sswhkYC26Wo9N2HqUIWfDmpSBBUfK1RjTPdGzkKPwrxm5iJom6JDDQhlzlBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OdtnVYVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30632606A324;
	Wed, 11 Nov 2026 09:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OdtnVYVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CCD1F00A05;
	Wed, 11 Nov 2026 09:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389691;
	bh=9oT8mJ+Ro9B5pT3ilEOpm07E7nXRbdqUWub1X6gjjq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OdtnVYVcsG19f5hTkpS9kaTbzYuiT4HMccwgMwUjVwnIpesQBW34vpb3Soyr4kOrP
	 hOWU9u/FdRtMey9V9HCAE456IT8ckxwm57A+Ly6VYYZWBpzFU181QmxIL4ZKaQBkuv
	 R4IW4Vu3xTtqaWY7OChZuL0TLDuaiwTiXF6Sh1i/iIOBQY4YZqWcOBld9mgeDtepGg
	 xhpH4Hal/ORXF7Ws8rDRjza2UZ1LZnHqJFb3QJhbDQIkq2cHWiFFEkTUDv9nHA3f8I
	 KC2GcTd5PWGGo5PuIK0Rr7OdS0N/e91AdadUEU857idCihrAQD4FlV8x8zGu2F2D2e
	 mjn9fyjTG/YWQ==
Date: Wed, 11 Nov 2026 10:34:46 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261111-weinreben-einlieferung-sequenz-e817949ea18c@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191236@kernel.org>
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
In-Reply-To: <sashiko-outbox-191236@kernel.org>

On Fri, Oct 30, 2026 at 04:10:02PM +0000, sashiko-bot@kernel.org wrote:
> Should ntfs_trim_prealloc() (called from ntfs_file_release() and
> ntfs_stream_file_release()) also check ntfs_emergency_state(vol) before
> rolling back preallocated blocks?

It only drops trailing holes from the runlist so no clusters are freed.
And __ntfs_write_inode(), ntfs_mft_writepages() and
ntfs_mft_record_free() refuse in that state so nothing reaches the disk.

> Does ntfs_drop_big_inode() need the same !ntfs_emergency_state(ni->vol) guard
> when truncating unlinked inodes with I_SYNC set?

Yes, ntfs_evict_big_inode() already leaves unlinked inodes alone in that
state. We'll probably just do the same.
