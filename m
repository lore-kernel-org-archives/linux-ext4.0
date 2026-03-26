Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566D83B7763
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526289; cv=none; b=MxntaQbsPVZ2yXZyXV6n70zxkeDKZt9pg+RQmVRGwA6hScH/Vbz4we8Twahq1WNCiJRhnkfXcU1L6EfUXKzRAZ/7f8oySBt+j68fGvmUaj4qihRiF/tRucA2TUzobsiGDSxk81lUhELDptSh+RxQXnxoSpxJbVg65D7M7+xRIwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526289; c=relaxed/simple;
	bh=2/j+w6H1MsulsZSBcwGI+WNQZaLWSgSrac+Yc1uEUBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LT2C8zoImED1TI4+Q9js6WQ6U4QGg8UInqleMn9Gj3IqEh+X0S391tAi/e4vcp0EbMfIgYu6m91dFUbPdr25J2aAciK3lArXMvPpq+/hLqCNRlham44hOjU2P63xUv/VMbDM0gu7Sy7v9vZ7qZcLFIR7K03oQfodHmeWUYm22s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CrdPpQma; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CrdPpQma"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvvHQ020389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526279; bh=/UKQ7z986HfCBu3OUXzVSTFsTaNs7vFdcYZOm+RDhDU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=CrdPpQmaegCPU46tKbhWF3s3rOIW9IvNzZtL6k10sXzDYlQjH+V7xzzQRLL9+UrkB
	 b8D1mYi0QSIOveSjIvycV9vQwYIHSWgAC/nxstsdPcNFidyMBc7piellc+A+K1/0br
	 QhpsIF1ztEVrCpbp0miOwO4FCAidKQn2doaixKK1ZgMNgQlqCSdGjUMCLgiKUUohK/
	 XEGFQ9edFi7rjgmGmkmID5yv2b9r0b37dB5WkT90VDs/t/d+P3WYqq9SuScFMYd/np
	 /Z+DgxEMVr7GsDkLv3cufiJ7KbGU+2s8n8Nj/iYm+XUIXPLca1AP80WnqcFGe7a+nZ
	 7ChUlPzrQAIrA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id EE8292E00DA; Thu, 26 Mar 2026 07:57:56 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Chen <me@linux.beauty>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: publish jinode after initialization
Date: Thu, 26 Mar 2026 07:57:46 -0400
Message-ID: <177452625029.1205486.10688089869136424604.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225082617.147957-1-me@linux.beauty>
References: <20260225082617.147957-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 25 Feb 2026 16:26:16 +0800, Li Chen wrote:
> ext4_inode_attach_jinode() publishes ei->jinode to concurrent users.
> It used to set ei->jinode before jbd2_journal_init_jbd_inode(),
> allowing a reader to observe a non-NULL jinode with i_vfs_inode
> still unset.
> 
> The fast commit flush path can then pass this jinode to
> jbd2_wait_inode_data(), which dereferences i_vfs_inode->i_mapping and
> may crash.
> 
> [...]

Applied, thanks!

[1/1] ext4: publish jinode after initialization
      commit: d4dfb4e294f762f0567c50ac6cd71ba02c976575

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
