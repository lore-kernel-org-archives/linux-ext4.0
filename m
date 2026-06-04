Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50969212566
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2026 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584411; cv=none; b=QsXZPb6dJoK3TCryJE3MTVpCta68FD6NMK4IrxkdgB3Jk309dw5fxqweshgAPKELAjZ+jJKZJH5yyhB3GjbaMALTLLN8j/H2oiOFQdOw344W9MJaS98dzTxWuyN0C6CCG0uSI8+klavdFpCMySvmWY08cXQun1z++hGR3S9NPX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584411; c=relaxed/simple;
	bh=tP5JKnhBF39Wb5k7qSsh8k4mZKvFxHvxQEwwTvvNT+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pgye8TGpbHH2lEwSyCj/y7o1jUqpacUSgfOiXzJT+Yzjiae0lvJpZI84NbclE5L6D/sAkaZH7r1FMV87KoJl7PkqDzJyhLKkjgYvurRQmEFbTTMgrkkw36Dsm3YU5cGfDU8VSj7PCoJCJrdCKBPlMAX/f7RFVKC4QzIuqScgCPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XjGi4Khf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XjGi4Khf"
Received: from trampoline.thunk.org (pool-173-48-113-247.bstnma.fios.verizon.net [173.48.113.247])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 654Ejx0q012420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 4 Jun 2026 10:46:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780584363; bh=j5wM2952woz1uz28Bltb9K9N8B/fTEeBFbj3QHbSzZs=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=XjGi4KhfXWDudYg6hBc/4kseCQKihzgjT4kcmUk5y7erZyfU6DywMiCEvT2g4+9JG
	 cg2nPgTuTsTrDaEk33QPt+qTvQuELotzhafIfGOIQzVSu/10j4i51d4dE84Sw/frQT
	 LEB0ht4FuvT4O7QhuyqdySkfDtvBGX9BYlj5/n+pwcPC0tkAYfnqqqvVaK8WzlX6O0
	 YHUK9S3zecSj/62wIb8jpEyG3eV2QMGulIk7K8tvb4Ysmjvrnrurc1zJK6y60ZbTQW
	 S/Iz2dZ6AqeRdkRCmUp+4DUCy9nIJlGWIs2vTiBo5H6gd94JzTY41bSAdlmynVvMP6
	 PXboeF4kzRuzQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 765572E00D5; Thu, 04 Jun 2026 10:45:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
        yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH] ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback
Date: Thu,  4 Jun 2026 10:45:53 -0400
Message-ID: <178058433997.388727.14058923901564780428.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
References: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 24 Apr 2026 18:42:01 +0800, Zhang Yi wrote:
> In EXT4_GOING_FLAGS_LOGFLUSH mode, the EXT4_FLAGS_SHUTDOWN flag was set
> before calling ext4_force_commit().  This caused ordered-mode data
> writeback (triggered by journal commit) to fail with -EIO, since
> ext4_do_writepages() checks for the shutdown flag.  The journal would
> then be aborted prematurely before the commit could succeed.
> 
> Fix this by calling ext4_force_commit() first, then setting the
> shutdown flag, so that pending data can be written back correctly.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback
      commit: d99748ef1695ce17eaf51c64b7a06952fa7cddab

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
