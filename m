Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA55024677B
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774676033; cv=none; b=YzXCkvOaHcNpXSKXGHXpy3F42Kp+ibxx4OAkM3w4gVWwedm3ladyXETl5VWp7KiFBxj9a/7pnggZ/MZcPhP0aLZwpfdkQSfOkzHgJisQ/xK6kl5JsdWnvPuv7aOFCedbjJdGguA4qxV37vIcDG81W5Yf5fmdX4fuQYCorKy2a4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774676033; c=relaxed/simple;
	bh=yh0fZL713/Dd0hqDKW7ZK7kbsJCBT8weQNfjgOgyK24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dEfl6KPeZ754hQITpmjUsPq9B/dn7W0GlTIJli7UP0yarKLIVEQDiozWIbNMOlgGqEbgjbDbfLL2dHel/iUGos6GS+DorhCnVYWxF8SULYtsh21//B0+F3v53PONyil0SYdQI5NOHi9FMcmbq8HWom6rS44t5Fu5MJfJQLhQcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QViFeKU1; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QViFeKU1"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VFYL013522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675877; bh=ts/m/XgqdLNPqTOHyIeVmdKtIWw2GZwqVh4oqyghfek=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=QViFeKU1MUW5Mk+zmhRTsRb1nU2AR3OJcdTaodl5thZ2T1LuzEfG/nTi+/xKFkiUf
	 p2XU9YN+t4Eed3IlERrOeuV81485dw+9z+/KK93aCWLlSOxX0GAoolXbCtKkSzgtpC
	 go5BcNXGRlajXwQZ4Q9vziQUFq4Mtjyl3cLolAQmQp8eqfV3YFGz6TIwFKH6YPoF3L
	 97INtnrQR68E0loriCq3CfofAsPeyj0uaRQNeniYcd4gm339/oynxv/Nh9epIFv38z
	 CQWCvixt3Za/3IqG9JsfO02vaNDNQYcXkPHTU37F1jS7Ximrbrw7NjqEUT7XsEAiNQ
	 8onc5aa//EsoQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 064392E00DB; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca, jack@suse.cz,
        yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths
Date: Sat, 28 Mar 2026 01:31:08 -0400
Message-ID: <177467585140.1335526.13346985320993451466.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
References: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 23 Mar 2026 14:08:36 +0800, Baokun Li wrote:
> During code review, Joseph found that ext4_fc_replay_inode() calls
> ext4_get_fc_inode_loc() to get the inode location, which holds a
> reference to iloc.bh that must be released via brelse().
> 
> However, several error paths jump to the 'out' label without
> releasing iloc.bh:
> 
> [...]

Applied, thanks!

[1/1] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths
      commit: ec0a7500d8eace5b4f305fa0c594dd148f0e8d29

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
