Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E48847CA8B
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2026 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788255626; cv=none; b=pPZiYMgZ1gYG5cT78ZHNzr2d4+bEMsdLP9FaIvcaDiqY4e59LIs80CWz+tdC2Q/e+oxPLLicaPVeWm5n9Feywv/VkRUMcQis9RBUb0DcHqA6IE0fePI8v6hLK90J8HC9lS+VI/Nwjdjsn9JsJqNHqUJYK9//7bj2M4TUYuz+8Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788255626; c=relaxed/simple;
	bh=LYDyK4gBUGhJfGB+ZH+RtS0cX3I9N8ObCQUN7umLGYI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=StmqoQZcQB5dLZE9ss6qZFq5JHKAdDAPrh4b+q7mOZA+gteXhStVihgyt9fFBY0UPuED3yZWiw+ZqenqTImFzSSiuEWDrRw+06fhLzDALAblgjy/bdbEo1xIWY/puFf00KM37f2I9ThiW3VC7CSx61vBptZvML3akX7QBfct4KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=jzHDncbD; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="jzHDncbD"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c250c6a6a9aso715755766b.1
        for <linux-ext4@vger.kernel.org>; Tue, 01 Sep 2026 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1788255613; x=1788860413; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gqaM/xWZrmjVxtHMuNbvYOFbikFpFhXJm1PCXoXTv1A=;
        b=jzHDncbDaUVEuez2xI+8BYFonguSeHMlV0/XxYR0774hOK8hXQtuLIglaAvSE1NfPo
         EckrXxo9MHPzrJUA+7hN3nHUVIGx1JCkm1hgv+P8r1zyw7jApjyNyRhdFKkiX4mv3g96
         yL3u0d+gnHBmWP3MY0Rj174EC7lY6jVPvw66nV+goAYSNnOGCDmsNCCK+J5dKUxDfmnM
         EOqdDY9+fwd6ajhRFhhhMdoZakIuLI0s5neCDEiW7pYjsg695Zan+7qSQUUlc4VK9idw
         FI1OMe86a9VW9F7ir1on5bZRBFNGMyytaVUOmNCgsL2Azaa/T5wmEfc2yL5Y5qNUKxQx
         ScqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788255613; x=1788860413;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqaM/xWZrmjVxtHMuNbvYOFbikFpFhXJm1PCXoXTv1A=;
        b=akiTpAbmw3TL67Vmc9yXQkFGq58ItrpFd7Qh/NvpqVT1ekZS+dPnI1MNSo6z7+NvVV
         Ezak6ZkNtgGX42/gSs9wt2w02v/5azvGLf57PZFCKA5GSScyWd+ylK95dO+DbKhAOVNj
         ZMYE0PxygJoOJguD6CzHhJLNabytFk5LcpjnA1NM/aB04LmD3y9I/9Bsp0bYnTiI9cxG
         SD/WrcVE0u8GB/KUVakdE/uH1dSU5pRk64KAUjZI5qJR9eTAFmdB9GBhHEx27lE5eSv2
         wUn96X/rCQSQ8OVl9MgPMuiZUQ+t/30N7dpKzfk/YwZfIFUG9h37KyG4T4CdCrRkO/lG
         d7RQ==
X-Forwarded-Encrypted: i=1; AHgh+RruKi5sDzDVee/DQGnn8xJuiIvu9uS1GfN3Pr1ijBe9IfP9r1nMB5Q1DycOghOodUL6b4R0CgtIpiFp@vger.kernel.org
X-Gm-Message-State: AFuF++mHSc4+MH31YToJWT2T69LnnVMjGogpPjOAi5NsU9iSgqpl35XJ
	6FVNUDUYhybtCoruYv3t6U3vifbUCWUBdd4kaTaBWK2bRvivPIUNyjwSp/f+Z/o0Oms=
X-Gm-Gg: AR+sD10m1k5upz2h3WKG4+SpKk9WRoWti/9riwwtpzXMo6s0kLzwIYvz45S/558LOR7
	1gfhRal1ALdWeSJDkhIOzEe/waxGircLwQKfhfzTAP7DGty5KIpevO17iMrOGLP7g/HuK28Bqtn
	YAiZ+EEhC/zjMv+6I55SZd4brqTSCjSbklwsgC1xoMOeMEFpSxjjGTAPzeF2zN2m1PU1tZltdjH
	kUADGR3tDYVYnrMZNPZOeKZ2nFCdVrLPTgitsKdR8bvxmEdAkALOSb0WZ2iTN4AAZw89ScT2/cG
	TlcWBUx/CY/tmrXwMAt4NQdFetfsrlNX+EJ5qjwj2vQNTSYz+gjzEJvfg4s3/WhoRWPVer9HubO
	aa/YmBLKCrord/txD0T8M9uH8bLgJrWdI1iDxxhUfzWWlcxi6oBXFxnlPFp4lvGEOYpOAAxLDzx
	yghh1dh37DEXGMSdzUsux2EmEgnv9oU96hlkv+3QFWrorPExWLdcwRAgpmcgkqYrnKk7brjtRbT
	gvtD7Ur/+7b7saVNELfsGAb5gzOXs6IcA==
