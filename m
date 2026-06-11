Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6903F7885
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 12:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181378; cv=none; b=QKdwcZVETbgIHCE8R4F5WR16VKzZ7er9NoZLYpGpVeDuUpe1nvCQ+H65pv+A/zGDhG9G6a/ef0iUjUugSit6N+2Qd6Q9kMarYZVw3lNxjYnrYstXCbUcg9adY5x4OZ+iKZJKuiYP9InUunLk3GTUupkz3QC2hCEaB1IyDQq4ITE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181378; c=relaxed/simple;
	bh=0o09vuj6JlkMcUCPruU4qbt0WCpPEYadeGi6N8eUSO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QfWz2YTM0kldNMIOQVy2wa6VOfCXpC2Cf0OM3hHAFIvZGvPTp0pwFrlM+c7gZoGuBYfZ+iEthla7sdxcbKGaB54g7Yw4lV9Xjhpb8L0fAvQPHcKflayj1MywNi2OFrDE6+PDeGgbcwk3KEZes+ODiIGIGiAPWs/PGtDzvFcWaVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=JdGSSk6F; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="JdGSSk6F"
Received: from trampoline.thunk.org (pool-173-48-113-189.bstnma.fios.verizon.net [173.48.113.189])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65BCZTqg008242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 08:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781181336; bh=Rx+LdEHsr3fkwaOg3QTw51ewMl4HfNH39Mi9ttL+zj4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=JdGSSk6Fh5MK45uAfy7ILLTZ9bCrvvoX5ub+vHUptqOy9nKRxSPhiYBRsBGam3V9A
	 bIXrQlhuMMHnyggRllNQeRdHil+HUgLSrFD9aXGPwnJe4lGDNO6qKtMGHSxO9Wi8Ym
	 4jFgqGYY4fklfkVASrATuXvOK9Pm1oSjoA74YrpjgLX07a4q5j9DnfE0xeRRIRJZVz
	 g7LrDpAWvtFdHFeAfYCcR2futg+Qx7hCxrZGhvTGpZnqL88y+33j373B4DHXu4nFMv
	 aEh1Bap2Zrlm82Xo7DQBgrw2m4oXLgqYHptW/Fy/YNeIKECMuZ/cdC0/4w6SkMzkeb
	 qioL0ShgSBkSg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0E5702E00D0; Thu, 11 Jun 2026 08:35:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        sashiko-reviews@lists.linux.dev, linux-kernel@vger.kernel.org,
        syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Thu, 11 Jun 2026 08:35:18 -0400
Message-ID: <178118128407.522716.4641375865971694376.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609062005.1702-1-aditya.ansh182@gmail.com>
References: <20260609062005.1702-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 09 Jun 2026 06:20:05 +0000, Aditya Prakash Srivastava wrote:
> When the data=journal mount option is used, the ext4_journalled_write_end()
> function incorrectly calls ext4_write_inline_data_end() without checking
> if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.
> 
> If a previous attempt to convert the inline data to an extent failed (e.g.
> due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
> the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
> call to ext4_write_begin() will not prepare the inline data xattr for
> writing, but ext4_journalled_write_end() will incorrectly attempt to write
> to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
> ext4_write_inline_data() since i_inline_size was not expanded.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix kernel BUG in ext4_write_inline_data_end
      commit: ad09aa45965d3fafaf9963bc78109b73c0f9ac8d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
