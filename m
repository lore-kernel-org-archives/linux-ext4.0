Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2D3353A75
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 07:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784705251; cv=none; b=JbD/OBkgd1V8PCRxVRoVhLBOT3ciXAj1YrwQ/yLVTekY1bW+1zMRlwXp0zao7SCnATILNFV3xkdmRRWjvh8VKlkfQK1x7wHIk6EoAwqESS+2Sa1fci6YQvXae4T8OF91DEWuUavtSCAYoqE6/ggAf7WRerv2A6340EECHvt/a2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784705251; c=relaxed/simple;
	bh=FAsqZMf1R9jNyv1V3obc5umTlKjfXl+Kjk7RA5IUXww=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PBKvBUs8lQmTpkIPbqwWeMPd8sEEkMmO3Rm6KIkviqqWjo/9ZOG8LE3BkvOxUGWG7iv7O9YZvJ19PQP23d+pZfFKLnYqS8jZm+d/q9MIr/J+WFBpgqUvR71UWg4R7coirMG1vVQgrEsYzDOwiai8kd/5RxqVPQo27rnY7V+TY/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=zay5bY9M; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="zay5bY9M"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848479c9bd5so5674512b3a.3
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 00:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784705248; x=1785310048; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zx0c4Q2o2V2Z0rytnWK5U8vEtkTZ9q0DCPxis64jpzU=;
        b=zay5bY9MY7EnbtUBQ9Ea8q+QIgLoayuEpZ3sUXynqWA9DLH5nJkB8mzA4NYW1y83tj
         tCl1Stg8Wp6GDRg0gIK97NsKq6nJmc1JKRWFFQN1XbUsde1TGQj8hdQ+pmcEKqWoeDB0
         d+w7khlOKbZlxS1eJVRT69oGOU9zBGLv8QVLd01Hr+FXQv8YlB85grpF6YA8++G+gxWh
         IDgcomp3umyYNRu+2PkKxDuw9BK6axTinEyUHguRM68DHdLktzohJratsjalnOJC4gQP
         7eum3PQTLipm/kzUVVjhRbvtGE+VW3Jj8nPb0t4rC4w08qd9Aff73VUnL7Dm6FZrSkXX
         Q/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784705248; x=1785310048;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zx0c4Q2o2V2Z0rytnWK5U8vEtkTZ9q0DCPxis64jpzU=;
        b=LCqGBoMEkKu2TCE/Lg4kyoDJWJsRBWJRN10tT4d04EGVPV7HICey8EgyOFZ3gHG46n
         mlWHAOerRdfWZsQDFoGnmgtzCcAw9VBdsahxQdHdaEvC0Y34JJ/vINjLI5EKcW1qew7K
         GsJU93F0YLNSk4M7t/Fxt5gPAcZeOuRgy5HXd+7H86iLqZOA3G7P2GfgR1BCA7QUHwad
         ux0LxbWumXu/41yuR7AuTt2wmmm8rSlVvLP6Q3fqZFJFqy9Jh6bLeS4B1UVELhu0fM6y
         2CimDZp6m9Y/SBXdHged4KWkhg395sY+S+sLKaQ+tRUjn6Zgq8ceZfys5DhjE1akTb9g
         P0QQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPPBvAmoP+vpSyjhU86CFn33skSWHYZpA6ZsyLjLWY547dfmuAl25rrTmrlAgLGV/1x+/XU/qfk9S8@vger.kernel.org
X-Gm-Message-State: AOJu0YyBxtbAiSVyk/tukmZ7IXoNdPmPMHgqV1xhNzqj0HzNF4cX6wai
	UN8qhUh8YGDU/Lb/HxHQwZNM0jakNasQElz3/B6unDjNz2bUDQuNs2E8MzFtZbvXfl4=
X-Gm-Gg: AR+sD10YO5TpQktncART/Uy1rfcutrGisz/0TVwcdMn2xKoQHMbxEALq7O0EujYzOjF
	ai/ghg514FtwUVa+/ofroXJNpKDZztic1QPeJypwPix4DbG4belolaBfvlM+fG2++zJzqluoI+1
	r8o7txDA1V4j+ADRkwVtzhGkxOAgGs7wr9IyUVd436wDxmHk41YDi0LCb2fJGbs586NB6ldbjJO
	7oyRacoPS+wQuJi383ooY/VE+g3XhIdH/6GgywyQphuC9bjmQHIpWqJSEyvonF0IM4QeTrsvAtQ
	8VxTVDTGXnN5Uc/4tzow3B/85txBN6TzzCdeRDHWxAi5iHn7y3IH1YACeavYAwY/lg5R90YrPYm
	5JHqQWtesfVE5jykhHano0v3xHbnZ82fmylXOEq2pt4s/VLH/4rGEe0Y4/zc+2HSFqmTamcxFtG
	jJpi2d5u0WTvGQsbOE8kcNtQHgID7oYhQ=
