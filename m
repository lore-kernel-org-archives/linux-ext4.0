Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792806791;
	b=FXcIB5PT3Nib+O4cQYp0dyoThbWuVL/i55qD6rVr8HwQ6m4h8pi1fz3rb+nKg6q0kEAK
	 Po10CYpTLjgg6jCqjgaR0JwRMOFlr+zlT9310CB4lprRUylypCfs20OcwBBntvBMQcxRI
	 qmTRtc0o8Y4uoHSTNGgO42PDuzQCRZDSHR1azGYOpVQhxE69u/KSCVHo0Dqll2LZZfCOE
	 wCdeXK7yrm7LctK9PqKXSQ4pPVYMWR629Y+WjG5KgZXxrkdGBd0bevGoxHQxdOp5dcLOG
	 vB0b/KYJoGCinAv3NAjyPJz0eP2gtLnoj/k40mgGdJtq+wVAG6S4NtPLwYs716QSsuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792806791;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LjWoAWdpEMOSOVmikYJXtdPPuJN6QLrm0MKN423NGus=;
	b=FaAo5dGUznpFgAYpdo3D48nKmHMEVMrtQZbIx95tRPurSDOd7rmtu2F2BdfbtEhBxwFa
	 kVAnzbFTJGn+nGNRl5WRolBnrP8oJkpzGzi6vYgPa8I5FxXM6urN8AyuWPUoG95PNTpXM
	 C9+cziKw0QXPdqBHnv9CSu/2Dc9ZcIxgIbC67vycankP6NRPmfkLFEcYiMKUVcJalBb7H
	 qHs9483vD1ZE010WvyEpy42MxZkO/HR2vXcSNpLgh6abqMXEiLeO9/QDDXpnarjjmx/90
	 2VN1y6tDzS+Q2P5xDwN8bhhdT1LgQXoG6tEJh6TcE+spqa2vCO6DZH5ZWhgZmBgoMHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YPpkhyyv;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75BF606A322
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 01:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B75BF606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YPpkhyyv
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2776325eec.0
        for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 18:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792806790; x=1793411590; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjWoAWdpEMOSOVmikYJXtdPPuJN6QLrm0MKN423NGus=;
        b=YPpkhyyv5hzFxNx4hYdWsiT+HV814azrCr67V+G+wP4mksFY+TstfA6X5nbFJvobdp
         DaIZbD9BpidwuMYdiIEMFjDT/1oZwf6Sl9UWdQJAEakU3FOE3pQ0I7k5sYIHQZwa6bZb
         CmKFjmDitTn0FioaO5sOnmxhRyktRt7BIxmQ8RmiHLgUY+Afe06x0+srbWIDJTDKOSm3
         0Hnpx5CRc9yg2+Q+7WVltFvoxG+yH4OZBhBRoB6yDiKDnf9dRSGhjQie5zq8wTn9uuLa
         QmqVm419VGHeLN7ikaqfiQxQ1D/M7NaS3eVY4d3/8vGGmgPFUtInWjiEW3XtGrjFqxt7
         s1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792806790; x=1793411590;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LjWoAWdpEMOSOVmikYJXtdPPuJN6QLrm0MKN423NGus=;
        b=g0Rera+AH1gCt6S4o5aj34CRgzNvNgy6al3qac/Q/8vYK4vMR8Yry3p5LCiSpq8/GP
         /8K5l4mBl0E2dvDnHuHyJ0lf+LkoIaojnwSDuXM/aaFb5u9Fp4TcplmMMpDhath5+H8P
         vEOObdzpbYkmPoQE5bZtwORmMgQSguixSyFrIZAUgVyElcH6b4p4phxVthyQKz53LxfS
         M024Mn84+av5jYdNr6DFWebpgfwumT9o9G2c4rPBGIuttH3txI8xddT8QKSGPvj8Y+BT
         RROkwmLIuqtqE1XfCI9EBUe/i6LdVy8ifIubZs+LCqsCmyXRtXFpwn4GDUJdDQJgxV+H
         TPmg==
