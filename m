Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FCA413788
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812295; cv=none; b=nFtQp2OdOGV1lg8wOsWU0X2XBO3/Ct5wB42UgKKF6Cc+xFVhe3wfTcIqmDvlfWIsvuJz2fcg+07TuHLDaHJ65cFJQaNM6kks5EazjYYb8TBo+VGe0b19PXKSt0o7GZZT+t1ByrXJz1DHcYS+Bw4h4VzXk5gihJYYJhb0EXSBTEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812295; c=relaxed/simple;
	bh=BSnZw3+VJKwqs2mtRl/vHjCm9IjvAMnTDuZ+y0gxTrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NY0UDwETigZFwXd3GAwW2knYXMjle+bNbODJA6pLPvp8IpXqPmjJo7IfhsDZVuK8sw1+IJylzNePhibJIKUcjQpmDRQyhosP5hPsC8550Zd5h54Sv1xxfp9iQp4RuGsNtBLGNy7Sd/mVa/9KvLdIsrjN3DFklY5qQuV2lbnh8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=VouYAWs7; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="VouYAWs7"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND8xdB017848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812142; bh=n5zSJ0yEYVg0hiVCN/XwbWR1BEEwVACtcZ9JFWlf9X4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=VouYAWs7NNYoFgjRW/9L/zpus9dlm6eRdyNhRG0wv/LIHlEYw5BxnKQ8WrSLcIKbZ
	 PY5MwadDfI/1mr24cVQ71EVVbv5V8HSvCDiWhbuHpMTFKMHbBoCtn1VhVSCLb77gPO
	 lZJ7Ir8pNRH0DCGDnRKUnJgv8W7xTIK2N8E/kL0YeFsACE3KSVzQmLmbNbuwEFqx8M
	 IRYLyvOceghdWLByd+CkdgxiWLTGsocJ4n0rB2HnDNtuN8Qafar8Wt82rXEPuS9l2j
	 qJcPBgPngobuCRyBxC1vsjhpLLtJYSDcb8vBHwB/ZNhD1E6P9mhZICyhOGRbCdBn99
	 ZNLhAlj14+g0g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id A400D2E3F0F; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Guanghui Yang <3497809730@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: clear error before retrying inode xattr space fallback
Date: Thu, 23 Jul 2026 09:08:35 -0400
Message-ID: <178481171747.796182.11985644104721391723.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_192F8A699EFD21126E02101131C9546F3C08@qq.com>
References: <tencent_192F8A699EFD21126E02101131C9546F3C08@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 08 Jul 2026 12:57:19 +0000, Guanghui Yang wrote:
> When ext4_xattr_make_inode_space() returns -ENOSPC,
> ext4_expand_extra_isize_ea() can retry the expansion with
> s_min_extra_isize.  If that retry succeeds by finding enough ibody free
> space, control jumps directly to the shift label.
> 
> The previous -ENOSPC is still stored in error in that path, so the
> function can update i_extra_isize but still return -ENOSPC to the
> caller.  Clear error before retrying so a successful fallback expansion
> returns success.
> 
> [...]

Applied, thanks!

[1/1] ext4: clear error before retrying inode xattr space fallback
      commit: 409a7f12a0933ff2c617fa814c76cef0bd1d457a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
