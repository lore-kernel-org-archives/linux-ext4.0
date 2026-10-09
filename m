Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571932D2381
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536218; cv=none; b=CScyam0kY816BHFh+v7MaFueLXY4u7LhluL8va8S56+gGNdQgzYxoaZIDweUbDiZv/sCQHeJwDOwYrmIn0uQ5XARMg0zWh9xaAuzlQ0LitRuwZaPbNprxyY+nMPyov8DY9YuCwdMvqntkoIadMA4mZx48yq7R8csbg7Mr0C0umA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536218; c=relaxed/simple;
	bh=Ms/CQ3ixB0pNffEzzUJ74VvCXdrdh2fGFy46067Surg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5lwuG2gV3zJ5VLOYWJfu5I/Mpot8y0YhumEG4L29lce7lc0ECV3zMeX2WAbWl/EKymHxfC03WuKKjKJKryR3wGc+/Pql0TXBIRGEXW4/0t+R5QDEqXwoTTNh6a+Bj2wwVVVs+0iH3KGho2r7Nq2b8ZxJg5LqKtgFbc5aH9i88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HLqPQ+hC; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HLqPQ+hC"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uYbj014199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536196; bh=xRklIDo8Hta2NDezeHJ87YuMZsNjKQqf/rQHFjudGuc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=HLqPQ+hCZoygo511YsFcI8IwqTKUbA7kFK02HsvH3SN8Pxh4VV3JDSP5gy4J5iAyF
	 f+VhhgGT7YbVamLwasvqr/RHfilkwhoI5IG66gvVto6KUYdsyH488Y/v2oSPFOYxwX
	 qd/cnRdnvkJDtMGNgbwTrCbRrJ5wjQX56CUdCUCvpXJM73/btDJBG40Uqse9WaRJke
	 cKr1Zhiz4JNLYH8Pr78Z6xT/IcFe1RDR02tjUPVuD673L+KU8c+bOLfqerRnPHuYcH
	 MJd4+cDOfO2go07j9kC4YI8tqGhU1f5K14KvBzbX7mlkfs6zByQqIiAj3881O8VT43
	 7GYLOoZF6cbCw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 656C92E0149; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hsiu-Hsien Lee <swinds24@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca, jack@suse.cz,
        libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com,
        harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix fast commit replay failing on a read-only mount
Date: Fri,  9 Oct 2026 04:56:24 -0400
Message-ID: <179153611737.860602.4325770212287839646.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260812044353.1018268-1-swinds24@gmail.com>
References: <20260812044353.1018268-1-swinds24@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 12 Aug 2026 12:43:53 +0800, Hsiu-Hsien Lee wrote:
> A filesystem with fast_commit that needs recovery cannot be mounted
> read-only:
> 
>   EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
>   EXT4-fs (dm-0): write access will be enabled during recovery
>   WARNING: CPU: 22 PID: 5544 at fs/ext4/ext4_jbd2.c:73
>    ext4_journal_check_start
>    __ext4_journal_start_sb
>    __ext4_unlink
>    ext4_fc_replay
>    do_one_pass
>    jbd2_journal_recover
>    jbd2_journal_load
>    __ext4_fill_super
>   JBD2: journal recovery failed
>   EXT4-fs (dm-0): error loading journal
> 
> [...]

Applied, thanks!

[1/1] ext4: fix fast commit replay failing on a read-only mount
      commit: e1a881ea4674876721cab97680d1d8308f90e9a4

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
