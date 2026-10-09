Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800C9413230
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536227; cv=none; b=a30RHeboq6zIfbuEyZTJXQ5JjeXgWkY+ywuQ7Uk65dGzsXMqZZN3yQeOgce4+ltFNvZY9DAAP7eA9DxbscQ1GdPpKJgGR0SGdpyGk6Vnp596jUY4T51jMzf2QzVL7af3VGnSZsRXL0j4PTWGtZ2MjEJ87QamupUxEZo2A9J6VAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536227; c=relaxed/simple;
	bh=0N4fXivqA8Bxvj6hLQnsHLEWucoVohA/BJHqhxOxLY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/nYJ3+5n3eJuxSw8wCGQvr8KFTiu55HlgqNryBITzuMOV3ZBZMF8UI1E5SybfCX1a/0hs7CKWRuUNwHYP44gUJFaYheLTq56FnDEV3T+2mAIhzlf107B1x0/EAFcrzrxrGuvQ1/r3D7kneEXHvnLUU9LK1BZTQ9FxSKuFgAH2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=L77us/ze; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="L77us/ze"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uVRH014135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536194; bh=tFk/cDxFEcfTXcCAEKodNmk15uuLDdJerQvJRNbWmJI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=L77us/ze1g4h8w7+Pt8cO2JzmuAou1WD+gWGiuhr0Ec/HRZTRGm4hnNeE0v3kPzZW
	 KdLkNiDHWHSI6EzDDF3qN3jI2ZQKKHJY0pwD0rM76NrBvOhF22xKagpgwnNYZ8V8ju
	 f/QpkJHiEerMFW9/WZgqiorp6OW5DvLWl8AabSp85cSfBt4a30gnqEevHbJeVAvaU4
	 JsZdaaoaSES+Mrg/bAfOWRg8EmMI7wEwIZGlcJeFfvip28S2TxRkOfvaCFP7YU/LDl
	 aEwCDDL3vdXJVapZBgFlkJH+3PGS3QNIiO4kDgvMUs+AZ9UVoZLV3gR7+ZFu3ZwHnZ
	 tckcD4Kq5V4nw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 50BEF2E00BC; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: guzebing <guzebing1612@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, djwong@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: only update tune mount options when requested
Date: Fri,  9 Oct 2026 04:56:18 -0400
Message-ID: <179153611735.860602.2935082355455489432.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260810151200.1405562-1-guzebing1612@gmail.com>
References: <20260810151200.1405562-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 10 Aug 2026 23:12:00 +0800, guzebing wrote:
> EXT4_IOC_SET_TUNE_SB_PARAM uses set_flags to indicate which superblock
> fields the caller wants to update. ext4_sb_setparams() checks set_flags
> before updating the other supported fields, but always copied mount_opts
> into the on-disk s_mount_opts field.
> 
> As a result, callers that do not set EXT4_TUNE_FL_MOUNT_OPTS can still
> clear or alter the on-disk default mount options through their unused
> mount_opts buffer. This can affect subsequent mounts by changing the
> filesystem's stored default mount options.
> 
> [...]

Applied, thanks!

[1/1] ext4: only update tune mount options when requested
      commit: 981eec6c300bd4e84ffac8f3c28b762d00f13e9c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
