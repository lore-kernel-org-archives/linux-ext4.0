Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE7E36F420
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 21:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780952973; cv=none; b=tfdyqCGrUYFNImvPO5hi5Ymjcr9xti2EfJ8htMY/+XmODxJeCLgwxMcdO7nVasM5n44LIS6kB38cSrgaDyMBR4NBKRHCqthHnokizkD88WzZx+uaTFSDdnALpMmeox9Uo49p2AU+PqQhxPgwLM5IdMXBKg4175ah4YkvzJe+Ylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780952973; c=relaxed/simple;
	bh=WeKcH1k1k+Fjm+zcdHCmDXdnVOlVdWlRjiFdTuiC8jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7S66mAClmtVS6EBQtOM6Aq//ieoQc0VYF9u0yRZpMRQZeIXGYrfIX8C2/zm9hqyVHjwoC8CVS5ghIAa3a0dnbM6F0OUP4WUul8fw3gMLZEZySABrj2Vg5WzTaBTgSWEKNt+ke2sy3lRVwolFGJ+u2LNvn5CiLCIYWvsTuE+ntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=B1jlgrZr; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="B1jlgrZr"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-307263ad0cbso6313718eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 14:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1780952971; x=1781557771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=src9lZ0GxCu9mRhWr9wm6Ut3OlmlCNZE0B9K93DaON0=;
        b=B1jlgrZrMlU8oSFz9Qn5ffUAItgkwgfFwH/o7uJPN/ujNB9VoJVkEwtsUlrV4r4hj7
         KkQel5SOnROIu3Gi+Hb74cgmrz0nHscuSzqr4SQfNH1fDV7MaXZl6/PGIz3eJu+leibn
         rzt6TUBwB7Beny5EA1JK6uwgQjsDz4rDF01pg/UQUNaA2N8ByIunqf3WLvJrWmJn+AOt
         3U+h/+ke2epJk/JSlD2dcvzL1B5AHN0sTWLPecM3JwEI5opOm7Nh+teHeHP73WpgXC3L
         orvWxXuihrtdoTrmmino08f3d2XnyoUX6+AX6xRblIyUNseXWkOFmjduNwqL2wZJS/t1
         KgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952971; x=1781557771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=src9lZ0GxCu9mRhWr9wm6Ut3OlmlCNZE0B9K93DaON0=;
        b=YQiPekwOHTysrWDyZx1XbkejrfwJQIWsSD4Z/WHjA5LHBmHS4OBQmrPxWJKzGwD0tr
         4TuQnYCOpf3NA10ZSDmlNJmIF7aTgP6rM9xJNRiil9CGO7YoKn5WhCkjO9UCRzLLfRqT
         ExQFAfIFm6AwpdkYr4ZwuuLn7q+5oWY+DoojwLiBifLf3Wqn1kX8Brmu6rBJxhVCu8zH
         XI7rrDBedV1WYXovyVYhKpktNXj8McYnU9ph4GHwUeZ/tPAPBYCwzcIzW1eBn1JVPVzI
         Vq2NgbhnsWrTHU5vpprszPCn8hQYVIm8CBE75QGduqPgS1Ugk6MykOAyBj54OFGAb8Wp
         SgKA==
X-Gm-Message-State: AOJu0YyMhF101DdN1y05S95NW47kZoekucwYGm/icTpKeCmD4kOnoWWb
	EZB3vbZhAwoOG/cQrFROjTmRD01RiE3aqMzWxlh8CUHuxdr1zSkKDzxnKKPjy7PkmRdbKnJoy8m
	z5K3wbflN
X-Gm-Gg: Acq92OFU/XjSyhuSqKzSRAv0LH/J6xe5O03N+rPBUs9d6sv6VyLy/Mu5SAqyH3Pru1M
	YIzvG9/HeSpHEDq1ncyQ+T+Wtivgfrlt5lJ0np/dptSDpxaXryFMTeohVU+1qGhwK9wa43AlDgo
	S+4C37agGdOGl94N3LUSKxibazT+qVbDUI9KS5pnh5H0ITl6VtBZlHEsoqjYDdovb32mY3z+POS
	HHsraahD71FcvCygrBejowdQF1Ekm9BmofdC+34IxuHgkf69Ottt5ZMBI00Y6nS8tEKrvVIU9K4
	VyJWmi6wHhxCXFX6+k7NUtS+7AzMcewsWpBTjG96y4NB1v9vasGLDurgz/wsUNMusiY4cTA8YcT
	G6na0K1aP5rF1s3GYAER+9+JxRYrzCeWhYEPm2VcF2kIKBHYlLuX9cm7OMBetKKLuZXS9ApdD69
	W1adAR/XeLIZ2cyLdNc3935UN6Hw==
X-Received: by 2002:a05:7300:80c7:b0:307:6e47:f881 with SMTP id 5a478bee46e88-3077b10ab65mr10401080eec.16.1780952970945;
        Mon, 08 Jun 2026 14:09:30 -0700 (PDT)
