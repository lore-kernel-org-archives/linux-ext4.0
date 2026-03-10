Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E103B3A4F49
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 04:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773118710; cv=none; b=jmWLvPjfxqw/b9hdeu8z2mDUCoqB6VxHXa8uipBEP31ceq2Y02q1Vjoqy1Bwkm+UOvOfoschN3Pqj8Uf/wQyg2GB2jddq3Y+5l1gnJJzEWZqeyonD0JaYce+2X4+kKv4Pa6PeNk8THzACyOz4GJnxqJMfITUmI3oHQjgefN/5Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773118710; c=relaxed/simple;
	bh=J20Qza02mIEn7AhvIUMgGqsLhz8k031fDfpPTwCh3xA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mmt+FO0atGoGdhPFDKbUkU5pXNrGb/+cYtMnQxYdLJaQtrBy4/p8JazctloLxuyMGq46rB7fI0szG+EFN+r3gfZilCWJbydNsZAQQQPgR0+6gHbhhOD4ojhnhzIf2v+uM1qfhHg7oZ9W3F2kBqz+NfDn3EknQy32MYYVX8CYJfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=juXtdM+y; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="juXtdM+y"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ae43042ea7so101093845ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 09 Mar 2026 21:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1773118707; x=1773723507; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thA2btnlalWPhD87Kzh1wpNjzogbarJrJKYeWBWLQXI=;
        b=juXtdM+yaxY1YRBFxROluI9Zq65QaU/gq/s4aINshmoe1q/1zx/vhYC6SElgqzwHdx
         Ch181AgXLlz/KGdyLTl5upjw5OcyXEY2Dn043PjLycANXKQi6ErX4ovo3ivX7VNt0njo
         CdUnWWVvdi+WxblNjaPGD20HwWgJ9mcVreOc4RrY7JFmbkRIpdfc4GL26OwMEDAN0ozp
         TsdzPb/jZhRFDESEMZ0G95ykBIEi0FLIJ8s9bo9dbH7d6/YP0w55quYU3X2u/ydtG18M
         Hi7/H5J4nGxrT7gp8hnzdFu7TG9AR9qhLoLl4pjplQC+mgCmslebGp4D/uQq3B2vrNIV
         4O8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773118707; x=1773723507;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=thA2btnlalWPhD87Kzh1wpNjzogbarJrJKYeWBWLQXI=;
        b=E84jfrrk/fNm2kriroOfUzb5SlYkznj5db1hltkZUTUcng4OnXvJFNV44PjLhlSeTW
         Sf7JpfoNrmTXA/cfbU2tkuRecpn0OYAnxRYLXabe/JdElj7sVcFfCRjvKFFXtLMfjnXY
         8QWdoihhjfjmUhcTwhPPMC6iUxq7CYPWxnExCy1KFX4qWE7j5zuidRe19o2hLr50wJpK
         DzJ01K+wEVOuABKiPaRonZxLfK6REtWsowme8KFZZdol4IlOZNUecaneO6J2NMZO93kv
         +198PuDAs8KL1aRrHAihOFK+uA590djysgV85vbtj60YoVK7i8vSvfAjrPoJXbNXKEzG
         PPng==
X-Forwarded-Encrypted: i=1; AJvYcCXjZt2OHU/wa04BsCW1CA4RXsO6HBLxCBsITONU8PCjaI+UuMLKlRuO6cUiJr7BayyUexWCzfxKeHdY@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp3vYqrYc9eRhDOv2lj4H7v+HdYH7ZtLzOehAH6yM9YbB7/Y1G
	PX55CKg25DHjTN1sy//i4hSbyvBFOiqWnhGp0REPb25BeylRoKTYPNQ+zL7N+Fob8eA=
X-Gm-Gg: ATEYQzyXtVOs7KDFebpI9B/1AtTzYei891j8fYI/s2Bxwpza5dk/ni0IYjXd70X9X05
	GFUjtquCaDmi7UPOMG3RHlu4jF1NiuBZ1+GW8Rv2VspUllyHlPkXdHzjD7CP5CrG6z8ozsK+sRe
	XEKDmUImwi96d9sn0ht67ABFkxMLnbZhr4y4RjMTb6tfJKXBUwL5fGp8pvyWBqmuVU5BtZkDRUa
	kX35ovEmb7cLPgKA3ncwwcqo6iNbZZnmLWxjBdL0IvugMdRw7uLSaVoB98VckIPIhQI9Ayfie5b
	VtmPdcAORCSgvJ+WnmozB4Pi4i6czI82UCyR5N4SsPRxbxcIFHWhUWMa3xHIJwdrGTfAHWH428A
	2Xbw4D9+9eOeBbCfW4lVm/BIX5QD3ifVltn6heFj/b7L/wKuKEYMj45xs/L12lJu10CC0NtD2Dn
	1yOM4pidC7nW/QyPQe9Dc/YisPYIOselrD9rEziJFrrFNoo02UnBrEpzjrFUeJuV4YIuLC2SsN3
	Z4Tjg==
X-Received: by 2002:a17:902:e545:b0:2ae:5c3d:b07d with SMTP id d9443c01a7336-2ae824bd5b7mr133926385ad.57.1773118707168;
        Mon, 09 Mar 2026 21:58:27 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f752bfsm178417915ad.60.2026.03.09.21.58.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Mar 2026 21:58:26 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] jbd2: gracefully abort on checkpointing state corruptions
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260309230838.422074-1-nikic.milos@gmail.com>
Date: Mon, 9 Mar 2026 22:58:17 -0600
Cc: jack@suse.cz,
 tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D8BF4CCD-17AD-4E7F-8DFA-AD01E3EE9231@dilger.ca>
References: <20260309230838.422074-1-nikic.milos@gmail.com>
To: Milos Nikic <nikic.milos@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 9, 2026, at 17:08, Milos Nikic <nikic.milos@gmail.com> wrote:
> 
> This patch targets two internal state machine invariants in checkpoint.c
> residing inside functions that natively return integer error codes.
> 
> - In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
> corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
> and a graceful journal abort, returning -EUCLEAN.
> 
> - In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
> an unexpected buffer_jwrite state. If the warning triggers, we
> explicitly drop the just-taken get_bh() reference and call __flush_batch()
> to safely clean up any previously queued buffers in the j_chkpt_bhs array,
> preventing a memory leak before returning -EUCLEAN.
> 
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca <mailto:adilger@dilger.ca>>

> ---
> fs/jbd2/checkpoint.c | 17 +++++++++++++++--
> 1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index de89c5bef607..cdfbfd27afae 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -267,7 +267,17 @@ int jbd2_log_do_checkpoint(journal_t *journal)
> */
> BUFFER_TRACE(bh, "queue");
> get_bh(bh);
> - J_ASSERT_BH(bh, !buffer_jwrite(bh));
> + if (WARN_ON_ONCE(buffer_jwrite(bh))) {
> + put_bh(bh); /* drop the ref we just took */
> + spin_unlock(&journal->j_list_lock);
> + jbd2_journal_abort(journal, -EUCLEAN);
> +
> + /* Clean up any previously batched buffers */
> + if (batch_count)
> + __flush_batch(journal, &batch_count);
> +
> + return -EUCLEAN;
> + }
> journal->j_chkpt_bhs[batch_count++] = bh;
> transaction->t_chp_stats.cs_written++;
> transaction->t_checkpoint_list = jh->b_cpnext;
> @@ -325,7 +335,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
> 
> if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
> return 1;
> - J_ASSERT(blocknr != 0);
> + if (WARN_ON_ONCE(blocknr == 0)) {
> + jbd2_journal_abort(journal, -EUCLEAN);
> + return -EUCLEAN;
> + }
> 
> /*
> * We need to make sure that any blocks that were recently written out
> -- 
> 2.53.0
> 
> 