X-Received: by 2002:a17:907:7ba3:b0:c20:56e8:5457 with SMTP id a640c23a62f3a-c25b3bb3c6amr406078866b.6.1788255612911;
        Tue, 01 Sep 2026 02:40:12 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a670b25d7bsm405772a12.25.2026.09.01.02.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 02:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Sep 2026 11:40:11 +0200
Message-Id: <DL3VPJ03VPVL.3RPHCJKUC07YY@fairphone.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Andreas Dilger"
 <adilger.kernel@dilger.ca>, "Baokun Li" <libaokun@linux.alibaba.com>,
 "Ojaswin Mujoo" <ojaswin@linux.ibm.com>, "Ritesh Harjani"
 <ritesh.list@gmail.com>, "Zhang Yi" <yi.zhang@huawei.com>, "Zhang Yi"
 <yi.zhang@huaweicloud.com>, "Bob Copeland" <me@bobcopeland.com>, "Namjae
 Jeon" <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Yuezhang Mo" <yuezhang.mo@sony.com>, "OGAWA Hirofumi"
 <hirofumi@mail.parknet.co.jp>, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Andreas Gruenbacher" <agruenba@redhat.com>, <linux-ext4@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <gfs2@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, "Weidong Zhu" <weizhu@fiu.edu>
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen
 data directly
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Joseph Qi" <jiangqi903@gmail.com>, "Chao Shi" <coshi036@gmail.com>,
 "Jan Kara" <jack@suse.cz>, "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Matthew Wilcox"
 <willy@infradead.org>, <linux-fsdevel@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <cover.1785951556.git.coshi036@gmail.com>
 <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com> <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
In-Reply-To: <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>

Hi Joseph,

On Tue Sep 1, 2026 at 5:37 AM CEST, Joseph Qi wrote:
>
>
> On 8/7/26 12:58 AM, Chao Shi wrote:
>> When a metadata buffer has to be copied out before it can be journalled,
>> jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather tha=
n
>> the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() ma=
kes
>> the shadow buffer point at a slab folio.
>>=20
>> That is not something the buffer_head layer can reason about.  A slab fo=
lio
>> overloads ->mapping, so a shadow buffer looks like it belongs to an
>> address_space when it does not.  buffer_set_crypto_ctx() already has to
>> work around this, and it is the reason mark_buffer_write_io_error() cann=
ot
>> be called on a shadow buffer today.
>>=20
>> Point the shadow buffer at the frozen data itself instead: leave b_folio
>> NULL, which it already is out of alloc_buffer_head(), and set b_data.  T=
he
>> previous patch taught fs/buffer.c to submit such a buffer.  folio_set_bh=
()
>> is now needed on only one path - the one that journals the page cache co=
py
>> directly - so it moves there, and new_folio, new_offset and the flag tha=
t
>> used to pick between them all go away.
>>=20
>> The two commit-path checksum helpers reach the shadow buffer's contents
>> through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a buf=
fer
>> with or without a folio.  Memory outside the page cache is always mapped=
,
>> so for those there is nothing to map or unmap.  Mapping it anyway would =
be
>> worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
>> kmap_local_page() hands back a one page mapping even for such memory, wh=
ich
>> is not enough for a buffer bigger than a page.
>>=20
>> Tested with ext4 mounted data=3Djournal,journal_checksum on a metadata_c=
sum
>> filesystem, writing files whose every block begins with the JBD2 magic s=
o
>> that escaping forces the copy-out, then crashing with sysrq-b without
>> unmounting and replaying the journal on the next mount.  Recovery
>> completed, the file contents matched, e2fsck -fn was clean, and an
>> instrumented build confirmed the b_folio =3D=3D NULL path was taken.
>>=20
>> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Acked-by: Weidong Zhu <weizhu@fiu.edu>
>> Signed-off-by: Chao Shi <coshi036@gmail.com>
>> ---
>>  fs/jbd2/commit.c            |  8 ++++----
>>  fs/jbd2/journal.c           | 29 +++++++++++++++++------------
>>  include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
>>  3 files changed, 50 insertions(+), 16 deletions(-)
>>=20
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index 3029cb6f6d64..0c85af91f9b2 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, str=
uct buffer_head *bh)
>>  	char *addr;
>>  	__u32 checksum;
>> =20
>> -	addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +	addr =3D kmap_local_bh(bh);
>>  	checksum =3D crc32_be(crc32_sum, addr, bh->b_size);
>> -	kunmap_local(addr);
>> +	kunmap_local_bh(bh, addr);
>> =20
>>  	return checksum;
>>  }
>> @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j, =
journal_block_tag_t *tag,
>>  		return;
>> =20
>>  	seq =3D cpu_to_be32(sequence);
>> -	addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +	addr =3D kmap_local_bh(bh);
>>  	csum32 =3D jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
>>  	csum32 =3D jbd2_chksum(csum32, addr, bh->b_size);
>> -	kunmap_local(addr);
>> +	kunmap_local_bh(bh, addr);
>> =20
>>  	if (jbd2_has_feature_csum3(j))
>>  		tag3->t_checksum =3D cpu_to_be32(csum32);
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 09efa337649e..6e05dc47e20a 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_t=
 *transaction,
