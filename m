Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793799191;
	b=CfuT8PhfU6sutgA93tbcYMg6CU4bB8Ri3vTLG+wT7obj1Ut3g981fW2qgE3Ow62iocme
	 n6FBIJQrrj7+8V6Jq8OsWZtsCjNMNEo4lx4KGBr5ZpruR57ZPqPCcWoDkG4ypr/q30OXC
	 7o3urp54HXRvnJ+yQafjFWxefETtUrarMGh99G6N58lzlYp8E8Vy0QpsXxUOVs6W6FxrS
	 z5zuqWdSJMUsJGQ/eRvOPBd+oIil0uQVbcLToaAxzktGAsoLjBU4G2y4ws3tKdL/GctKV
	 sYzADdsIr2ADwNPi/9GjNVDLr5ECEIcEPCoa6PK21zM7mh0b4Tw72bZIGPlgoJh6iKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793799191;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=D5vqMFn+zOBq/wF/9DudCzY7MY5X52Zyk5vuVITihGM=;
	b=JCHvPFJbNJCIhUuoBOaDHGsYoj+Qlgyj7ndUBGmwtabGqTSxi0YSy+Uc72jSeoEo+kkH
	 g/6O8bjhAi/OlcL2qc3OsKuYcoypnivzNSrLEeNeHVkHszfDsGJ10KIJ6xaZzcV1v+HHX
	 erwcd7acBOekxx1rialj4hlgqGBeU4s+rbVhVP7GzGlJELDMkZW/TPJsfFCKTC7q788R2
	 S6QOcD7nNjh01zF9fs6pkqDJNAEn1Ns9Ik+gUiz7WszJLc+wJzI3AyPASe/DbJU/Mpvwk
	 sR4kQ8dVsUk6HFnb3cWj+Xrx3V+g0VR/37rMFdRtmApMiuAH85yjaVgWxokhDVX2XOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Za6edzx5;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020CD606A33A
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 13:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 020CD606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Za6edzx5
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-14fc585291cso675454c88.1
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2026 05:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793799190; x=1794403990; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D5vqMFn+zOBq/wF/9DudCzY7MY5X52Zyk5vuVITihGM=;
        b=Za6edzx5N5punkzq1/UYi9mxrc5gluGlNz9xbMYf0GlusehSE5ix7u8JuwlD7nhTu6
         wYsbjtK2zroaltom9Yj95mlXtsvk63zLuGEaDRH1J9w5YPC3I/5F7wP5l+XP8JgFeyeG
         9IMyJsKIzlZawdTR7fCtr3cxUQl/5Jlkhx81vnNoElWOjXxCC1In/uruyD8lcl89Y/Ab
         8oy0RWm9Ds4w4sbiPpmTsB76B6tlNLo/Z8FL5UDRUoyxIek56UnReROVi2IgpSPIrtdX
         cdS4ylfD9JQGNOaN8BtjhrZRhcVNbOqhCauymJA+ZI3CN4WtHeZ8UJ+lyC3vCp13Dj/J
         Pu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793799190; x=1794403990;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D5vqMFn+zOBq/wF/9DudCzY7MY5X52Zyk5vuVITihGM=;
        b=N6e0vmU/3Fefv1QCw5M5ybxo8Hbog6epjUNsfLiGKgzHBr5qGNMzKzyuabNAyULpVH
         pmwZs8k06vPJDnrAyV+ch0wAd0+mbIFuL6OrZYVt5wB8bnVU0UBKLWPmOzcVwJZRkPN0
         al/Ru3+WXPKfvMulyo6UVrd7kMhz9TnoBMIj84kcbmn1eLgUQoii+FD99i2SxRSvUEwD
         Y0HmNCCnd4aSObQRDDzIQgCAQQ4FvghBAY3z/pNHpCmCcrwd3aVwTid39miXHKFqZohT
         9JL6oACXmXCNmZ554ePH/y5R8ktxbsnY+ecXvgvmo7gXyhfgLZzfwD4krnusxP3fx33H
         ecCQ==
X-Gm-Message-State: APuU4Z92yrRgRbTP8ktDNnryCrbrbbHNYI1BiKW4QMHUjN/1wUx5TUvu
	QMfqxUkjg/tx9NyCCGFhkY7C+/zz/72aKxThgEIEFEcD+CC76Ef8YzOn
