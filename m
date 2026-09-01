Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297A944064A
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2026 03:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788233843; cv=none; b=CNSGkzkbdHFf7OKnqR3sX6xt/rIPk7t2diqn/X1gpiQwjkWre7YB74ztqnplyjMcnegZH7lroLAiQPtAJYzWIhGG0kfVtCAvHrKg0QDY/ySqhUYYpaLMGu1XDv4pfmiGr0Vr2/jEVTse8fz0Ti2T8qatzNXtTxrhk4plyoM1nqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788233843; c=relaxed/simple;
	bh=yqJJYKb+G/E22m/OAgvFzqj5UMSEptqYLIVuMXJV3FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xbv43Iplr6jBTZJZ22+rsGchwrWx8oI+DCMEindmn2QSy9xuQjC81aadjDkeW593GSW0iZ9S7oJsJ2sp9vubId+9fO/06w77/cj0O8SVw8rxBJ/66WuiVgb4FZKZnX5s5q1ON3EvIbTgPS2+r66/f2tdUEzg2GmMRij5jiMUpz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAThHtxl; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAThHtxl"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-382ef647e20so4378317a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 20:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788233841; x=1788838641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Y/fADxvRxExbmfjSF20mYAtoYxHc/TwJOV7kDL/3Bkg=;
        b=AAThHtxl7uHJNtWOge+/5WqUE29p5ylSvOvgWJuCwkFWUjfXqsgNyHjyNY3tvNFA7u
         1tyoSbYCnNa6lHuFOQVL2oCCrM9AyFTn+aIMLGzAlxL5fTpnfD5+uXn+Ow0HltqyS4yR
         YysZ1sby2eevxwKnCnP5Zs8/VZSnrVMdSQloM0xnyb/FrxNq3UFj7QOQM4ZvBIWSEyFm
         41HHSe3Aw5yQj01QYGC0xFRcPq+o7nwf1hClPM8KLfdC2IWRaBULEJ9tX7BWDSqK83sf
         flyl77heLn5K6ECFi+x+Q68T8nywaY+2LghQga4f5OogDSRNhcpqqNX0Hib1JKBMdQ4M
         bkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788233841; x=1788838641;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y/fADxvRxExbmfjSF20mYAtoYxHc/TwJOV7kDL/3Bkg=;
        b=er1CWkCcM/j0CZ1gNQU421kBxaHo+ViwiNoNIh0iMhB2OvwB3AXmeRl7pcImqdCIxP
         aHsXrLsoqcpMgw5Gt5Xc3sTU3XeuJBa9gURXXpxpd/JXM36k3ZMfwjoVGoAbvjW9ircn
         KVLh794OBF+mR+2o2rLxRBeotAkFrRIJCfor8yEu6KfoEfz6+SVoe7aGDywXj0afQ91M
         WQsEs4ETX8EBOeV0ChiHmw5qWQzCdNwR1i77hybbwxYkX1QH1NowMcCVCWwQlOqMIErG
         OjlsDST1edncCRgYwms2387IhUozVmlUznZPUfl5Wult+AX3uZgdBPYl2RYPObqiSs2E
         dTTQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjS1NCrKLxAxfv2qWZHxeo35ZuIL1OWosgCvIaOXsP7J4qxMMxxM8RPEJRPH5qPvB1LhY9DcZxQNJp@vger.kernel.org
X-Gm-Message-State: AFuF++nA4STgSLD75dwVsOhgHYb0Qu1DfKsnGvBqjFdM9BK4asaY/AqQ
	AZlyItXK1WI5Ws/BALDTsnuEx4ecs9tFPg1hGv9Yp5ONuzr0cqvnp/Ua
X-Gm-Gg: AYBFou29w0kD4h0O928c2Z32hXZ0NHkkGa+mx5L+1HqTE9//Y/dBG0OBAAYsx9QPAfE
	9e9SD6mKgBnUalTxuYOdII4/Lt2ASFeq23IQes9hbGjsUwP5Z22RinMpiUFIPtMELzPRCuRwtM+
	ZBwZ3pgkGrUhMsU/2W6oqsKu+VpLxp96TGqAWgkl2XaJ6VvxrNJ+BQmoVsWKsU9Gfz8l9QS63lX
	s7F53K7RtLWUp8LVeKiytR4G9BqmL61h0mEL3MCJb9NwH74LssMk39RCC/bqk2H/UMRVtsDys2P
	wOgI3UYtFEOt4w88c6j8G+YDn0fhcUOsyITbzO9HNu1+I0U2nwkBcxf7A8Zn24R/ZvhW5rppk8M
	qyASj8kx1GdFPagGm7XRvEyvYxCpI5Txjuaw5BBq759Yuocgh+Af4kMGd8i1iSdhwwgQBvPREDy
	HoSQ2IUGDiOPczvdytSr1F0jyW3pGkx5kCjt5Rghc0inQheOcvah3egSVvCngAMUbetJfR3+2c0
	RXjbnVBWr6e