>>  {
>>  	int do_escape =3D 0;
>>  	struct buffer_head *new_bh;
>> -	struct folio *new_folio;
>> -	unsigned int new_offset;
>>  	struct buffer_head *bh_in =3D jh2bh(jh_in);
>>  	journal_t *journal =3D transaction->t_journal;
>> =20
>> @@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transaction=
_t *transaction,
>>  	/* keep subsequent assertions sane */
>>  	atomic_set(&new_bh->b_count, 1);
>> =20
>> +	/*
>> +	 * b_frozen_data is slab memory, not page cache, so when we use it the
>> +	 * shadow buffer gets no folio at all: b_folio stays NULL from the
>> +	 * allocation and b_data points straight at the copy.  Pointing it at
>> +	 * the slab folio instead would hand its overloaded ->mapping to
>> +	 * anything that goes looking for an address_space.
>> +	 */
>> +
>>  	spin_lock(&jh_in->b_state_lock);
>>  	/*
>>  	 * If a new transaction has already done a buffer copy-out, then
>>  	 * we use that version of the data for the commit.
>>  	 */
>>  	if (jh_in->b_frozen_data) {
>> -		new_folio =3D virt_to_folio(jh_in->b_frozen_data);
>> -		new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen_data);
>>  		do_escape =3D jbd2_data_needs_escaping(jh_in->b_frozen_data);
>>  		if (do_escape)
>>  			jbd2_data_do_escape(jh_in->b_frozen_data);
>> +		new_bh->b_data =3D jh_in->b_frozen_data;
>>  	} else {
>> +		struct folio *folio =3D bh_in->b_folio;
>> +		unsigned int offset =3D offset_in_folio(folio, bh_in->b_data);
>>  		char *tmp;
>>  		char *mapped_data;
>> =20
>> -		new_folio =3D bh_in->b_folio;
>> -		new_offset =3D offset_in_folio(new_folio, bh_in->b_data);
>> -		mapped_data =3D kmap_local_folio(new_folio, new_offset);
>> +		mapped_data =3D kmap_local_folio(folio, offset);
>>  		/*
>>  		 * Fire data frozen trigger if data already wasn't frozen. Do
>>  		 * this before checking for escaping, as the trigger may modify
>> @@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
>>  		/*
>>  		 * Do we need to do a data copy?
>>  		 */
>> -		if (!do_escape)
>> +		if (!do_escape) {
>> +			folio_set_bh(new_bh, folio, offset);
>>  			goto escape_done;
>> +		}
>> =20
>>  		spin_unlock(&jh_in->b_state_lock);
>>  		tmp =3D kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
>> @@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t=
 *transaction,
>>  		}
>> =20
>>  		jh_in->b_frozen_data =3D tmp;
>> -		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
>> +		memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
>>  		/*
>>  		 * This isn't strictly necessary, as we're using frozen
>>  		 * data for the escaping, but it keeps consistency with
>> @@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transaction=
_t *transaction,
>>  		jh_in->b_frozen_triggers =3D jh_in->b_triggers;
>> =20
>>  copy_done:
>> -		new_folio =3D virt_to_folio(jh_in->b_frozen_data);
>> -		new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen_data);
>>  		jbd2_data_do_escape(jh_in->b_frozen_data);
>> +		new_bh->b_data =3D jh_in->b_frozen_data;
>>  	}
>> =20
>>  escape_done:
>> -	folio_set_bh(new_bh, new_folio, new_offset);
>>  	new_bh->b_size =3D bh_in->b_size;
>>  	new_bh->b_bdev =3D journal->j_dev;
>>  	new_bh->b_blocknr =3D blocknr;
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
>> index 699970b4bbf2..20b8fca1abfa 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct =
buffer_head *bh)
>>  	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
>>  }
>> =20
>> +/**
>> + * kmap_local_bh - Map the data of a buffer.
>> + * @bh: The buffer.
>> + *
>> + * Buffers usually live in the page cache, but a few are built over mem=
ory
>> + * which is not.  Those carry no folio and b_data is already a kernel a=
ddress
>> + * which is always mapped, so there is nothing to do for them.  Pair wi=
th
>> + * kunmap_local_bh().
>> + *
>> + * Return: A pointer to the buffer's data.
>> + */
>> +static inline void *kmap_local_bh(const struct buffer_head *bh)
>> +{
>> +	if (!bh->b_folio)
>> +		return bh->b_data;
>> +	return kmap_local_folio(bh->b_folio, bh_offset(bh));
>> +}
>> +
>> +/**
>> + * kunmap_local_bh - Unmap the data of a buffer.
>> + * @bh: The buffer.
>> + * @addr: The address returned by kmap_local_bh().
>> + */
>> +static inline void kunmap_local_bh(const struct buffer_head *bh, void *=
addr)
>> +{
>> +	if (bh->b_folio)
>> +		kunmap_local(addr);
>> +}
>> +
>>  /* If we *know* page->private refers to buffer_heads */
>>  #define page_buffers(page)					\
>>  	({							\
>
> When tested ocfs2 on next-20260831, I've encountered the following NULL
> pointer dereference:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>     jbd2_journal_commit_transaction+0x932/0x1b10
>     kjournald2+0xb2/0x250
>
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit(). But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio. So submitting such a buffer during journal commit oopses.
>
> A simple fix:
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk=
_opf_t opf,
> =20
>  	bio =3D bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
> =20
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> =20
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))

