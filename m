Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9452D8795
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779979182; cv=none; b=A+TzK8+s3+UnnI+z3Nw8Ys6fgMAIboje73RvAW39LXaOG2maTpOkX8ZnY53gdJevlN88xY3+r4LpPgA2ur1x+QKqAeYgDO/qPVLLKeqjJ8A7V1/60Zk5qUmQF/tj4c8tZOhKj1YALZsnuO3eNURHoqJloZJept6e2xQ9+dJztQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779979182; c=relaxed/simple;
	bh=qphTy97Jz2axouSfDB+6LflVo+XiMp9MzMare124RyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNmZB2exlmeKaw/iyGC6obt475zR1UKlrpiOeVa+WHa5nl0b3p8ABTCjnPIakTS8T2hNJzIfkKLh8m7jRhTmgYkTGU2Oywf+x0agXQ/RP6s1zpe2QEsZVpe/VRwLy9YTGTo3edE9OCtVto9xCjhTl3Ff1dXL+gr+R+zzDwngAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=TUbbi6DR; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="TUbbi6DR"
Received: from trampoline.thunk.org (pool-173-48-119-150.bstnma.fios.verizon.net [173.48.119.150])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64SEcghM004828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779979129; bh=5CfOfbwetcTsuxPhpSc86mkv5WifwcAD1b3JTAtYiLM=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=TUbbi6DRNmzVlbRdYiWIuht75b+C9oZIXWn1FUvKBLsl4hJmPqdLdxp8e134hON/c
	 fPowrrMqEusH1B4BLcGtriYe3gPPEJY0czaDcBVPpgGQ40N3mfuW4Ldho/nbd5L1QQ
	 +BEzCE4ERbnxV8Jcdhs/WlbILTw+GOYPdmjnC7AZzIgaNNF8ssgmu0DkEEAancgl44
	 RPaDoaptXp84l1zdFVu9W4SCtf85c0psJlp7GkhqymDdAt9oHKJMyowiQvBvHeN9q/
	 IZHYiOACWWM2UyEbQCs/FZZ6/Edkxv2pp3IelpeTgauyXiumZHvzreDgI4qieHjFVK
	 C1o2bSKVcSrPg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 929672E00CF; Thu, 28 May 2026 10:38:42 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, edward062254@gmail.com,
        visitorckw@gmail.com, david.laight.linux@gmail.com
Subject: Re: [PATCH v3 0/2] ext4: add hash Kunit tests and optimize str2hashbuf
Date: Thu, 28 May 2026 10:38:38 -0400
Message-ID: <177997910348.258983.12600861367754963001.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413065114.730231-1-409411716@gms.tku.edu.tw>
References: <20260413065114.730231-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 13 Apr 2026 14:51:12 +0800, Guan-Chun Wu wrote:
> This series adds Kunit tests for fs/ext4/hash.c and refactors
> the str2hashbuf_{signed,unsigned}() helpers.
> 
> Patch 1 adds test coverage for ext4fs_dirhash(), including the main
> hash variants and relevant edge cases.
> 
> Patch 2 simplifies the str2hashbuf helper implementation by processing
> input in 4-byte chunks and removing function-pointer dispatch. This also
> reduces overhead and shows roughly 2x improvement on longer inputs in
> local testing.
> 
> [...]

Applied, thanks!

[1/2] ext4: add Kunit coverage for directory hash computation
      commit: a4841d91a7f57d38d3a63c18b4ce68ee5e06829b
[2/2] ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers
      commit: d8c73397cc49362a88a57b67c11eff6e65b525e8

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
