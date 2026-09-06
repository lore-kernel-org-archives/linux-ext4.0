Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C1861FCE
	for <linux-ext4@vger.kernel.org>; Sun,  6 Sep 2026 11:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788692597; cv=none; b=j40DjJ7gOTZYip5QS2KkMC+mFaIxWvf5abLk5fGgmiuYnotpk2Uk9OLfG3TLTp1dHDX+b0YCFRb1Vf8k2YlYM/zDnKw4V4Rl2lbp0RRRdHnW9OjfqeVawDGYSnqZ0X6boSYiQIlN01GxzrQ0Tk63Mh/l56qWqM0qEnOb4UeOgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788692597; c=relaxed/simple;
	bh=Wh+1k4RApAPWbefg/l5jJOdlds/sTpd6aEibZwgyVHU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Zxk8XXtShJ8KW0/RkvX1M5oR22s/rhVCS9oJ7xAWj7lDvhBi6llCuJW00bt5M88/gMZUKEoEr0NHRTUhdMLCGgbLyx+DWUwPd2H4OTsjWUXYoz43JYdcY0AOiLMPn4iBFlYjGXNPU4j1qFCOHZqkA+ZWS1Y3b7NCj0IeSonH14E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6/sZ/Ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6/sZ/Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1311F00A3A;
	Sun,  6 Sep 2026 11:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788692595;
	bh=Wh+1k4RApAPWbefg/l5jJOdlds/sTpd6aEibZwgyVHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B6/sZ/RyXHyXqHjs3wrbnocn16AR71m8YxlpUAgkdbA8+qLaxFtYk9mdO0yPTRg4M
	 GJV5Qc75bLNdG1C7Nt2EYeCBMNn3EyA7vuQs+ye6FCdgFTZRpwsfgOSL9AUz2hoXcu
	 Aqdcrm9t60Pq9ZFNN+tAzm+HYGJL1wHmgf2wdUNXUxR+L5WB3yTSMeA51p9YB93KRH
	 EfwY1gF6oPEsZC3/+8eY+c7ftIRuZpiBKERN3pAJI+vAhwuFcd9a0omfzOekntftTc
	 ZXM7vVJQK4eL9zs/Ne08HlZtyuDH9y54gSjAi0zQzFM5BFT0aT8tTNReXn2XTYykOl
	 hePhsF/D7sHsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: avoid buffer/folio lock inversion in
 __ext4_get_inode_loc()
Reply-To: sashiko-reviews@lists.linux.dev
To: ThangNN99 <ngocthang2710.1999@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
References: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 06 Sep 2026 11:03:14 +0000
Message-Id: <20260906110315.6D1311F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The itable-block bh is locked, then the "is bitmap cached?" probe calls
> sb_getblk(), which can block on that bitmap block's folio lock. A
> concurrent block_read_full_folio() on the same bdev folio locks buffers
> in the opposite order (folio lock, then each bh), so the two tasks can
> deadlock on each other's lock. Use the non-blocking cache lookup here
> instead; a miss already falls back to make_io exactly as before.
>=20
> Only ext4_reserve_inode_write() reaches this probe with a real inode
> (ext4_iget() passes NULL, which skips it), and it normally runs right
> after the read that loaded that same inode, so the itable buffer is
> still warm and the early "already uptodate" return skips the probe.
> The window needs the folio reclaimed between load and writeback, which
> is why this is rare and why syzbot's bisection could not pin it down.
>=20
> Reproduction status: root-caused from source and confirmed against
> both syzbot stacks (inode.c:__ext4_get_inode_loc vs.
> buffer.c:block_read_full_folio); the lock_buffer()/reserve_inode_write
> path was exercised live (orphan cleanup on mount) to confirm reachability
> and to confirm this patch introduces no regression there. The deadlock
> itself was not reproduced locally -- doing so needs the itable buffer
> genuinely reclaimed between inode load and writeback, which a small
> single-shot QEMU test doesn't naturally produce.
>=20
> Reported-by: syzbot+03afbb29537f0336b7ad@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D03afbb29537f0336b7ad
> Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260906104841.5607=
5-1-ngocthang2710.1999@gmail.com?part=3D1

