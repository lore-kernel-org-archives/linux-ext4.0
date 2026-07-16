Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459733BADA2
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 07:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187060; cv=none; b=urlLsTlLaJ/Hj8ki3oipN5nX8maSB38Fbkmi36OqrVo0O3HD1ZX7yeup9QZua+adQ0GWEYLybkaAWewiSZsfEglf2TMK7zDHbliflLflvnXo5AY8Ubme8+/IEiW5VObkxOtHDrWdd1q+XBbRhOhyoKRjWmmrTzG6vEidhG9PxcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187060; c=relaxed/simple;
	bh=9iI7i4hSDg4kNzMD30XboCuuZXvE3yzIV8pIXmtLihY=;
	h=In-Reply-To:References:Content-Type:Date:Message-Id:Cc:From:
	 Mime-Version:To:Subject; b=BDFwuQPzRAy27sSbutg+nDmMhJiPEDplfAT6hpz02vEuhqcmHpjjn+bfLF8WOoX97DUd2l9Te189OuAhCnuofnhHc3H2bGUo3llff2xmOFmygHJ9TFrX2Z9MqezYEhEqx1uyedxE2CgIQZikppT9RNICeN8x66G9xY7mKPcV10c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YOCIWUCB; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YOCIWUCB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784187044; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9iI7i4hSDg4kNzMD30XboCuuZXvE3yzIV8pIXmtLihY=;
 b=YOCIWUCBBYLw1XrVgD7P6xEvFxAjUSuzQ/32d1RJztxkGE3vh+G6Bsb0Yj/goc9pepER2T
 G6c2TPag92e/WdIQBGZNmV+KgjMXGtJtapz6L9TZafFeIQsfHkfVnFQvvl2ITNEpvT17Rg
 t2Uw70QkBo5A3gWV1iB7O+aVy4Z0xC1N7iVURO2FVwTt0ZrtTbazcyn3A8rWVGKcpobC8F
 hiYhRLIyZrCEWkOn/lDWBGtZziq+CbDVnBee82Y/3QKe2fQ7nLFFe0b+XBtzt+Lht2t3oD
 sp0RmZWAitMH7u3cwH+TN6a3t1zriUKPnyD7DtgXMksBSjyly1vPFUJCViHsRg==
In-Reply-To: <283ee8d1-4bd6-4956-a83c-ac3033ac6c9d@gmail.com>
References: <20260714114358.93335-1-changfengnan@bytedance.com> <osv5omv7siwplyisblmyxttwx7f52ptqsxfi72jmqujogfs4uv@fyhemkm6uwbe>
	<283ee8d1-4bd6-4956-a83c-ac3033ac6c9d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 15:30:39 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.55873583.692f.47e4.966f.1e571a817904@bytedance.com>
Cc: "Jan Kara" <jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: "Zhang Yi" <yizhang089@gmail.com>
Subject: Re: [RFC PATCH 0/2] ext4: fix DIO read slowdown after extent status reclaim
X-Lms-Return-Path: <lba+16a5888a2+df3508+vger.kernel.org+changfengnan@bytedance.com>


> From: "Zhang Yi"<yizhang089@gmail.com>
> Date:=C2=A0 Thu, Jul 16, 2026, 14:08
> Subject:=C2=A0 Re: [RFC PATCH 0/2] ext4: fix DIO read slowdown after exte=
nt status reclaim
> To: "Jan Kara"<jack@suse.cz>, "Fengnan Chang"<changfengnan@bytedance.com>
> Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.=
com>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.co=
m>, <linux-ext4@vger.kernel.org>
> Hi!
>=C2=A0
> On 7/16/2026 12:19 AM, Jan Kara wrote:
> > Hello!
> >=C2=A0
> > On Tue 14-07-26 19:43:56, Fengnan Chang wrote:
> >> This series fixes a slowdown in ext4 random direct reads that appears =
after
> >> extent status entries are reclaimed.
> >>
> >> Problem:
> >>
> >> The extent status tree and the extent-tree leaf buffers do not have th=
e same
> >> lifetime. =C2=A0Memory pressure can reclaim an extent status entry whi=
le the
> >> corresponding metadata buffer_head stays in the buffer cache with its
> >> "verified" flag set. =C2=A0The next lookup then takes this path:
> >>
> >> =C2=A0 =C2=A01. ext4_es_lookup_extent() misses--the entry was reclaime=
d.
> >> =C2=A0 =C2=A02. ext4_find_extent() reads the leaf, but __read_extent_t=
ree_block()
> >> =C2=A0 =C2=A0 =C2=A0 returns the already verified buffer without calli=
ng
> >> =C2=A0 =C2=A0 =C2=A0 ext4_cache_extents().
> >> =C2=A0 =C2=A03. ext4_ext_map_blocks() returns the part of the extent s=
tarting at
> >> =C2=A0 =C2=A0 =C2=A0 m_lblk, and ext4_map_query_blocks() caches only t=
hat suffix.
> >>
> >> Reads to earlier blocks in the same extent miss the extent status tree=
 again