Received: from p1 ([2607:fb90:ec95:a47:31fb:2ecb:8319:54ea])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df191d0sm26972762eec.21.2026.06.08.14.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:09:30 -0700 (PDT)
Date: Mon, 8 Jun 2026 14:09:26 -0700
From: Xiang Mei <xmei5@asu.edu>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH ext4] ext4: fix out-of-bounds read in
 ext4_read_inline_dir()
Message-ID: <v2exhnurd6oyapif2e5fk5k6kk7mxm6mwn3d4af3rjljpidpfu@5q26wiosj3sn>
References: <20260608210713.1940288-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608210713.1940288-1-xmei5@asu.edu>

On Mon, Jun 08, 2026 at 02:07:13PM -0700, Xiang Mei wrote:
> ext4_read_inline_dir() reads de->rec_len / de->name past the end of its
> inline buffer for a crafted or corrupted inline directory, triggering a
> slab-out-of-bounds read during getdents64():
> 
>   BUG: KASAN: slab-out-of-bounds in filldir64 (fs/readdir.c:371)
>   Read of size 8 at addr ffff88800fd3da3c by task exploit/146
>    ...
>    kasan_report (mm/kasan/report.c:595)
>    filldir64 (fs/readdir.c:371)
>    iterate_dir (fs/readdir.c:110)
>    ...
> 
> The payload is copied into a buffer of exactly inline_size bytes:
> 
> 	dir_buf = kmalloc(inline_size, GFP_NOFS);
> 
> but iteration runs in an inflated logical position space, extra_offset
> bytes larger than the buffer (extra_size = extra_offset + inline_size),
> so the synthetic "." and ".." entries land at the offsets they would have
> in a block-based directory.  A real dirent is therefore formed at the
> physical address "dir_buf + pos - extra_offset", yet the loop bounds and
> the ext4_check_dir_entry() length argument are all expressed in the larger
> extra_size.  This mismatch lets two reachable sites dereference a dirent
> before confirming its physical offset is inside the allocation.
> 
> In the main loop, ctx->pos is attacker-controlled via lseek().  The entry
> is validated with extra_size instead of inline_size, so
> ext4_check_dir_entry() accepts rec_len/name_len running up to extra_offset
> bytes past the allocation, and dereferences de before its (too-large)
> length check fires.
> 
> In the cookie-rescan loop, entered when i_version changed since the last
> readdir(2) (or after an lseek resets the cookie), the walk restarts from
> the beginning with i bounded by extra_size.  As i approaches extra_size,
> "i - extra_offset" approaches inline_size, so the unconditional read of
> de->rec_len runs past the allocation before any validation.
> 
> Both are the same defect, logical extra_size space versus the physical
> inline_size buffer, so fix them together.  In each loop, reject a dirent
> whose minimum-size header would not fit within inline_size before forming
> and dereferencing de, and validate the main-loop entry against inline_size
> rather than extra_size.  extra_offset only inflates the logical position of
> "." and ".."; the dirent itself always lives in the kmalloc(inline_size)
> buffer.  Entries that legitimately fill the inline data still pass; only
> accesses that would fall outside the allocation are rejected.
> 
> Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  fs/ext4/inline.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..0ec85cfcc859 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1454,6 +1454,9 @@ int ext4_read_inline_dir(struct file *file,
>  			/* for other entry, the real offset in
>  			 * the buf has to be tuned accordingly.
>  			 */
> +			if (i - extra_offset + ext4_dir_rec_len(1, NULL) >
> +			    inline_size)
> +				break;
>  			de = (struct ext4_dir_entry_2 *)
>  				(dir_buf + i - extra_offset);
>  			/* It's too expensive to do a full
> @@ -1488,10 +1491,21 @@ int ext4_read_inline_dir(struct file *file,
>  			continue;
>  		}
>  
> +		/*
> +		 * ctx->pos can be set to an arbitrary value via lseek(), and
> +		 * the rescan above may also advance it.  Make sure the dirent
> +		 * header lies within the inline_size payload before
> +		 * dereferencing it: extra_offset only inflates the logical
> +		 * position of "." and "..", the dirent itself always lives in
> +		 * the kmalloc(inline_size) buffer.
> +		 */
> +		if (ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
> +		    inline_size)
> +			goto out;
>  		de = (struct ext4_dir_entry_2 *)
>  			(dir_buf + ctx->pos - extra_offset);
>  		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
> -					 extra_size, ctx->pos))
> +					 inline_size, ctx->pos))
>  			goto out;
>  		if (le32_to_cpu(de->inode)) {
>  			if (!dir_emit(ctx, de->name, de->name_len,
> -- 
> 2.43.0
>

Thanks for your attention to this bug. We have a PoC that can trigger 
the KASAN crash. Please DM if you need it to reproduce the issue.

Xiang
