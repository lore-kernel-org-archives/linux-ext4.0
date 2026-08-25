Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B529389E1A
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2026 07:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644739; cv=none; b=oQKFBA8s+O+J8+8WtC+wlyDHSgn52xqeDvACHWZg5IuP6Tj4UFFSt/hcfENDHGF+SracIIkW5ivP2bzAKzNBk0jRPFwGIejb9Q9fkknuAmkqiCivUxpTpq2WPyU1etZ2Mom4K/v/tjDxfWcTp8ufn3TTFB9zIOtekLKrryjCRCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644739; c=relaxed/simple;
	bh=s3x3RNU/eA7uy/SJ1qUVWhAw0EVi7d4DWm+cDdSIGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WquqOoSbhM9iv8Y6M/M/OJYaMGwbaaKdme+DEGCAcZoQWAQx7hk7pfIobl01VBkvaIlyQkr+zrKEh13h2+LQRHWI2+AvL0A9vH6fDUE6oZpfS5tr9ObFeqkZ87/oiF0GCReKjwmdbj9bt2uoNfWFoxPhKixVroEGCoR/8WkeLgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=psMhoKGn; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="psMhoKGn"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-39266382df6so3737136a91.3
        for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2026 00:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787644738; x=1788249538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BCxIjrQYLQM8XDCQ4pvIySM2CoxYiO6JYpvvBpStof4=;
        b=psMhoKGnys+zXVO2FsZdpn2fvizsTgJp7I6S4C//VJrA/m9GYPwkPQpUlXbACqwJjp
         Zw6pg7HLel5O5jPy0/griwYL2L5ZMvwi8naMQJXZ4OLrDx3OReyW9JGKzorcC1OC1/Xw
         DTd1Qk3ZyINicKzIVZQY89uGSY8eCfJ47CqKb9YnnLGLZ/AzUm5KWL6OjVe73CvhTP9J
         G//3nbNfJ2MXNlbQedqbC/n/g4Fgy0kRRDvyVhF32O7BOC1OV+l5Y7W2vdp0xAmFsgv6
         Y5wFyX+yJ6yIdPejXlUrQQbFKZVQ3qf8Xj59IoBdlOeA88m+QehMBbb0ceZbYzFPSFoW
         XNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787644738; x=1788249538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BCxIjrQYLQM8XDCQ4pvIySM2CoxYiO6JYpvvBpStof4=;
        b=NzBJQ2SCqHhtZjA+cc1VVdzcwKD5dVRDo2b67s0ILS7nf3NkRpXmCikpO707WI+FDF
         cpKlxZ25Wzk8NI6ynDhJD/mfjT3pVkshwtca03vlsJBkRRwTzB4PwxYU2sAvgPafmeRk
         YuzChN6xjhdUXZG4unQ6K9SgWdyGvSK7OdOqy3+1DYSZJocI5v2w/d3kps452nMrMZw8
         t0Kso70HcxO0Mtjfplk6LOlgAlTMp0QV0//LFaf1WRZe96R9/uks5WeJ7Ud/AEyIV4AZ
         ahjA32Qh0kcgcx7gom6hokE8ZI4thOwChPbazVKgSU0O5U4Krx2wFfdNQoNFop25OLLw
         SpBg==
X-Gm-Message-State: AFuF++nH77sRJmxODPh+hK0BUMzLa10vIm8Kke1LQElnLAVQErldMhfB
	WWPXdFMHzBUPsR+Q76PwR4ilNU11kC/Y0NPi6RDlvuUiTLe25/qLwfGVoOl/T5AW
X-Gm-Gg: AR+sD13gl9vmM1tETyXmf64NB8Sjth7ogdEI3IjVWucLrgp0uMB340OJnP57UhA/sJl
	AKzFw80gYtalmTqF7z7s+P6h/qbKautCgJwJw23dvl7Qsb2MAXdoGWhfYvJZ2tDt9KqfILc4CS8
	scqIzUOnhJUcLmFTjrzOAL96KQAjGEUkOdq5aIE8QciKJZmdxHgzPwAMehkbw9zs4Hu5TevFczF
	5WDoEf+IUSLNYomt1vvQnRplLQBGGm3yu0fJDS+3Yh9c/Cu85K+pmVZh1av55BTYVhqNfMT1sG3
	/3HF2cUUZ0VQu00M8gS1yI+8jr2zhDMS+F35WQn/UMz4UCyXe8IeyqGX73BnIckkl6BRYLqDuap
	+yeyfq+w7qZ1VLevb5URf9b2JjMWwpEh5iO8jQRoMUTCI6J4gkKIfFR6SP2mnzx4W3D4tpBjGhj
	npnmLPhRIVuewrmyFNysrVA73tam3VcVy3uq5LnYuhAnD2JQpPzmfTloknC5ox3FkpjexIFbieV
	cL/X74prRw=
X-Received: by 2002:a17:90b:4a81:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-395c33ec558mr55513154a91.7.1787644737768;
        Tue, 25 Aug 2026 00:58:57 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3282525562dsm6041392eec.31.2026.08.25.00.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 00:58:57 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH] ext4: skip extra isize expansion while unmounting
Date: Tue, 25 Aug 2026 13:28:36 +0530
Message-ID: <20260825075836.2693545-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260824100141.86E351F000E9@smtp.kernel.org>
References: <20260824094512.2436628-1-hemanth.selam@gmail.com> <20260824100141.86E351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 24, 2026 at 10:01:41AM +0000, sashiko-bot@kernel.org wrote:
> This isn't a bug introduced by this patch, but does checking s_root here
> without synchronization leave a race open during unmount?

The s_root test is advisory, like the SB_ACTIVE test next to it, and the
patch does not change that.  The race you describe is the
check-then-dereference inside ext4_xattr_inode_create() itself, between
the s_root == NULL test and the inode->i_sb->s_root->d_inode dereference
eleven lines below it.  That predates this patch and is untouched by it.

What the patch changes is how often that code is reached.  Without it,
anything that dirties an inode after shrink_dcache_for_umount() has
cleared s_root and before SB_ACTIVE is cleared walks into
ext4_xattr_block_set() and hits the warning.  That is the path syzbot
reproduces, and there the caller is the unmounting task itself - iput() of
a lazytime inode - so no second thread is involved.  With the patch those
callers get -EBUSY first, so the window your scenario needs gets smaller
rather than larger.

Of the two workers: ext4_ea_inode_work() only iput()s EA inodes, which
carry no in-body xattrs, so it never reaches
ext4_xattr_inode_lookup_create().  ext4_end_io_rsv_work() does reach
ext4_mark_inode_dirty() via ext4_convert_unwritten_extents() and is only
flushed in ext4_put_super(), so it can run in that window - and with this
patch it gets -EBUSY there too.

> Or if s_root is cleared right before the warning check inside
> ext4_xattr_inode_create(), wouldn't we still hit the original warning?

Yes, and it returns -EINVAL exactly as it does today.  The patch removes
the deterministic path syzbot found, not that check.  Flushing
rsv_conversion_wq and s_ea_inode_work before shrink_dcache_for_umount()
would close the rest; I can send that separately if it is wanted.

Thanks,
Hemanth
