Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CDC471CFC
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812168; cv=none; b=Y720qo77rsLsUxjLaxaZgstlU8exD+JZE8jaOfaPypOKwp5qaFa0p/TTKkTCqVDkwN8tvR+lxz2xqEc0Sy/sdT2xTvNrkObDOHDl0wc9HM8xRz0K4PixsqdSKCLZhbZkU4XmwjgpJDukC2LT0HInWtnP0w/uXb9nlgKir2ue24E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812168; c=relaxed/simple;
	bh=L/6+1lMp5RgsxqhOzqfapjPSowi//+VGs20/UB8mtxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Os7eTethv4jnhKixRUWsarynywf61DbplsKF66XFm4R/2FszD0C3StxfxPetAbCnfqFvQ8AYZXCpp16knDrI/5xTzS5E6cC8KmsqxzfYI4k6m6hXfDtDyNKRaisfBzhzsWiyeBVxkRKftCt2Du36Mci8Ww1518qtT1L1ODRYUMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Qu3MVlDr; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Qu3MVlDr"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND8xKr017841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812142; bh=e6aYxnvY+Sfky7o7KmA7wz0UR1f1nN57ikU5nZKY/qc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Qu3MVlDr1Hdv1Ti1RZTCDeaKBEH08w3EJw7u/wA37tz2HQPMsL61AQ62ePnMiJHsi
	 Sa3qdLtfxbVXtVJPR5pqzQh0iKMIaZ3bPkGS/NDABEJHNj1rv6zvxqxr0Ol4UrylLD
	 LAALJ1qDgRhvG05DNK7XQK/IqkBNZf6V5zzWBzR8jfvPpaiSaXNoQfMy/8FYPjgWPn
	 M5TrUBAea9aEqn7pDk0B92TEvSU7XbBEOOdGf1sFAll3gH/Ozawd7ApfuIMZmTMg2O
	 HNKcNRvYtAdF5ciJaw55uwnJtvb+XyRAK3kZhWy69IfQXIPQrYa9TY/g1ftOcfw6bv
	 B3/IqZSXsVlmg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id A9E5C2E3F15; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Guanghui Yang <3497809730@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix buffer_head leak in ext4_init_orphan_info
Date: Thu, 23 Jul 2026 09:08:37 -0400
Message-ID: <178481171748.796182.16133332077893825293.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_B38798612A159E21450ECF959016371B0807@qq.com>
References: <tencent_B38798612A159E21450ECF959016371B0807@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 09 Jul 2026 14:41:51 +0000, Guanghui Yang wrote:
> ext4_init_orphan_info() reads orphan file blocks with ext4_bread()
> and stores the returned buffer_head in oi->of_binfo[i].ob_bh.
> 
> If ext4_bread() succeeds but the orphan block magic or checksum
> validation fails, the function jumps to out_free. However, the old
> out_free loop starts releasing buffers from i - 1, so the current
> buffer_head at index i is skipped.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix buffer_head leak in ext4_init_orphan_info
      commit: 05704335803b69c1bfa8637b7ada942bf2ee8a41

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
