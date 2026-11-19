Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099668;
	b=VHgutYCYYACJIaWiWJO/7JvfIC+lscrXzB5h1RAOZt2MD73Cq7QSwtA0SPGVyo5uS9gK
	 VKF+leCHTbRcqfJ9Jnh8sOcfboCbZLDqBRmCn/9rZY8U31jPA3twMFkdxauf2dt1sY1hB
	 8MolWnLBNQc4rrgqoHYJqPBDrggtjtW7ggxL2RiyBCkD0+67/KDxjjlVujwQcPcg2UO9Q
	 9fyCTxQvV4RtK29mCOUD1sXabbMRmyTwzUZj8TRU/52E4AHCXsj+/w2jvQg5eMTj0QvPX
	 EAWzpPQ6rW/dViGLmmGbpWoFKe75YldMx536UgkPD00pNtVq7GW8GT5xHQsRliovegA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099668;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=v3IfxHBh2/kV4rA3edyMxILQnbV3GYK4g2E3o7TgJzA=;
	b=jjQgZVeF55AJ5L183bLXKTGvjWlU+9Ae59GTr6xGWR5IlW9ZpaNIOvMerEV4EcS355KJ
	 iGnlBQy3zitzJ3KLb3I8ktgQLT8fm9mEqECdFJa1+OhfUJu29cM/lbusFzerhA06YotXL
	 Tjnv+bpG1LL9LWHRGcieaZCmifgZ7eHXjemPPRLhtTdJVAeUdlBAxn/aujCaN5VgYLkUo
	 wkcaE6LcK9UWXAoL+LnWh0Ad77OkqWLLSSclfiGRkp72yJafi6iTzRxyOOMVUjYeIZkmv
	 mOFD7CGphNPLdIPIKDhuZOsxRFPVRCkML+MdNZRPIjGgkpgleavCB1wcfaUMuHtq2oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Kep2VYdH;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A8606A337
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 299A8606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Kep2VYdH
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElcDC018000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=v3IfxHBh2/kV4rA3edyMxILQnbV3GYK4g2E3o7TgJzA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Kep2VYdHr3D36d/Hzv4UbRt3ELY2UAgm+DrWyxa4Rwu25fS2wcSGHS8mrd5dZvJ+9
	 Jjrbfk5TME3bg46Sa1tqW8Ihqn+S1J84eYgP86cVdxtvMxRnPNbq8dojik+RRB9Kqw
	 JYx4/tKHk3XeHDcF2uo4rAgJWh/2kg/n+KTB71xyLu9SOrqlk2WtyGtR+vnACCQn2o
	 TbMrH6q2cxzaGRp0sxog0SDScueyqho6WVStadNFHvo7rA/lBOFtOHNV4IMKeWIh+1
	 TNSu4ylmvTFCGUdJZQJPe4puC/kPL0eN7BpMVyctCCAdGwf/A8de7KZswa+x+aa9lO
	 3PkdekBkEDlcw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 01B8E2E015A; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        guolingxing <guolingxing@tju.edu.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix buffer_head leak in ext4_ind_map_blocks() error path
Date: Thu, 19 Nov 2026 09:46:51 -0500
Message-ID: <179509948699.1938961.2305275787703402146.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009062846.327298-1-guolingxing@tju.edu.cn>
References: <20261009062846.327298-1-guolingxing@tju.edu.cn>
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


On Fri, 09 Oct 2026 06:28:46 +0000, guolingxing wrote:
> When ext4_ind_map_blocks() is called with EXT4_GET_BLOCKS_CREATE on
> a non-extent mapped inode of a filesystem with the bigalloc feature
> enabled, it fails with -EFSCORRUPTED via 'goto out'.  However, at
> this point ext4_get_branch() has already acquired buffer_head
> references for the chain of indirect blocks, which are stored in
> the stack variable 'chain'.  Since 'goto out' skips the cleanup
> loop that releases these references, they are leaked permanently
> (each failed allocation can leak up to 3 buffer_heads, and repeated
> allocation attempts keep pinning the corresponding pages in memory).
> 
> [...]

Applied, thanks!

[1/1] ext4: fix buffer_head leak in ext4_ind_map_blocks() error path
      commit: 79dd565874b3fa2d5cbafb2c2cb00ba850e6d4a8

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