I'm seeing the same issue on my board with next-20260831.

[   21.833061] Unable to handle kernel NULL pointer dereference at virtual =
address 0000000000000000
[   21.833090] Mem abort info:
[   21.833094]   ESR =3D 0x0000000096000004
[   21.833099]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   21.833104]   SET =3D 0, FnV =3D 0
[   21.833109]   EA =3D 0, S1PTW =3D 0
[   21.833113]   FSC =3D 0x04: level 0 translation fault
[   21.833118] Data abort info:
[   21.833121]   ISV =3D 0, ISS =3D 0x00000004, ISS2 =3D 0x00000000
[   21.833125]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[   21.833130]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0
[   21.833135] user pgtable: 4k pages, 48-bit VAs, pgdp=3D000000011400a000
[   21.833141] [0000000000000000] pgd=3D0000000000000000, p4d=3D00000000000=
00000
[   21.833153] Internal error: Oops: 0000000096000004 [#1]  SMP
[   21.833160] Modules linked in:
[   21.833174] CPU: 4 UID: 0 PID: 496 Comm: jbd2/loop0p2-8 Tainted: G      =
  W           7.3.0-rc1-next-20260831-00014-g30164ed72bef #83 PREEMPTLAZY=
=20
[   21.833184] Tainted: [W]=3DWARN
[   21.833188] Hardware name: Fairphone 4 (DT)
[   21.833194] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   21.833201] pc : __bh_submit+0xa0/0x1fc
[   21.833217] lr : __bh_submit+0x94/0x1fc
[   21.833224] sp : ffff800086f23c00
[   21.833229] x29: ffff800086f23c00 x28: ffff00008ba4b840 x27: 00000000000=
00ce4
[   21.833241] x26: ffff000086369188 x25: ffff000086369000 x24: fffffff0000=
00000
[   21.833252] x23: 0000000000000000 x22: 0000000000000000 x21: ffffac13e04=
17880
[   21.833263] x20: ffff000092a41500 x19: ffff00008fa86120 x18: ffff53ee15a=
4c000
[   21.833273] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000000=
00000
[   21.833284] x14: 0000000000000000 x13: 0000000000000000 x12: ffff000081a=
d6108
[   21.833295] x11: 000000000000000d x10: ffff000092a41400 x9 : 00000000000=
0000d
[   21.833305] x8 : 0000000000000000 x7 : 0000000000000000 x6 : 00000000000=
00000
[   21.833315] x5 : 00000000000002b3 x4 : ffff53ee15a4c000 x3 : 00000000000=
00001
[   21.833326] x2 : 0000000000009801 x1 : 0000000000000000 x0 : 00000000000=
00000
[   21.833337] Call trace:
[   21.833342]  __bh_submit+0xa0/0x1fc (P)
[   21.833352]  bh_submit+0x1c/0x34
[   21.833360]  jbd2_journal_commit_transaction+0x890/0x1674
[   21.833372]  kjournald2+0xb0/0x220
[   21.833379]  kthread+0x11c/0x13c
[   21.833390]  ret_from_fork+0x10/0x20
[   21.833403] Code: 94053530 aa0003f4 f9400a60 b9404fe2 (f9400003)=20
[   21.833412] ---[ end trace 0000000000000000 ]---

With your patch applied, everything seems fine again.

Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4

Regards
Luca

>
> Thanks,
> Joseph

