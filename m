Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC51F31F9A3
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 13:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049580; cv=none; b=phcwWXEVkOY5ZkP8aJ0tPzobwKvSaznI7MGQ2+udfHyyfr8OVjJOAayzWQXGLE7liPuv+xG8MnBitFXkALLks7z3EoV7wSK3o5iOfdz9vOUTa5FS6x68x6bAHfNkOxBJ03GsD/PElaC/aMRaGsDGFje/MXsuV43xzZL7t538PKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049580; c=relaxed/simple;
	bh=zRSq9GBe9RB8pR9poGoz6gdAAzNYkiK3X/2GByHGY5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHeNUE2PgKFOr1UtTYnLAjAfgsfkIIP6ai3+/KAxt6YgP3wMg/ONLWxfFh5F3IGKrqGJfb4p1dkZvychbBdsrUkSGzqkOjBwXl6XtPZ7qA0S9SO5OHYFHokQ3jH8M+a1bVSSTHsoVjDG6O0rtOr4bRhwoo5MULeBnUIsH1fW1JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dNTM07Pq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PebdmVVE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNTM07Pq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PebdmVVE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775049578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lyW12uBXRpbNCpKffg0iXnMuUrdM+MfpJppnsHO2xnY=;
	b=dNTM07Pqtq0jQUEe3/nEx31HD+7YqmKv+dVp+eJpS8HMwklYHPxprwz3BXmprTJMf1MoNh
	0/M36iNTkC77q3moHXjIhokUCyTrDv3oQ+Uay2JbeIxBDyB91wHB5evWnJ4pSI1AmdgRBO
	KXFIcW0FfCCBjorURtvOh+yamasNTlQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-KldmncEgOLOoI56KvM6hNQ-1; Wed, 01 Apr 2026 09:19:35 -0400
X-MC-Unique: KldmncEgOLOoI56KvM6hNQ-1
X-Mimecast-MFC-AGG-ID: KldmncEgOLOoI56KvM6hNQ_1775049575
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-487219e0800so47951775e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 01 Apr 2026 06:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775049574; x=1775654374; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lyW12uBXRpbNCpKffg0iXnMuUrdM+MfpJppnsHO2xnY=;
        b=PebdmVVE4cdNJ/jzEPt34+I9zC//EA29Ttu+HT3YKvXH9GNOER/JDErPV5JL5JwfH+
         XjxhP5qORrHDRxegzxqNo0V2rG+5N2I05DzDcdTwbLWkDYxfBmxvXbsymicLRt3PCI1e
         cvf9/2RvGPu97LIl5+WuxYxcPnFXiSrk01Z48FcFLYWu1gU99GGzY/6xSnka3Xz1UbJ4
         /64qtZkRd0806ffNceiW8ar0y1MpltkCdkdUJQpOhMaAy2JoarSXKQ6dkJN+E0dCZ9Ir
         qxDF+ubEUcsFQ0q9+HlyVT7gQwu3aZL8i85lF9cXRWq+JqGEuuRe1F+LSNMCMlaawEc6
         o9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775049574; x=1775654374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lyW12uBXRpbNCpKffg0iXnMuUrdM+MfpJppnsHO2xnY=;
        b=YPiT8DkpC3E0Qp9kGfIjsxug/3bVGtuPjw4XAUBCH7q522iHIAKmhNNQWXxNntHyJA
         tYhGEO+HSeDmOmp9pT/VMsFP0GqqXorb41OeeGdLPJbutU6QCJek4yGHfsJz98GN49Ql
         fMXcVlvgLtIqaEpkxkfZEWHp87P006TmdyYSDvyls3vs7G+WTyMHLMXDJ5bV92TbkubO
         HyOCLhGWvJbOk4pd/ojDsK6cWPhlPUK/S+stGIeyeWro3CVkr2VIXB9P2xEeXCrgvT9I
         kxxX3IoGbqruRnuRXRko3Jxfbqc9+e/cA0WXKVI0fZIxTn9yAmVXkdtwSLOPPlfXvaB2
         SA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkaDMYeooNlP0rrZNxyVCLOr2n5G8d+DflwfQhAtJWIE10L0aTYVpUX06pC7O22ohllKfTD42FPdfN@vger.kernel.org
X-Gm-Message-State: AOJu0YwxWerVSR7Um1mawpHCzNGUJuovrgwoDbdWUl6IY+nyclNsXOwd
	R30pmjPzCKONvfIkLkr619gchddEWXgjMe9kX9wx34fF/aWs3nuquDDyHC6kW05CQzPY2N34a9u
	EnSuu90rpxQZ9rlKt9/hV7dnwJDfmOlt6Exna7Ib6kSiSyHWkSMQ50RlCYKoogaV3sWGQvIxD
X-Gm-Gg: ATEYQzzj4+wWovIHhEEuBHM9ALErabburDvtetdtGgVi5ZjoCNMz/LdsQ+oqIbAsgGH
	zWeB++xYoDPt73nU7oRh61LgfurGimCoMVAXEFVe4fDLN4L3uhIKJ3SBVsxZzyk9gt8qhEZKUV7
	exHEOKZoz1SiNHts5gmj+UqU9bRu2s9orDRZo4P6Ove1xcaX/HQk0MJj3aU5PqnQ8YzDtiC6rZH
	OOG7LauIl0MNWNPPEeuvhfLg2xJQm0d7DCj5cRTzSXaP/yqoLjGYHTPrQ+vqk4/epQiODph4pga
	AU55uEk2U52u6wnN6YHr82a6Zzt2jmECSzxXrjc8aD2H6YYkTu16J3WI6xaRsZUQXIK3S/Wlj9E
	WnIfRWGxbPy8c7Q==
X-Received: by 2002:a05:600d:18:b0:483:6a8d:b2f9 with SMTP id 5b1f17b1804b1-4888356847amr45594825e9.5.1775049574207;
        Wed, 01 Apr 2026 06:19:34 -0700 (PDT)
X-Received: by 2002:a05:600d:18:b0:483:6a8d:b2f9 with SMTP id 5b1f17b1804b1-4888356847amr45594115e9.5.1775049573591;
        Wed, 01 Apr 2026 06:19:33 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887adc52b2sm43924305e9.12.2026.04.01.06.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 06:19:33 -0700 (PDT)
Date: Wed, 1 Apr 2026 15:19:31 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 21/22] xfs: add fsverity traces
Message-ID: <oxglumin3yplbpc647rudg6vqptkcfatf5mayzqdjcowfx7q23@p3flnabfpd4g>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-22-aalbersh@kernel.org>
 <20260401063146.GD24459@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401063146.GD24459@lst.de>

On 2026-04-01 08:31:46, Christoph Hellwig wrote:
> Wouldn't most of these trace points make more sense in the core
> fsverity code before calling into the file system?
> 
> Otherwise they look good to me.
> 

oh the _file_corrupt one seems to be not used anymore with new
fserror interface

The _read/_write ones were pretty handy for debugging issues when
block size < page size when XFS read block, so, fsverity request a single page but
filesystem fetched more blocks, but with the current implementation
it's not relevant anymore

The only one which still make sense is get_descriptor, which
probably could be core fsverity one

I will drop this patch, this doesn't seem to worth it for single
trace point

-- 
- Andrey 

