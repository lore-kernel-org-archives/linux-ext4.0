Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6C8429CEC
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 09:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067636; cv=none; b=huYpzyV/NJnZ9QoHjWQgliDDjBL1LyXMdjuHjOJ4w0Tk1Qyfy6otWC3X4Cejtmi5/67IWkGKcCsC4ftsoCb0JqRH86m/EifLEtdnx44h6p+8pj2J/Ft8pqodwvwb+cIG3yYlF03zA7H3KA6L15EBBtMQKUH5s96AZMIpuBtC2Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067636; c=relaxed/simple;
	bh=HmmHSOBi6Fqj+ayaB0kp+lUWkEfnbaCEl7Q3FaEXEB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZJatY2yBcU4JV0NeVoFj/4/ds9hpCtwrXo+CJS9hx0cZDjBCH5at0WD28P5ZD1IV1gSigHlbQLPpJBroEOaoiYEovjzY/yuayo9zq3Ow/pDHdR1yW+6VizNNTaSO3GrCgDbPXggoKmFrFRQp+QDAf/ebhC/Ge4vQc61+MUfEvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcDyGPzS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zvj6LuSE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcDyGPzS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zvj6LuSE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
	b=NcDyGPzSk+OMiF0X1bWzUInOqvB9z2HSoc5ojXzvKOgwPb7cUmUFCsFflXt/le2KvKMXec
	obtk3rO/AuWUHEmccpQZ9d18p4xClILt4VolKeXgbx7yiBa6sVVBsVNKAZfSJcFpaDf4z7
	EH/5zDTC7c8Q5rt8N0Etz1Yon/IHhhY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-Wk3bovtTMr6B5KTzcypscA-1; Tue, 22 Sep 2026 05:00:32 -0400
X-MC-Unique: Wk3bovtTMr6B5KTzcypscA-1
X-Mimecast-MFC-AGG-ID: Wk3bovtTMr6B5KTzcypscA_1790067631
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c25edb54d22so469652766b.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 02:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067631; x=1790672431; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=Zvj6LuSEQevmekF3sv11Yn9+PZ1zxrFHNmv5GiOcmad5jiLAbxwwTM6nTE+lQBw+h9
         PAVdMFTUPul+gjkLIlpiviDMT0W/k7RIVkWQwmcc0sZusbw8n32eoRmg9Yh5hlIjpPHf
         iq/D7kyqJNNUw8+MKAO+QyqPdv5J9mxZEjze3KrNDxcnwiKfNmCYqSKr7JW+9KQ80N++
         7riRz06C1PNvE8tLlmwMITFvNBoIAZX8g1sRfsb4nk19z1I4ahMoVHw1063tTpQuIdcu
         Xn0CbGv0xQE39mYsL49gH6j99Aq8THSI7IHOGycb3TnFoWWEp/kQKRshKZaiA1rtDlvg
         ZAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067631; x=1790672431;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=h5W+p2cb+2ji8outpIIkFemY/3MjEGetdQyr2ZAoFBwXTooV4SyBsMXHuEm4wNSIds
         BFf/4E1mwkQ7S8Ponr7jMfp83IJr4GEjY/MZXzSW9x0kakOxmrhZw4GBjDFCye4fXcBP
         +eY1YxmTG2z1nNY4siyCl0Xt3vZ/xNLuZXZ3aJqET6aCJYxFy0LNz8UGx1PhK1+Q1FkC
         VUBScVd5oqYt7uFAqvOX9fWdhGUakN/YMCVtD/oTtFYhBCJ1OTAP1d6ljVZ6HgAmdAdZ
         o8g//vaPSl9EdGY9V3OnaXidflNp77tBYReBv3wqvV8Z3s08H/hExFeiYUOiPrO8VVsW
         OB6w==
X-Forwarded-Encrypted: i=1; AKwUvBzxoKtFfXytzPBlGQiWo/xDaAjyBuTyGj1EenqXLxCxJSbaSaTfOFyVvBpuqm9fQepsxNjsP5ifhiss@vger.kernel.org
X-Gm-Message-State: AFuF++lFTZPYCTPpwgmFPxDaudkX760suXxe17Q9PPBQCM90zFxzSHs9
	9IEN3ddm771VnUnnFYbY9mO4G3vjtRIMX/ourX0oyJlO+3mgShc3WOOHzfGUL4N1voG9ch99+Up
	wNTl6a+osAo1fKeymKXhOjL0K3NMhTfbjVGXMoOx73YoZ8ufttkdUPFP7KI7NcA==
X-Gm-Gg: AYBFou00tpJ6ENPqmC0Y5iri+WtkRjLE4THymp2w+AnaHkOF8K1kv3nighyfS6NCyKi
	leR2S7NYcP4ZpgUArGDLsU/p2uqlGtMcXqyJUmmO3QpTxfGPQg56DzOzVBgqD+qFSH6oqJTck86
	P15sPX3Xfw9Jex4yPKfaWS7Pldgp6NugPepfvwZznkGD5S+eOEmpLIE5xAzbv0NU87Rp9EEqGdp
	Yc4HVZteUXssnaadXYMZqj1t5eWvUXMyum+6XC0z8WVZAoh119Xtb5/ZMcM2PCTVQPxvaUVACgK
	ylIlhQYM+TwYuszZGsCKE7SqRoDz/s161KPSmgJCOhnJY/Ekzp8vkvLqjV+/f1pOqIu9V6iByvx
	kyfoyKvB1xjDeZF3Zx0JBnT3dJ28k6RbQEg==
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217330266b.20.1790067627784;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217326266b.20.1790067627294;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c4309c7sm51460566b.6.2026.09.22.02.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:00:26 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:00:26 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, 
	hch@lst.de, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260922045144.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922045144.GP2705364@frogsfrogsfrogs>

On 2026-09-21 21:51:44, Darrick J. Wong wrote:
> On Fri, Sep 18, 2026 at 01:15:12PM +0200, Andrey Albershteyn wrote:
> > Hi all,
> > 
> > This is next revision of fsverity for XFS.
> > 
> > The main change from v15 is addion of kmem cache
> > xfs_fsverity_ioend_cache instead of adding work_struct to iomap's ioend
> > struct.
> 
> FWIW, Sashiko found at least one or two bugs, but the reports only got
> echoed to the ext4 list.  Perhaps it's time to discuss allowing it to
> email linux-xfs for bugs that it claims to have found in xfs code?

I'm checking its report for fsverity series, but for other patches
not that often. So, maybe it would be useful for "critical" and
"high" priority issues (not sure if it's possible to configure it
that way).

*this time sashiko sent me a bunch of "no regression found" emails
which I think are not necessary

-- 
- Andrey

