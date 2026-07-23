Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928F24EA380
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812178; cv=none; b=l+ifj9O5SHu82XFbko8JCM2Rp6Q5A/33Uom2P++1+29eLr7vgP4AD7rWmtSJJLAtZ1AmsLj+IjuQcasYyCM82nQAq64SckvqwiQlbXQMG2CbJi4RQijf65zlpr6Mw0P0owx//asYdoEmicUyHySEZKc70QYtC4GXf5yHC4W9Ue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812178; c=relaxed/simple;
	bh=Ffp+82a+kPVANVSfE4UoPLzS57UGE/MJDj2zzx+4H4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mbtDdn9CoexynsIiFBYCUl5F/N6NMozgPiZMac4oJKnb0+W0mnwB5sAQO5mq+aWilveHlOYez9XKlZbylUmra7cCqlUjqITU6UBvyh+8TQZg3r+IDW9/Ud5nwpD19Emzw+T5IbfSv2OLAz97b/mXIxT3UtBEYQrX8QeigJdDKvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Co0ksC24; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Co0ksC24"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND948H017973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812147; bh=SoxFe76Q5Ck7OJ+6Zars+9LwhXxMDX97oGV3QnGVKQs=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Co0ksC24/RAK+zSQpV6N74dQw+ZNqVj625eugryiaz+EeYYSY0f5/vlX3MGqyIJZs
	 tNH5MOKL0wNtmqxjCsnjqXWqXBEJ+SpJxnG/6Tmw8+r9LZSQhXBepPqT7gRTdJBU6R
	 Co2nIVIhJyJOnxt+WQno1/+sOgvbge8XcEdqv0dsFILaIr5qLxumKebfbGeZq3pcwk
	 H95KSEGkgXh//uu0zuSNTKVzLVp5vzpbQ7zy7OV1DTQddZRitmHAozk3p54v0BYjdL
	 E3eXnITEvyqse9af82Np//r5FCImeA/Ulq90kWx89Y3EUjdPKczIs2/1nj7afK00kw
	 xvIapS+vKo0MQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E14D42E3F25; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        Yun Zhou <yun.zhou@windriver.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v14 0/4] ext4: deferred iput framework for EA inodes
Date: Thu, 23 Jul 2026 09:08:53 -0400
Message-ID: <178481171721.796182.16168303721890374305.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710030851.2791589-1-yun.zhou@windriver.com>
References: <20260710030851.2791589-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 10 Jul 2026 11:08:47 +0800, Yun Zhou wrote:
> This series introduces a deferred-iput framework for EA inodes to
> eliminate a class of lock ordering issues in ext4 xattr code.
> 
> The problem: iput() on EA inodes while holding xattr_sem or a jbd2
> handle can trigger eviction, which may acquire those same locks or
> s_writepages_rwsem, creating circular dependencies.  The immediate
> deadlock (during mount-time orphan cleanup) is fixed by two separate
> patches already reviewed and posted:
> 
> [...]

Applied, thanks!

[1/4] fs: add iput_if_not_last() helper
      commit: 2a4c637d6fab83b689aea834d8e725189a2ef370
[2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
      commit: 4f48af3dc75545f6c874e7d195aeff009c7453ba
[3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
      commit: a54778243e88f2a941e145e5afa43bd1619c0a66
[4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
      commit: 3a00c9bc8ea5b816eac165550a4676a3bcde7f2d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
