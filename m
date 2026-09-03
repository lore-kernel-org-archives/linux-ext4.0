Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA8B49DB88;
	Thu,  3 Sep 2026 12:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437649; cv=none; b=roqBTzEcaW5zIkGhhZzITpX0tPfcgwn1dfzTvPFdc+B6toggkN+FeltocRaFj40lHnBeD7RoME50m3wYd/m2WKHOQmZcaLf6Tk/YRcYd20lRff1d9Mxpx7cAHc77eCxRTqG4z7id5GF5T2gHljioQ5/f7lRQTXztlmdP14AfHNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437649; c=relaxed/simple;
	bh=mCUhuI/r8B4YSh7D45AOKbywZ0ii0dLNWcLtZW8HV5Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=P4BRs6R40AOfHOly8swp/sDpfA6HaGFOM3wGK6feaaSEWAALvDFpDLOsVnlgMRDTOR5e+LjbCijwezpnNt/W6h2teMu6ttK4ZcVzflL8RHe+12Cl5yQgtbj9ubVDcB/K7cqLpm4Gvv508XM2LLD7pPxKnnFcwnUmjwMtk4Xihq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Yki8kjdP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Yki8kjdP"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683AWhpZ864766;
	Thu, 3 Sep 2026 12:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iFqGvQ
	djq9fXkjQD7sQlJ3fOggXicU9dOlAznsVYKAM=; b=Yki8kjdPzWQqaiwyIHOh25
	DVRdJ6i5TYTT7eVm7GSwo20ssk9lD9+DQZQA7w4Vv8qjujtXIQuu1vI6ZOBHcgSI
	wJMS9oUqvGErL3A7iGO4Lahf51MOckA3L6UaLVcfkLcgjPfy6kd6XgOqZXwCwvTe
	HOFRV7xnGblLz5bwrxuZa2sU/7U3oistQlligmY3CT0Ta74OZ2TxjmkJvWlU3xc0
	ZsALxKiEqfX1B2PouxHCP8rOrcc+1YKOaV6/t8t1fa9+FXZv10dNBR3Y34QHDqg3
	0CLh1iXFlFT2vU7CKTh6WkK1fp9SHtamfBqGrb9nOr5kORt9K3+Zwrf0kd8/03Mw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq3rmphx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 12:13:08 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683CBSne004008;
	Thu, 3 Sep 2026 12:13:07 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcceyfbwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 12:13:07 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683CD7gU30737026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 12:13:07 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A10458062;
	Thu,  3 Sep 2026 12:13:07 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E6AB58057;
	Thu,  3 Sep 2026 12:13:00 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.61.240.230])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  3 Sep 2026 12:12:59 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data
 directly
From: Venkat <venkat88@linux.ibm.com>
In-Reply-To: <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
Date: Thu, 3 Sep 2026 17:42:47 +0530
Cc: Chao Shi <coshi036@gmail.com>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Zhang Yi <yi.zhang@huaweicloud.com>, Bob Copeland <me@bobcopeland.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev,
        linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9CC2EE8A-9F67-408A-87A1-62AF671B4BFB@linux.ibm.com>
References: <cover.1785951556.git.coshi036@gmail.com>
 <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
 <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
To: Joseph Qi <jiangqi903@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=EIc2FVZC c=1 sm=1 tr=0 ts=6a996455 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8
 a=JfrnYn6hAAAA:8 a=VnNF1IyMAAAA:8 a=coiGVfEO3YzgxE8FU1AA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEwNCBTYWx0ZWRfXyKuSdoGmh/Nq
 IPML2wwBVdQ02glXEXZmO/3Gcwts95LNdPQydqKfAjBQWdep6E91onUd+J4MJUhaoYUhKgZDJ7t
 ODd1GQQEREis+HY+I3CfmdR4IhQjm7TR+gDqiStGALr1YqR5BmD3YovdFDYc4TBxzFEH2aC5+3o
 M0RRR2BOXzCxQpI91Aucru1o8LeVeXqToMSseDP5RFql0yf8NicAd1tCbmCtn8f/+ImKU7tE7Bh
 NFqKIpcdmo9ZRhTD85DE/k4tc6un2DgpzAWP3ltFWTsqXxsDVR6tjKub3XRfSh+k+m51ONEb0yN
 W6Av3S3sA5l16Vtl9GCardfo9wkrftfZjqsEw6B0M533O7KClnuk3O6rl5+SB3cAly3GmGa7Ts/
 YaIZNit3VR5A0xg4K/yRG7A3BUEux9zuztqXrHrduhHOdaxGvL8se51QBM5QCWkuKyeZ5qtRqle
 SucEVMrzn4NLWgSJ0ag==
