Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793434985;
	b=uy6fw1P8LV9pKPiQzTWVWHZx+mHMzTTIV4WaulxVO9ZS6DWuAMFbb6FOiU7dBqRDst5c
	 J2Su55jMGspzO++zYM1TiqJNu49kvJk05f4N9foAGnAvSwGuT77E8hcXoZ9AYGoTJY1SV
	 oosnBdjFpoL/uQmNytOSVR7MRQLvsoMPRBdB827Os1nzq1ziYjAUDVZrcH25UWZZmMy3q
	 fLQVwx4Kqz304LlBpIIiz98C3kkYYLGj90QAAsY7yw7GcVKYz0q6y5l3wxW8xf3svpqgV
	 XVyiDvL3sf3RTumbVBi7CfpkNv6t15WFL1rcQbT1/XxKtDQnBxDv+gRg/Ilr95oaM1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793434985;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=tOj9wR1+oMDTq+geNGWmE+H0ijWQOROYJCn+bfYjsvw=;
	b=fEe4x9mbV1VPK7rA1smpz7TMuQxwdVJsBgIiW/DmMiv0xWaqCK6c98WcucMUE6FlomH5
	 QH8GGc43Z1+Jlty/uZr5OEMH8uiBQnFfW+8z+klCXr3SomPp98P2n1eip3KptFdPtFlKI
	 w8QZsHwc978/P22sJhD8cS4yNKbUyW6CNnRITxXdjlp6oNxNXpiAyChnFsax50cauFko+
	 WllVFcd/dAYZGUP2vp/mMsmrPet0Dti0ljtkY0WotyScBTMh2DlI1tVIMBvhcxk0K0583
	 ubtLO+ao3AyneZ1IeQRb3DBwrwfSQFX/AD6nNZgOC7ALu+X2NRmK+sw4xCgCqTaAWag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B58A606A31A;
	Sat, 31 Oct 2026 08:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B58A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jGrYh4CGBz20PM;
	Sat, 31 Oct 2026 16:22:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 33D814056E;
	Sat, 31 Oct 2026 16:22:51 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZPNZpeVqongWCg--.34205S3;
	Sat, 31 Oct 2026 16:22:50 +0800 (CST)