X-Received: by 2002:a05:6a00:4092:b0:845:e9e8:6458 with SMTP id d2e1a72fcca58-84c29272e79mr20800874b3a.20.1784705248459;
        Wed, 22 Jul 2026 00:27:28 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:5433:70f8:26df:52b6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e1728566dsm883520b3a.18.2026.07.22.00.27.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2026 00:27:27 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [RFC PATCH v3 0/2] ext4: speed up fast commit on random writes
From: Andreas Dilger <adilger@dilger.ca>
X-Priority: 3
In-Reply-To: <20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
Date: Wed, 22 Jul 2026 01:27:15 -0600
Cc: "tytso@mit.edu" <tytso@mit.edu>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "me@linux.beauty" <me@linux.beauty>,
 "libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>,
 "harshadshirwadkar@gmail.com" <harshadshirwadkar@gmail.com>,
 "yi.zhang@huaweicloud.com" <yi.zhang@huaweicloud.com>,
 "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0A044AA9-8457-4DF8-902E-72208C1C6CC6@dilger.ca>
References: <CGME20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
 <20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
To: daejun7.park@samsung.com
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 21, 2026, at 18:59, Daejun Park <daejun7.park@samsung.com> wrote:
>=20
> Fast commit is meant to make fsync cheap, but on random-write =
workloads it
> defeats itself.  ext4 still tracks a single coalesced [min,max] =
logical range
> per inode (i_fc_lblk_start/len).  When an inode is dirtied at several =
disjoint
> offsets between two commits, that span widens to cover them all, and =
at commit
> time ext4_fc_snapshot_inode_data() walks the whole span through the =
extent
> status tree -- emitting an ADD_RANGE per mapped segment and a =
DEL_RANGE per
> hole inside it.  For scattered writes that is hundreds to thousands of =
ranges
> even though only a handful of regions were actually modified.
>=20
> The recently merged fast-commit snapshot work did not change this: it =
caps a
> snapshot at EXT4_FC_SNAPSHOT_MAX_RANGES (2048) and fails over to a =
full commit
> when the span exceeds it.  Measured on dev (7.1.0-rc4) with a sparse
> random-write workload (1 GiB span, R disjoint 4 KiB writes per fsync, =
300
> fsyncs):
>=20
>  R=3D16 regions/fsync:  ranges/commit 1095,  full-commit fallback 76%
>                       (snap_fail_ranges_cap on 226 of 300 fsyncs)
>=20
> Fast commit barely functions on this workload.
>=20
> This series tracks the actually-modified disjoint ranges instead of =
one span,
> and snapshots only those:
>=20
>  1/2 replaces the single [min,max] range with a small, bounded set of =
sorted,
>      disjoint ranges (up to EXT4_FC_MAX_RANGES =3D 16; the two closest =
are
>      merged on overflow, so the worst case degrades to the old =
single-span
>      behaviour).  ext4_fc_snapshot_inode_data() then walks only the =
tracked
>      ranges.  The on-disk TLV format is unchanged.
>=20
>  2/2 allocates the range array lazily: the first range stays inline, =
the
>      array is allocated only when a second disjoint range appears, and =
on an
>      allocation failure we fall back to the inline single range.  =
Per-inode
>      fast-commit footprint stays ~20 bytes.
>=20
> Result on the same workload (dev, patched):
>=20
>  R=3D16:  ranges/commit 1095 -> 16,  fallback 76% -> 0.7%,
>         snap_fail_ranges_cap 226 -> 0
>=20
> i.e. the over-logging and the fallback storm are gone when the number =
of dirty
> regions is within the bound.
>=20
> Honest limitation: when the number of disjoint regions per fsync =
exceeds
> EXT4_FC_MAX_RANGES (e.g. R=3D64 with the bound at 16), the overflow =
merge
> re-coalesces and the win largely disappears (fallback 95% -> 87%).  A =
larger or
> tunable bound recovers it -- see the open question below.
>=20
> Testing (on dev, patched):
>  - crash recovery: deterministic writes + fsync, kill -9 QEMU (power =
loss),
>    reboot -> fast-commit replay -> verify every fsync'd block, e2fsck =
-fn.
>    9600/9600 blocks verified, 0 mismatch, e2fsck clean.  Run with =
R=3D64, so the
>    overflow-merge path is exercised.
>  - ext4/generic fast-commit xfstests (ext4/044 ext4/045 generic/455 =
456 457
>    470 482): ext4/044, ext4/045, generic/456 pass; generic/457, 470 =
skip
>    (reflink/dax unsupported on ext4); generic/455 fails identically on
>    unpatched dev (pre-existing, patch-unrelated); generic/482's single =
failure
>    in a combined run did not reproduce (3/3 pass in isolation on the =
patched
>    kernel).
>  - on-disk format unchanged, so e2fsprogs needs no update.
>  - both patches are checkpatch --strict clean.
>=20
> Posted as RFC -- this sits right on top of the new snapshot code and I =
would
> like direction before a non-RFC submission:
>=20
>  - Is tracking disjoint ranges in-core (this series) the right shape, =
or would
>    you rather the snapshot side skip holes/unmodified extents some =
other way?
>  - EXT4_FC_MAX_RANGES is fixed at 16.  The R>bound case above wants it =
larger
>    or tunable (sysfs/mount).  Preference?
>  - The array is allocated under i_fc_lock with GFP_ATOMIC, falling =
back to the
>    inline range on failure.  Acceptable, or move the allocation =
outside the
>    lock?
>  - Overflow merges the two ranges with the smallest gap -- acceptable
>    heuristic?

