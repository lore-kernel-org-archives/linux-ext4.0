Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D6041166E
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563517; cv=none; b=lwAbRZimMkQiVTu0Q0lNRXuaUnC/bdjspV6hPSFM9ixdn9xrTKHeLQfrPNN/7OSBDhc2RAwqoqv6G/7fjx31rX5l+vngWFPvAPKDy7OYm2vc/KxEE7dO0doHpRFhsID2EH5OLYAT6jk4lwogJtIDbsPIY7YXG8Nz3nueeMrMVbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563517; c=relaxed/simple;
	bh=v8ht1d3qnpQXprqhvwRtoKvdsC7wSpNGPpNSlmD5f7w=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ai2vEcyWdBK3cDCNlRxPnVJ3gIPN9+489ThYne8jKt+LReQYcj0zYbjF0c1PWPkZ0PG7D9LMulQQCDWJtuFI/1I2GmTnfI8PFCcW7PG0sm2fiHXlqxjVghHBoh1l8vOA3cFIxXOl9p+8v/upY7B9zBX7wswquOKx8K2J2rbvq5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=fGK/9ooR; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="fGK/9ooR"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38deea72eebso8253304a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 09:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784563515; x=1785168315; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vb1pv8tfTVgoUonZ7LoUildCsDWvCj01pODKNinxLq0=;
        b=fGK/9ooRTxdr3+5zvsFM6P/Jn8MbzRMnQ2SVZ0V3dpjIQwHLiR1kj9K10kf6Zm8o9e
         62jvb9i6qzBfE33X6Kt+2WbjIvWr+nUYPlIf5hmyY7z+HrPW/L9yCVo7kaNUFMnMKdKy
         qGgbNQIs29m6P3o8YBZZqZJfcorO4gGjINIFB6cHags9kJzsvlaz1NUH28KTkdAmsLyY
         twZcUrsUvY98QW/Y2NauyOfz7ZZS/7kIOeKfTOD53akmCHyZC2gGwCTpXLd+kVdx3F8O
         qb0be7XuNVUaNN+zH37LTFz50S0RSxP2Lk5TyrC1PkL/NLXebLSt5eSSO+T/HOIoG290
         q7Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784563515; x=1785168315;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vb1pv8tfTVgoUonZ7LoUildCsDWvCj01pODKNinxLq0=;
        b=A7Ou2FzGsbkqtc87Uj6Lyx8N2zt/VkiStEm2ABT1zj5qIFnz6C4G30XvSnbuCC0B3z
         Emhv5Mm9D4k21qiSUy0xJDFVLH90jOaUYxI9xHcMSFBdaZht0iylCVLhhP32XbsMPJE+
         fRbPmxTfBNynGiUAEBU+pjcWHFW9VdJV8PAnHqymqAw4GLFuD0JSopKSJbUrLsB9FWkH
         862cpIgIwRo1rHkzH/IIB+MNURmPMpxTqUzI76b4lzdG+uD7nqgLDLMcrcmKsnjF1XPy
         rvYUwfl4vWCaf6JqtaB+oQy20ZD7XPW6zFwBkYw/SOhLAyQVANM2okpZUn83dPghnzGi
         5UjA==
X-Forwarded-Encrypted: i=1; AHgh+RpxM1C0P44ezeOpcojhYcbu3IQJzb/EoBiga/QJG+S94dGXg+2a2r/6GAda9PBZXXSARwaJ2aDvAFYd@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoyh2xT6fbwJaLZhxDSTTURX266Kx0+FP4QgPHhqeSlNvp0UeB
	7NBOIfWQ9RoFgf/STg/CbzS0GHFJclphRK9hjfTtm3MF4h4yTlAVMZMqoGs/iepHh/KTtEXK1GT
	t64d4
