Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F9381B1D
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567052; cv=none; b=kqxlopN7VDZhwdqVpsMH5G9lBPYdumFBT9yfn9cFSmqrUl7V1kUnTVK682uvJtJpuluu4fNSimal97mbQjMmDZGUl9AWxLnoGcKxZLYMkYITfB4kjhm9TX9LCoz4X2qFUWkLyINtrvJIxOAZjIUitBfC2GBTFpuPecM+rfz6hQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567052; c=relaxed/simple;
	bh=eFD3WPCmglnlOAxlOFy/ZCOv6hFf116irxgZZsCso+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X+WFTd+LO8ABT6QvP59OERptZMDycNgkK2MHe3QzUK+WxlIJkJRse4yDFclbAt80Bar5yISvr8ub7LpSAfDFE55Ds8Vjk8D4D8Qq+Tus7mZtzPpb4SgKKJ92jR8bx4AJo9nlli+yJS/X7gV/kAfXKG359Y4/XmL8YKP3jRz93ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxpoRdEl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kD7lpGGq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxpoRdEl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kD7lpGGq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789567041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=si2ROIQcvCsUOop+V1xZhSo56xdC4eQzPJO67kXhPWE=;
	b=TxpoRdElD7m1x2GEkjRPYE+euvzSGNhtU5Nhy/hQF7sctPD5zzH327cZcrDZyn0fyRCCfo
	jB11FeYltqnMr4FUaZp83orA2lmEghxktTmi76DQy81Uvaio+5T83DH4DK7DX9auQo9zh1
	Dr/PL9Ha28zcvTXXcdD0/nGLnEsMCfw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-JRGcCuMVMqiTOevMUueElA-1; Wed, 16 Sep 2026 09:57:20 -0400
X-MC-Unique: JRGcCuMVMqiTOevMUueElA-1
X-Mimecast-MFC-AGG-ID: JRGcCuMVMqiTOevMUueElA_1789567039
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486f18da958so1229408f8f.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 06:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789567039; x=1790171839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=si2ROIQcvCsUOop+V1xZhSo56xdC4eQzPJO67kXhPWE=;
        b=kD7lpGGqVjXdwyzMVeWt+eoRvk/owxrBsowfZbOnSqeD5TwT9ie0SzjT98hPGVSwCp
         Rp5RbWKJF+S7+ZZvzptUPsypvph5Kbw66WgH4e7IT91iTC04W2tzn1rVC0B8hsG5Lmpw
         znlafzc5fr8gnjjM4cH2x/UxKrN+vlaPSgiJM+aiBqsWvKaVi+nnWJYOmk+W75UsufN3
         U6sll7ZjRncMr4WAC/OXSxdivQwHge/1z4PEE1+Hdn8QetkNyqgZXFlmDah7D9UndfXv
         IicXqgLFWQoS3Hny0cdvFI4oxchxnKQoHWMfuinc2QXXtYjXtHx1K2NGC8RNoPScLTkm
         jgnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789567039; x=1790171839;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=si2ROIQcvCsUOop+V1xZhSo56xdC4eQzPJO67kXhPWE=;
        b=JfNSlnIbboCqXgJYPsiakF9WBlq6JE5r7LJQb/TmE5toKkoCYIeBE+KfTw2AvdqjDJ
         nsIV2SNoHKvTOO05i5alSxUt3wRLThAmv16XceoQrYoWnm9Ooy2W44G34ZP4++YIG+i9
         8X3RqFV17l2V+1yJQT1XEE3EVoImIyXEwcNXdonAyO4rV2N2UM7ln3GgG/LlDq1xS1zh
         HNSFe77mUH1Gqr9xkR1AHrVlWdEqeMXIc4kWxOssozS/RVS2DzMaZgHztdi+hzcLgDXE
         bVJS8OokZWu15N33kfzefb55LaADk1yTXg+3urUt060XLL9u8a2+1YBbpk1APljfiOD8
         q0Cw==
