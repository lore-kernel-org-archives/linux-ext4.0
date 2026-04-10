Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBC03DEFE9
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834347; cv=none; b=nOQKgw1+D0bRHcyQSLuCOi0b9WJs5A63sHGY5KUnxBbTTwXV0kxngD++EEayis9kYHHaxQRftWKPVmh3NAJErUc6a89FWrc5D5NQnPpdPt6mPuMzvsGaHrfodUmpEoo8VKidK19sqUf5IDIMVHu19+gDAxveDhy0G8Fh4zPNb48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834347; c=relaxed/simple;
	bh=sf8nEjOvatD4lqUHkwUyKBU94mi+rQnQ7mg42Ae0zW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSHxFHCEHPaXd8rkzT2SSTP7+ET0UppnLFxVV2n5wqBa8wd0NWIuLd5/R1Yuom2d5kIwQhWojpzKmJqZ3+T4F/vch8MyRvYgj2tAqaxV1eFWqUQ6xuL4eC3l7w/23/fYMmGf9DjyvBnFgZw2v1WSgzbQf7pu9sZaBrDpl5BuSdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=U65VVo3n; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="U65VVo3n"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIp8Z015864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834332; bh=w6e2ugiVfiSXXSltmPYM2JTyr0DbMXWjcFGfztS8iTA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=U65VVo3nghp53jKFemlQbBeuL7JtHRKR9Y7TCot+HO2NugPnvmZ8qzcBS+a+SVptA
	 laSjwfrda7Dh0qKHzSeCBhTT8w4czXJQXdkytuhArxJV58BrfHZvw41jKOCp+KL1sQ
	 YoiutQeRlUjEMbujCA/2JH8KEaSZkb4l0S99pUyYToAo22NjGZlhGzShU3oQ8yoATP
	 J6osI+ALK8vgZPwXT7p6oQwS/IU+aypIhamxNNBx6Dco5zFzHsn3Ow4Z/MJX4j/ho6
	 3BkXwTP3t5mdl97KQmaadineMVsaUtDtyK7T5JwV5sWvls25g3nkRats6WpLNgfWi+
	 oKxQZAZ2sT1Nw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 138692E00E3; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        Ye Bin <yebin@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz
Subject: Re: [PATCH v5 0/5] Fix some issues about ext4-test
Date: Fri, 10 Apr 2026 11:18:42 -0400
Message-ID: <177583430879.2758959.12008342906533107308.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330133035.287842-1-yebin@huaweicloud.com>
References: <20260330133035.287842-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 30 Mar 2026 21:30:30 +0800, Ye Bin wrote:
> This patch series is based on:
> [1]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/
> 
> Diff v5 vs v4:
> 1. Patch[3]
> Move ext4_es_register_shrinker() before setting up the mock inode.
> 
> [...]

Applied, thanks!

[1/5] ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
      commit: 5941a072d48841255005e3a5b5a620692d81d1a7
[2/5] ext4: call deactivate_super() in extents_kunit_exit()
      commit: f9c1f7647ac8fb70bebb1615ac112d1568abe339
[3/5] ext4: fix the error handling process in extents_kunit_init).
      commit: 17f73c95d47325000ee68492be3ad76ae09f6f19
[4/5] ext4: fix possible null-ptr-deref in extents_kunit_exit()
      commit: ca78c31af467ffe94b15f6a2e4e1cc1c164db19b
[5/5] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
      commit: 22f53f08d9eb837ce69b1a07641d414aac8d045f

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
