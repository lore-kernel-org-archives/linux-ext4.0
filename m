Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871427;
	b=HHfNVkSs+vVKDO3f4oRTEjMKFJqdDo8cXVAoVDdfcytqtjHFb6tfqsyNrpd55E14o8A1
	 aKfVotGwpT7wEVo32/DViCyzbduJs362CLm+HCpLvcBf/LN0RoXyN3IP5eikKGFY8CVDd
	 DetC8d6v6ZRy1K9kZO5+JdIEpDnfqW/LBoPQ9jqM+btavkfch38WHVyRQVFIXwiaWSSHF
	 HQpkh5Ql+kenPw5hxQcpfnNbV+bUmTfL6SxBS0PZ7QZJnt+xln0GaExU8iiQiREHn0mGy
	 sbqEuajtA3AzJa9ar3OoITDJ8tAYOLG9GVrjKho0OkyLnPl5aSGAtqKbXgqgU/XlbOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871427;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7K/3UYmHmYqyZ4dedHvbD3/glGO/i1xPnHZWZAvi/hU=;
	b=hYOZYFD4NpINGyhGqqpJW1uo3MuRSeJBLEzBS5jteJEEf8s5ZbpzeQzZHmzukbL0JgUz
	 oJniLFeRwavUq/BnTK5npfOvuGkES+7RU2NhNAqjRZmFYhqN6rV5kNLv65A8BNqcvorPx
	 gR2PIB/WlTa43uAEu8HpnKqJRBIQBmq++0QiXIdQ1TjnZ1B5iHOAZKY4XdqGb8Nd6DzF3
	 tNeClZjST0JpavEOonAw3Ah3KCU9AhzfqVb5dYHddF9STbvm9qV40wp587+WGyCGjfisN
	 YWhGujqP9SLuzPAlocb0JykPpiS5Pen19Ie/AH1hCYFkzYXEtYKywGC7HkYGUkKJ14w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c2bSiclw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56512606A31B;
	Thu,  5 Nov 2026 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c2bSiclw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5550D1F000C1;
	Thu,  5 Nov 2026 09:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793871427;
	bh=7K/3UYmHmYqyZ4dedHvbD3/glGO/i1xPnHZWZAvi/hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c2bSiclwFvsOddDtNdBAGgue40cuAASBAriHF4ShMSnAH+dj5VoZ54/+FhXWYPl8+
	 oGTmZ8+y0aZU1aGjpnG7PSNmLbrbHYBDtRkHAazRnTRaKM7kFb1gWrF4MgOONLKn6A
	 D2g12W0/aSEoOEuqtKS+lZMd28/Pr0BAO8/hqM+XQ06Tn/zM0G4nP7gRYzQBGI8gDb
	 NiFAE3FpUff/5JW8M6gm899fXTDENHW+NvBDvfaMy6A6GVA7US5GfJYie8tO9D2ot0
	 3bnnWozdI7NLkK3bt+hwaq3bUOwgoV+63mfnaC86dYVSR7/ECeqqyJT/2JhMDDaHKE
	 5J3D+4peA5HLA==
Date: Thu, 5 Nov 2026 10:37:01 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 3/9] ext4: add ext4_inode_loc_block() helper
Message-ID: <20261105-eurer-wimpel-gierig-935915475d98@brauner>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
 <lqhym4n6vu46kretnwfstfutik4vl4l5imhnf6pi3aranjpryx@bgtxuzuha2zs>
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
In-Reply-To: <lqhym4n6vu46kretnwfstfutik4vl4l5imhnf6pi3aranjpryx@bgtxuzuha2zs>

On Wed, Nov 04, 2026 at 06:07:04PM +0100, Jan Kara wrote:
> So I don't think this patch is really needed. ext4_get_inode_loc_noio()
> does exactly what you need so you can use it in the next patch. If you
> really wanted to use sb_find_get_block_nonatomic() instead of
> sb_find_get_block(), you can actually switch ext4_get_inode_loc_noio() to
> use it.  ext4_get_inode_loc_noio() has only a single caller in ext4 -
> ext4_fc_snapshot_inode() - that is actually fine to take the folio lock.
> But that is mostly unrelated improvement to ext4.

Ok, I'll drop this and use ext4_get_inode_loc_noio().

Hm, the nonatomic lookup isn't optional though. Afaict, the atomic one
bails when the folio is being migrated. So for the fast commit snapshot
this now means we fall back to a full commit.

So in ->sync_inode_metadata() we now skip a dirty inode block and
fsync() returns before it's on disk. So we need to switch
ext4_get_inode_loc_noio() over to atomic as well, no?

-- 
