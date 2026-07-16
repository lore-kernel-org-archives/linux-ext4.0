Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA742C21DF
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 19:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784231165; cv=none; b=DEWnIaqQKLIRvmOdOznzJkZSF4RDx7NW1FIvrMaxBHGmxr2wDUtp5gLSrO/lNzsqFyXBnpeQzzgik3i7hWV0DY0sjIGK6aD9hz3rrpIj45nQ4Sf1/N9hgF4WjDlkas69A9Wose77u6X5612gh+NYEqhrDvPnXIq59kWDegFcsdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784231165; c=relaxed/simple;
	bh=1I0ck93pWOYtabKWBRxutyxghgTUqDy8CDj8LVkkpSY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YvE9JHmhwpi2gXVBV0unbplvBJTTCO9nKEPOMh8XBKCgKQja9dVlvOLlKaG/cVhOFQx7TWgvtL1PoI+zplsGOcfhv8yu26r15pBVxJwmgyzqpiAkGF11lU+nSjLhB323hR0hIdsuvLFkp/SKgXCAG6+oKTct+zwtzZ/kK38dohE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=fVli2hMd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="fVli2hMd"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cc73e322dbso86903675ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 12:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784231163; x=1784835963; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hUzm/i5MnyvUWOj6bdpFl24+rBSEZBlb+8hc5WYkiPM=;
        b=fVli2hMd2c5OhYIMlf4dpJBUtcKbxWR0N8K/zwV9DdTwvT1ksjGuuXI4BP9tGsx2Ol
         28eKJG8bOwUL194t21WZZdV0LD2khEno4EeWQT4EVqj0KxKoAotza4BlmVAp6eQa3vMC
         2IhDc8rTxkCV5qwXear82Ck8fmEmTCrSFpzwChXW75+i5T/hPMIAhbSeK4AxahWPFajZ
         858PzdG9ZcTMDMjfxRj3dojjrdLconreqj+/6TOWxmVluoPQ6BwHdfh6JJEXTbGOe1Z6
         ktbih3HNTavYUCo3+eISII+qsHg28TGM9hMXBGycep9TJ4TmUGGCsuj68yDlmCaKaA0y
         iE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784231163; x=1784835963;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hUzm/i5MnyvUWOj6bdpFl24+rBSEZBlb+8hc5WYkiPM=;
        b=mEktcfC+Yuut11Kp0He/kPIZrfS8zDbPYoNbXUSkMPifwGPx+kc+RCmJhVNHJXavGT
         jBLPDuiMw1+HFcmQAQQmVoS6wIXU7llz1GKw1v7Qa/MDWKtpdIGPmOja7uMx2rMPhouv
         cIacIEykJkdu2a3xk/Mote41s7LYENsPTXrhOqsaltDW4zT4L7RPQOVLwsHDCNa3Xj/I
         6TnBGmfCrWfrLWlBdGie7IIppGgQnHw465DiJx1kiQX+U4DJacB+buk8IO5WDcVTLjZp
         Ga2dzEORyKsvQtG/Rj9NhZaPXpTP67+Dp/DpNGIPsL0UhWnq5zijud2ZYQ6BRGNSDaiF
         fJfw==
X-Gm-Message-State: AOJu0Yx3jK0OiwU6WfwLwt09D8fvsGn11qG8K7s9eZJ/CxMd3Q/lTtiw
	YoWv/hcr4Ow4qMiNCcbXqX93Hxs9tq87zt0P5OdCuAW1dc8N5GfWVAZLbzuzlnMRSt0zGfEoQjJ
	78RHj
X-Gm-Gg: AfdE7cm36hfh68Y1N+XNXX+GwpQ0hI5GuAZDBcToVPzuScNK4n8jEOz/OGC33HNAgNH
	+0lrorHmhQPMjuR0BEeqsastzHF+nj1FSCM31Qcqww5sJ46sNGsQVXDui5KYQ8XSWyp+FqvbcWY
	31oQgSjKcnOlxi3D8yAhd6IQBiVetiGgbAAe++y4iPD4XLm7W20k81pjXvx2BclSH+IzHC1njmP
	7M0Q5Lh6+EkRg6Bg4jr1Z0E6NNLaAIP3kcCbmvhQJRS3cCFlYSUnL6CZ/7k0hJEOHiIfMQMI2T4
	7JuK3twbqoXoREZGIes/zj91bTBI2wfhTnkfJMzWhldOHierQLsNHG7uurBDThq3XHKRuJFO9XK
	/9lVC4D+kKSXH+5HpJBSRBUIYmpO1dw5yoDByhKuC3E9ufPFRfnjTpcQa083yvstzCg4karWJvr
	38i47JmE0y3FNPf6HTq8+mX0tkJwzhEKE=
X-Received: by 2002:a17:903:288:b0:2c9:c6f3:457a with SMTP id d9443c01a7336-2cf03d71fd4mr85642215ad.31.1784231162532;
        Thu, 16 Jul 2026 12:46:02 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:3854:7eec:417a:89dd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf100e44e1sm25361975ad.6.2026.07.16.12.46.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 12:46:02 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH -v2] ext4: enable scoped NOFS when starting a handle in
 nojournal mode
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260716144831.41290-1-tytso@mit.edu>
Date: Thu, 16 Jul 2026 13:45:51 -0600
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <F1DF796F-992C-439F-B889-9F62DD22ED9E@dilger.ca>
References: <20260716144831.41290-1-tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 16, 2026, at 08:48, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> The jbd2 layer enables NOFS mode using memalloc_nofs_{save,restore}()
> while a handle is active.  We need to do the same in nojournal mode so
> that it is safe to remove GFP_NOFS flags while a jbd2 handle is
> active.
> 
> This will require that we actually allocate a real handle, but with an
> h_invalid flag set, so there is a place to put the saved memalloc
> context.

If you wanted to avoid an allocation for each nojournal handle on 64-bit
systems, you could put a magic number in the high 32 bits of the handle
pointer (which is unlikely to conflict with real memory addresses),
and the PF_* flags in the low 32 bits.

While the memory savings would be minimal (32 bytes for minimum kmalloc),
it would avoid a potential new allocation failure path for that mode.

> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index b68561187e90..7348fdadc810 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -513,6 +513,7 @@ struct jbd2_journal_handle
>  	unsigned int h_sync: 1;
>  	unsigned int h_reserved: 1;
>  	unsigned int h_aborted: 1;
> +	unsigned int h_invalid: 1;
>  	unsigned int h_type: 8;
>  	unsigned int h_line_no: 16;

Not sure if it makes much difference, but should h_line_no be aligned on a
16-bit offset and h_type aligned on an 8-bit offset by adding an
"unsigned int h_unused:4" field before h_type, or reorder them so the 1-bit
fields are at the end?  That would allow the integer fields to be accessed
directly rather than also having to shift them.

Cheers, Andreas





