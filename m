Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5753921D0
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 11:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784029869; cv=none; b=cd5ka/qn7PlA7jXQRxqHiWlonyxy6UvQcV9CErs5VVLZhvnAzqfoYhP+TRxPjDtHSgs/9o1G+KwX7pz2Tjt9jueuMElfDDDCWpvIKLT+rcZupBInjL70YXy8h+3tbrS5G3Iwts045CrdYjSyqcJJ1IdQMnsNHNQ++X7MORjylzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784029869; c=relaxed/simple;
	bh=bUvNFOr2yUHxftb2BcbHN/YRaMA8HIhfhHmU5QxtmeY=;
	h=From:Mime-Version:References:Date:Message-Id:To:Cc:Subject:
	 In-Reply-To:Content-Type; b=fHLhhazIc8j+ubPFSHkSTcK7acrdgbj1bCPGQw5ouZpiRALEa+ri/OFzTLrVc6hO/oazTE6IUDDaKl2DbumHDy2CWF3iPGwbuC+Jyrekr7kRxLrfv+Rp8RocQnvC0EhynRscJzUQKg9pKUOiq5OCrBjt6kvOv4Bxg+NYBDexT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=bvDEAb1j; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="bvDEAb1j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784029862; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bUvNFOr2yUHxftb2BcbHN/YRaMA8HIhfhHmU5QxtmeY=;
 b=bvDEAb1jJvH6MXW5rMhFWmrTv8OYyH5VtqSkSbaY2WeUlXJ7ljzKCG4z+dmSRrvbApDrwW
 bTpIfSkTbOrPNnRwxAJpBoEX7vf7MLQ05oNSg3Gxi9vJH3I41VdbC7zbOgHrYOdf5eOBWi
 Kj9Ofaqh7rreAeST9WbEya6j+vpgtE+n1FW/HsrTl28okhXIOjZRtx1X6tNxtciJ7hZyQ4
 vof5/8yPvMpbyTtRFHvZgx1onRdINTo439MW37Jp52731yk7siqgKV8OJnJT7ajJ3+vb9+
 wUhG8JfBn1a4IoRjt0Zv6JTVRfrYiwvmgPzIReznD64w7DvQmsrXSVSUcFh/lw==
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260714114358.93335-1-changfengnan@bytedance.com>
Date: Tue, 14 Jul 2026 19:50:58 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.64a50ffd.320d.4063.8c65.be19a44f77b6@bytedance.com>
To: <tytso@mit.edu>
Cc: <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ext4: fix DIO read slowdown after extent status reclaim
In-Reply-To: <20260714114358.93335-1-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+16a5622a4+20a1ab+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: multipart/mixed;
 boundary=4d8c4ed831b15cf8143b80cdaff9471708fe2317d914c9888fb86ad1e8b4

--4d8c4ed831b15cf8143b80cdaff9471708fe2317d914c9888fb86ad1e8b4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

This issue can be reproduced using the script attached.

> From: "Fengnan Chang"<changfengnan@bytedance.com>
> Date:=C2=A0 Tue, Jul 14, 2026, 19:44
> Subject:=C2=A0 [RFC PATCH 0/2] ext4: fix DIO read slowdown after extent s=
tatus reclaim
> To: <tytso@mit.edu>
> Cc: <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.=
cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com=
>, <linux-ext4@vger.kernel.org>, "Fengnan Chang"<changfengnan@bytedance.com=
>
> Hi,
>=C2=A0
> This series fixes a slowdown in ext4 random direct reads that appears aft=
er
> extent status entries are reclaimed.
>=C2=A0
> Problem:
>=C2=A0
> The extent status tree and the extent-tree leaf buffers do not have the s=
ame
> lifetime. =C2=A0Memory pressure can reclaim an extent status entry while =
the
> corresponding metadata buffer_head stays in the buffer cache with its
> "verified" flag set. =C2=A0The next lookup then takes this path:
>=C2=A0
> =C2=A0 1. ext4_es_lookup_extent() misses--the entry was reclaimed.
> =C2=A0 2. ext4_find_extent() reads the leaf, but __read_extent_tree_block=
()
> =C2=A0 =C2=A0 =C2=A0returns the already verified buffer without calling
> =C2=A0 =C2=A0 =C2=A0ext4_cache_extents().
> =C2=A0 3. ext4_ext_map_blocks() returns the part of the extent starting a=
t
> =C2=A0 =C2=A0 =C2=A0m_lblk, and ext4_map_query_blocks() caches only that =
suffix.
>=C2=A0
> Reads to earlier blocks in the same extent miss the extent status tree ag=
ain
> and walk the extent tree on every I/O.
>=C2=A0
> Testing with fio 4K random direct reads (io_uring, iodepth=3D128) on a
> 128 GiB file (75 on-disk extents) after triggering extent status reclamat=
ion:
>=C2=A0
> =C2=A0 Baseline (full extent status cache): 525k IOPS, clat avg 241.96 us
> =C2=A0 After extent status reclaim (no patch): 296k IOPS, clat avg 428.69=
 us
