Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099692;
	b=ArFpE2drxdyBXXYBgGcc1OH0MRD0A0kNr59WTf6m8LBptcrc5lF2Xx1IuZNCnpRBpHiF
	 rUmB3oAWvH4FEG/7rcVnkH7pCnP4smXtVf7YhJ9Vq65dB2BS/3ro9Na5QT1QNkghB3n54
	 ipPK+5XX4yK0egSv//IVa6jywduOzCuUMlEoo4dimSNHBXH6vOqmPLAAliE4dgC/QLMTG
	 yITMNKYrN7B21izArbOi0hZS2zvBZH1VYv96tuy6P/B85ip5dLIU8PvG8scJqJmPuZ/hZ
	 Ak92D0oeU7VbAYIz4z1kBhm6c4YiVS9ih0cyp8kFcKtTzeX1t1nb0B5wh0Ros6yT6qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099692;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=mVHF+exKX73nNHy102awAuxiSXIWMB8Ri25mxYgYUs0=;
	b=QlxzGhSPEWIJJ1v7aTLgpBC7UIJUM6y2/L8ZQoYhBlNI+7dTUaqzN69WqEfnwT3fNvjv
	 0jky2LNyHdROULghQM1Jda+P75lwqTVuzIk1V2oeKD+lwyXE1tDZUPY5w0vAQo1iyoZit
	 hetkNdkCbhC37QpJ//IZSYDIfMmDjQ+MkQfd9zH5CxlZjT6Rno+Ca3ZtDSdYrX+lX6XZo
	 On5fWHAa0YyKaMjEdXwUQ7gaRNbRrQZr/8qXe+p2I/7zVRVeoOLn/GNt5KS3VDp3brIQq
	 WDSJVLHeAZ+Yt3400Kzof0WXAkYYpzhPwH59MbZu5ciwKAiLfplTVobF+QPv9Becw1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=F7b4MNBz;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C903D60A3811
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C903D60A3811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=F7b4MNBz
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElcAC018006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=mVHF+exKX73nNHy102awAuxiSXIWMB8Ri25mxYgYUs0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=F7b4MNBz2cjEfQ0xvrfJPXqYXGdXFkfsMFk8PwWvyImhlm+hUR1Ww1TvNqBoRY4CZ
	 hfzsHZWhWk+g+ckw5V2nKAM77gqus5+teq22sDPYQv6os1UJBU+ob1Bez2rq624x0D
	 RX/eVtWeHuVcC59IEWCJfDCp1Jnc5Vvcfc7lW47X1ZdHBCkhux/7+7R94GyXrP+qRh
	 2fKXIsurubWF+YVfSgq8nxaFh7z5johBeZ/bEtR47zc4oUNP+DLqjwV12WA3+KEg7U
	 U+hidNZ2OPCdA/jgYN0kUOlrbU915VuvCXaJYAQPdjjO357VtY9bJmk0U4FjP8S72n
	 0RMLInR0saFmQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 09A942E015C; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        guolingxing <guolingxing@tju.edu.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ext4: check return value of blkdev_issue_flush() in unchecked call sites
Date: Thu, 19 Nov 2026 09:46:53 -0500
Message-ID: <179509948705.1938961.15367647916080691242.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013082331.2089623-1-guolingxing@tju.edu.cn>
References: <20261013082331.2089623-1-guolingxing@tju.edu.cn>
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
Content-Transfer-Encoding: 8bit


On Tue, 13 Oct 2026 08:23:29 +0000, guolingxing wrote:
> This series adds return value checks to the blkdev_issue_flush() call
> sites in ext4 which ignore the return value: lazy inode table
> initialization and the file system device flush issued before
> starting a fast commit.  Both call sites also issue the flush without
> checking the barrier mount option; the series makes them honor the
> option, consistent with the other cache flushes in ext4 and jbd2.
> 
> [...]

Applied, thanks!

[1/2] ext4: check return value of blkdev_issue_flush() when initializing inode tables
      commit: baf9a298bdd704c6a1fcdbdad92d7a802e9c02c1
[2/2] ext4: check return value of blkdev_issue_flush() when starting a fast commit
      commit: 49ac01dd7d436e068a62ee2b5601654234d8994e

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