X-Gm-Gg: AR+sD12iHY9/r1aafGPIt7BYimSEV5hUz2BWSVzl+4r909HPRhbYg0kAIQpI4ls/BiL
	eatENVsJVKWY4nkOFsMdLLzrbVjTh9ZCgpmXRxqzssL4TH3e2YofE0SEO0hdb99lgl0hDzX2ZwO
	lojnhV1a+aTS/1C/Gwvcf7SkSfYN5SMAmNfEjpypXHpXsc50bbX7MMoWvFJYEOyqSmLl3HiWRRf
	W3ZbXgyrRrXCE4pxpWv+zqC8RfLD+OiR+xy0rRFntR5nH9pCTQykRvb9en6gvXmAgO8yGIeiYlb
	ycIyFo4JO/LE9njG8n419tXJL32+6iOanm3Dc6FZIBhsKD6tY8QrM/Ttlq4pnWrzVdSpZ1ED1KQ
	dQkdJWb1hxdXuWAeP4j0DkBeV9S9f3ccdcaWI3INlkKRZUVXnMIza5PxPLF5CKaDtI3FjaPXqNm
	XEyymiPxSsV5affW94aAShO4bBmibSu0Cp3uszEUpd
X-Received: by 2002:a17:90b:1d45:b0:38c:e9e9:e7ce with SMTP id 98e67ed59e1d1-38e4b41bfd4mr15395885a91.3.1784563514958;
        Mon, 20 Jul 2026 09:05:14 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:d9b7:1db:a020:b64d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e9208f731sm4346a91.6.2026.07.20.09.05.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 09:05:14 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2] ext4: fix race in ext4_mb_check_group_pa
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260720065505.4019225-1-rafad900@gmail.com>
Date: Mon, 20 Jul 2026 10:05:02 -0600
Cc: tytso@mit.edu,
 libaokun@linux.alibaba.com,
 jack@suse.cz,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2AAF0DFB-2FD5-405B-8965-1C88AF6E2B98@dilger.ca>
References: <20260720065505.4019225-1-rafad900@gmail.com>
To: rafad900 <rafad900@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 20, 2026, at 00:54, rafad900 <rafad900@gmail.com> wrote:
> ext4_mb_check_group_pa drops the reference count on the previous
> best PA using atomic_dec(&cpa->pa_count) without holding the
> cpa->pa_lock.
> 
> This causes race with ext4_discard_preallocations() which checks
> pa_count to decide whether a PA is still in use. If the pa_count
> is dec between the check and the discard, the PA can be freed
> while ext4_mb_check_group_pa() still holds a reference to it.

Can you please explain this race condition further?  I don't see where
ext4_mb_check_group_pa() is using cpa after the reference is dropped.

> Fix this by taking the cpa->pa_lock around the atomic_dec.
> Similar to pa->pa_lock which is taken outside of the
> ext4_mb_check_group_pa() function.

At this point, it wouldn't be clear why `pa_count` needs to be an
atomic at all, if `pa_lock` is always held during inc/dec/check?

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ed1bd00e11cd..c9a118ae4658 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4833,7 +4833,9 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
> return cpa;
> 
> 	/* drop the previous reference */
> +	spin_lock(&cpa->pa_lock);
>  	atomic_dec(&cpa->pa_count);
> +	spin_unlock(&cpa->pa_lock);
>  	atomic_inc(&pa->pa_count);
>  	return pa;
>  }

In ext4_mb_check_group_pa() there is no reference to `cpa` after the
refcount is dropped.  In its one caller ext4_mb_use_preallocated():

		list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[i],
					pa_node.lg_list) {
			spin_lock(&tmp_pa->pa_lock);
			if (tmp_pa->pa_deleted == 0 &&
			    tmp_pa->pa_free >= ac->ac_o_ex.fe_len) {
				cpa = ext4_mb_check_group_pa(goal_block,
							     tmp_pa, cpa);
			}
			spin_unlock(&tmp_pa->pa_lock);
		}
		rcu_read_unlock();
	}
	if (cpa) {
		ext4_mb_use_group_pa(ac, cpa);
		return true;
	}
	return false;
}

It *looks* like 'cpa' is used after ext4_mb_check_group_pa(), but it is
replaced on the return by 'tmp_pa' in that case, so there is no further
use after the refcount is dropped AFAICS.  Even the list iteration is
using 'tmp_pa', so that couldn't be it either.

There may be a race condition somewhere, but the commit message doesn't
provide clear details of what it is.

Cheers, Andreas





