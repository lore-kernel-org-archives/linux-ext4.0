Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099715;
	b=gp2Zc1TYkLpVgGuUl2kpNOvMxv/HJce+4N0kVmFyr17WGWehROi8WWpo/j85JZ1iwFyl
	 zyGhVlLbAKUhEZbP5U5UAanrp0wVNx0NXG0cnNwVj7N2zCFYgqkyYV9BKHvpt8ACuj6GW
	 lLVfjZsD1cjpg7EGRm3OFj9iY7tJx5CGrHZcVtgw6Khhd64NEtzOM5orL8h3MIEIdPSbR
	 S5DYYBVjh8BhpvKlaZxYhKFQIBYhwnm9pAEeCjLpe3Hhr/k2JXnB9O8T5JMVUfjUIopaG
	 XMXmmozynqjuLcYDdNKb2rdhrGmB791UPZL/1b3d1Fxf+OO994R1NLeFT7HzxDyVb/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099715;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=1/D5TRdPGEJv/deORRf7lI6TarBcGeZ7nHw5ckttJ6Q=;
	b=g4vxjFgrtr74ilnj4MOuTlqcs4gAxizKPErMdr5/YLbCN5CEKlWfRRWp5rTKqa8E7yyM
	 RQcvtcyRxukJCpUHavOlMu8ujTvuGV9ouGfx8jLIkuU/ijOc1FToS460Po11ZHkZWv5dd
	 FCLI3Uv3tL628xN0QnfSb1dkdzb72uKZGAF14B/E0e3uyIz6pNkkG+osMKQHzFSGbPERj
	 g+D43MZ0wdVNrUE5QB+CPI+cQ/jBkYnP8Z8o/PizkRBFii2elp8GWDlncR7HTNs4Ica9z
	 985cyY54y9n45Ylapz4q01/S0j9s53jBEPE9hXi4arYMxofier9UCos7qvuFg48QcJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=oZBiw3Dj;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724006070C2B
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 724006070C2B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=oZBiw3Dj
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElg0E018270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099666; bh=1/D5TRdPGEJv/deORRf7lI6TarBcGeZ7nHw5ckttJ6Q=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=oZBiw3DjHt5lL9MqN5yI27gPELYMwiMFZ9OrUd69hJRB9NWSypFcL+XJ7EBVlo43m
	 UCtJXRcHaC4TvLufgD/nmR17La2dpTOXfizyUa7G/Hij3L1GCrtY+zXEOX9XTx6To/
	 7lQPOreev/BHzeY6QrnMzMPRCPQzjY69ojyTjo/emr0R5u++MH0zVuNir0TFILhDrw
	 Mw8OklqnoWTqyR46+7hCRrvgBiYY3kvvl6GpZ2iye4HSMf/B9lvhZgACbaLYrHVBuq
	 tivv/eL8IdfqLumRqK3EDdDJZ9AfLvWiW4J3vJvukBsoM7F9Cc9grVKHPXdYw6lXNJ
	 8iLo3D8233hyg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 776AF2E019C; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
        chengzhihao1@huawei.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v2 0/4] ext4: assorted fixes related to the buffered iomap conversion
Date: Thu, 19 Nov 2026 09:47:25 -0500
Message-ID: <179509948721.1938961.6124445990802957861.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
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


On Fri, 30 Oct 2026 10:13:34 +0800, Zhang Yi wrote:
> This series fixes some small issues introduced by the iomap
> conversion [1] as well as some pre-existing issues found by Sashiko. The
> first two patches were sent separately before [2]. Packaging them into
> this series to facilitate merging.
> 
> Patch 1/4: fixes a complaint from smatch, making ext4_iomap_writepages()
>            return 0 directly when it encounters an inode that doesn't go
>            through the buffered iomap path during leftover writeback,
>            instead of reusing the stale ret variable, even though it is
>            also 0. Not a functional problem, it just makes the code
>            clearer and silences the complaint.
> 
> [...]

Applied, thanks!

[1/4] ext4: return 0 instead of stale ret in ext4_iomap_writepages()
      commit: 943b2d083db0e1bbdcebaad144358b1416f02818
[2/4] ext4: fix extent status cache clearing when truncating inline data
      commit: af05a1e287c389f8dcecacbf93bc65875ad37ff4
[3/4] ext4: add inode to orphan list before extent conversion
      commit: 819809ac85ae334cc9996ee0b582b8883f36da9f
[4/4] ext4: initialize map->m_pblk in ext4_da_map_blocks()
      commit: 109c4b25e5e4494b7533f34dd335685bcaaf1dc9

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
