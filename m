Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F0A292B2E
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779921705; cv=none; b=PK75PGpS1jF1IQ1tYGzsFDXzHgQXGj4GvTf71vyL1Nc09WTC8NleWyEGF04ceXTQ0hyg43/XOJ9G2VMuSRp/MuD5wmJ4pEfDuF0WvjqaklT393zOt3+CWXs8qYGp3HdG2oIsqRlMA7KqT6BmaKq05jCPt5UaEoAJXjllbcFGKfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779921705; c=relaxed/simple;
	bh=LWyhWusqHr4rQgdvmPOrVaCWSEHYAt554Q0TgVqFBAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJXTQ/IMVWyJ92xEVPDmSGJU61t99YU16+BfiYOoJ+9plUyK2W2BBRSiO3BbZVAHjgbHwXWLDwGwNuXOAoIQO7KKV6OIi5pCoO9EP71yhZJP2BzRi0dPwdkaF47zlAfY8C31NIgspxBe4yfRHZJKG93SC7EcA/De76vTsOIBqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DiP3Fx58; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DiP3Fx58"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8354461da74so5722012b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 15:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779921704; x=1780526504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PS1QiPPseraqYZzSGuyGeQTFkHJ1l+wgxnVan1O+b0I=;
        b=DiP3Fx58Z5VrEdwY7kjptCOepOOHDy8zV0Ac5ySjdW4f+l1+vDiBNiKiBzu636TGcU
         3sd38WaRMSNrRZa7jxWC6anAxvVtqvkF45zWGzfHYfsB63mQpm0pE2dVt0ekNpNkLrGV
         n7b8kNYbZykxiWAz0q80vZwxp1S4oPKT0vqK2gRuKayCrK9iKcs/yLF1DhugXB/yVhzr
         i+cNR7W1V1EHZvWhyp1OGlh8hOpQCMkEieT5Csk7MMjEqzw1c3aSKtzhMAqzX6fx4r/O
         lGL6DMqEu1XxRvJ60EBWZ1DIt9Te+oi3ZPE6r1i02MYAksmoVDr/RVwd3vRlv1pIFcy+
         xIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779921704; x=1780526504;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PS1QiPPseraqYZzSGuyGeQTFkHJ1l+wgxnVan1O+b0I=;
        b=sK0ywdQU15F0GeU+10bcoY7A4gNBum1iHvJLgOnJqi9QwGKpHRFv01LDpn0OJtd5+F
         fpqfhHCch5pAt2sMrJIwTe34Q4v0HTqSVEUeKAdfyAZ1DiftVF5v8poduV1RYiqmY+CF
         xJrRisCdKC3Sgb0ma8s5bs0HMPfcFzgrbnVaIZy2jqr8b1/7FeNaPugrDxjW4G6mIGHD
         wyxrdl75hWQzSTpQvQI9oHlKAjNaMrl++BRElfGBh1uiorGmjAWY1+7OpeLzxL60oZD1
         TB4sBVhUF/E8sw9iuQfAMpoXlAQTRVTUOkEiPNpQXFMHZUp2MxBChB9htdSPx9pgwCLo
         iJHg==
X-Forwarded-Encrypted: i=1; AFNElJ/G1kj15yn0AedcUZyJbwYH2kw6fHdYf+DU2ecauqKPrxJ3meGv+zm4FykO1qLN29a7m0pxr84WseDo@vger.kernel.org
X-Gm-Message-State: AOJu0Yy91IxoZT7CIbYbg+siRrP7mFJOiyMpMIiVJKGwuUl6abah7B3l
	WGiMCE5x3bwKAo/kCl+cNc7o4wEi7LQ83jI4/VhqcR65GwlUDnlYXNLh
X-Gm-Gg: Acq92OFo7+YqeXJw7qj6gb+3hDMV48a4hcGlOXi37WeGu+KG/4x83APvaLBs4Ox/50R
	CafmeSEPKFQpcFvIQ79nNkJckmFhP9SLtCS1tMyLmEW/Bp2NGTvR8dxf7XfLTPnq0HP4ct2u2F2
	QOWnaE3TUrJGItg50fiy9N6Z23sYrfU9BRA9oFNNuSaDrJF6KT05a5Ht/iGJT1/oq21G0/xZ/NQ
	Yd598KdH+uHi1urtrzJcKPD9j5mpp1QTAsRXQVZzsxtn0+bGjk0DT390c7EiOLXlaE49p9P+BmZ
	IWql7Lb+QWVjycChI8GI+g6WmrXgdP7utC6bmIjtwD8dmmETWvvakzcONJYSHFyzbFGYhs6AsZu
	AluTT7dOy9z3afjne+7fjJIwy/3A/hKLS22DK+x4Dk5PPyW+txCI/EwGRthvz/6Wq09k/dvPcsn
	HS4GialsXfIXfLmSS6Mti8ximKOUdrUUyNbOUirw==
X-Received: by 2002:a05:6a00:3a14:b0:835:41f3:f453 with SMTP id d2e1a72fcca58-8415f3f67d5mr21283194b3a.17.1779921703896;
        Wed, 27 May 2026 15:41:43 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6eac68esm3382981b3a.15.2026.05.27.15.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 15:41:43 -0700 (PDT)
Message-ID: <e039c677-073b-4201-8588-ad84d58639e4@gmail.com>
Date: Thu, 28 May 2026 06:41:39 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] fstests: verify f_fsid for cloned filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <a24645463979d0550e0010030995b0ed609215c1.1779367627.git.asj@kernel.org>
 <ahP2hjv9zl_WL1kg@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP2hjv9zl_WL1kg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/5/26 15:13, Christoph Hellwig wrote:
> On Thu, May 21, 2026 at 08:54:55PM +0800, Anand Jain wrote:
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
> 
> Seems like these are stuck on the btrfs list.  Any progress on that?

They are in the `for-next` branch of the Btrfs Linux repository:
https://github.com/btrfs/linux.git