> =C2=A0 Degradation: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0-43.6% IOPS, +77.2% latency
>=C2=A0
> Fix:
>=C2=A0
> Patch 1 makes ext4_es_cache_extent() report whether the requested range i=
s
> cached when it returns. =C2=A0The result is passed through ext4_find_exte=
nt() and
> the internal map flags, so ext4_map_query_blocks() can skip the second ca=
che
> update when the leaf was fully cached. =C2=A0If population was skipped or=
 an
> insertion failed, the existing query cache remains as a fallback. =C2=A0T=
his avoids
> taking i_es_lock for writing a second time after a leaf read has already
> populated the extent status tree.
>=C2=A0
> Patch 2 handles the extent status lookup miss described above.
> ext4_iomap_begin() opts into a new EXT4_GET_BLOCKS_CACHE_READ_EXTENT flag=
 for
> DIO reads. =C2=A0If the leaf lookup did not populate the extent status tr=
ee,
> ext4_ext_map_blocks() caches the full matching written extent (ee_block,
> ee_len) before cropping the mapping to the requested block. =C2=A0Later r=
eads
> within that extent can then use the extent status tree directly.
>=C2=A0
> Fengnan Chang (2):
> =C2=A0 ext4: avoid caching an extent twice after a leaf read
> =C2=A0 ext4: cache the full extent after a DIO extent status miss
>=C2=A0
> =C2=A0fs/ext4/ext4.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A09 +++++++=
+-
> =C2=A0fs/ext4/ext4_extents.h =C2=A0 | =C2=A04 +++-
> =C2=A0fs/ext4/extents.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| 43 +++++++++++++++++=
+++++++++++++++--------
> =C2=A0fs/ext4/extents_status.c | 20 +++++++++++++------
> =C2=A0fs/ext4/extents_status.h | =C2=A06 +++---
> =C2=A0fs/ext4/inode.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 40 ++++++++++++=
++++++++++++++-----------
> =C2=A06 files changed, 91 insertions(+), 31 deletions(-)
>=C2=A0
> --=C2=A0
> 2.39.5 (Apple Git-154)
>=C2=A0

--4d8c4ed831b15cf8143b80cdaff9471708fe2317d914c9888fb86ad1e8b4
Content-Disposition: attachment; filename="ext4_es.sh"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="ext4_es.sh"

