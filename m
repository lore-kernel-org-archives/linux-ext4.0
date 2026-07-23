Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08913471CFC
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812183; cv=none; b=Gxc4467eHOobsMGgEZS+WVNqs1bRJ8Q4JyO/Pk8YNvw4P4cY4FDYoazBm/3j6bHkHfMtjU1rRa6tlKtkWOv67GOCrXeT/Kq5i8siSTC3J+Nf3c/VmFzkq0mfiW2K7rMR42pDZUG1cD+OaYVP0gzAc0oV9tf+9NcOshb1W9ig9dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812183; c=relaxed/simple;
	bh=O1UmXZiL/ScmTp3WpiZYoLcHctMPIbJPASzpVLsOKwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uoUmt9ykUqUxQtVMbXE/AgcBzc/7zhCeyBFy9RpY7Gxz7m+w7FKHbaNZ0UQlIh36zKsqR9arpIMJPJ5IYn50Oudl1cgZgnSQx+0pP7yOACctOX4V3Udf8+DQSK/Ynk+iqpNmlKMK9PVNFkQF3LlkJk2zlOPBHrFiqdbUi84w3+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=mqRgpxfh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="mqRgpxfh"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND92Dt017887
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812146; bh=xDJjENyp2qOkdLCeyq3BY6U+bl43kFOoqEZkVsMTGsE=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=mqRgpxfh1ZUaQKtxtR9R/1XP5e5UWJ0a6U6Zbas6npXr9sATz3Oc2egG44krym80V
	 P/Ut9g44biB6bfFXZurChfELIXW87EVseaMwGr9XKVk7FsPIo6/qGiu5Z/r4Y2svn/
	 0P1Nh4YNiQzbryalJCBFfyY7woQEgrX2r/j9iYizfstR6kkk9OduJ+fEg9vHJukRBS
	 ff8xfy4aoB+aVvJSCo4inlMbUzym0HAddIx8eg8YGbKsxc50cqnvi5iemZ5bnY8R+/
	 cvJgbfNQzVnSWY1u+l4+MidO+76tOG6Y87lQ58uHxKUVtHePhPn4yFX+laTwxww1nx
	 i0VHzWPUnKatQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id B4A9E2E3F18; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Bohdan Trach <bohdan.trach@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, mchehab+huawei@kernel.org,
        bohdan.trach@huawei.com, lilith.oberhauser@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] ext4: optimize ext4_mb_prefetch
Date: Thu, 23 Jul 2026 09:08:40 -0400
Message-ID: <178481171726.796182.13440367167961292450.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260615100331.163997-1-bohdan.trach@huaweicloud.com>
References: <20260615100331.163997-1-bohdan.trach@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 15 Jun 2026 12:03:27 +0200, Bohdan Trach wrote:
> v3:
>   Rebase to latest ext4/dev.
>   Added R-b by Jan Kara for patch 1/2.
> v2:
>   Fix issues found by Jan Kara, added R-b for patch 2/2.
>   Extend commit message of patch 1/2 a bit.
> v1:
> https://lore.kernel.org/linux-ext4/20260521125931.16474-1-bohdan.trach@huaweicloud.com/
> 
> [...]

Applied, thanks!

[1/2] ext4: avoid RWM atomic in EXT4_MB_GRP_TEST_AND_SET_READ
      commit: 0e364a030229b3b06b858dbe4b7412d87d9d86ce
[2/2] ext4: get ext4_group_desc in ext4_mb_prefetch only when necessary
      commit: a6a1e7e569dcbf3269b731c05189dbc64532e137

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
