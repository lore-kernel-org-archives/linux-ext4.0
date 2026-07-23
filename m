Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA8B4D2EDD
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812170; cv=none; b=ln6qWJWoYhiFS7bW1Lh6n+7iNb78cRKyrshcQJwyt8aN1D48Mq5Nk82llgr0SsiXDLzYq8RYnYe1gIjDY1RKFXRm3wWSSnIQhJVgM1U4DOmplSH258XvGAbEUb2JnfZO+0xrEQE17Xg1gNCVC4iEDhoc5sErDnOOnxXygF+3rDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812170; c=relaxed/simple;
	bh=LfbGobofqeVht/L6UiQvSczZY4mvkXhYwFg/zp15p54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNwoFwXZKJKVhG1Ogb47DukX3YiXmVsjWK+RAUVQrCaRrVKrp6vAaq8L3F/aGI/rh5/wmqqAwhdaOvkNaghOEAE3yG0qpQT76dM2ibQbX/cZxWFi62vFdX9ms1KcVVkm3OmIs5JPMFiqv3j+dLSys+aez87nHPwxPmx+U9g7B2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=LBYf8Nd4; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="LBYf8Nd4"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND94tw017974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812147; bh=La38wqRcBdAqru4+Cs+6GKAawzucfalIXI0Kc/ImoWY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=LBYf8Nd4bi4EYp0c1th6D0GeDwx+ksvZJeEp5hD9r46hy3OzJ/eG5ZYo/MEDZqtma
	 6Ak0fAdAK24PzN2OVZFoni6E/C96O3p6ry8OPm7ei2HaUMRxgYetmAwhmYvMHCt3Qp
	 xD9tUm847qL/Rss+ywa/fvqv0dDSB72b2/aGNBSAeWwfdT+teoqy3aqBX5ezrX47KG
	 a1Ay0l5g+vR/QuA6v+n2WpI9Vp2OjomDSVkLxyGzBhPPOnKPKWYa+n1fSTeIwC21mI
	 uOdxJd3uhenjXebbsjjPAdSRFY2FyQRLmBsZXko4XwskUa/yhKz1w603njGG1RLqNw
	 xdDD47xAziVvg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id DDC662E3F24; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        Yun Zhou <yun.zhou@windriver.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Thu, 23 Jul 2026 09:08:52 -0400
Message-ID: <178481171720.796182.8518231772987734798.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623061903.2148767-1-yun.zhou@windriver.com>
References: <20260623061903.2148767-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 23 Jun 2026 14:19:02 +0800, Yun Zhou wrote:
> ext4_try_to_expand_extra_isize() is called from __ext4_mark_inode_dirty()
> while holding an active jbd2 handle.  During mount (!SB_ACTIVE), the
> expand path may move xattrs to external blocks and release ea_inodes via
> iput().  When !SB_ACTIVE, iput() calls write_inode_now() which acquires
> s_writepages_rwsem, creating a circular lock dependency:
> 
>   s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem
> 
> [...]

Applied, thanks!

[1/2] ext4: skip extra isize expansion during mount to prevent deadlock
      commit: 7461c60b9c6a839b13ad4c3490681a0cf5aa0637
[2/2] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
      commit: 2c0e4fb511f97467dafc91b6afb3414100289081

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
