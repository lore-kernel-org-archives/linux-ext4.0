Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78133C343A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773320254; cv=none; b=Ctnx7zTHUR8SEDK/AJvM5Y/42I9JSK4qu9Df/qVKhwMswMU8U1CJoFbtNZKr3MVr/iOteWBfb5x7q9TWHUgYyBbu04x1Uun5zfzTmSaGjPwjgcRWSJUk/xJefaly4BG9HVgVreSxtEaWBgimUNTlHtT+PFYja7lytzqyodtrOmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773320254; c=relaxed/simple;
	bh=Rr1jkAP22lZkLvo3o90a9fRSWh9+kilNKtAarSScWFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Saaewb2zUVyOAdtoims9JacBBeRTsQIqB96AjRPrL7XPLx6FQIlKmrGX+REFRf8P0c33G733IHprj4h+iwb4iE1WJABRkljSf5ln9vv6PKj+RwT22iUkU9IJZvyFbxTGyeBwexx+1uyECicAi8qHQX5tvxUQL1lLrGdRGIwcatM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fHqxjqGD; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fHqxjqGD"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5094b54a250so5475721cf.2
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 05:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773320252; x=1773925052; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1SF1XBHkHR0j7NZVucv0LxpGoGXl67PUefLsfwpAbo=;
        b=fHqxjqGD7mReR8MT2yBowt9MuNKPAKQc++mWcb4ZOttX6YldICO+OnnxWIQjO0C8L5
         wjOw0Gg7MqV4U+G9pES+s6h1NtZIjaKrBXMW81hrLyc8SxWYHtvQK3FlTjqiyroZskXE
         jYj0kUENL7Yhu5zg+0UQ91XYlYYlozX9U8uAqBEFaih0fSnDo8kprjTDRYJ58gzKRExo
         MSUW+Q+e0P2WpZGotx0DuVRaUqq4vGsUUSX1YbPnOxmRUKlXFY/aNRmXMXDbAEfx0Lnn
         e41FpuPSZjTSuTkWfTMW8e1MvewVXC2p6zLd4GrSZjvSKS4Q06nDQYaSimUW3qR5RhoY
         JV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773320252; x=1773925052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1SF1XBHkHR0j7NZVucv0LxpGoGXl67PUefLsfwpAbo=;
        b=OjCVCrO95//nApYbQrYuTS1o6mzb0apwdJVvX41UtttEjJ+xLS5UxH2/PSY6E/DIXx
         /iAq2oPP6IGWQKb0sXubnEKlj7rk0helcpGyv15hnJpFWKoB1u/CyIfWoILMfi4OAYxG
         RJNdyKattErik/84yPqmts1wi/fXmoDTfZR7zMKsOwccXEQ3Tu8wJ/jJJrQuEnwuRGrv
         nQcURJFW+CjGoTLzDxYo7T51Lpz5XbY4YqR+q63M1M3H2u9BwSXOh+D+PhU/1pqeFvnk
         2cts581nawQpqoE0vuT+97zHDLNU4W21z2LazzXoUEqmsArMoX6WIMHR0+zvACdV7uE0
         Kmog==
X-Forwarded-Encrypted: i=1; AJvYcCXbOLFEpMEi/By4NSqwsMMKquk1R0DaLgSZoOLjuwx6EMh7Olj4IsflHKhMKc8N4vkOldBQD7Jt2XSY@vger.kernel.org
X-Gm-Message-State: AOJu0YzsVwrZPI6SxTpDVLPe977tkM2p/dMO+UHZk+gBGU7A965+XIdg
	NB4COK2h6PYguddnz/q3DY/Mv3b22w8XMSfkzej5o2Oc1YzjhfqP5AmPGMtCdCnGvyI=
X-Gm-Gg: ATEYQzzUfT9voGmgEpNOtYDHmj7Rnlt1+votVVIgTmvbo2W0xcZcLvnhvyoyB8SjcDN
	3atw3BnyGr/tBTuomfi2OnRvl0GE46GkiIXD3YeWDSYG9wzTHNr7kOWIwJty7kj3ZlSTFsb66Pe
	qV9AYqEG2PVWuTCa8NGEz7p3HU7/NGAtxot8+jPmnCzR0Sk/JEnHGRM3/2ZGQLzM3HABqCkYose
	KSimETzv1I5TbDVRrJB2nCt55kOqXj/J7lQLCpIUM6fGVXtpNk8mc9n5XBO3UvrJ8M+3wzl4JiO
	FtVSntJSu9GB1/cnXhIEMoDEBwc+8KjiDgbx+iPe17DCHh4NFbd3Wuje9DDq2Z4ZZkIA7CaEWar
	C5wLItpTj05vYXsgiVzNv0QyRxsbmw1T6xIMp8Y7QbBYkqw/IKZCr+aqsmaUvbPBkD+WpXVKQ8W
	sY0h6z8DUXn+55fyv1nqR1T1P3XOx4PxPcn12PXJGujLkt/7hJWkMU4NTbXmW0rx+GEXgMsoX0k
	C1z4jiC
X-Received: by 2002:ac8:5d4d:0:b0:509:cbc:127b with SMTP id d75a77b69052e-5093a1bd58fmr77950521cf.60.1773320251710;
        Thu, 12 Mar 2026 05:57:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65bd318fsm33341196d6.8.2026.03.12.05.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:57:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0fbW-00000006fKD-1POa;
	Thu, 12 Mar 2026 09:57:30 -0300
Date: Thu, 12 Mar 2026 09:57:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org,
	ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <20260312125730.GI1469476@ziepe.ca>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <abBlpGKO842B3yl9@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abBlpGKO842B3yl9@google.com>

On Wed, Mar 11, 2026 at 02:40:36AM +0800, Kuan-Wei Chiu wrote:

> IMHO, the necessity of IS_ERR_OR_NULL() often highlights a confusing or
> flawed API design. It usually implies that the caller is unsure whether
> a failure results in an error pointer or a NULL pointer. 

+1

IS_ERR_OR_NULL() should always be looked on with suspicion. Very
little should be returning some tri-state 'ERR' 'NULL' 'SUCCESS'
pointer. What does the middle condition even mean? IS_ERR_OR_NULL()
implies ERR and NULL are semanticly the same, so fix the things to
always use ERR.

If you want to improve things work to get rid of the NULL checks this
script identifies. Remove ERR or NULL because only one can ever
happen, or fix the source to consistently return ERR.

Jason