Have you looked at implementing a more dynamic structure like another
extent status tree, rbtree, xarray or or similar instead of having a
fixed-size array?  At *some* point the number of random blocks in the
fast commit will be so large that there is no value to tracking them
separately anymore, but the fixed 16-range limit is clearly too small
based on your testing.  It would be useful to do some testing of how
many separate ranges gets worse than the fallback.

Getting this tuning right is always difficult, and will depend on the
application workload, IO size, the storage bandwidth/latency, etc.
Having a dynamic limit is much better than a compile-time constant.

A runtime tunable is the minimum, possibly storing one range directly
in the inode, and using that as a union with the pointer to an allocated
array of ranges.  Something like the following that allows a range, with
an inode flag whether the union holds a single range or allocated array:

	union {
		struct ext4_fc_lblk_range i_fc_range;
		struct {
			unsigned int		   r_count;
			struct ext4_fc_lblk_range *r_ranges;
		} i_fc_range_array;
	};


Better would be a union with the root of a dynamic range tree.  It is
better to re-use some existing kernel functionality for this instead
of creating yet another tree implementation.

Cheers, Andreas

> Changes since v2 [1]:
>  - Evaluate the range adjacency bounds in 64 bits to remove a latent
>    ext4_lblk_t (u32) overflow.  The largest valid lblk is
>    EXT_MAX_BLOCKS - 1 (the shrink path in ext4_setattr() passes it; =
the data
>    path is bounded by the m_lblk >=3D EXT_MAX_BLOCKS check), so "end + =
1" and a
>    range's "start + len" can reach EXT_MAX_BLOCKS.  These were =
computed in u32
>    in ext4_fc_range_add() (1/2) and __track_range() (2/2).  On =
reachable inputs
>    they stop one short of wrapping, so there is no behavioural change, =
but the
>    arithmetic is now done in u64 so it cannot wrap regardless of =
caller --
>    matching ext4_fc_snapshot_lblk_range(), which already used 64-bit =
bounds.
>    No other site in the series shares this pattern (audited).
>=20
> Changes since v1 [2]:
>  - Rebased from v6.17-rc3 onto ext4.git dev; re-implemented on top of =
the
>    merged fast-commit snapshot model (v1 targeted the old
>    ext4_fc_write_inode_data(), which no longer exists).
>  - Motivation now uses the in-tree snap_fail_ranges_cap counter.
>  - =46rom and Signed-off-by use the same identity.
>  - Reposted as RFC.
>=20
> [1] v2: =
https://lore.kernel.org/linux-ext4/20260623082331epcms2p4798e9d26b06f9a005=
bcca7b2edf395d3@epcms2p4/
> [2] v1: =
https://lore.kernel.org/linux-ext4/20260611044733epcms2p38013ae683a2835555=
26f70e4eab6d2a9@epcms2p3/
>=20
> Daejun Park (2):
>  ext4: fast commit: track disjoint modified ranges per inode
>  ext4: fast commit: allocate the range array lazily
>=20
> fs/ext4/ext4.h        |  42 ++++++--
> fs/ext4/fast_commit.c | 231 ++++++++++++++++++++++++++++++++++++------
> fs/ext4/super.c       |   1 +
> 3 files changed, 234 insertions(+), 40 deletions(-)
>=20
>=20
> base-commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe
> --=20
> 2.43.0


Cheers, Andreas