Message-ID: <1828cae6-692e-4fe7-a5da-bdfea4ea90e7@huaweicloud.com>
Date: Sat, 31 Oct 2026 16:22:48 +0800
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
Subject: Re: [PATCH v3] ext4: do not advance i_size on a buffered write that
 copied nothing
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, yi.zhang@huaweicloud.com, yizhang089@gmail.com,
 dave.hansen@linux.intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261030040520.4138904-1-hengyul@cs.unc.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261030040520.4138904-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAnZPNZpeVqongWCg--.34205S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AFyrAFy3uF4xtryxArWDurg_yoWxuryUpr
	WYkw1rArZ2vw1jgrZ3ZF1jqF18K3W8JrW7GFyxKayfZFn8ZFyxKF10qrW5WFWUArZ7XF40
	qF4kCr95W3WqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/30/2026 12:05 PM, Hengyu Liang wrote:
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
>     char *p = mmap(NULL, 4096, PROT_NONE,
>                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>     int fd = open("/mnt/ext4/file", O_CREAT | O_TRUNC | O_RDWR, 0600);
>     pwrite(fd, p, 4096, 1024 * 1024);   /* fails with EFAULT */
>     fstat(fd, &st);
> 
> Before that commit, the result is st_size = 0.
> After it, the result is st_size = 1048576.
> 
> This patch will leave i_size alone when nothing was copied, as
> ext4_write_inline_data_end() already does.  Unlike ext4_write_end(),
> the delalloc path does not trim after a short write, so the folio and
> the delayed blocks that ->write_begin() set up beyond i_size are left
> behind, and the blocks stay reserved until the inode is evicted.  When
> the write ends beyond i_size, drop them as well.
> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Thank you for the update! This looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>


Please note that I went through the three scenarios reported by sashiko.
I think the first one is a false positive, and I had already sent a
patch to fix the third one [1].

The second scenario, however, is indeed a real issue. But I think it is
a pre-existing problem and needs a separate fix, because there is
another way to end up with a half-converted inline inode passing
through. That is, a truncate to 0 can catch up in the middle between
ext4_da_convert_inline_data_to_extent() starting the conversion and
ext4_do_writepages() completing it. I'm not sure whether this outcome is
expected, though, since apart from the subsequent ext4_write_begin()
path, I don't see any other damage.

Perhaps we should, in ext4_write_begin(), after the
EXT4_STATE_MAY_INLINE_DATA snippet, also check whether there is still
inline data, and if so call something like ext4_convert_inline_data() to
let it finish the conversion before copying data.

[1] https://lore.kernel.org/linux-ext4/20261030021338.1768292-3-yi.zhang@huaweicloud.com/

Thanks,
Yi.

> ---
> Changes in v3:
> - Also trim after a short copy: drop the '!copied' check and compare
>   pos + len with i_size after the update, as ext4_write_end() does
>   (Zhang Yi).
> - Reword the last paragraph of the commit message.
> - v2: https://lore.kernel.org/r/20261023172532.3271348-1-hengyul@cs.unc.edu
> 
> Tested in KVM with KASAN: the reproducer above, failed writes around
> EOF, and short copies on delalloc, nodelalloc and 1k block filesystems.
> e2fsck -fn reports no errors.
> 
>  fs/ext4/inode.c | 39 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6ede3644a738..9c20876629bc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1578,15 +1578,18 @@ static int ext4_write_end(const struct kiocb *iocb,
>  	 * it's important to update i_size while still holding folio lock:
>  	 * page writeout could otherwise come in and zero beyond i_size.
>  	 *
> +	 * If nothing was copied (e.g. the source buffer was unreadable), do
> +	 * not move i_size up to pos.
> +	 *
>  	 * If FS_IOC_ENABLE_VERITY is running on this inode, then Merkle tree
>  	 * blocks are being written past EOF, so skip the i_size update.
>  	 */
> -	if (!verity)
> +	if (copied && !verity)
>  		i_size_changed = ext4_update_inode_size(inode, pos + copied);
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (old_size < pos && !verity)
> +	if (copied && old_size < pos && !verity)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
>  	/*
> @@ -1697,13 +1700,13 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  		if (!partial)
>  			folio_mark_uptodate(folio);
>  	}
> -	if (!verity)
> +	if (copied && !verity)
>  		size_changed = ext4_update_inode_size(inode, pos + copied);
>  	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (old_size < pos && !verity)
> +	if (copied && old_size < pos && !verity)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
>  	if (size_changed) {
> @@ -3349,6 +3352,24 @@ static int ext4_da_should_update_i_disksize(struct folio *folio,
>  	return 1;
>  }
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
>  static int ext4_da_do_write_end(struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned copied,
>  			struct folio *folio)
> @@ -3386,12 +3407,12 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	 * checked, we need to update i_disksize here as certain
>  	 * ext4_writepages() paths not allocating blocks and update i_disksize.
>  	 */
> -	if (new_i_size > inode->i_size) {
> +	if (copied && new_i_size > inode->i_size) {
>  		unsigned long end;
>  
>  		i_size_write(inode, new_i_size);
>  		end = offset_in_folio(folio, new_i_size - 1);
> -		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
> +		if (ext4_da_should_update_i_disksize(folio, end)) {
>  			ext4_update_i_disksize(inode, new_i_size);
>  			disksize_changed = true;
>  		}
> @@ -3400,9 +3421,13 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (pos > old_size)
> +	if (copied && pos > old_size)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
> +	/* Drop what ->write_begin() prepared beyond the resulting i_size. */
> +	if (pos + len > inode->i_size)
> +		ext4_da_truncate_failed_write(inode);
> +
>  	if (!disksize_changed)
>  		return copied;
>  
> 
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed

