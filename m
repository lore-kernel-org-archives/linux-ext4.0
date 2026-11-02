Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793616805;
	b=J63d8lNgTj9I5MbDetGxOHEVO8lTT0IPPXZ/gw27AxJVPybZ6SCAPOVc9wbfjIlPy+AY
	 NBZkkkel6ZzSYJVsyxD7a0yjCXgDFjjZ3A2tDdxcIXj5Kb+vbb/JPMjt7f+H0oe8ZSYEl
	 Gz2dIFMa42LW06XC+bAsPJA+5tGo6a0K6RgC8ugnRu1XidN/7+ftofQ9fBVD87Q4uRqUC
	 +XUCxewMhJi8/J6DoAaSWM2SvMsspFLI7nSUs2TxFy9AaIkRYlBmiPigs2zFkML3NLSmr
	 85yL5PMwTufvhN1vATI5jS0Gg2jeSnW083QOdDALCWsS4vW9UjxzmyuZkmWHzT9LNbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793616805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=rciz4+NfV/n7GNfIPMbnR7FGjDwc67n4vXgzhcNqgXQ=;
	b=0YxAY6lRjODOxqDg7UcAfh865bOzs+tlIRn/TzUjp5DJIlT3cdo/d4UETw4NkiGJAwBm
	 nb9ZrAQydkdMYYjaLG5zOtRGZck17qm45o6nP+aywPFPtxEbtavxRCVWbldHiaqfXvWN3
	 /3ctRhpG2q1kDp1rjNwndiKktkCiXTAXc2rXc4BwsUiloPKex6zXb1oQJGImv5t+coh6L
	 diV4noUQ85j24U2sXfPMALOlPK511/uaVlFXlczrHTjKr0nDVofCPBgEFfiEj3JiwI8xJ
	 NGS1YEaBw0Qscj6nTTeBC7+WbuiMsEqpUOdKXPg+niwjDoK5wstjq8l7zKvmjsFcXnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b="ZqkG/jvY";
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6509606A327
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 10:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6509606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=ZqkG/jvY
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a058315c79so1277670b3a.3
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2026 02:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793616804; x=1794221604; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rciz4+NfV/n7GNfIPMbnR7FGjDwc67n4vXgzhcNqgXQ=;
        b=ZqkG/jvYw4DlBUH+7ZDQOLUwPb8HDLvyrVsSNpqO513hIK35/s4g1SiiXeCT/Eo6N6
         5bTlT48RVI8P2a69YJHt9bk++jbBabuvYsG5XxaCl3V1UXoEm3wH1gRms1hPYZG75UpM
         tqZ7+fEXiPBwbj3XUl2Y2eKq5SFCCOsbNN+6TT53mA5Nk20bSNEAUygORUyILR+KAFxy
         tAUv63uOzUwNerT3dy8wrHx42SiWckF2L5B2yn6OUWKpQDo0+iymYqIYo4YAlxrhebO3
         2YmDCgQbOa7JAmQnAxNINLvdkK3C6rVGEOrTds9YBjYPbmXiTL3IUUyVvrwyxGgswDb1
         95qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793616804; x=1794221604;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rciz4+NfV/n7GNfIPMbnR7FGjDwc67n4vXgzhcNqgXQ=;
        b=NPlO7s+UPDWQWcudJv6dbJvhGrBAJdWmkQj746xe3MRjWOC+4GkL4N+WAWn5A7LWH+
         rUY4Im15+LZWjO+B0u/V9e6vA1UB+RxwEXia2HkYVUQwltfNYfE7SA2abojWwSgOxLdT
         PJtpjzQ/CutM/AVWA0A7yRGaAgIy7M64zk0buRyjQE6OX+t6T2mYdi+kxOW8+kDKZF06
         XHeNTkXJUW88gkd8hEMtyFuj+7w4Lf2C0gKkxlIFJOt60Zv+cRfDee9l4jFX2sNY2zAC
         37nxUSsN1eLd946Aob2HpRAeDsWO4Wze10HG1VbqtRS3Tqv3WdYtDqsLwaX6KhI6wVH2
         QqQw==
