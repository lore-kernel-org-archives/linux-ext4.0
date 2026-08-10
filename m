Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212EE3B4EAA
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 11:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786361445; cv=none; b=lg33J4cfpUuYkB3DoRd8M7fLxVOc2AtVUU2P5I2Em0sz+yH176XqScYDilnRBYRBiSn9ZTERqUtC8idCDi9/7JJ0BnC6PNaeEB1M/fYk5FNG6kdFQZenfR2ZAacx8FXqXbTQG5nTC5G58Epo5S/S1U1WxfbvxADBXfYSDmEr7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786361445; c=relaxed/simple;
	bh=MyFTowQ00YNIQn9mzAfkqD4B8i2qb100w8uykV0rw7U=;
	h=Message-Id:To:Cc:In-Reply-To:Date:Subject:From:Mime-Version:
	 References:Content-Type; b=JhYuuC6bNVfR0Sqa0q9Up9klOd/97r1qTCYcdGQl/xg0SBEugR8HkJNICB/8iNPWUiWjqV+SB2pLiT9RLiNGwGSpqDiaBXXQ5aoSEexIx8b9i/qMAFjbY4Zj9MV/qVliawT8Zm5iHWArB2Zngqoneu+Dq331RuPo3mwNxhziK+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NdbDwjG4; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NdbDwjG4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786361431; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=MyFTowQ00YNIQn9mzAfkqD4B8i2qb100w8uykV0rw7U=;
 b=NdbDwjG4Hqs4Tnwgd0vzBwgENMh8rheD9YMvC2i7HGTdWhB2gzXdqvQoksfCCb6WyGzTFH
 +rr/JhYgt52ndwjQp92aOOFq+ICHVg1EfNiBKMhnmLcD+Udm0UJOkp/MKoiVDZ6oFoJSzj
 MxSf4oJRvFAiVgyQUJ/3fvXyqoELufzSfOXczFNrT4nNSui/OSSpuXx0Af/FN3kziMPmhN
 aYSOn5Y+rImi1o5V/Gx4iZVrX3AbnizSs3FfWt6Am3hGS0OjBitv9x746WHmk/EPVfUWlL
 K56skxHE179REDDnM1WXlTRAyEXabYGMsys72AS2MGH3aERDs46BZHlH25F8aQ==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.63b2d457.9fed.4e50.938c.d7cf548c1ad8@bytedance.com>
To: "Jan Kara" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Cc: "adilger.kernel" <adilger.kernel@dilger.ca>, 
	"libaokun" <libaokun@linux.alibaba.com>, "Jan Kara" <jack@suse.cz>, 
	"ojaswin" <ojaswin@linux.ibm.com>, "ritesh.list" <ritesh.list@gmail.com>, 
	"yi.zhang" <yi.zhang@huawei.com>, 
	"linux-ext4" <linux-ext4@vger.kernel.org>
In-Reply-To: <f4prqhixlrwwz3oiphmzrzy6gzibbjtwhclef7muv3slcx2dam@fxv5rmyoaxsj>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 19:30:26 +0800
Subject: Re: [PATCH v3] ext4: cache full extents during mapping lookup
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a79b655+eaff32+vger.kernel.org+changfengnan@bytedance.com>
References: <20260723124326.82446-1-changfengnan@bytedance.com>
	<f4prqhixlrwwz3oiphmzrzy6gzibbjtwhclef7muv3slcx2dam@fxv5rmyoaxsj>
Content-Type: text/plain; charset=UTF-8

Hi Ted:

It looks like this patch is good to go, can we merge it?


> From: "Jan Kara"<jack@suse.cz>
> Date:=C2=A0 Wed, Jul 29, 2026, 04:26
> Subject:=C2=A0 Re: [PATCH v3] ext4: cache full extents during mapping loo=
kup
> To: "Fengnan Chang"<changfengnan@bytedance.com>
> Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.=
com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi=
.zhang@huawei.com>, <linux-ext4@vger.kernel.org>
> On Thu 23-07-26 20:43:26, Fengnan Chang wrote:
> > The extent status (ES) tree and extent tree leaf buffers are reclaimed
> > independently. An ES entry can be reclaimed while the leaf buffer remai=
ns
> > cached with BH_Verified set.
> >=C2=A0
> > When this happens, ext4_es_lookup_extent() misses. =C2=A0Since the leaf=
 buffer
