Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5F139D3FC
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 03:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784689269; cv=none; b=MD4H1KQ2S/QlAJmMbfz+1AfC2UclJCCBXghuYeKqkH9kbKtPQRp0rSbSOB65kNfnLDDJDnodBSQl7Ud9JiXJ1mRSdr7zbWPA+1p5FzzVLROX5KQF3A9HDOUSKvALNW3AtA/IHXob3BRxUqVHytWpmN7Jce77wwiO0bB1JLI5yvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784689269; c=relaxed/simple;
	bh=LOQbljvZmkE3kHtILlUSyJeNtumRU1e5oImj6NtAbLQ=;
	h=Message-Id:To:Cc:From:References:Content-Type:Date:Subject:
	 Mime-Version:In-Reply-To; b=Y9ITX/zSZRTGfeSR9jjYxsEdMtHtal/dAfM6MmlWAdqXuthFa94tFa7FrJICU6YTGdrXBTkW4gmYUjR+jiOF4pn+WaY7Dmjp7rHR8Yi6spRaz3QDIEp4pJON0oiK95KYPqxW+sF0eDwIFGbV9GOU/r0rK4s1VQWcLSABCQC1c6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=pApwXW3G; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="pApwXW3G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784689259; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=LOQbljvZmkE3kHtILlUSyJeNtumRU1e5oImj6NtAbLQ=;
 b=pApwXW3G5IneJVxpvq9UyIJPoUk8tZV3FcbV2GbyGczOy7KUfWoOuqWJ3weQWELrnd8gt/
 l9o2AzaA4QB0CvSxTIiooM5mkm3cR1OtIAv3n4cC37gJk/u0Riz8TrSYDarr4Ox4r3++kj
 VwWdLPZSGCW+L/ouwFbVDMwpEGe6A11QqHqsVxWh1QXc9A3gStcwiIOqTDbYx/RFaPuE9i
 N+3LVxvH6bOQrqMev+BuCcV1flKKJkxMslEQqEkSOSQLNU/kS9x1J/pH8Eh5h2gyH89xGD
 me+6AmeeHrRf06OXkdhiSu8AttgBi8gilq0ZOEJRgQrudejtxI5MFwE6VJL4LA==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.61b2aa58.70d3.491a.bf4d.2ab068c26e69@bytedance.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>
From: "changfengnan" <changfengnan@bytedance.com>
References: <20260720075133.50539-1-changfengnan@bytedance.com>
	<8c443e8f-178f-4411-9027-320a14a40c80@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 11:00:53 +0800
Subject: Re: [PATCH] ext4: cache full extents during mapping lookup
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <8c443e8f-178f-4411-9027-320a14a40c80@huaweicloud.com>
X-Lms-Return-Path: <lba+16a603269+d6ff76+vger.kernel.org+changfengnan@bytedance.com>


> From: "Zhang Yi"<yi.zhang@huaweicloud.com>
> Date:=C2=A0 Tue, Jul 21, 2026, 15:43
> Subject:=C2=A0 Re: [PATCH] ext4: cache full extents during mapping lookup
> To: "Fengnan Chang"<changfengnan@bytedance.com>
> Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <tytso@=
mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@s=
use.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>
> On 7/20/2026 3:51 PM, Fengnan Chang wrote:
> > The extent status (ES) tree and extent tree leaf buffers are reclaimed
> > independently. =C2=A0An ES entry can be reclaimed while the leaf buffer=
 remains
> > cached with BH_Verified set.
> >=C2=A0
> > When this happens, ext4_es_lookup_extent() misses. =C2=A0Since the leaf=
 buffer
> > is already verified, __read_extent_tree_block() returns it without call=
ing
> > ext4_cache_extents(). =C2=A0ext4_ext_map_blocks() returns the part of t=
he extent
> > covered by the request, and ext4_map_query_blocks() caches only that ra=
nge.
> > Reads to other blocks in the same extent then keep missing the ES tree =
and
> > walking the extent tree.
> >=C2=A0
> > Cache the full extent in ext4_ext_map_blocks() before the returned mapp=
ing
> > is limited to the requested range. =C2=A0Check the ES tree under the re=
ad lock
> > first. =C2=A0If the full extent is not there, ext4_es_cache_extent() ch=
ecks
> > again under the write lock before inserting it.
> >=C2=A0
> > Do not do this when ext4_ext_map_blocks() is called with
> > EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE. =C2=A0NOCACHE paths can chan=
ge extent
> > mappings, so caching ranges outside the request can leave stale ES entr=
ies.
> > Cache both written and unwritten extents, as ext4_cache_extents() does.
> >=C2=A0
> > Tested with fio 4K random direct reads using libaio at iodepth 128 on a
> > 128 GiB file with 208 on-disk extents. =C2=A0The results are averages o=
f three
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
> > Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@byt=
edance.com
> > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
>=C2=A0
> Thank you for the patch! This overall looks good to me, just some minor
> suggestions below.
>=C2=A0
> > ---
> > =C2=A0fs/ext4/extents.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A09 +++++++++
> > =C2=A0fs/ext4/extents_status.c | 33 +++++++++++++++++++++++++++++++++
> > =C2=A0fs/ext4/extents_status.h | =C2=A03 +++
> > =C2=A03 files changed, 45 insertions(+)
> >=C2=A0
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 91c97af64b317..f43dd9c3bc44e 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4310,6 +4310,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct =
inode *inode,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk=
_t ee_block =3D le32_to_cpu(ex->ee_block);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_fsbl=
k_t ee_start =3D ext4_ext_pblock(ex);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
short ee_len;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int s=
tatus;
> > =C2=A0
> > =C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > @@ -4317,6 +4318,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct =
inode *inode,
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
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_cache_extent_if_missing(i=
node, ee_block,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0ee_len, ee_start,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0status);
>=C2=A0
> After this patch, I think the calls to ext4_es_cache_extent() in
> ext4_map_query_blocks_next_in_leaf() and ext4_map_query_blocks() can
> also be replaced with this helper.
>=C2=A0
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/*
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 * If the extent is initialized check whether the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 * caller wants to convert it to unwritten.
> > diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> > index 6e4a191e82191..83fe2068ab656 100644
> > --- a/fs/ext4/extents_status.c
> > +++ b/fs/ext4/extents_status.c
> > @@ -1082,6 +1082,39 @@ void ext4_es_cache_extent(struct inode *inode, e=
xt4_lblk_t lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_es_pblock(&chkes), ext4_es_status(&chkes))=
;
> > =C2=A0}
> > =C2=A0
> > +/*
> > + * Avoid taking i_es_lock for writing if the entire extent is already =
cached.
> > + * ext4_es_cache_extent() rechecks under the write lock if the cache c=
hanges
> > + * after this read-side check.
> > + */
> > +void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t =
lblk,
>=C2=A0
> I'd prefer to move this logic into ext4_es_cache_extent() and add a
> parameter(e.g., read_search) to control whether to do pre-search unbder
> the read lock. If the extent is likely to already exist on the status
> tree, we can pass 1. Sounds good?

ext4_es_cache_extent add a parameter=C2=A0 to control whether to do pre-sea=
rch
sounds good. =C2=A0
I have some questions about when to perform a pre-search.
Are you meaning that a pre-search should also be performed when
ext4_map_query_blocks_next_in_leaf and ext4_map_query_blocks call=C2=A0
ext4_es_cache_extent ?
ext4_map_query_blocks_next_in_leaf is ok , but I think it only makes sense
to perform a pre-search for ext4_es_cache_extent in ext4_map_query_blocks
when in extent mode, because in extent mode, the entire leaf is cached, so
it=E2=80=99s likely that the extent already exists=E2=80=94but this isn=E2=
=80=99t the case in indirect mode.
Right ?

