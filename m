Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2523D75A1
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536251; cv=none; b=tNPmPXTRqGE2xK3oWmMiucRsyaTcCuzQ3ec4pHPvuumSuYusozh7CS//3APLra0kPfgS1XbIHHV0pRYi0RGF/YAev04R4Li/FuD/GFHdq4RXOaW01C46m/zYHSxamLL7F6jaxp7fxZQdcWE5+0eWQmfzoFm+S5ClNs33Omrd4Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536251; c=relaxed/simple;
	bh=6J1dPIvYYNfRgSSEaiEuE6KBeVNgm3/y9XQKAWm3jBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Md6+N+O3mIfZfMGKErBcKwxHpZq80YeEvTa/t1PY37E+leRP5WXZzcaBqyVumm/lw6RrR6iCRTNSov9dB7/CaWbk5km+pXfqA6X49cxBOG+vGH1i63i6Uok0BN3AC+jWl7beBurKAUwvHvyGCnwWiIuVXPac5odTB3dutOHYJF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=H9jvTPBT; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="H9jvTPBT"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uY3c014211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536198; bh=n+26eLxK3oQ7b/C6oneNrEOgUCszQM7atT4O7C1aafU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=H9jvTPBT1bY1ns3y4IbwKuNDBx+CGa7MpLtRpNS+yA8iRZp6CgcaI/1lzSYwErG3s
	 I9+MnDCiuj3OehFFUyqCusuwrhWCThf9nSKtdCq1NwDkLrt/H25zjFeSEcoaSsPckV
	 eA3xmi5tCQeojXsEbTrqYo96MlWXpYjA31DbGMf5tSGHQiEzTrE5nrEQ2BTEEDsO7H
	 GbaZD9L4RCL7UWyOF3YaG5p1DkYrpYUNirMkt0PQRm03hK9xuFwcRWFHf4X99fna5z
	 D00gBFuAz+EoFN/s0TgeiuNU+3rnUWdIqFmjXjnYdV26rnzHA69hnmsv5feV0/1uCh
	 G2D+SUE2OkZog==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 690C62E014A; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com,
        chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v6 00/31] ext4: use iomap for regular file's buffered I/O path
Date: Fri,  9 Oct 2026 04:56:25 -0400
Message-ID: <179153611724.860602.5266334742364847927.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 03 Sep 2026 20:35:12 +0800, Zhang Yi wrote:
> This is v6 of the series converting ext4's buffered I/O path from
> buffer_head to iomap. This iteration doesn't have significant changes
> since v5. It just fixes bugs pointed out by Sashiko, improves commit
> messages and comments to prevent false positives from Sashiko. Rebased
> on 7.3-rc1 (45c13f3f9e3b).
> 
> You can get commits here:
> 
> [...]

Applied, thanks!

[01/31] ext4: simplify size updating in ext4_setattr()
        commit: f1dac42750c950dbe9f222b7520f082fc063fcf7
[02/31] ext4: factor out ext4_truncate_[up|down]()
        commit: 7ef800c025eaeb426883c16f02f930da51160306
[03/31] ext4: skip ordered I/O wait when zeroing beyond i_disksize block
        commit: 4df90406bf62f90f4270ced45bd8500134dea5ff
[04/31] ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
        commit: eaff8d796722ccce34581b03f24534a6c29bcfa1
[05/31] ext4: recheck extent status tree before block allocation
        commit: 9a9ce46904bd90622947567b58188e34bf370e95
[06/31] ext4: fix orig_mlen initialization in ext4_map_blocks()
        commit: a151ced18d2f51db2c89c2067c1529d06ff88170
[07/31] ext4: allow ext4_map_blocks() to start its own transaction handle
        commit: 8787d53c6c84dd13d5b5027c7d9c890499b7a03b
[08/31] ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents
        commit: 5c42228dbb3f2e10ebeae18844e835655e145f0e
[09/31] ext4: skip block allocation for holes in the data submission path
        commit: a88a4ccb5d8c09f76fb7eacd85abb34b1d1ee461
[10/31] ext4: add iomap address space operations for buffered I/O
        commit: d7b0117968de9bac63b67b23bf980494f4d98093
[11/31] ext4: implement buffered read path using iomap
        commit: e933fd1b6cd5322563d5caf283dabd9cd09bcef8
[12/31] ext4: pass out extent seq counter when mapping da blocks
        commit: d5fc46e0fe6747f5281cd8e8eca09e53137dcd48
[13/31] ext4: do not use data=ordered mode for inodes using buffered iomap path
        commit: ad5eab6106328336f03d59b48332a67f37ae5279
[14/31] ext4: implement buffered write path using iomap
        commit: 8dccd9f0a1a93f47b758fcf6b3f7f304a1309680
[15/31] ext4: implement writeback path using iomap
        commit: 5c83026214c990923a2ef4ce38c2c773e9ff86ad
[16/31] ext4: implement mmap path using iomap
        commit: d13be7c144f9df5fc5cb452043f4a2e275f55114
[17/31] ext4: implement partial block zero range path using iomap
        commit: 92cd6a8e63caa0815197921f40fb6235d4bdfe7b
[18/31] ext4: drain writeback before removing extents on the iomap path
        commit: 8cdd6123c732c039320edf5105eec25b95edb2ba
[19/31] ext4: add block mapping tracepoints for iomap buffered I/O path
        commit: 9baea35b95c29a07b8f2c813a29ebe473202ae16
[20/31] ext4: disable online defrag when inode using iomap buffered I/O path
        commit: c6d61f8e3e4f75e341958f83d853b872168b4836
[21/31] ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
        commit: 7894caa160a917b5c69e6e11773106634f70fe28
[22/31] ext4: submit and wait for pending disksize-grow I/O on writeback
        commit: b9dc57ecc8a5ba34299e737d4954c1df54f16ea8
[23/31] ext4: advance i_disksize to i_size upon disksize-grow I/O completion
        commit: 61bf54b10d4fdcb32ce0cd625dfc14e7f2c02359
[24/31] ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
        commit: dce8729e91d2b967574a94e2636adbbb97dea44f
[25/31] ext4: submit and wait for disksize-grow I/O in fallocate paths
        commit: 4b0d638453ade967e99883d20564c2b0e53dc290
[26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate or error
        commit: d8938e95403ed7888b80cb39d7e7e047a493161e
[27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
        commit: 7e6b2d5ae79a8060610fb20fc4690ece412403cb
[28/31] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
        commit: ec18ea1899e51f5a00abe4563d21b362e026cfd5
[29/31] ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
        commit: b3ddc732eb4c07947f6b45df58964ea9e3bfc48f
[30/31] ext4: partially enable iomap for the buffered I/O path of regular files
        commit: 03616d672cbfae29ca08b706dff8512debfa4781
[31/31] ext4: introduce a mount option for iomap buffered I/O path
        commit: 35aefefd7aba0801bab635b11943f932626be3b2

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
