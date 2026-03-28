Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FEF33B6E4
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675907; cv=none; b=Cacf6tRks2kwEYUNeOJGd4wBLpq2bPj7ESuw7qSTsrm4O6oJnErRv4npt8466pqTkCilgRli2CwaChCILUj1NITIZr8+jthwv/10jiyP25rRyCFwE4P8dMCy29Y0V0GcwPhm2wkRmq7SRd7/UBK/fPCrSFshwmGINkWVga7ltrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675907; c=relaxed/simple;
	bh=ewICTHiEIwrSeYAmEnm3Pi21+pZJHsrZEjCKM+9GZcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRih4TO4ORW5D62taq9b5K/TyUUv/3sHwIf1OBDkSvGgb81gcRaH6bYVoWd6XJ8n/Ymh7dFPMBOgDEAjAwb7jONJACftkLCGlXsbjK+PbV/yKLRQjk4+aeRszZbQ2p7poUHH3n5PLI/6eONHrHTMjcLgv/3sTfvJdlZcaa4FteU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Me267F0s; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Me267F0s"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VFrb013521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675878; bh=BVQzkForPgKwHLYPFphAmdp3sJj5DGznN6ablZKoPrk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Me267F0smxinBHIrHCT8Dp6aP6oOtmzEMUh1jpwM+rm4Ak9RcRU+xOEQSlruwZvNy
	 Zymf/BJOFnDCkxGg8Di1MWB86tp9kDHWcWLQZuSCAOr497gBDQvh2DcxvnSOUtmaJQ
	 u+VMH1MQ+7wK2fxyU08z3OXHVM6bny/wLv9HA4CuyXi/XWek7jPH/8NXj5z0CJm5Uk
	 +cZplhjtpWAS4XB6m1kHv33TJ+JXRLiORRAmnuKqSAPRC6RQo4zEVFcggVY3jNMP3T
	 amyUnnVHDU6+k05M0dO2QiHpRWY7A/b4hk3+1FfSihClQOdkzFN6P+9SLNWXhp9Hok
	 MsQMq3ufC+28A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 00B602E00D9; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, jack@suse.cz,
        Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jiayuan Chen <jiayuan.chen@shopee.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>, Ye Bin <yebin10@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: fix use-after-free in update_super_work when racing with umount
Date: Sat, 28 Mar 2026 01:31:06 -0400
Message-ID: <177467585137.1335526.9377463426356906310.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260319120336.157873-1-jiayuan.chen@linux.dev>
References: <20260319120336.157873-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 19 Mar 2026 20:03:35 +0800, Jiayuan Chen wrote:
> Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount
> filesystem") moved ext4_unregister_sysfs() before flushing s_sb_upd_work
> to prevent new error work from being queued via /proc/fs/ext4/xx/mb_groups
> reads during unmount. However, this introduced a use-after-free because
> update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
> accesses the kobject's kernfs_node after it has been freed by kobject_del()
> in ext4_unregister_sysfs():
> 
> [...]

Applied, thanks!

[1/1] ext4: fix use-after-free in update_super_work when racing with umount
      commit: d15e4b0a418537aafa56b2cb80d44add83e83697

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