X-Gm-Message-State: AFq9FYI1ZK04uFf22Q1CEu2nxpPgLnEHvWWB6skkr7zEVztcXfvEb2HE
	W1c57EgY+DXhcPGl0BqgwRixUIudTgihGFc2gkiPDAXd/5noNGoAIwi6Fplskv+DYXQ=
X-Gm-Gg: AYBFou0QC1OPqtTS/CrJBcrDdSmJV50jhl0tSm86zZMPZa2XfZ8ezimWHvwAIvrbEgt
	nNuGhtzc6QC8oyjSchg8VdJwlOj2du2YBSste5B1x1CzfhgzcNSMBplQSgPPQsnnhdkuCUSXyKA
	fRCgshv1RardBcWQ8ExhHOUvTXXClag+OXqwlU2lZMl64xnKlci9fobt3We9cC/u/ZnlAZOh6eN
	uvvXym53hjVpMI5YImeAkZUdIDuXzTrfxLN9BTIF1dX8jfF6tlh5NOXCkupgQg4jZpbj67iUM1w
	AOOW6Ts14cq1BBWYMy6KlM/8wtUViFm4bKsZ1Bw4oe0lE0wPm9lVnG1B4+mjHQdkrroietkwSPz
	2PxhnvvGc3buEJ0bIX7tnXi0CNUe4XoArg6z1YFpLcE5UGZmkN2sZlzgEMyie037shSYKtrHtAK
	vBsdiL1EN0hNkGzy9ARfqT+jG+jBjd8YCiVsVjjBFfrCKaSqmUmfRGxQzHHWKZctahcw1pRKqNv
	0pt4NoqRIhuvi4qKf4JlgYqVGqDeGbwTiXa4F8/yTLOM24OaInDvWFxNy0Tt+KOKtmE+66VG+oh
	4fd5oaEypbkDoDM0vsh7dRWt/o+fyt8yuX4Acj+qiyuR8/kOxkY5SuXzwP6mWT0u9QG2G6gD
X-Received: by 2002:a05:6a20:430a:b0:3e1:78c5:dfde with SMTP id adf61e73a8af0-3e92903d6a4mr8950975637.87.1793616804031;
        Mon, 02 Nov 2026 02:53:24 -0800 (PST)
Received: from [100.81.10.186] ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb0981bbc8sm2864285a12.26.2026.11.02.02.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 02:53:23 -0800 (PST)
Message-ID: <5283a93e-8373-4e2a-af31-88e50522260e@bytedance.com>
Date: Mon, 2 Nov 2026 18:53:18 +0800
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
Subject: Re: [PATCH v2 4/6] ext4: put folio on partial writeback validation
 failure
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, riteshh@linux.ibm.com, yi.zhang@huawei.com,
 stable@vger.kernel.org
References: <20261023061851.45579-5-sunjunchao@bytedance.com>
 <20261102083649.3798099-1-guolingxing@tju.edu.cn>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <20261102083649.3798099-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 4:36 PM, guolingxing wrote:
> Hi,
> 
> Thanks for agreeing to drop patch 5/6.
> 
> I also noticed that patch 4/6 duplicates an earlier patch I posted on
> October 16:
> 
> https://lore.kernel.org/linux-ext4/20261016142524.655789-1-guolingxing@tju.edu.cn/
> 
> The earlier patch has already received a Reviewed-by from Zhang Yi:
> 
> https://lore.kernel.org/linux-ext4/743d1d96-40f9-4dac-839f-5d5269364b50@gmail.com/
> 
> Could patch 4/6 also be dropped from the next version of the series?
> 
> Thanks,
> Guolingxing

Sure.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
