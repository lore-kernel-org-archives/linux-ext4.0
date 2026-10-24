Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792825990;
	b=DC5vPZxlFQJE+MeypMio5dIFMpB3tN3cOmxFdkV7YM24fvZ/j2ST/INHz+0QaOlMyed+
	 F6WR4Q5+QSQ35ft1AWDom+jcCYwi67ar4wfwoyFp6mm4s6hrU4kuqL0KgBwYQoyE6w9Gt
	 t3dWjYr+xYL4+ANaMy/ubmy7PQnHfbBdG2qxTGVL+0DzP1eMVh5oVNsBrHtuNw+Ko8Iju
	 ubtVIHGwYNDKnttIkWV/lJY0wZnwx86XPWvuiRc/oi1H8ZsUPTZAa0Okn9BfdrymRFNyG
	 AjMNnVwao4OeWFqy4uY756Rzxk+bVbx9eJ/zNozoXMpaDQc3CBgs0/MyATgZLMwDxpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792825990;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vvVgDb84+ZH4mGzuu/NhPjeDNR0l9LEuFpIELpyf8Yk=;
	b=nwYPYt7wAsDg+c5hhkUOnJSz3MRsZtNvGbaE0uCx+dDLGVY3m0xt3zteJs1W9v3+tFsq
	 bhryx7HsFQgX7ovF3Huw2hNpXXdM5AzAp4F5Wucm25gG0OIPnUV/kVogkbEiLXB6mnkbT
	 1ObnDU000j5hoy2gp9AwUCpMi2f6iNOWOTMWczFUB4yqygNx/UTBoS0ljEIavVgYMLfn+
	 tnlav3nbt2vqM8ZAf1g9EesBGMO3zZdsd8uSdkEAsDwz2RmFxlFoe8fo/nkgnmxRBMX3C
	 6szX4Ox758uSwGOVfiRQNQahr8GDvCOZ1Qk5ka4FvfKb+1ywuO+qEYmNIa+xp+Hn5qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gaaCZKW9;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F581606A31D
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 07:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F581606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gaaCZKW9
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so640109a12.3
        for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 00:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792825989; x=1793430789; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vvVgDb84+ZH4mGzuu/NhPjeDNR0l9LEuFpIELpyf8Yk=;
        b=gaaCZKW97VyVrU/UyqRFDCtRPkmeVHzomoYOSsaSLwy9qc1oyKdXLDd2xNt9iRiBrm
         jqYJlin3hbz/1w0/aFEwX6+jsw8fhFlndilXsXCXmpTi6v99GUKpU6r1zwKe9DBofW9C
         jZXE1bnCoHNLiKq2JXbHDVHQ+U7fNH6piDeQrDCXDnDLzenNUNC4zSn2V3JZkQxD4kL8
         gqhud9Pr3E6yLkmb1+kyoMrftn7P1e0+Keh1aOLv0jROV+YtlW+ck9V/5IptxIjLmSUU
         tNz2VbP9G+Tb7Qa6O5deJtcsWeqD5FbVBif3UG9NlOYJTC6gk7b4t203EYBJCkgPHqEu
         E0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792825989; x=1793430789;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vvVgDb84+ZH4mGzuu/NhPjeDNR0l9LEuFpIELpyf8Yk=;
        b=N8Rpv5WE8H26bNWEHkd0pS9t/bDF2ACjtqD1XGaH7SQ2i+RDaneLi3r5G9OVmnB4rB
         sTkBZ9Y/lKpc/Vh65NkhOnFJKlB32lTAm45hpBMIYmrRitne4wt+HOePu7FZhBSB1m2v
         CVRYmIHP0ZchkEetI0Tbq9fLf7LBmkNfcsmn+skoNsidTj7zacOAIN6Xp5bl/rGjUi6y
         0gwpU8xGoq8azZ7YkPgpBis6fsAStFbtMWbGQxlwj9Wi7VuABkfM28CLyvzORVn5aTby
         Fi4OPdiDjUNG2bENqENNwOHXlC1ItKuP0zln52XvI639Bh4VQA/lc2AE224SYS8oowLC
         LqcA==
X-Gm-Message-State: AFq9FYKOtMKI/hk+Eeb8L7z7HtMH4XJOrCxZnhaERjWgTcRS2kJYY4Gb
	65QvaNF9gOmcQdBs3gX0ppC+z7Pix/bHBP5JDcY9FT3j2NFlvBwmX2Hf
