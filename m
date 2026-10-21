Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593288;
	b=qJ6kdrIJl0xMQlIN0Fys2ZxeHo8HLPjqJiqNixRhzH662A/XhJlArmHL7wWdqxlAUpDH
	 SCr/1JzajlI9rtxR2N4wyUQBCoZmzpYePV7XoEggcgz9YEDQkpNRchGGzO6CHC7d/buL3
	 lhpu1VmPAyba9A+cCuMHcoLxXKc5/kdINAfVpCiZIAM9VJp2xjubgxLI4FXHTGyPWbN41
	 gW6t06BX6FILhvak84q63C2M9P+NrabvnmyNMSWIy5utdpSmj2y/6FGFAuNfF4Vbm7O/L
	 WdkzwjrryuOr61StKEtyJcB9EGDDcsIvLg/itSKgQZmomLEnWgvB61jeK09U9VdcWEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593288;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=i1o45mU1wVGBJYMOu+l6LXLaf1xRjqI1u8WDXqM4gzE=;
	b=oY7hn8AeCrCaafQU9GmbzBe2w3WFnDJi9JBlaOnwSS6UlyYizZrpD1d8hPdKs/wyX/vx
	 8hf/O+mKpxche52lc6onMAdmrg6DUlMpC3tlW7Pc/SFEsqkunc19BEfKy2A6M2Ea7StQy
	 AGojxDaTnw4Uyj9l7N+wbSIrMo6cOE6qoZXgEb8JB+AJvCYnKciEsjKbjFpSi60dZXvzo
	 KndQG59OT4z45QUxfPEMBqVzYmZC5rlVqrnkRmtd1+wBusqhh8NlANljA/Mh3jBihdl9d
	 bJoWaQRn4PTV9syqpcZ3GgHvko8ai1cg3h7kI2xfwtmiUQZhBAmy3bF0izBZlkEJkZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yYoM0Iap;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XWwsFUKY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yYoM0Iap;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XWwsFUKY;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B3D606A328;
	Wed, 21 Oct 2026 14:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76B3D606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yYoM0Iap;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XWwsFUKY;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yYoM0Iap;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XWwsFUKY
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A67541FAA3;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1o45mU1wVGBJYMOu+l6LXLaf1xRjqI1u8WDXqM4gzE=;
	b=yYoM0IappbjPkKyB/pYvzpL+WN4kVfCoEWt8WjAKjmgPwrMUnj/NqsZIHMf0WpeAT+0pq7
	3QMtkrifp/JRT+ILKAY8ZJiSWAl8t5HOrJLubnOvOuQ+/cQNvaBX78hDJ+dpBpXg4LAc2l
	7IYdiAn4JqlXaSo7xlZtIefS+A1PLWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1o45mU1wVGBJYMOu+l6LXLaf1xRjqI1u8WDXqM4gzE=;
	b=XWwsFUKYkcPW1OsHvE0cU/Xk9Ey9EDWp0xESuHSE4wS/K2oRjh2ifwI/t4hgm/PHCxyffl
	9tBcyFDNwsSAY0DA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1o45mU1wVGBJYMOu+l6LXLaf1xRjqI1u8WDXqM4gzE=;
	b=yYoM0IappbjPkKyB/pYvzpL+WN4kVfCoEWt8WjAKjmgPwrMUnj/NqsZIHMf0WpeAT+0pq7
	3QMtkrifp/JRT+ILKAY8ZJiSWAl8t5HOrJLubnOvOuQ+/cQNvaBX78hDJ+dpBpXg4LAc2l
	7IYdiAn4JqlXaSo7xlZtIefS+A1PLWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1o45mU1wVGBJYMOu+l6LXLaf1xRjqI1u8WDXqM4gzE=;
	b=XWwsFUKYkcPW1OsHvE0cU/Xk9Ey9EDWp0xESuHSE4wS/K2oRjh2ifwI/t4hgm/PHCxyffl
	9tBcyFDNwsSAY0DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F45A1351E;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KxuoDH/N2GoMWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 21 Oct 2026 14:34:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EE445A141A; Wed, 21 Oct 2026 13:24:28 +0200 (CEST)