X-Proofpoint-GUID: -g_v9bnlwMHKB6xrpSO-1MAOKijKKg7E
X-Proofpoint-ORIG-GUID: 4ujC3OIThFmieW3YLQ-qLI07Afazpx4q
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEwNCBTYWx0ZWRfX47SaPMa0aSY5
 ifmUYp1R/F7hR6CrRAvtLBuLaMBNEu+UiucOuTgK52RgzO01C4NSe9CMn/e0DgSx9SwNUdIEyJV
 u2QqCvHbWB8w5hkjtEEzpjnJ7tPs6V4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_03,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030104



> On 1 Sep 2026, at 9:07=E2=80=AFAM, Joseph Qi <jiangqi903@gmail.com> =
wrote:
>=20
>=20
>=20
> On 8/7/26 12:58 AM, Chao Shi wrote:
>> When a metadata buffer has to be copied out before it can be =
journalled,
>> jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather =
than
>> the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() =
makes
>> the shadow buffer point at a slab folio.
>>=20
>> That is not something the buffer_head layer can reason about.  A slab =
folio
>> overloads ->mapping, so a shadow buffer looks like it belongs to an
>> address_space when it does not.  buffer_set_crypto_ctx() already has =
to
>> work around this, and it is the reason mark_buffer_write_io_error() =
cannot
>> be called on a shadow buffer today.
>>=20
>> Point the shadow buffer at the frozen data itself instead: leave =
b_folio
>> NULL, which it already is out of alloc_buffer_head(), and set b_data. =
 The