X-Gm-Message-State: AFq9FYLAxWwsEwD2weM0F7YHrb8Lc5qnmNfkdfJ1OTvqAjhAGSBo0Eq7
	kl/2f6t0Hi2z330gfcRbhmU1a7mHMDIV0pFlnFcbZcM6irYS1daYx58s
X-Gm-Gg: AYBFou0KCot22nGuEXQTbWKHvfSvF6re5AxjizYDlMQ4xE6rRqG/rXXmp7KtC5XErnM
	yxflikiQCr/YJJfykxR5GalKi8m65jtIgHK17XklpjSFeb1vJIc32ji/QrbLj18Dnl3eg78OW9Q
	scJDsCc37f4Rkd6B7AiFRbhlcu1ZXhsmffGJyankFOuyCnIaqsb42HCrYNY4RJaUPDiYSTge+gh
	80FPShtjAWCwfGqg/Bg6RfbxcPBpREu55dUUoK7X9IS1JSFJqM1xi5lm3QRVvZSUy0uhI7zPBvf
	jPnKsckjicPLpr17V2R20XcnSUgrswp7rZXCq4lAOBpMQZ5E+66pWThBrktYdleNRoIbXdT3zN0
	PDM7OyYNUkMf2Yl57CIeINPdj+5CsjPGLfVZnEzsoT1GBD1svulgoXa3hsg8D7wQEjhWc+VLgqi
	/5v7nuAPZKne/S7LN+9pqVGD9YTxpaTuCltct0dmW8XIB7o6WA/PPnJQkPiTFogKQ6cUfMtwuy8
	Imk0I0c7gYTfFWVXkdvHG94ou7AoTRaAuUrIUSg28Ww7LKsmTGcuPhkA4u80rrdSqQBIpF2gPYm
X-Received: by 2002:a05:7300:ae18:b0:366:f9c2:9b16 with SMTP id 5a478bee46e88-369e8502798mr1345628eec.31.1792806789656;
        Fri, 23 Oct 2026 18:53:09 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d95e91sm2474651eec.15.2026.10.23.18.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 18:53:09 -0700 (PDT)
Message-ID: <02b542c0-8b25-41b3-b271-fb6fde641544@gmail.com>
Date: Sat, 24 Oct 2026 09:52:40 +0800
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
Subject: Re: [PATCH] ext4: return -EINVAL on hole in
 ext4_convert_unwritten_extents_atomic()
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>
References: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/2026 6:23 PM, Ojaswin Mujoo wrote:
> We should ideally never encounter a hole during the endio conversion as
> that indicates something is wrong with our extent handling. Still if we do
> find a hole at atomic write endio, ext4_map_blocks() returns 0 which would
> be returned back to callers by ext4_convert_unwritten_extents_atomic().
> This can be wrongly interpreted as a success. Fix this by bailing out with
> -EINVAL instead.
> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Ha, this looks good to me, thanks!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>   fs/ext4/extents.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7193429a05e1..b54d8227786b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5107,6 +5107,14 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
>   		map.m_lblk += ret;
>   		map.m_len = (max_blocks -= ret);
>   		ret = ext4_map_blocks(handle, inode, &map, flags);
> +		if (ret == 0) {
> +			ext4_msg(inode->i_sb, KERN_ERR,
> +				 "inode #%llu: block %u: len %u: "
> +				 "hole found while converting extents for atomic write",
> +				 inode->i_ino, map.m_lblk, map.m_len);
> +			ret = -EINVAL;
> +			break;
> +		}
>   		if (ret != max_blocks)
>   			ext4_msg(inode->i_sb, KERN_INFO,
>   				     "inode #%llu: block %u: len %u: "
> 
> ---
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
> change-id: 20261023-ext4-atomic-endio-fix-b4-9e1ead9e1aca
> 
> Best regards,