IyEvdXNyL2Jpbi9lbnYgYmFzaAoKc2V0IC1lCgpGSUxFPSR7RklMRTotL21udC94eH0KRVNfRElS
PSR7RVNfRElSOi0vbW50L2V4dDQtZXMtcmVwcm99CkVTX0VYVEVOVFM9JHtFU19FWFRFTlRTOi0y
MDAwMH0KRVNfQ1BVPSR7RVNfQ1BVOi0wfQpSVU5USU1FPSR7UlVOVElNRTotMTB9CklPREVQVEg9
JHtJT0RFUFRIOi0xMjh9CkZJTz0ke0ZJTzotL2RhdGEwMC9jaGFuZ2ZlbmduYW4vZmlvL2Zpb30K
CmlmICgoIEVVSUQgIT0gMCApKTsgdGhlbgoJZWNobyAiUGxlYXNlIHJ1biBhcyByb290OiBzdWRv
ICQwIgoJZXhpdCAxCmZpCgppZiBbWyAhIC1mICIkRklMRSIgXV07IHRoZW4KCWVjaG8gIlRlc3Qg
ZmlsZSBkb2VzIG5vdCBleGlzdDogJEZJTEUiCglleGl0IDEKZmkKCm1rZGlyIC1wICIkRVNfRElS
IgoKaWYgW1sgJChzdGF0IC1jICVkICIkRklMRSIpICE9ICQoc3RhdCAtYyAlZCAiJEVTX0RJUiIp
IF1dOyB0aGVuCgllY2hvICJGSUxFIGFuZCBFU19ESVIgbXVzdCBiZSBvbiB0aGUgc2FtZSBmaWxl
c3lzdGVtIgoJZXhpdCAxCmZpCgpERVY9JChiYXNlbmFtZSAiJChmaW5kbW50IC1uIC1vIFNPVVJD
RSAtVCAiJEZJTEUiKSIpCkVTX0lORk89L3Byb2MvZnMvZXh0NC8kREVWL2VzX3Nocmlua2VyX2lu
Zm8KVEFSR0VUX0lOTz0kKHN0YXQgLWMgJWkgIiRGSUxFIikKRVNfRklMRT0KCmVzX29iamVjdHMo
KQp7Cglhd2sgJyQyID09ICJvYmplY3RzIiB7IHByaW50ICQxOyBleGl0IH0nICIkRVNfSU5GTyIK
fQoKZXNfbWF4X2lub2RlKCkKewoJYXdrICckMiA9PSAiaW5vZGUiIHsgcHJpbnQgJDE7IGV4aXQg
fScgIiRFU19JTkZPIgp9CgpjbGVhbnVwKCkKewoJaWYgW1sgLW4gIiRFU19GSUxFIiBdXTsgdGhl
bgoJCXJtIC1mICIkRVNfRklMRSIKCWZpCn0KdHJhcCBjbGVhbnVwIEVYSVQKCmNvbnN0cnVjdF9l
c19vYmplY3RzKCkKewoJRVNfRklMRT0kKG1rdGVtcCAiJEVTX0RJUi9leHQ0LWVzLlhYWFhYWCIp
Cgl0YXNrc2V0IC1jICIkRVNfQ1BVIiBweXRob24zIC1jICcKaW1wb3J0IG9zCmltcG9ydCBzeXMK
CnBhdGggPSBzeXMuYXJndlsxXQpjb3VudCA9IGludChzeXMuYXJndlsyXSkKZmQgPSBvcy5vcGVu
KHBhdGgsIG9zLk9fUkRXUiB8IG9zLk9fQ1JFQVQgfCBvcy5PX1RSVU5DLCAwbzYwMCkKZm9yIGkg
aW4gcmFuZ2UoY291bnQpOgogICAgb3MucG9zaXhfZmFsbG9jYXRlKGZkLCBpICogODE5MiwgNDA5
NikKb3MuY2xvc2UoZmQpCicgIiRFU19GSUxFIiAiJEVTX0VYVEVOVFMiCgoJdGFza3NldCAtYyAi
JEVTX0NQVSIgZmlsZWZyYWcgLXYgIiRFU19GSUxFIiA+L2Rldi9udWxsCglleGVjIDg8IiRFU19G
SUxFIgoKCWVjaG8gIkNvbnN0cnVjdGVkICQoZXNfb2JqZWN0cykgRVMgb2JqZWN0cyB3aXRoICRF
U19FWFRFTlRTIGV4dGVudHMiCn0KCnJ1bl9yYW5kcmVhZCgpCnsKCWxvY2FsIG5hbWU9JDEKCgki
JEZJTyIgLS1uYW1lPSIkbmFtZSIgXAoJCS0tZmlsZW5hbWU9IiRGSUxFIiBcCgkJLS1ydz1yYW5k
cmVhZCBcCgkJLS1icz00ayBcCgkJLS1kaXJlY3Q9MSBcCgkJLS1pb2VuZ2luZT1pb191cmluZyBc
CgkJLS1pb2RlcHRoPSIkSU9ERVBUSCIgXAoJCS0tbnVtam9icz0xIFwKCQktLXRpbWVfYmFzZWQ9
MSBcCgkJLS1ydW50aW1lPSIkUlVOVElNRSIgXAoJCS0taW52YWxpZGF0ZT0wIFwKCQktLW5vcmFu
ZG9tbWFwPTAgXAoJCS0tcmFuZHJlcGVhdD0xIFwKCQktLXJlYWRvbmx5IFwKCQktLWFsbG93X2Zp
bGVfY3JlYXRlPTAgXAoJCS0tZ3JvdXBfcmVwb3J0aW5nIFwKCQktLWV0YT1uZXZlcgp9CgplY2hv
ICJLZXJuZWw6ICAgICQodW5hbWUgLXIpIgplY2hvICJGaWxlOiAgICAgICRGSUxFIgplY2hvICJF
UyBkaXI6ICAgICRFU19ESVIiCmVjaG8gIkVTIGV4dGVudHM6ICRFU19FWFRFTlRTIG9uIENQVSAk
RVNfQ1BVIgplY2hvICJmaW86ICAgICAgICQoJEZJTyAtLXZlcnNpb24pIgoKIyBLZWVwIHRoZSB0
YXJnZXQgaW5vZGUgYWxpdmUgd2hpbGUgdGhlIEVTIHNocmlua2VyIHJ1bnMuCmV4ZWMgOTwiJEZJ
TEUiCgplY2hvCmVjaG8gIlsxLzNdIE5vcm1hbCBwZXJmb3JtYW5jZSBiZWZvcmUgZHJvcHBpbmcg
RVMgY2FjaGUiCnJ1bl9yYW5kcmVhZCBub3JtYWxfYmVmb3JlX2Ryb3AKCmVjaG8KZWNobyAiWzIv
M10gQ29uc3RydWN0IEVTIG9iamVjdHMgaW4gJEVTX0RJUiBhbmQgZHJvcCBzbGFiIGNhY2hlcyIK
ZWNobyAiRHJvcCBzbGFiIGNhY2hlcyBvbmx5LiBEbyBub3QgdXNlIGRyb3BfY2FjaGVzPTMgaGVy
ZS4iCmNvbnN0cnVjdF9lc19vYmplY3RzCnN5bmMKdGFza3NldCAtYyAiJEVTX0NQVSIgc2ggLWMg
J2VjaG8gMiA+IC9wcm9jL3N5cy92bS9kcm9wX2NhY2hlcycKCiMgUmVsZWFzZSB0aGUgaGVscGVy
IGlub2RlIHNvIGFueSByZW1haW5pbmcgb2JqZWN0cyBiZWxvbmcgdG8gdGhlIHJlYWwgd29ya2xv
YWQuCmV4ZWMgODwmLQpybSAtZiAiJEVTX0ZJTEUiCkVTX0ZJTEU9CgplY2hvICJFUyBzdGF0ZSBh
ZnRlciBkcm9wIGFuZCBoZWxwZXIgY2xlYW51cDoiCnNlZCAtbiAnMSwxMHAnICIkRVNfSU5GTyIK
b2JqZWN0cz0kKGVzX29iamVjdHMpCmlmIFtbICQoZXNfbWF4X2lub2RlKSA9PSAiJFRBUkdFVF9J
Tk8iIF1dIHx8ICgoIG9iamVjdHMgPiA0ICkpOyB0aGVuCgllY2hvICJUYXJnZXQgaW5vZGUgJFRB
UkdFVF9JTk8gc3RpbGwgb3ducyBFUyBvYmplY3RzOyBzdG9wIGluc3RlYWQgb2YgcnVubmluZyBh
IGZhbHNlIGFibm9ybWFsIGNhc2UiCglleGl0IDEKZmkKZWNobyAiVGFyZ2V0IGlub2RlICRUQVJH
RVRfSU5PIGhhcyBiZWVuIHJlbW92ZWQgZnJvbSB0aGUgRVMgc2hyaW5rZXIgbGlzdCIKCmVjaG8K
ZWNobyAiWzMvM10gUGVyZm9ybWFuY2UgaW1tZWRpYXRlbHkgYWZ0ZXIgZHJvcHBpbmcgRVMgY2Fj
aGUiCnJ1bl9yYW5kcmVhZCBhYm5vcm1hbF9hZnRlcl9kcm9wCgpleGVjIDk8Ji0KCiMgUmVzdG9y
ZSB0aGUgY29tcGFjdCBmdWxsLWZpbGUgRVMgdHJlZSBmb3IgdGhlIG5leHQgcnVuLgpmaWxlZnJh
ZyAtdiAiJEZJTEUiID4vZGV2L251bGwK

--4d8c4ed831b15cf8143b80cdaff9471708fe2317d914c9888fb86ad1e8b4--