X-Received: by 2002:a17:90b:1e05:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-3989bd54c4emr26982077a91.19.1788233841226;
        Mon, 31 Aug 2026 20:37:21 -0700 (PDT)
Received: from [30.134.112.244] ([107.151.169.131])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f9e907fsm30635648eec.25.2026.08.31.20.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 20:37:20 -0700 (PDT)
Message-ID: <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
Date: Tue, 1 Sep 2026 11:37:14 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data
 directly
To: Chao Shi <coshi036@gmail.com>, Jan Kara <jack@suse.cz>,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
 Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev,
 linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
References: <cover.1785951556.git.coshi036@gmail.com>
 <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
From: Joseph Qi <jiangqi903@gmail.com>
In-Reply-To: <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/7/26 12:58 AM, Chao Shi wrote:
> When a metadata buffer has to be copied out before it can be journalled,
> jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather than
> the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() makes
> the shadow buffer point at a slab folio.
> 
> That is not something the buffer_head layer can reason about.  A slab folio
> overloads ->mapping, so a shadow buffer looks like it belongs to an
> address_space when it does not.  buffer_set_crypto_ctx() already has to
> work around this, and it is the reason mark_buffer_write_io_error() cannot
> be called on a shadow buffer today.
> 
> Point the shadow buffer at the frozen data itself instead: leave b_folio
> NULL, which it already is out of alloc_buffer_head(), and set b_data.  The
> previous patch taught fs/buffer.c to submit such a buffer.  folio_set_bh()
> is now needed on only one path - the one that journals the page cache copy
> directly - so it moves there, and new_folio, new_offset and the flag that
> used to pick between them all go away.
> 
> The two commit-path checksum helpers reach the shadow buffer's contents
> through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a buffer
> with or without a folio.  Memory outside the page cache is always mapped,
> so for those there is nothing to map or unmap.  Mapping it anyway would be
> worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
> kmap_local_page() hands back a one page mapping even for such memory, which
> is not enough for a buffer bigger than a page.
> 
> Tested with ext4 mounted data=journal,journal_checksum on a metadata_csum
> filesystem, writing files whose every block begins with the JBD2 magic so
> that escaping forces the copy-out, then crashing with sysrq-b without
> unmounting and replaying the journal on the next mount.  Recovery
> completed, the file contents matched, e2fsck -fn was clean, and an
> instrumented build confirmed the b_folio == NULL path was taken.
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>
> ---
>  fs/jbd2/commit.c            |  8 ++++----
>  fs/jbd2/journal.c           | 29 +++++++++++++++++------------
>  include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 3029cb6f6d64..0c85af91f9b2 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
>  	char *addr;
>  	__u32 checksum;
>  
> -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> +	addr = kmap_local_bh(bh);
>  	checksum = crc32_be(crc32_sum, addr, bh->b_size);
> -	kunmap_local(addr);
> +	kunmap_local_bh(bh, addr);
>  
>  	return checksum;
>  }
> @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
>  		return;
>  
>  	seq = cpu_to_be32(sequence);
> -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> +	addr = kmap_local_bh(bh);
>  	csum32 = jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
>  	csum32 = jbd2_chksum(csum32, addr, bh->b_size);
> -	kunmap_local(addr);
> +	kunmap_local_bh(bh, addr);
>  
>  	if (jbd2_has_feature_csum3(j))
>  		tag3->t_checksum = cpu_to_be32(csum32);
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 09efa337649e..6e05dc47e20a 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  {
>  	int do_escape = 0;
>  	struct buffer_head *new_bh;
> -	struct folio *new_folio;
> -	unsigned int new_offset;
>  	struct buffer_head *bh_in = jh2bh(jh_in);
>  	journal_t *journal = transaction->t_journal;
>  
> @@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	/* keep subsequent assertions sane */
>  	atomic_set(&new_bh->b_count, 1);
>  
> +	/*
> +	 * b_frozen_data is slab memory, not page cache, so when we use it the
> +	 * shadow buffer gets no folio at all: b_folio stays NULL from the
> +	 * allocation and b_data points straight at the copy.  Pointing it at
> +	 * the slab folio instead would hand its overloaded ->mapping to
> +	 * anything that goes looking for an address_space.
> +	 */
> +
>  	spin_lock(&jh_in->b_state_lock);
>  	/*
>  	 * If a new transaction has already done a buffer copy-out, then
>  	 * we use that version of the data for the commit.
>  	 */
>  	if (jh_in->b_frozen_data) {
> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
>  		do_escape = jbd2_data_needs_escaping(jh_in->b_frozen_data);
>  		if (do_escape)
>  			jbd2_data_do_escape(jh_in->b_frozen_data);
> +		new_bh->b_data = jh_in->b_frozen_data;
>  	} else {
> +		struct folio *folio = bh_in->b_folio;
> +		unsigned int offset = offset_in_folio(folio, bh_in->b_data);
>  		char *tmp;
>  		char *mapped_data;
>  
> -		new_folio = bh_in->b_folio;
> -		new_offset = offset_in_folio(new_folio, bh_in->b_data);
> -		mapped_data = kmap_local_folio(new_folio, new_offset);
> +		mapped_data = kmap_local_folio(folio, offset);
>  		/*
>  		 * Fire data frozen trigger if data already wasn't frozen. Do
>  		 * this before checking for escaping, as the trigger may modify
> @@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		/*
>  		 * Do we need to do a data copy?
>  		 */
> -		if (!do_escape)
> +		if (!do_escape) {
> +			folio_set_bh(new_bh, folio, offset);
>  			goto escape_done;
> +		}
>  
>  		spin_unlock(&jh_in->b_state_lock);
>  		tmp = kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
> @@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		}
>  
>  		jh_in->b_frozen_data = tmp;
> -		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
> +		memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
>  		/*
>  		 * This isn't strictly necessary, as we're using frozen
>  		 * data for the escaping, but it keeps consistency with
> @@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		jh_in->b_frozen_triggers = jh_in->b_triggers;
>  
>  copy_done:
> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
>  		jbd2_data_do_escape(jh_in->b_frozen_data);
> +		new_bh->b_data = jh_in->b_frozen_data;
>  	}
>  
>  escape_done:
> -	folio_set_bh(new_bh, new_folio, new_offset);
>  	new_bh->b_size = bh_in->b_size;
>  	new_bh->b_bdev = journal->j_dev;
>  	new_bh->b_blocknr = blocknr;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 699970b4bbf2..20b8fca1abfa 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
>  	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
>  }
>  
> +/**
> + * kmap_local_bh - Map the data of a buffer.
> + * @bh: The buffer.
> + *
> + * Buffers usually live in the page cache, but a few are built over memory
> + * which is not.  Those carry no folio and b_data is already a kernel address
> + * which is always mapped, so there is nothing to do for them.  Pair with
> + * kunmap_local_bh().
> + *
> + * Return: A pointer to the buffer's data.
> + */
> +static inline void *kmap_local_bh(const struct buffer_head *bh)
> +{
> +	if (!bh->b_folio)
> +		return bh->b_data;
> +	return kmap_local_folio(bh->b_folio, bh_offset(bh));
> +}
> +
> +/**
> + * kunmap_local_bh - Unmap the data of a buffer.
> + * @bh: The buffer.
> + * @addr: The address returned by kmap_local_bh().
> + */
> +static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr)
> +{
> +	if (bh->b_folio)
> +		kunmap_local(addr);
> +}
> +
>  /* If we *know* page->private refers to buffer_heads */
>  #define page_buffers(page)					\
>  	({							\

When tested ocfs2 on next-20260831, I've encountered the following NULL
pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__bh_submit.constprop.0+0x87/0x120
  Call Trace:
    jbd2_journal_commit_transaction+0x932/0x1b10
    kjournald2+0xb2/0x250

Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
__bh_submit(). But jbd2 shadow buffers have a NULL b_folio since commit
5febcba29792 ("jbd2: point the shadow buffer at the frozen data
directly") made them point b_data at the kmalloced frozen data rather
than a folio. So submitting such a buffer during journal commit oopses.

A simple fix:

diff --git a/fs/buffer.c b/fs/buffer.c
index 427d8a817cd5..f46fa6413032 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
-	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
+	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
+	    op_is_write(opf))
 		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))

Thanks,
Joseph