X-Gm-Gg: AYBFou18VeEN076wyd7jqp8i7TtrnLUPDfJheuNkk3MIrYWNA9xBWRxcjk4DIqvzuVk
	m87P94Y1hUjkT0s8Da6mlvayixgwQm8FuOWSYDuRyUUzApbqwUelJ0ZsNfbkBNWJEIaX5K6O1ED
	s0Y30WYGRhDNn19ck1iTwdUMm3TEDp+6VYD6LXJd2FdtOaBZgyi+66F2rJ3YocHEJEFkx0ZgjhX
	Px4Uujar7ENvwhx+Ma3LAvZmHuWFKViQas1bWACZ0CIa04SR6G7QzZwBWixpmx0XSuxe8ftdaQd
	sp/dMAyd32sfu/o6q5Wq+ei2JPeaykHQ/tev0xJVlbPo033m6/iEESGMDiJJiOozwmYLQuQ0zTY
	oX1mlU64nv/117ncJNoDAfKHGhF5UGwJzO7ctIrJhPWsZLfRiL9zaak0Lzoi1PDKCXPaaR1v6ob
	gxDjzLt08Xb6BqPOmW4zcO+jZq/DY8O+Dll4fuYNjsexApPT6S9hQ5HiB3FmqQbNJoeTOSYvVzj
	KGSd3l0rOUnTRjGB/oFNSYBleN4LMeeZJ8jyNcw2FgWSsKs8Rw6ypVqrp/dLzvELiHFdaAnV6jP
X-Received: by 2002:a17:90b:4acf:b0:3ac:9e76:aa93 with SMTP id 98e67ed59e1d1-3adea0b1206mr1026779a91.7.1792825988773;
        Sat, 24 Oct 2026 00:13:08 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe6af0dsm1895499a91.5.2026.10.24.00.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 00:13:08 -0700 (PDT)
Message-ID: <abcaabca-d99e-4bf2-b31b-5e96e7accd29@gmail.com>
Date: Sat, 24 Oct 2026 15:12:35 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: do not advance i_size on a buffered write that
 copied nothing
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, yi.zhang@huawei.com, yi.zhang@huaweicloud.com,
 dave.hansen@linux.intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261023172532.3271348-1-hengyul@cs.unc.edu>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20261023172532.3271348-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2026 1:25 AM, Hengyu Liang wrote:
> Commit 665575cff098 ("filemap: move prefaulting out of hot write path")
> made generic_perform_write() call ->write_begin() and ->write_end()
> before it finds out that the source buffer cannot be read.  In that
> case ->write_end() is called with copied == 0.
> 
> However, ext4_write_end(), ext4_journalled_write_end() and
> ext4_da_do_write_end() set i_size to pos + copied without checking
> copied.  As of now, a buffered write() past EOF that fails with EFAULT
> grows the file to the write offset, and the new size can reach the
> disk.
> 
> The issue can be reproduced on an ext4 mount with:
> 
>      char *p = mmap(NULL, 4096, PROT_NONE,
>                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>      int fd = open("/mnt/ext4/file", O_CREAT | O_TRUNC | O_RDWR, 0600);
>      pwrite(fd, p, 4096, 1024 * 1024);   /* fails with EFAULT */
>      fstat(fd, &st);
> 
> Before that commit, the result is st_size = 0.
> After it, the result is st_size = 1048576.
> 
> This patch will leave i_size alone when nothing was copied, as
> ext4_write_inline_data_end() already does.  The delalloc path does not
> trim after a failed write, so when such a write reaches past i_size,
> it also drops the folio and the delayed blocks that ->write_begin()
> set up there.  Otherwise that folio stays dirty past EOF and writeback
> never cleans it.

I feel the last sentence isn't quite accurate. Dirty folio past
EOF will be cleaned up during writeback. In mpage_process_page_bufs(),
when lblk >= blocks, if 1) there are no blocks to map, it will
directly call mpage_submit_folio(), which clears the dirty flag on
the folio, and then mpage_submit_folio() will shorten the writeback
length, so that ext4_bio_write_folio() will also clear the dirty
flag on the corresponding bh; if 2) there are blocks to map, then
after the required block allocation is done, it will likewise call
mpage_submit_folio() and do similar cleanup. Am I missing something?

> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> Changes in v2:
> - Rebase onto the ext4 dev branch.
> - Also trim when a failed write starts before EOF and ends past it
>    (pos + len > old_size), as suggested by Zhang Yi.
> - Keep the Fixes tag and the new helper, as discussed on v1.
> - v1: https://lore.kernel.org/r/20261009044656.1993196-1-hengyul@cs.unc.edu
> 
> Tested in KVM with KASAN: the reproducer above and failed writes around
> EOF on delalloc, nodelalloc, bigalloc and 1k block filesystems.
> e2fsck -fn reports no errors.
> 
>   fs/ext4/inode.c | 42 +++++++++++++++++++++++++++++++++++-------
>   1 file changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6ede3644a738..e96321ce17d2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1578,15 +1578,18 @@ static int ext4_write_end(const struct kiocb *iocb,
>   	 * it's important to update i_size while still holding folio lock:
>   	 * page writeout could otherwise come in and zero beyond i_size.
>   	 *
> +	 * If nothing was copied (e.g. the source buffer was unreadable), do
> +	 * not move i_size up to pos.
> +	 *
>   	 * If FS_IOC_ENABLE_VERITY is running on this inode, then Merkle tree
>   	 * blocks are being written past EOF, so skip the i_size update.
>   	 */
> -	if (!verity)
> +	if (copied && !verity)
>   		i_size_changed = ext4_update_inode_size(inode, pos + copied);
>   	folio_unlock(folio);
>   	folio_put(folio);
>   
> -	if (old_size < pos && !verity)
> +	if (copied && old_size < pos && !verity)
>   		pagecache_isize_extended(inode, old_size, pos);
>   
>   	/*
> @@ -1697,13 +1700,13 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>   		if (!partial)
>   			folio_mark_uptodate(folio);
>   	}
> -	if (!verity)
> +	if (copied && !verity)
>   		size_changed = ext4_update_inode_size(inode, pos + copied);
>   	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
>   	folio_unlock(folio);
>   	folio_put(folio);
>   
> -	if (old_size < pos && !verity)
> +	if (copied && old_size < pos && !verity)
>   		pagecache_isize_extended(inode, old_size, pos);
>   
>   	if (size_changed) {
> @@ -3349,6 +3352,24 @@ static int ext4_da_should_update_i_disksize(struct folio *folio,
>   	return 1;
>   }
>   
> +/*
> + * Delalloc counterpart of ext4_truncate_failed_write(): ->write_begin() only
> + * reserved delayed blocks, so drop the page cache and the delayed extents
> + * beyond i_size and leave the blocks that are allocated there alone.
> + */
> +static void ext4_da_truncate_failed_write(struct inode *inode)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, inode->i_size);
> +
> +	filemap_invalidate_lock(mapping);
> +	truncate_inode_pages(mapping, inode->i_size);
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +	filemap_invalidate_unlock(mapping);
> +}
> +
>   static int ext4_da_do_write_end(struct address_space *mapping,
>   			loff_t pos, unsigned len, unsigned copied,
>   			struct folio *folio)
> @@ -3386,12 +3407,12 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>   	 * checked, we need to update i_disksize here as certain
>   	 * ext4_writepages() paths not allocating blocks and update i_disksize.
>   	 */
> -	if (new_i_size > inode->i_size) {
> +	if (copied && new_i_size > inode->i_size) {
>   		unsigned long end;
>   
>   		i_size_write(inode, new_i_size);
>   		end = offset_in_folio(folio, new_i_size - 1);
> -		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
> +		if (ext4_da_should_update_i_disksize(folio, end)) {
>   			ext4_update_i_disksize(inode, new_i_size);
>   			disksize_changed = true;
>   		}
> @@ -3400,9 +3421,16 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>   	folio_unlock(folio);
>   	folio_put(folio);
>   
> -	if (pos > old_size)
> +	if (copied && pos > old_size)
>   		pagecache_isize_extended(inode, old_size, pos);
>   
> +	/*
> +	 * A write reaching past i_size that copied nothing leaves i_size
> +	 * alone, so trim what ->write_begin() set up beyond it.
> +	 */
> +	if (!copied && pos + len > old_size)

Why do you keep the '!copied' condition? AFAICT, if copied is non-zero
but less than len, the excess delalloc extent allocate by
ext4_da_write_begin() should still be cleaned up.

Thanks,
Yi.

> +		ext4_da_truncate_failed_write(inode);
> +
>   	if (!disksize_changed)
>   		return copied;
>   
> 
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed

