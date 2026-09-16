Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98C40315F
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542644; cv=none; b=WLxZV4j9UQMg1SIUxV4He/lw1skvAaOXdrB7q+AQbUpqwswBhRqKtHUB8RqrmWqWaJAZHdHyFc6W7hcOb7RbEBN3XgSEDwAqDG5VYV09JtALPHVy7gWPfnQibJxBbcWs/Iy+TQjVO1vwarJcm3AUOqhFrSuzlNa8MwPsYgAscak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542644; c=relaxed/simple;
	bh=THm0UYQyFdOBvAbX3XFetq97sIbiH20rDQJvrEzV1E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIS2sHaTml0WW3MnRcr8X4cOYrwIZ2rqluNqrempOq0QhNkxCvHmqZyXMbeZDEHeO9C40I+vBVypZ4QFUg7+cawj3UOSmhWTkE73N0pWHEOW6f1y3/Hnth/8arh5drY7TcI+ZlyNQW3RxSJCrqEPP7NWcyrDW0Zxq49H5Z54xN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DFcOCCo5; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFcOCCo5"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2dd68a16955so19827695ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 00:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789542635; x=1790147435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PHTV3yTiDAgtNlvTcMBcYTn+z7U7tH7ocWsUmIkKCZc=;
        b=DFcOCCo5gueo88MeU5lFIAqayl2qO+2XhpYiZcjLalHdjG+YkSYuskvnv4lbDba+is
         7KMJlrbqc6RmDs3slxNAmYDEdsZlRJ+HEuNevtt6SSfw7aRcQkQjOQK8D35qoMB7zsK7
         a93CDylxbFiqnHrVOubEBnzUtNcAOFHnaV5NQieesCTZ6+gXjengHY+oODrVasBA1NpU
         iwRsXgXJbFL1xKsB2OfG1sNXzPV0TJ3lPzmiGhvu5MUzX1Dln+Gy2z3p+eJdEuTZDQ04
         A4BlAFbmKP7P7fGt25Ayb0tmZjkVmNQmfJiOk1XaIBvM9780HQm2KC3eGYWoK8q7gBA/
         CVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789542635; x=1790147435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PHTV3yTiDAgtNlvTcMBcYTn+z7U7tH7ocWsUmIkKCZc=;
        b=RInwdi7gNxMKRrLiEEa2RAeuaNg0r2dXWbSlVIGmQThTUyiAw0sfigNlJUa6fWlTKe
         uMdljdEcFiyNfR2M9Acy18vG7w384K8UQV85dbcja18T1HtBRUicu/zAEyhwTAejp2yD
         TKimwmyINDCgT+qb9ZfL7Rkbj9rVERLVUsLbXgLhasrr+M66PZcg4uMFx3nNnoPDxeUW
         ik1cjrIln2zgORrnKntkCCOESg60g3ijpk47W89GBbrGVyS+btSd2DAPs2QGJRc4n+9w
         TLN6RSCwRHjqfUiVqD7mI7Li3IRiwOPiprJ4ec76Y43LrMsIC9XeE8l6jHPj8M/gdbtt
         YnoA==
X-Gm-Message-State: AFuF++kHqk/D2ZqSETfnxPWlmvuPv1zRbXKA8cJxv3qPPu4Nfx6P52OC
	HlmR6EnXWvXgbqU1k+2cKX1o/W30iTIfObzvRDB8us8LHfQCOyT2GM9bAb17iWNZQE0=
X-Gm-Gg: AYBFou1EXvUofbYYR5Gd1hHH6lhoI8tCS58qiTQjiBogncV4HIP4iI/tZoIbCR8nSz1
	ikXqYs7jI/jUEySsJEvv+R83Gnspy5N1R9Tv0ApG8Z+1f8D/E9OkJuaoztAOA6Yt+9O77Psk2wm
	yuA4kmCRoQjQivM5nIXmjDLeKPeFD+uovcUgGvedlwrcM9t09MrVv2HzOMEqPmZUtUn1IxCvwnA
	JofT4XNHCMuJijIjwhtC1oDwV20yjPSrtasc21DvAK5+rgqQydsKiv+NLmOefXfi9tWDZpRxf7n
	U2tk4je/kHs67e+z/UI0xI1qOlhom/RKEuCQxM8p3I6RixlXAz1Jixv7vze2WkrClOsTyH2HLyy
	+yWi86iXwI+S5D6+E+TQDfe69IQ98xT2XrtieVM336LDe9iCLjAoJ61m6Kr+C6U8FmvyALJB/zX
	WcOoIwJ4IwpDTakiZ2sxaqNJr8U8B2BAyMRZDqtxmPPcAhAr6WAcTvw06ErX2jyiBiE7+db3Vs4
	sUa0WFjsTUnHuibZH5ik473U6+5pOLk4whB20VsQk2C4WM81m/e7K2RRsEKh00gV9bua16ECahN
	imWlkkcF/0YQ585d0KJxfPLbSkch7LSqJ+pr4c2ctFWsR6WM4XhbRxigU8WTJ1Q=
X-Received: by 2002:a17:903:4b30:b0:2d8:d4d2:d138 with SMTP id d9443c01a7336-2dd7655397dmr87409035ad.20.1789542635399;
        Wed, 16 Sep 2026 00:10:35 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5b2753csm10544840eec.31.2026.09.16.00.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 00:10:34 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2] ext4: drop extra ea_inode ref in cached-block reuse path
Date: Wed, 16 Sep 2026 15:10:31 +0800
Message-ID: <20260916071031.2176921-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <kn66y456qvowbu4irzqtkl2ttrubknnir6yi5bdh4c7uup4ave@7b6ybqm2e7ya>
References: <20260814065023.3466742-1-matthias.goergens@gmail.com> <kn66y456qvowbu4irzqtkl2ttrubknnir6yi5bdh4c7uup4ave@7b6ybqm2e7ya>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue 18-08-26 16:09:30, Jan Kara wrote:
> The only reasons why ext4_xattr_inode_dec_ref() can fail are catastrophic
> fs failures => no chance of keeping the fs consistent anyway. So just
> reporting the issue with ext4_error_inode() and otherwise bailing out with
> the least effort is the right thing.

Agreed, and sorry for the long silence.  v3 reports the error and
returns it, no unwinding.  It still puts and clears ea_inode on that
path so that cleanup does not retry the decrement.  After a successful
decrement the branch reaches cleanup with error == 0, which only puts
the inode, so nothing else is needed there.  The change to the
new-block path is gone, and the version notes now sit below the ---.

> I can be missing something but why don't you just call
> ext4_xattr_inode_dec_ref() [in the new_bh != bs->bh branch] and be
> done with it? No need for more complicated condition, also no need
> for iput() or clearing of ea_inode.

I'd like to keep the condition: new_bh != bs->bh drops one reference
too many in one case and none in another.

1. In-place modification, then a hit on a different cached block.  The
   h_refcount == 1 path writes the entry into bs->bh->b_data and jumps
   to 'inserted'.  If cache_find() then matches another block, we share
   that one and release ours, and ext4_xattr_release_block() runs
   dec_ref_all() over the modified old block, which already drops the
   lookup_create() reference.  A second drop in the else branch leaves
   the ea_inode one reference short.

2. new_bh == bs->bh with a cloned s->base.  Re-setting an unchanged
   external value on a shared block takes the lookup_create()
   reference, clones the block (ext4_xattr_value_same() does not
   short-circuit external values), then finds the original block in
   the cache: the "keeping" branch, where nothing consumes the
   reference.

Measured on ext4.git dev at 9091c97be340: fresh 64 MiB ea_inode
filesystem per row, 1 KiB blocks, 256-byte inodes, single mount; one
user xattr with a 240-byte name (so it does not fit in the inode body)
and 3000-byte values V and W (EA inodes at this block size) on files A
and B; V's on-disk EA inode refcount read with debugfs after umount,
and the files' xattr block numbers checked to confirm sharing:

  scenario                              stock         v3
  set A=V, set B=V                      2             1
    ... then remove both                1, kept       freed
  set A=V, set B=V, set A=V again       3             1
    ... then remove both                2, kept       freed
  set B=V, set A=W, set A=V             1             1

The last row is case 1: A=W gives A its own block, A=V modifies it in
place, and the result matches B's block (both files end on the same
block).  Both kernels end at 1; the else-branch drop would give 0.
e2fsck -fn is clean on every v3 image and flags every leaking stock
image.

v3 follows.

Thanks,
Matthias