> > is already verified, __read_extent_tree_block() returns it without call=
ing
> > ext4_cache_extents(). ext4_ext_map_blocks() returns the part of the ext=
ent
> > covered by the request, and ext4_map_query_blocks() caches only that ra=
nge.
> > Reads to other blocks in the same extent then keep missing the ES tree =
and
> > walking the extent tree.
> >=C2=A0
> > Cache the full extent in ext4_ext_map_blocks() before the returned mapp=
ing
> > is limited to the requested range. Add an optional read-side lookup to
> > ext4_es_cache_extent().
> >=C2=A0
> > Do not do this when ext4_ext_map_blocks() is called with
> > EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE. NOCACHE paths can change ext=
ent
> > mappings, so caching ranges outside the request can leave stale ES entr=
ies.
> > Cache both written and unwritten extents, as ext4_cache_extents() does.
> >=C2=A0
> > Tested with fio 4K random direct reads using libaio at iodepth 128 on a
> > 128 GiB file with 208 on-disk extents. The results are averages of thre=
e
> > 10-second runs:
> >=C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0before re=
claim =C2=A0 =C2=A0after reclaim
> > =C2=A0 unpatched =C2=A0 =C2=A0 =C2=A0 =C2=A0419.6k IOPS =C2=A0 =C2=A0 =
=C2=A0 274.6k IOPS
> > =C2=A0 patched =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0426.1k IOPS =C2=A0 =C2=
=A0 =C2=A0 423.7k IOPS
> >=C2=A0
> > Average completion latency went from 303.02 to 462.78 us without the pa=
tch,
> > and from 298.36 to 300.07 us with the patch.
> >=C2=A0
> > No latency regression was seen in A/B test.
> >=C2=A0
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Suggested-by: Zhang Yi <yi.zhang@huawei.com>
> > Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> > Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@byt=
edance.com
> > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
>=C2=A0
> Hum, you have taken an easy way out :) I was hoping to get rid of
> ext4_es_cache_extent() calls in ext4_map_query_blocks_next_in_leaf(),
> ext4_map_query_blocks(), and perhaps more places by a strategically place=
d
> calls in ext4_ext_map_blocks() and ext4_ind_map_blocks(). But this patch
> fixes your problem without adding too much technical debt so I'm fine wit=
h
> that. We can cleanup the ext4_es_cache_extent() calls later. The patch
> looks good to me so feel free to add:
>=C2=A0
> Reviewed-by: Jan Kara <jack@suse.cz>
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Honza
>=C2=A0
> > ---
> > =C2=A0fs/ext4/extents.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| 17 +++++++++++++--=
--
> > =C2=A0fs/ext4/extents_status.c | 17 ++++++++++++++++-
> > =C2=A0fs/ext4/extents_status.h | =C2=A02 +-
> > =C2=A0fs/ext4/inode.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 15 ++++++++++=
+----
> > =C2=A04 files changed, 41 insertions(+), 10 deletions(-)
> >=C2=A0
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 91c97af64b317..85e213761a18d 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -537,12 +537,12 @@ static void ext4_cache_extents(struct inode *inod=
e,
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (prev =
&& (prev !=3D lblk))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0ext4_es_cache_extent(inode, prev, lblk - prev, ~0,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 EXTENT_STATUS_HOLE);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 EXTENT_STATUS_HOLE, false);
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext4_=
ext_is_unwritten(ex))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0status =3D EXTENT_STATUS_UNWRITTEN;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_c=
ache_extent(inode, lblk, len,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_ext_pblock(ex=
), status);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_ext_pblock(ex=
), status, false);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0prev =3D =
lblk + len;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0}
> > @@ -4239,7 +4239,8 @@ static ext4_lblk_t ext4_ext_determine_insert_hole=
(struct inode *inode,
> > =C2=A0insert_hole:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Put just found gap into cache to s=
peed up subsequent requests */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_debug(inode, " -> %u:%u\n", hole_=
start, len);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_cache_extent(inode, hole_start, le=
n, ~0, EXTENT_STATUS_HOLE);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_cache_extent(inode, hole_start, le=
n, ~0, EXTENT_STATUS_HOLE,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 false);
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Update hole_len to reflect hole si=
ze after lblk */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (hole_start !=3D lblk)
> > @@ -4310,13 +4311,15 @@ int ext4_ext_map_blocks(handle_t *handle, struc=
t inode *inode,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk=
_t ee_block =3D le32_to_cpu(ex->ee_block);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_fsbl=
k_t ee_start =3D ext4_ext_pblock(ex);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
short ee_len;
> > -
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int s=
tatus;
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * unwrit=
ten extents are treated as holes, except that
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * we spl=
it out initialized portions during a write.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ee_len =
=3D ext4_ext_get_actual_len(ex);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ext=
4_ext_is_unwritten(ex) ?
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_ext=
4_ext_show_extent(inode, ee_block, ee_start, ee_len);
> > =C2=A0
> > @@ -4328,6 +4331,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct=
 inode *inode,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0ext_debug(inode, "%u fit into %u:%d -> %llu\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0map->m_lblk, ee_bloc=
k, ee_len, newblock);
> > =C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (!(flags & (EXT4_GET_BLOCKS_CREATE |
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_EX_NOC=
ACHE)))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_cache_extent(inode, ee_bl=
ock, ee_len,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ee_start, status,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 true);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/*
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 * If the extent is initialized check whether the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 * caller wants to convert it to unwritten.
> > diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> > index 6e4a191e82191..5a03878b06160 100644
> > --- a/fs/ext4/extents_status.c
> > +++ b/fs/ext4/extents_status.c
> > @@ -1023,7 +1023,7 @@ void ext4_es_insert_extent(struct inode *inode, e=
xt4_lblk_t lblk,
> > =C2=A0 */
> > =C2=A0void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk_t len, ext4_fsblk_t pblk,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0unsigned int status)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0unsigned int status, bool pre_search)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct extent_status *es;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct extent_status chkes, newes;
> > @@ -1043,6 +1043,21 @@ void ext4_es_cache_extent(struct inode *inode, e=
xt4_lblk_t lblk,
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(end < lblk);
> > =C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Avoid taking i_es_lock for writing if t=
he entire extent is already
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * cached. The write-locked search below r=
echecks after a miss.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pre_search) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read_lock(&EXT=
4_I(inode)->i_es_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0es =3D __es_tr=
ee_search(&EXT4_I(inode)->i_es_tree.root, lblk);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (es && es->=
es_lblk <=3D lblk && ext4_es_end(es) >=3D end &&
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
!__es_check_extent_status(es, status, NULL)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0read_unlock(&EXT4_I(inode)->i_es_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read_unlock(&E=
XT4_I(inode)->i_es_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0write_lock(&EXT4_I(inode)->i_es_lock)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0es =3D __es_tree_search(&EXT4_I(inode=
)->i_es_tree.root, lblk);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (es && es->es_lblk <=3D end) {
> > diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> > index f3396cf32b446..c2da72e3c82ba 100644
> > --- a/fs/ext4/extents_status.h
> > +++ b/fs/ext4/extents_status.h
> > @@ -139,7 +139,7 @@ extern void ext4_es_insert_extent(struct inode *ino=
de, ext4_lblk_t lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool delalloc_reserv=
e_used);
> > =C2=A0extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t=
 lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t len, ext4_fsbl=
k_t pblk,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int status);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int status, bool pre_se=
arch);
> > =C2=A0extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_=
t lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk_t len);
> > =C2=A0extern void ext4_es_find_extent_range(struct inode *inode,
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index ce99807c5f5b2..d43266c489785 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -523,7 +523,7 @@ static int ext4_map_query_blocks_next_in_leaf(handl=
e_t *handle,
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (retval <=3D 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_c=
ache_extent(inode, map->m_lblk, map->m_len,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, statu=
s);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, statu=
s, true);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ma=
p->m_len;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0
> > @@ -546,11 +546,11 @@ static int ext4_map_query_blocks_next_in_leaf(han=
dle_t *handle,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0status =3D=3D status2) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_c=
ache_extent(inode, map->m_lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_len +=
 map2.m_len, map->m_pblk,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status, true);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0map->m_le=
n +=3D map2.m_len;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_c=
ache_extent(inode, map->m_lblk, map->m_len,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, statu=
s);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, statu=
s, true);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return map->m_len;
> > @@ -562,6 +562,13 @@ int ext4_map_query_blocks(handle_t *handle, struct=
 inode *inode,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int status;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int retval;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int orig_mlen =3D map->m_len=
;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * ext4_ext_map_blocks() may have already =
cached the full extent, so
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * search first to avoid taking i_es_lock =
for writing. The indirect
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * path does not prepopulate the ES tree a=
fter the initial lookup miss.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0bool pre_search =3D ext4_test_inode_flag(i=
node,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0EXT4_INODE_EXTENTS);
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0flags &=3D EXT4_EX_QUERY_FILTER;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext4_test_inode_flag(inode, EXT4_=
INODE_EXTENTS))
> > @@ -593,7 +600,7 @@ int ext4_map_query_blocks(handle_t *handle, struct =
inode *inode,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =
=3D map->m_flags & EXT4_MAP_UNWRITTEN ?
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0EXTENT_STATUS_UNWRITTEN : E=
XTENT_STATUS_WRITTEN;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_c=
ache_extent(inode, map->m_lblk, map->m_len,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, statu=
s);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, statu=
s, pre_search);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =
=3D ext4_map_query_blocks_next_in_leaf(handle, inode, map,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0or=
ig_mlen);
> > --=C2=A0
> > 2.39.5 (Apple Git-154)
> --=C2=A0
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>=C2=A0
