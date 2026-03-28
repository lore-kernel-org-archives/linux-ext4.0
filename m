Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470E820C029
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774676017; cv=none; b=a41ErUezPZikepg9j+pfY/qi8RPwmfhKROv9iHcWbE5shkkHp8v9woE2ERPtnDNFAMpxLtDGeXgMj4Oi6L6Yq5tt7oY6DVxsJmht4MsS1xq3RPNKkoJPQNAYVrSy0uAFBXGrh+oqrgGEJ4e+uJ7CN+vP/q/Qi6QerNK7WxhCQTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774676017; c=relaxed/simple;
	bh=RBnV7BAOV4T+n3ENHKVNHQeS+r6RY8TS8I/gP+3s5Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qgj3n9ltMWKnwSOzBtjU7ruAhUIrlRYijXy2nHIpl4t0HL38sytbkuVYw12bsltpfLqpI4AkTujD6/9zQr4JO8ZaiNObQAOOd4MS3/D0Y1g3nqOv4D1+hJaHz3mg6wdX1uPkeKK4/FtSb9pYcVrzB4u0miFw1VhGrBJNVCuN8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=pMdOvNaY; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="pMdOvNaY"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VI2A013577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675880; bh=JmNqoI0x19J4kWmGQt2+7MwvFXMsUrShyeOVaCpE7SY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=pMdOvNaYCpbZWeHzHZJoAbFXUHxe18wt+m/y8TpwBcFT4qCu67g1Dw4dWtkPV+7sp
	 a6XYdA8Et30pHT+8SxWdrZN7BWzxaEsa+ZcDjBg+jN5lmeCAZwKO+mmp2NHPC54Di8
	 Hv09lKOl4ByNe1lTxL7jOxW7ZilmaAd18IfOS15Vr5RZZ/+VqOrq59q1ESDhbHS0pg
	 OhaKaSSzfnKtZO3EBPxW0qBn8Lr9KNlZm/xIJZQ4rM5OboKDKfkmkB8TwKmO/8AMUo
	 vr1BSmUSCrCataxr1ybPcQcVLjmovDOPaGxpodLNLhJv0Hg1dqZOnDNxqkKx15vwmB
	 uVFW/T+ny5BGA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 10DCE2E00DF; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        Ye Bin <yebin@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz
Subject: Re: [PATCH v2 0/3] decoupling the ext4 test module
Date: Sat, 28 Mar 2026 01:31:12 -0400
Message-ID: <177467585127.1335526.1760800007321515439.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260314075258.1317579-1-yebin@huaweicloud.com>
References: <20260314075258.1317579-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sat, 14 Mar 2026 15:52:55 +0800, Ye Bin wrote:
> This patchset is split out from the "Fix some issues about ext4-test"
> patchset. It decouples mballoc-test.c and extents-test.c from the
> ext4 module, resolving the issue where these two tests could not be run
> when EXT4_KUNIT_TESTS is set to M.
> 
> Ye Bin (3):
>   ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
>   ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
>   ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
> 
> [...]

Applied, thanks!

[1/3] ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
      commit: 49504a512587147dd6da3b4b08832ccc157b97dc
[2/3] ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
      commit: 519b76ac0b31d86b45784735d4ef964e8efdc56b
[3/3] ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
      commit: 9e1b14320b154094bb2c1bee6d8c6cb851fc3215

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