Date: Wed, 21 Oct 2026 13:24:28 +0200
From: Jan Kara <jack@suse.cz>
To: Kaixuan Li <kaixuanli0131@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: stop verify_reserved_gdb() one entry short of the
 block
Message-ID: <mlx7il3nok35qeppdkafrqgztvazj3fc44xrp2umziye5ox24m@xwg43blfi3jn>
References: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sat 19-09-26 19:39:40, Kaixuan Li wrote:
> verify_reserved_gdb() walks the backup group list, reading one __le32 from
> the reserved GDT block per iteration, and bounds the walk after the read:
> 
> 	if (le32_to_cpu(*p++) !=
> 	    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
> 		...
> 		return -EINVAL;
> 	}
> 	if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
> 		return -EFBIG;
> 
> The block holds exactly EXT4_ADDR_PER_BLOCK(sb) entries, so when gdbackups
> reaches that value the test is false, the loop runs once more, and *p++
> reads one entry past the block before -EFBIG is returned. The same value is
> also the largest gdbackups the function can return, and
> reserve_backup_gdb() then uses it as an index into a block of exactly that
> many entries:
> 
> 	data = (__le32 *)primary[i]->b_data;
> 	data[gdbackups] = cpu_to_le32(blk + primary[i]->b_blocknr);
> 
> which writes one entry past. Comparing with >= stops the walk before the
> read and caps the return value one lower, which closes both.
> 
> The walk enumerates the groups ext4_list_backups() produces -- the powers
> of 3, 5 and 7 below the group being added -- so EXT4_ADDR_PER_BLOCK of
> them, 256 at a 1K block size and 1024 at 4K, cannot occur within a 32-bit
> group number. The entry the old bound went on to read was therefore never a
> real backup.
> 
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Reproduced on v7.2.4 x86_64 with KASAN enabled, and on v6.12.9 before that.
> Three images, one reproducer, the resize target passed on the kernel
> command line:
> 
> 	case                     stock                  patched
> 	A plain, 8 -> 32 groups  0, 65537 -> 262145     0, 65537 -> 262145
> 	B group 257 (APB + 1)    0, 2105345 -> 2113537  -EFBIG, no growth
> 	C ^sparse_super walk     -EINVAL                -EFBIG
> 
> 	(APB is EXT4_ADDR_PER_BLOCK, 256 at the 1K block size used here.)
> 
> B is the write, and the thing to notice is that the resize SUCCEEDS on the
> stock kernel -- this is not an operation that aborts after the access:
> 
> 	BUG: KASAN: slab-use-after-free in ext4_flex_group_add+0x50f0/0x5680
> 
> C is the read:
> 
> 	BUG: KASAN: slab-use-after-free in verify_reserved_gdb.isra.0+0x270/0x290
> 
> A is the control that matters for a one-character change: an ordinary
> online resize goes through reserve_backup_gdb() -> verify_reserved_gdb()
> and is unchanged by the patch, same return value and same resulting block
> count.
> 
> Building B needs the group being added to be exactly EXT4_ADDR_PER_BLOCK+1:
> below that the index is in bounds, above it the read defect trips -EFBIG
> first and the call aborts before the write. At a 1K block size that is
> group 257, so the image is built with groups 0..256 already present and the
> resize adds only 257. sparse_super is cleared with debugfs so the walk runs
> end-1 times rather than skipping most groups.
> 
> Mounting a crafted image is not a Linux kernel vulnerability
> (Documentation/process/threat-model.rst), and I am not reporting it as one.
> I have not attached a Fixes: tag: the bound reads the same in v2.6.32, so
> it predates the git history I can bisect over.
> ---
>  fs/ext4/resize.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -794,11 +794,11 @@ static int verify_reserved_gdb(struct super_block *sb,
>  				     grp *
>  				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
>  				     blk);
>  			return -EINVAL;
>  		}
> -		if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
> +		if (++gdbackups >= EXT4_ADDR_PER_BLOCK(sb))
>  			return -EFBIG;
>  	}
>  
>  	return gdbackups;
>  }
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