X-Gm-Gg: AYBFou3CH3rDTwmJzpt1trrg7JcfeXSltk486JuZXWUG0dEmM/Xtu5V8d9JQ6zOFIzL
	t/ks8T6h6SqM47NSQO+QuUXSSCnLv2PUizZkphyUksuuWu8CiolxFLC4FLbOUunvW1mvrqPh3Ru
	41leMm26HxRIndZ/PKwzESfDvoheD/UuZetMlIzbEZSGz/tQh/EFSVqXt4q7eRovp6+B6qMgukk
	+yrKFSUz/msBBK4SVmMlLVO2CQYe7te4O8c1kNzeoR9c/hsybKhFVQEXzMkR9c4br0doiQgpM0k
	i8zrDkVPa5Pg6dLBUyJ2qLLxyEz0HqZNIHBqOlIb9d7SaRPZHnls3ZJgI1VwE3ykfxXhXkq6a0h
	Y153KVO4PB15SOVC1/M5rsOqxEycU82Xw9o9W3OLrhF+AW4560IMkAAmpjjjHdTHXqz36jdT/+5
	V+HGrREvrhs6B2hF3mm5W8GEB06xZA+vFOKxg0pVsbl23EIWoWx5AuedJ3RuQpHeoYB/IK6Z0ed
	FZ7NVW9xhB6wQ1Dw/SoHrO4w+5dHmx/aQlxPLREOFJSWAuvyNgEj6lrhmbwO0E3mm52XB1YKPa9
	IxbrD9Se9L22qdoULfbIQxBfSKXPAg3jEVMv1ZEsVmo5FrWi
X-Received: by 2002:a05:7022:b059:20b0:1ad:3402:733f with SMTP id a92af1059eb24-1ad3420f9a1mr23734715c88.44.1793799189731;
        Wed, 04 Nov 2026 05:33:09 -0800 (PST)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca39b8eb3sm10183771eec.27.2026.11.04.05.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 05:33:08 -0800 (PST)
Message-ID: <3f0e8eb7-88cb-451a-8335-ab2698047404@gmail.com>
Date: Wed, 4 Nov 2026 21:32:34 +0800
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
Subject: Re: [PATCH v2 6/6] ext4: use atomic bitops for io_end flags
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, yi.zhang@huawei.com, riteshh@linux.ibm.com
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-7-sunjunchao@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20261023061851.45579-7-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/2026 2:18 PM, Julian Sun wrote:
> Before EXT4_IO_END_FAILED was added, the writeback thread set
> EXT4_IO_END_UNWRITTEN and final completion cleared it after the last
> io_end reference was dropped. Adding EXT4_IO_END_FAILED introduced a
> concurrent writer in failed-bio completion. Successful bio completions
> do not update the flags.
> 
> An io_end can cover already-mapped folios submitted before a later
> unwritten extent is mapped. An earlier bio can fail while writeback
> first sets UNWRITTEN. The non-atomic updates can then lose a bit:
> 
>    Bio completion                  Writeback thread
>    --------------                  ----------------
>    read flag = 0
>                                    attach reserved handle to io_end
>                                    flag |= UNWRITTEN
>    write flag = 0 | FAILED
>    /* UNWRITTEN is lost */
> 
> With data_err=ignore, losing UNWRITTEN makes
> ext4_io_end_defer_completion() return false. When the io_end reference
> count reaches zero, ext4_end_io_end() and its reserved-handle cleanup
> are therefore skipped.
> ext4_release_io_end() only warns about the remaining handle before
> freeing io_end. The leaked reservation keeps j_reserved_credits nonzero,
> so jbd2_journal_lock_updates() can wait indefinitely.
> 
> The reverse interleaving can lose FAILED and skip a requested journal
> abort.
> 
> Use atomic bit operations to fix the race.
> 
> Fixes: e856f93e0fb2 ("ext4: do not convert the unwritten extents if data writeback fails")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

This is a good catch and it makes sense to me. Thanks!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>   fs/ext4/ext4.h    | 16 ++++++----------
>   fs/ext4/page-io.c | 20 +++++++++++---------
>   2 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8d3af062a830..f6b2901fc8ba 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -271,12 +271,10 @@ struct ext4_system_blocks {
>   };
>   
>   /*
> - * Flags for ext4_io_end->flags
> + * Bit numbers for ext4_io_end->flag
>    */
> -#define EXT4_IO_END_UNWRITTEN	0x0001
> -#define EXT4_IO_END_FAILED	0x0002
> -
> -#define EXT4_IO_END_DEFER_COMPLETION (EXT4_IO_END_UNWRITTEN | EXT4_IO_END_FAILED)
> +#define EXT4_IO_END_UNWRITTEN	0
> +#define EXT4_IO_END_FAILED	1
>   
>   struct ext4_io_end_vec {
>   	struct list_head list;		/* list of io_end_vec */
> @@ -295,7 +293,7 @@ typedef struct ext4_io_end {
>   	struct inode		*inode;		/* file being written to */
>   	struct bio		*bio;		/* Linked list of completed
>   						 * bios covering the extent */
> -	unsigned int		flag;		/* unwritten or not */
> +	unsigned long		flag;		/* EXT4_IO_END_* bits */
>   	refcount_t		count;		/* reference counter */
>   	struct list_head	list_vec;	/* list of ext4_io_end_vec */
>   } ext4_io_end_t;
> @@ -4093,14 +4091,12 @@ extern int ext4_resize_end(struct super_block *sb, bool update_backups);
>   
>   static inline void ext4_set_io_unwritten_flag(struct ext4_io_end *io_end)
>   {
> -	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN))
> -		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +	set_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag);
>   }
>   
>   static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>   {
> -	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
> -		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
> +	clear_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag);
>   }
>   
>   extern const struct iomap_ops ext4_iomap_ops;
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index d409821fefa2..3604292e8a5e 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -146,7 +146,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
>   	struct bio *bio, *next_bio;
>   
>   	BUG_ON(!list_empty(&io_end->list));
> -	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> +	BUG_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag));
>   	WARN_ON(io_end->handle);
>   
>   	for (bio = io_end->bio; bio; bio = next_bio) {
> @@ -183,7 +183,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
>   	 * or stale data may be exposed.
>   	 */
>   	io_end->handle = NULL;  /* Following call will use up the handle */
> -	if (unlikely(io_end->flag & EXT4_IO_END_FAILED)) {
> +	if (unlikely(test_bit(EXT4_IO_END_FAILED, &io_end->flag))) {
>   		ret = -EIO;
>   		if (handle)
>   			jbd2_journal_free_reserved(handle);
> @@ -198,7 +198,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
>   		mapping_set_error(inode->i_mapping, ret);
>   
>   	if (ret < 0 && !ext4_emergency_state(sb) &&
> -	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
> +	    test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag)) {
>   		ext4_msg(sb, KERN_EMERG,
>   			 "failed to convert unwritten extents to written "
>   			 "extents -- potential data loss!  "
> @@ -235,11 +235,11 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
>   
>   static bool ext4_io_end_defer_completion(ext4_io_end_t *io_end)
>   {
> -	if (io_end->flag & EXT4_IO_END_UNWRITTEN &&
> +	if (test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
>   	    !list_empty(&io_end->list_vec))
>   		return true;
>   	if (test_opt(io_end->inode->i_sb, DATA_ERR_ABORT) &&
> -	    io_end->flag & EXT4_IO_END_FAILED &&
> +	    test_bit(EXT4_IO_END_FAILED, &io_end->flag) &&
>   	    !ext4_emergency_state(io_end->inode->i_sb))
>   		return true;
>   	return false;
> @@ -254,8 +254,9 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
>   	unsigned long flags;
>   
>   	/* Only reserved conversions or pending IO errors will enter here. */
> -	WARN_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
> -	WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN &&
> +	WARN_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
> +		!test_bit(EXT4_IO_END_FAILED, &io_end->flag));
> +	WARN_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
>   		!io_end->handle && sbi->s_journal);
>   	WARN_ON(!io_end->bio);
>   
> @@ -283,7 +284,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
>   
>   	while (!list_empty(&unwritten)) {
>   		io_end = list_entry(unwritten.next, ext4_io_end_t, list);
> -		BUG_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
> +		BUG_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
> +		       !test_bit(EXT4_IO_END_FAILED, &io_end->flag));
>   		list_del_init(&io_end->list);
>   
>   		err = ext4_end_io_end(io_end);
> @@ -369,7 +371,7 @@ static void ext4_end_bio(struct bio *bio)
>   			     bio->bi_status, inode->i_ino,
>   			     (unsigned long long)
>   			     bi_sector >> (inode->i_blkbits - 9));
> -		io_end->flag |= EXT4_IO_END_FAILED;
> +		set_bit(EXT4_IO_END_FAILED, &io_end->flag);
>   		mapping_set_error(inode->i_mapping,
>   				blk_status_to_errno(bio->bi_status));
>   	}

