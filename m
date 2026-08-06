Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24CE471CF6
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028536; cv=none; b=MWwvr6lAVnhT6C/upgqr9Zo02cTy+y/e3fE1nfBw/X9Yed01Zd0pMH9lLyAP3vMUlWnV0lDqTySVsXOtW05/CNEzIQQF3sYeEO+fiWee8tMK9nqut5xHqLnM1WF5DKVVX+aGqJIUsSuNa7C1IRfPLmAQbE4K/RTOtOUgTXwnAXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028536; c=relaxed/simple;
	bh=8a0i6zzX4RW3yEqgPoZjG3Y29Src0CVEEsCFzITAmw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pa4/9d5KnYjYoSFuNEsYfgcRGmVZacrz9svMmsiqDtc7kFLY0c0ufD9ILbAsItET+uyb7rD2HPrto2xFfGTSBj/64qGmHypECMkhTXkWUgxbJnZFX2XwceZQaQVtxgiV+5qW/AuEFDlBazsjA/Tdq6ior88J6yYydQnFm0heDxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=nLusXsBo; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="nLusXsBo"
Received: from trampoline.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676F18lS011332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 11:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786028471; bh=xI/3XBRHzNV1HKH1aWzcP+7ZombObMaSf6W4f0dBs2k=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=nLusXsBoq1bnSlCYw4PuE7gmEggLEeQZ2AkDbI/KYDN3NWHZevdX0XWB9FkbuCTku
	 FxVO8BKAi4JaD24Iav6CccREW8b3Ue2U6dB8DekOjlqGTNMmn1KqUK7t+1gxqBnsdd
	 omyJgILRfAoQwsNp+iCQD2u9ZtY3dX8Gr5ojBYWb/9Fa3RC6RXd3nNFwhv0iVb4Tzm
	 VVOi3zxT266IlE1LB9HAM/pnwQ1L1nABWsgxEtorGTf0TQ1kxrcsyHsX0N6r+BISat
	 ELNDooG8nlnhoP8OIlVzg6bVprgCP2VpGb3ElDpKL5F8jiCvWImLdB9b5zbzk8HFUS
	 CLx4iRfeXvmTA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 191B52E3F19; Thu, 06 Aug 2026 11:01:06 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
        chengzhihao1@huawei.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH 0/2] ext4: ensure WRITE_ZEROES is power-failure-safe.
Date: Thu,  6 Aug 2026 11:01:01 -0400
Message-ID: <178602814510.965683.9213425035068203757.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 29 Jul 2026 16:59:16 +0800, Zhang Yi wrote:
> This series is extracted from the last patch of my previous series
> "ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES"[1]. It
> fixes the issue where FALLOC_FL_WRITE_ZEROES could leave written extents
> beyond EOF after a power failure (reported by Jan). This series fixes
> the on-disk orphan list corruption and filesystem corruption that could
> occur during partial extent conversion in
> ext4_convert_unwritten_extents() as reported by sashiko in the previous
> version.
> 
> [...]

Applied, thanks!

[1/2] ext4: export converted block count from ext4_convert_unwritten_extents()
      commit: 5b3dcb924a38ecd2c0d828ff30c357357eda1da8
[2/2] ext4: protect WRITE_ZEROES written extents with orphan list
      commit: f7237a775c8f3e99e0e77b7c10fb626815fb2877

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
