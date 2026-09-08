Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5C2EEE86;
	Tue,  8 Sep 2026 05:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788845613; cv=none; b=FaS+5vy4tNuU6HGt0d5B11Thcjy9xZ2tVh7cZdfevQ9gskmJwnTFDS/eCPRnJnWdZzynP6pQi7EvLXNPnm4F3ZLYOXWVTrnGk9ZuwDhr7wm0QK4iHB5Zf8+zo3jxZy2ZhAZv9ncs/G5XovothfWi3PGMUpEzF9pEztFw+3rOGzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788845613; c=relaxed/simple;
	bh=dltaH28yUjQQlHMbETH41/bwEToJ8j3Tnd1zRYasmoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCsogRJ0qvlReNK8xXcbYvo+XXwNEDVnhxJDh22woqb4Y0ib72K9fN7c3FTTA7jcAjM+KFTsm8BenAnG6i/Zv1xziwA4gTvhRDqmnE/Q8MA9h71/e3wgP/A8oXpjLcnhi6ZzQdHeRNud2D2+rw+l9V1lFebyhcv0ZFbAkPmizJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=Asdo7YPL; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=IgOkvxgQ; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="Asdo7YPL";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="IgOkvxgQ"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788845584; bh=JoGBcgZLjUjt6VU2m3AjQN3
	W9Ha4kS+Fchgk2bcEpFQ=; b=Asdo7YPLF/TekBShRaprBgqTSEyNNJRCoZ9A6FWC2mSGG1Yitp
	VUIlCvtqC1EoWHNMgd4IxPLIGMY4RXup/Q4iiIlx+T9RSU7Pgp3wO6Uz5YpUg85AAkAZlH2A2ZZ
	dtsrCCeoi9CJ5d3+Rycg9D18TyLIR1Q3lab8v5wj6jPXI07lx4+LHi4r0IPJg2A2WBR2S02jaBK
	3kJWPnDnrNI7oT2hlI1FcBB3t3AF/C9okJ8Ha0CFyiPscY8WVshRMvugCc2rtTyVwml4tPBMbYK
	7qH2spDYiSSpc36BTAAKVOf6bcTyk1XbCamhPc6iDZ0z04edhvXem2wEMZ+oDA7Su/A==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788845584; bh=JoGBcgZLjUjt6VU2m3AjQN3
	W9Ha4kS+Fchgk2bcEpFQ=; b=IgOkvxgQUcbwHbp/r9PXPqqW/A+EqZpzdEPWWC2WsCFzuqiPH9
	1EerW4WWv8JBGfAGFMkbik1yfBzjs2EfLiDQ==;
Date: Tue, 8 Sep 2026 05:32:57 +0000
From: Dang Huynh <dang.huynh@mainlining.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <ap-dKIn7mos_Ez6Q@melt-pi5>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>

Hi Joseph Qi,

I have the same issue on my Orange Pi 5 (next-20260904) and this patch
fixed it. Been running for at least an hour without any issues.

Tested-by: Dang Huynh <dang.huynh@mainlining.org> # Orange Pi 5

On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
> 
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
> 
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
> 
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/buffer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
> -- 
> 2.39.3
> 