I=E2=80=99d like to make the following change:

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b317..2ffb5027aa1ee 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -537,12 +537,12 @@ static void ext4_cache_extents(struct inode *inode,
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (prev && (=
prev !=3D lblk))
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ext4_es_cache_extent(inode, prev, lblk - prev, ~0,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 EXTENT_STATUS_HOLE);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 EXTENT_STATUS_HOLE, false);
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ext4_ext_=
is_unwritten(ex))
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 status =3D EXTENT_STATUS_UNWRITTEN;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_es_cache=
_extent(inode, lblk, len,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_ext_pblock(ex), s=
tatus);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_ext_pblock(ex), s=
tatus, false);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 prev =3D lblk=
 + len;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0}
@@ -4239,7 +4239,8 @@ static ext4_lblk_t ext4_ext_determine_insert_hole(str=
uct inode *inode,
=C2=A0insert_hole:
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Put just found gap into cache to speed=
 up subsequent requests */
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 ext_debug(inode, " -> %u:%u\n", hole_star=
t, len);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ext4_es_cache_extent(inode, hole_start, len, ~=
0, EXTENT_STATUS_HOLE);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ext4_es_cache_extent(inode, hole_start, len, ~=
0, EXTENT_STATUS_HOLE,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 false);
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Update hole_len to reflect hole size a=
fter lblk */
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (hole_start !=3D lblk)
@@ -4310,6 +4311,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inod=
e *inode,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t e=
e_block =3D le32_to_cpu(ex->ee_block);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_fsblk_t =
ee_start =3D ext4_ext_pblock(ex);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned shor=
t ee_len;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 unsigned int statu=
s;
=C2=A0
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
@@ -4317,6 +4319,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inod=
e *inode,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 * we sp=
lit out initialized portions during a write.
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 */
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ee_len =3D ex=
t4_ext_get_actual_len(ex);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 status =3D ext4_ex=
t_is_unwritten(ex) ?
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trace_ext4_ex=
t_show_extent(inode, ee_block, ee_start, ee_len);
=C2=A0
@@ -4328,6 +4332,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct ino=
de *inode,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ext_debug(inode, "%u fit into %u:%d -> %llu\n",
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_lblk, ee_block, ee=
_len, newblock);
=C2=A0
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 if (!(flags & (EXT4_GET_BLOCKS_CREATE |
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_EX_NOCACHE=
)))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ext4_es_cache_extent(inode, ee_block,=
 ee_len,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ee_start, status,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 true);
+
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /*
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=C2=A0 * If the extent is initialized check whether the
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=C2=A0 * caller wants to convert it to unwritten.
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 6e4a191e82191..5a03878b06160 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1023,7 +1023,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_=
lblk_t lblk,
=C2=A0 */
=C2=A0void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t len, ext4_fsblk_t pblk,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=C2=A0 unsigned int status)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=C2=A0 unsigned int status, bool pre_search)
=C2=A0{
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct extent_status *es;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct extent_status chkes, newes;
@@ -1043,6 +1043,21 @@ void ext4_es_cache_extent(struct inode *inode, ext4_=
lblk_t lblk,
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(end < lblk);
=C2=A0
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 /*
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Avoid taking i_es_lock for writing if the e=
ntire extent is already
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * cached. The write-locked search below reche=
cks after a miss.
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (pre_search) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 read_lock(&EXT4_I(=
inode)->i_es_lock);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 es =3D __es_tree_s=
earch(&EXT4_I(inode)->i_es_tree.root, lblk);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 if (es && es->es_l=
blk <=3D lblk && ext4_es_end(es) >=3D end &&
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 !__e=
s_check_extent_status(es, status, NULL)) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 read_unlock(&EXT4_I(inode)->i_es_lock);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 return;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 }
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 read_unlock(&EXT4_=
I(inode)->i_es_lock);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
+
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 write_lock(&EXT4_I(inode)->i_es_lock);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 es =3D __es_tree_search(&EXT4_I(inode)->i=
_es_tree.root, lblk);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (es && es->es_lblk <=3D end) {
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f3396cf32b446..c2da72e3c82ba 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -139,7 +139,7 @@ extern void ext4_es_insert_extent(struct inode *inode, =
ext4_lblk_t lblk,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool delalloc_reserve_use=
d);
=C2=A0extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lbl=
k,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ext4_lblk_t len, ext4_fsbl=
k_t pblk,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int status);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int status, bool pre_search=
);
=C2=A0extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lb=
lk,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t len);
=C2=A0extern void ext4_es_find_extent_range(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b2..341b7c649e133 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -523,7 +523,7 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t =
*handle,
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retval <=3D 0) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_es_cache=
_extent(inode, map->m_lblk, map->m_len,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, status);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, status, t=
rue);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return map->m=
_len;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0
@@ -546,11 +546,11 @@ static int ext4_map_query_blocks_next_in_leaf(handle_=
t *handle,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 status =3D=3D status2) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_es_cache=
_extent(inode, map->m_lblk,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 map->m_len +=
 map2.m_len, map->m_pblk,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status, true);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_len +=
=3D map2.m_len;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_es_cache=
_extent(inode, map->m_lblk, map->m_len,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, status);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, status, t=
rue);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return map->m_len;
@@ -562,6 +562,8 @@ int ext4_map_query_blocks(handle_t *handle, struct inod=
e *inode,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int status;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 int retval;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int orig_mlen =3D map->m_len;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 bool pre_search =3D ext4_test_inode_flag(inode=
,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0=C2=A0 EXT4_INODE_EXTENTS);
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 flags &=3D EXT4_EX_QUERY_FILTER;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ext4_test_inode_flag(inode, EXT4_INOD=
E_EXTENTS))
@@ -593,7 +595,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inod=
e *inode,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D ma=
p->m_flags & EXT4_MAP_UNWRITTEN ?
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXTENT_STATUS_UNWRITTEN : EXTENT=
_STATUS_WRITTEN;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_es_cache=
_extent(inode, map->m_lblk, map->m_len,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, status);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map->m_pblk, status, p=
re_search);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retval =3D ex=
t4_map_query_blocks_next_in_leaf(handle, inode, map,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 orig_mle=
n);
--=C2=A0

>=C2=A0
> Thanks,
> Yi.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t len, e=
xt4_fsblk_t pblk,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int statu=
s)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct extent_status *es;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk_t end;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0bool cached;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (EXT4_SB(inode->i_sb)->s_mount_state & =
EXT4_FC_REPLAY)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!len)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0end =3D lblk + len - 1;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (WARN_ON_ONCE(end < lblk))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0read_lock(&EXT4_I(inode)->i_es_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0es =3D __es_tree_search(&EXT4_I(inode)->i_=
es_tree.root, lblk);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cached =3D es && es->es_lblk <=3D lblk && =
ext4_es_end(es) >=3D end &&
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !__es_check_e=
xtent_status(es, status, NULL);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0read_unlock(&EXT4_I(inode)->i_es_lock);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cached)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_es_cache_=
extent(inode, lblk, len, pblk, status);
> > +}
> > +
> > =C2=A0/*
> > =C2=A0 * ext4_es_lookup_extent() looks up an extent in extent status tr=
ee.
> > =C2=A0 *
> > diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> > index f3396cf32b446..d8fab84911352 100644
> > --- a/fs/ext4/extents_status.h
> > +++ b/fs/ext4/extents_status.h
> > @@ -140,6 +140,9 @@ extern void ext4_es_insert_extent(struct inode *ino=
de, ext4_lblk_t lblk,
> > =C2=A0extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t=
 lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t len, ext4_fsbl=
k_t pblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int status);
> > +void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t =
lblk,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_lblk_t len, e=
xt4_fsblk_t pblk,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int statu=
s);
> > =C2=A0extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_=
t lblk,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk_t len);
> > =C2=A0extern void ext4_es_find_extent_range(struct inode *inode,
>=C2=A0