> >> and walk the extent tree on every I/O.
> >>
> >> Testing with fio 4K random direct reads (io_uring, iodepth=3D128) on a
> >> 128 GiB file (75 on-disk extents) after triggering extent status recla=
mation:
> >>
> >> =C2=A0 =C2=A0Baseline (full extent status cache): 525k IOPS, clat avg =
241.96 us
> >> =C2=A0 =C2=A0After extent status reclaim (no patch): 296k IOPS, clat a=
vg 428.69 us
> >> =C2=A0 =C2=A0Degradation: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-43.6% IOPS, +77.2% latency
> >=C2=A0
> > Good spotting!
> >=C2=A0
> >> Fix:
> >>
> >> Patch 1 makes ext4_es_cache_extent() report whether the requested rang=
e is
> >> cached when it returns. =C2=A0The result is passed through ext4_find_e=
xtent() and
> >> the internal map flags, so ext4_map_query_blocks() can skip the second=
 cache
> >> update when the leaf was fully cached. =C2=A0If population was skipped=
 or an
> >> insertion failed, the existing query cache remains as a fallback. =C2=
=A0This avoids
> >> taking i_es_lock for writing a second time after a leaf read has alrea=
dy
> >> populated the extent status tree.
> >=C2=A0
> > Did you observe a measurable performance increase after this change or =
is
> > this mostly a theoretical improvement?
>=C2=A0
> I share the same concern. It would be great to see some test data to
> back this up.

Only a theoretical improvement, no improvement in real test.

>=C2=A0
> >=C2=A0
> >> Patch 2 handles the extent status lookup miss described above.
> >> ext4_iomap_begin() opts into a new EXT4_GET_BLOCKS_CACHE_READ_EXTENT f=
lag for
> >> DIO reads. =C2=A0If the leaf lookup did not populate the extent status=
 tree,
> >> ext4_ext_map_blocks() caches the full matching written extent (ee_bloc=
k,
> >> ee_len) before cropping the mapping to the requested block. =C2=A0Late=
r reads
> >> within that extent can then use the extent status tree directly.
> >=C2=A0
> > I kind of dislike the additional complexity these two patches add to th=
e
> > extent mapping path only for this corner case. As far as I have checked=
,
> > maybe we would be better off to update the extent status tree with the
> > found extent in ext4_ext_map_blocks() / ext4_ind_map_blocks() where we
> > still have the full extent information available. And for start we coul=
d
> > just check whether the extent is already there under read lock (as in t=
he
> > common case we expect it was already cached when reading extent tree bl=
ock)
> > and only if we don't find it, we grab the write lock and insert it. If =
this
> > proves to be too slow, only then I'd bother with figuring out how to
> > propagate the information from caching of the leaf block to the place
> > adding extent to the extent status tree in the least painful manner...
> >=C2=A0
> > Also it would be good to hear Yi's opinion as he was the last doing lar=
ger
> > cleanups to the extent status tree handling.
> >=C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 Honza
>=C2=A0
> I tend to agree with Jan here. The current approach adds quite a bit of
> complexity that I think would hurt maintainability going forward, so I'm
> more inclined to take Jan's idea.

To be honest, I also think this approach is a bit complicated, but I hadn't
thought of a better way before; I'll give it a try as Jan suggested.

>=C2=A0
> In addition, one thing we do need to watch out for, though, is the
> EXT4_EX_NOCACHE case. We should avoid adding unrelated extent range into
> the cache, as that could lead to stale extent cache issues during
> writeback.
>=C2=A0
> Thanks,
> Yi.
>=C2=A0
> >=C2=A0
> >> Fengnan Chang (2):
> >> =C2=A0 =C2=A0ext4: avoid caching an extent twice after a leaf read
> >> =C2=A0 =C2=A0ext4: cache the full extent after a DIO extent status mis=
s
> >>
> >> =C2=A0 fs/ext4/ext4.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A09 +++=
+++++-
> >> =C2=A0 fs/ext4/ext4_extents.h =C2=A0 | =C2=A04 +++-
> >> =C2=A0 fs/ext4/extents.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| 43 +++++++++++++=
+++++++++++++++++++--------
> >> =C2=A0 fs/ext4/extents_status.c | 20 +++++++++++++------
> >> =C2=A0 fs/ext4/extents_status.h | =C2=A06 +++---
> >> =C2=A0 fs/ext4/inode.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 40 ++++++++=
++++++++++++++++++-----------
> >> =C2=A0 6 files changed, 91 insertions(+), 31 deletions(-)
> >>
> >> --=C2=A0
> >> 2.39.5 (Apple Git-154)
>=C2=A0
