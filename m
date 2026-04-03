Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D272E2BE7B6
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 21:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775250624; cv=none; b=XJy427SyUtZFGh9TFKJkYyQFB3DMurYhLySGUkCTIQxsVfDNre42g5X2tws9+OJZPbKBaRs4no+KZPCPZRPSq7ymcqZIsBO6TmVQCjFssynhI1So3I4nQUxtB1An7MFoU/GVosVZ1gXp0ehjFTAXV2z7KCbF5044SypASciTtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775250624; c=relaxed/simple;
	bh=lIacrHw4O+mbhc7l/4w4dkkDNfJvDb25a+6xIv/NDys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5tyOu9rLi340cDqIpU73Z7w2pWU9EXNyA2MmlYjnHH0VRBTuqpGkM/w/LIkCgcm2L2z7X3peNrQmhA5W3fSjkV1qrBFkv1qzxX8q/mBY1Y13IDgfeV3OGOVGYsG2dRQE9j4M2X8p0x0qTvuBW5p3Xjkv1/1Hz88f/0SuNi4OnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=BodGijII; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="BodGijII"
Received: from trampoline.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633LAGL8027003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 17:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775250618; bh=KTnAeFFQ7+y+gkth7Jg/StkeknAuSgF29PTlML+RT3E=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=BodGijIIDFuU1o+YHO8LkUgIr9LY8RGKIreDb9UuPF7uvE5Y8Rib1RPAbJ37bLPvA
	 7+mUqhA7Xen/0Zbaz5H3SH8zb9RCfoPdlRPQUf5SvY15EVisDOW8cgX0jnPAVW8x/9
	 YVambURIHiPMMh5KYl3LGWgUa6dSlFhex5vptryhPPQxxGOFaueyUC1KFeh0alErca
	 kIu/HgW58nv8MuJ8WqNVLGEk/0Uoo9vZ1hKIA9ZDRjggWLHmc0AMuHT/gXqP/dbCR7
	 kVbfjtRQPU3MrP0ogPSKs2foZbOWlxQAuklKHYZCu3u5AfzCw2sI2gWaH8A0IZGUw4
	 L2AaAoCv7PWIg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 633712E00D6; Fri, 03 Apr 2026 17:10:16 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] libsupport: change get_thread_id return type to unsigned long long
Date: Fri,  3 Apr 2026 17:10:12 -0400
Message-ID: <177525049406.2437065.223736157996355413.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260403151927.GB6192@frogsfrogsfrogs>
References: <20260403151927.GB6192@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 03 Apr 2026 08:19:27 -0700, Darrick J. Wong wrote:
> With -Wformat enabled, the e2fsprogs build spews out a lot of warnings
> for fuse2fs:
> 
>  ../../misc/fuse2fs.c: In function ‘__fuse2fs_finish’:
>  ../../misc/fuse2fs.c:152:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘uint64_t’ {aka ‘long unsigned int’} [-Wformat=]
>    152 |                 printf("FUSE2FS (%s): tid=%llu " format, (fuse2fs)->shortdev, get_thread_id(), ##__VA_ARGS__); \
>        |                        ^~~~~~~~~~~~~~~~~~~~~~~~~                              ~~~~~~~~~~~~~~~
>        |                                                                               |
>        |                                                                               uint64_t {aka long unsigned int}
>  ../../misc/fuse2fs.c:556:17: note: in expansion of macro ‘dbg_printf’
>    556 |                 dbg_printf(ff, "%s: libfuse ret=%d\n", func, ret);
>        |                 ^~~~~~~~~~
> 
> [...]

Applied, thanks!

[1/1] libsupport: change get_thread_id return type to unsigned long long
      commit: 582a5ff290423e6fc11e91ba0534e422c026f018

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