X-Forwarded-Encrypted: i=1; AKwUvBwRJNQVgZWENlC1t6sUcSZ3xF6vRKtyUtqpQNiOWJDkQidBem+VXCV4MGbLdIS/DUnm2LVQ5Q1OSfW/@vger.kernel.org
X-Gm-Message-State: AFuF++n5IXtoSCxKkETE5RNuNPNAFHMyx8Sc4SpyEDOta47uQYbYofKJ
	csQRBag5s0Tv2lUpY20xnZyDPwP2bJOM2q9Au9bdPbG+m5v2n+8fmxCn7l+xzBfRZ0ZWrPDQFav
	Gxlhz69CjSIbI3Unk8D6JyRm8sWm3gDMeAC9uTtiB9MhIZ+ftyaL05sY3i+p1Su8=
X-Gm-Gg: AYBFou09FENFSPjCyhfqdf2YIURGTLvQyB0r/qIPiwFhBL1QDckeQo2kvU2iEGgfxZB
	f58nbt8/zNprgtdEUpgq9YR0s5SVwSbt6cY0euBwyPt4jl3EM0i5+LOGIJxi1je6YIxf2skZ1AS
	PH4VUqNyE+3V+P0hgT/ewr1OIkoUBJG6DLm8nxeVV0BZUImSpWwE+zHT3nF7dR7t8uwvw1nrsKW
	MidgtbyS1mqb1/yxGrWaCASvdD/1TWot1DqaLpTfYwxqTVc9RW78oPLA+O8WI65NJxVcxycta92
	uHCHQoiRb1PBHfzIsJpn/D6xXvYsYWmUB+CUJNS51EsdA11CTIJK4RH3Exha2e2fOYxnnlzLZjm
	MGLPus11frsSF7IZ+m96q1lXDnuNP
X-Received: by 2002:a05:6000:2890:b0:486:fcf2:fdf7 with SMTP id ffacd0b85a97d-48705b90f4fmr11674707f8f.14.1789567039032;
        Wed, 16 Sep 2026 06:57:19 -0700 (PDT)
X-Received: by 2002:a05:6000:2890:b0:486:fcf2:fdf7 with SMTP id ffacd0b85a97d-48705b90f4fmr11674671f8f.14.1789567038623;
        Wed, 16 Sep 2026 06:57:18 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-41-176-3.web.vodafone.de. [109.41.176.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fa70sm7071024f8f.9.2026.09.16.06.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 06:57:17 -0700 (PDT)
Message-ID: <6a790a32-e28e-4a79-9eb8-9bf039b57bc6@redhat.com>
Date: Wed, 16 Sep 2026 15:57:16 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ext4: enable scoped NOFS when starting a handle in
 nojournal mode
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
References: <20260721140152.461286-1-tytso@mit.edu>
 <20260721140152.461286-2-tytso@mit.edu>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260721140152.461286-2-tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/07/2026 16.01, Theodore Ts'o wrote:
> The jbd2 layer enables NOFS mode using memalloc_nofs_{save,restore}()
> while a handle is active.  We need to do the same in nojournal mode so
> that it is safe to remove GFP_NOFS flags while a jbd2 handle is
> active.
> 
> This will require that we actually allocate a real handle, but with an
> h_invalid flag set, so there is a place to put the saved memalloc
> context.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
...
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index b68561187e90..7348fdadc810 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -513,6 +513,7 @@ struct jbd2_journal_handle
>   	unsigned int	h_sync:		1;
>   	unsigned int	h_reserved:	1;
>   	unsigned int	h_aborted:	1;
> +	unsigned int	h_invalid:	1;
>   	unsigned int	h_type:		8;
>   	unsigned int	h_line_no:	16;

  Hi!

FYI, this seems to cause a warning during "make htmldocs" now:

  WARNING: .../include/linux/jbd2.h:523 struct member 'h_invalid' not 
described in 'jbd2_journal_handle'
Could you maybe add a line to the kerneldoc comment?

  Thanks,
   Thomas

