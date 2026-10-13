Received: from out28-1.mail.aliyun.com (out28-1.mail.aliyun.com [115.124.28.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0314237E5F2;
	Tue, 13 Oct 2026 02:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856917; cv=none; b=TQKjNMu2Vhn3c/cSMshahfOdf1o+J9n43CLcu3xewsr5ifhTa6LW35Rf0Qjo+khycFsEqwm4ezp7DzDqUR1j3JTFhDO3d1P3qNG7qn0n+HaVw7JAgC5uXh75gt6IIOlVKaS701q+xluj6JNsuBRX9x+6BL3Y1bCnSPJBzijsO8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856917; c=relaxed/simple;
	bh=El1gm2QXCyk6BMtLE7OLMwLSYkCGgr0Dww7mE2ml/cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0HjHOudURCI/10PRNWND7bjKDvg1KBAwSxb69jBygLHzLer+bIbhcTDBMCfNjQ24i1OnySHz5ayGsVrr+oICZPdot20qZHDm9zpBIUd7EQ3FksvkqQhiXs2cm64zBt2O2Cg9u8SDJ+A0hh4n8M3VZI4b4jyPIB7sNZJVVIQsLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=Nb09rNav; arc=none smtp.client-ip=115.124.28.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="Nb09rNav"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791856906; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jw4QLSY1JGurDTMfKM4O66yjInxgdzpGy3tXigO4+7Y=;
	b=Nb09rNavA/2+3+A7Iqpa62CG2h+UeRim3erNJL3vB2NTHQa/2TnxZmxyukEYWyv8JJm9BS33NfGfNg3YeciOW6P0SUdrxma6jecLH4M/lWEMtR6w1Pv3CFkhgWaCKVOowvZ5kd7Y/Exqg733+vWYbyHVOa7i5gMEXjM77wPj98s=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1738694|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00315073-0.00053508-0.996314;FP=5093895818369959676|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037022039;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.jajBP1r_1791856905;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jajBP1r_1791856905 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 10:01:45 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guozh23@xiaopeng.com
Subject: Re: [PATCH] ext4: check CAP_SYS_ADMIN in ext4_ioctl_get_tune_sb()
Date: Tue, 13 Oct 2026 10:01:45 +0800
Message-ID: <20261013020145.1297074-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012060844.836001-1-zhugl3@xiaopeng.com>
References: <20261012060844.836001-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I checked the original series (20250916-tune2fs-v2): neither the
commit message of 04a91570ac67 nor the discussion around it says
anything about a permission policy for the GET side - the only
statement is that the ioctls allow parameters to be changed while
the file system is mounted, without needing write access to the
block device.

You are probably right that reading these parameters is not
sensitive on its own: most of them are already visible through
/proc/mounts or statfs(), and the superblock is readable by anyone
with read access to the block device.  The argument of my patch was
the asymmetry with the SET side rather than an actual leak.

I'm happy to drop this patch if Ted confirms that the missing check
was deliberate.
