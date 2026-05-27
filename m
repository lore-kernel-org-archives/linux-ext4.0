Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B69400E17;
	Wed, 27 May 2026 11:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779882808; cv=none; b=fGoIRt5sSP8arNNBpx1GqF56A/5/NzwwJ6OAyzPw7Ux27sAWW01fQVeKEp+uAt0geGEHsSzrIE38pPgBcFKuC4kBuTsLIM4bDS5hzVN8Y6nwZD5D6F8d1ND570F5RzhK+hQO1Snjhjzb9LqA5D1ZvdP3dsc/KsCGLMCBZh6h+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779882808; c=relaxed/simple;
	bh=GMGPOmAXJIWUqBQ7uUHU2mhSVLtkRhIxFdRYqdFcirY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPLQE80Ks0cAaMW5LZ/uw7kpkqQEjim8qhjQF1EVDdK9KP/zjBIL/UKK9LxCFcgniaYdKvv5qn+znNmD6GXBUSdKVuz8/dh9Hk6MzJWJ2SSitGBC7bWe5LoCsuQt+xk9+7KK+oV7RnmT9NZC81f3YOJBswn8h981R30bhPZY68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSLx645b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSLx645b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEFE1F000E9;
	Wed, 27 May 2026 11:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779882805;
	bh=5AaYM3rCtrknSXtor6TlatxblbL0I51WjFp14BcxqHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YSLx645bHFkxgsYvr7XNJkfA2egswx+IBvhFUxCGhFHBnsFkjCrX3aKv6bgjndep7
	 1FpeGiuwJgxLxDgH7Y/FvXFswMEKf1gPiXnRc7swI97whEoZkqud7QJOKYxBLGCVNO
	 QE1sPBusueBEMQJQMQoymPAtBL34m3SRBaIIheJ+qa33FbDoYihajfo3+NgXfstRYA
	 yTlX33f0axFWenVlVf7QZlH/3k/65Xp0xw+ivZEJgHFne04FDqrje55viE161Vx6Gd
	 nntACcAOVF93uanSLgQinUo6sOp0Bp4VSCMOC2/uRuw+I9iWif4ulztkWFADJtXMiW
	 IDuAXLL5rEvZA==
Date: Wed, 27 May 2026 13:53:21 +0200
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/8] super: drop sb_lock from setup_bdev_super() tuple
 publication
Message-ID: <20260527-butterbrot-rausspringen-ortseinfahrt-eae154bd985f@brauner>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
 <20260526-work-sget-v1-5-263f7025cedd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260526-work-sget-v1-5-263f7025cedd@kernel.org>

>  	}
> -	spin_lock(&sb_lock);

Yeah, I failed to consider that we need to protect against a concurrent
sget_fc() call with a custom callback so we cannot reasonably drop this
lock.

> -	spin_unlock(&sb_lock);
> +		WRITE_ONCE(sb->s_iflags, sb->s_iflags | SB_I_STABLE_WRITES);