>> previous patch taught fs/buffer.c to submit such a buffer.  =
folio_set_bh()
>> is now needed on only one path - the one that journals the page cache =
copy
>> directly - so it moves there, and new_folio, new_offset and the flag =
that
>> used to pick between them all go away.
>>=20
>> The two commit-path checksum helpers reach the shadow buffer's =
contents
>> through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a =
buffer
>> with or without a folio.  Memory outside the page cache is always =
mapped,
>> so for those there is nothing to map or unmap.  Mapping it anyway =
would be
>> worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
>> kmap_local_page() hands back a one page mapping even for such memory, =
which
>> is not enough for a buffer bigger than a page.
>>=20
>> Tested with ext4 mounted data=3Djournal,journal_checksum on a =
metadata_csum
>> filesystem, writing files whose every block begins with the JBD2 =
magic so
>> that escaping forces the copy-out, then crashing with sysrq-b without
>> unmounting and replaying the journal on the next mount.  Recovery
>> completed, the file contents matched, e2fsck -fn was clean, and an
>> instrumented build confirmed the b_folio =3D=3D NULL path was taken.
>>=20
>> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Acked-by: Weidong Zhu <weizhu@fiu.edu>
>> Signed-off-by: Chao Shi <coshi036@gmail.com>
>> ---
>> fs/jbd2/commit.c            |  8 ++++----
>> fs/jbd2/journal.c           | 29 +++++++++++++++++------------
>> include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
>> 3 files changed, 50 insertions(+), 16 deletions(-)
>>=20
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index 3029cb6f6d64..0c85af91f9b2 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, =
struct buffer_head *bh)
>> char *addr;
>> __u32 checksum;
>>=20
>> - addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
>> + addr =3D kmap_local_bh(bh);
>> checksum =3D crc32_be(crc32_sum, addr, bh->b_size);
>> - kunmap_local(addr);
>> + kunmap_local_bh(bh, addr);
>>=20
>> return checksum;
>> }
>> @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t =
*j, journal_block_tag_t *tag,
>> return;
>>=20
>> seq =3D cpu_to_be32(sequence);
>> - addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
>> + addr =3D kmap_local_bh(bh);
>> csum32 =3D jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
>> csum32 =3D jbd2_chksum(csum32, addr, bh->b_size);
>> - kunmap_local(addr);
>> + kunmap_local_bh(bh, addr);
>>=20
>> if (jbd2_has_feature_csum3(j))
>> tag3->t_checksum =3D cpu_to_be32(csum32);
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 09efa337649e..6e05dc47e20a 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -327,8 +327,6 @@ int =
jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>> {
>> int do_escape =3D 0;
>> struct buffer_head *new_bh;
>> - struct folio *new_folio;
>> - unsigned int new_offset;
>> struct buffer_head *bh_in =3D jh2bh(jh_in);
>> journal_t *journal =3D transaction->t_journal;
>>=20
>> @@ -348,24 +346,31 @@ int =
jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>> /* keep subsequent assertions sane */
>> atomic_set(&new_bh->b_count, 1);
>>=20
>> + /*
>> + * b_frozen_data is slab memory, not page cache, so when we use it =
the
>> + * shadow buffer gets no folio at all: b_folio stays NULL from the
>> + * allocation and b_data points straight at the copy.  Pointing it =
at
>> + * the slab folio instead would hand its overloaded ->mapping to
>> + * anything that goes looking for an address_space.
>> + */
>> +
>> spin_lock(&jh_in->b_state_lock);
>> /*
>> * If a new transaction has already done a buffer copy-out, then
>> * we use that version of the data for the commit.
>> */
>> if (jh_in->b_frozen_data) {
>> - new_folio =3D virt_to_folio(jh_in->b_frozen_data);
>> - new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen_data);
>> do_escape =3D jbd2_data_needs_escaping(jh_in->b_frozen_data);
>> if (do_escape)
>> jbd2_data_do_escape(jh_in->b_frozen_data);
>> + new_bh->b_data =3D jh_in->b_frozen_data;
>> } else {
>> + struct folio *folio =3D bh_in->b_folio;
>> + unsigned int offset =3D offset_in_folio(folio, bh_in->b_data);
>> char *tmp;
>> char *mapped_data;
>>=20
>> - new_folio =3D bh_in->b_folio;
>> - new_offset =3D offset_in_folio(new_folio, bh_in->b_data);
>> - mapped_data =3D kmap_local_folio(new_folio, new_offset);
>> + mapped_data =3D kmap_local_folio(folio, offset);
>> /*
>> * Fire data frozen trigger if data already wasn't frozen. Do
>> * this before checking for escaping, as the trigger may modify
>> @@ -379,8 +384,10 @@ int =
jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>> /*
>> * Do we need to do a data copy?
>> */
>> - if (!do_escape)
>> + if (!do_escape) {
>> + folio_set_bh(new_bh, folio, offset);
>> goto escape_done;
>> + }
>>=20
>> spin_unlock(&jh_in->b_state_lock);
>> tmp =3D kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
>> @@ -391,7 +398,7 @@ int =
jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>> }
>>=20
>> jh_in->b_frozen_data =3D tmp;
>> - memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
>> + memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
>> /*
>> * This isn't strictly necessary, as we're using frozen
>> * data for the escaping, but it keeps consistency with
>> @@ -400,13 +407,11 @@ int =
jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>> jh_in->b_frozen_triggers =3D jh_in->b_triggers;
>>=20
>> copy_done:
>> - new_folio =3D virt_to_folio(jh_in->b_frozen_data);
>> - new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen_data);
>> jbd2_data_do_escape(jh_in->b_frozen_data);
>> + new_bh->b_data =3D jh_in->b_frozen_data;
>> }
>>=20
>> escape_done:
>> - folio_set_bh(new_bh, new_folio, new_offset);
>> new_bh->b_size =3D bh_in->b_size;
>> new_bh->b_bdev =3D journal->j_dev;
>> new_bh->b_blocknr =3D blocknr;
>> diff --git a/include/linux/buffer_head.h =
b/include/linux/buffer_head.h
>> index 699970b4bbf2..20b8fca1abfa 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const =
struct buffer_head *bh)
>> return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
>> }
>>=20
>> +/**
>> + * kmap_local_bh - Map the data of a buffer.
>> + * @bh: The buffer.
>> + *
>> + * Buffers usually live in the page cache, but a few are built over =
memory
>> + * which is not.  Those carry no folio and b_data is already a =
kernel address
>> + * which is always mapped, so there is nothing to do for them.  Pair =
with
>> + * kunmap_local_bh().
>> + *
>> + * Return: A pointer to the buffer's data.
>> + */
>> +static inline void *kmap_local_bh(const struct buffer_head *bh)
>> +{
>> + if (!bh->b_folio)
>> + return bh->b_data;
>> + return kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +}
>> +
>> +/**
>> + * kunmap_local_bh - Unmap the data of a buffer.
>> + * @bh: The buffer.
>> + * @addr: The address returned by kmap_local_bh().
>> + */
>> +static inline void kunmap_local_bh(const struct buffer_head *bh, =
void *addr)
>> +{
>> + if (bh->b_folio)
>> + kunmap_local(addr);
>> +}
>> +
>> /* If we *know* page->private refers to buffer_heads */
>> #define page_buffers(page) \
>> ({ \
>=20
> When tested ocfs2 on next-20260831, I've encountered the following =
NULL
> pointer dereference:
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>  Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
>=20
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) =
in
> __bh_submit(). But jbd2 shadow buffers have a NULL b_folio since =
commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio. So submitting such a buffer during journal commit =
oopses.
>=20
> A simple fix:
>=20
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, =
blk_opf_t opf,
>=20
> bio =3D bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>=20
> - if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> + if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +    op_is_write(opf))
> bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>=20
> if (IS_ENABLED(CONFIG_FS_ENCRYPTION))

IBM CI has also reported this issue, and with this patch, issue is =
fixed.

Please add below tag.

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Regards,
Venkat.
>=20
> Thanks,
> Joseph

