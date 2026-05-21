Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB9B37B02A
	for <linux-ext4@vger.kernel.org>; Thu, 21 May 2026 09:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779356541; cv=none; b=q/aVyrHMS1LId8EkaHbP9GH5bfFlihyBRdg8KbRM4v8wkBhHGxvx9ynNVn/kJNR3WRJJinTGL/DzinodwN2HBve4POgb/mmZ5yQbiPGxGginbebHs8HRIDpgJmbfSM9rQP2lBPQqwc1jMgpbzfoqqiTdhbe4ajjJXTE3qMXPB/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779356541; c=relaxed/simple;
	bh=/n6YuXXsfcsk7J7Yb0y1thOCuPSSvlN7WSB70uhim0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sb1V9GsjujR/dBdxsnw6sobfGIUzyZ/rHc+3fORkzlkPxLiPQmy26KfQTiAx7nsNF7PtTTKhVZHOsyFhzt5HRchs7TJbm1P952ecoBxY6F6URmdypR0pp196594nJBfccO/lM7VYZZ6lELJw+6NxRPwWZdXKST/WDFhnkJFEHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGcQDpYv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gE2mTH44; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGcQDpYv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gE2mTH44"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779356539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
	b=bGcQDpYvPLEbfBQZC3lTQsyr+3H+rvNlLXE3wyLChrVgz3Apo2altjc2wB8pfFOfDsNfFa
	UadquxiGdIqFnEDcyI2HQZx4+8VlVdn7CmW1otNXES/tIBRVaUSEV1co+/vet7wFiJPgDJ
	a/dekJKAtWfO86M4E3Kz6p0phUb113Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-fKWYgV7hM42d75SGHqCMSA-1; Thu, 21 May 2026 05:42:17 -0400
X-MC-Unique: fKWYgV7hM42d75SGHqCMSA-1
X-Mimecast-MFC-AGG-ID: fKWYgV7hM42d75SGHqCMSA_1779356536
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ea38c03a1so598230f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 21 May 2026 02:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779356536; x=1779961336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=gE2mTH44GayFr9mtAkmJVfSU67d3tm+/YLoN17BfGZH3Kca71yP9gzWsOKPeIsBvRD
         laEPjmCECV77JeVn2SVjFX74IqeEWHDMu8tUR8rhrshkr5wxfi2XcsVJccvbpbFEoWPv
         T0aUIqhFrL5b/ffdNRMW5j4OnaKfqZS5jKXSx8i7zQFOkQn+EJQ/EZi9N9/nAPflgD+5
         dy6pfrWDU14zulEvGUGFZnzpcbEeVydktffcHNVHMhfkzW3gi8amUGywq1wodNRvSV7A
         SWesHKw5+EIirgvWil3KTxyyGqJCG5WJq03iNKYm/EYtJ/BjPsF9U4QLV9nW/dOAZEDz
         6nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779356536; x=1779961336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=Ikw4CNYwIUy1PmHsPxfsny/pPL8bcm6sKXH8FOeoFtvNYMmHX1TCgkgcgGrc8KJXcT
         A2kbCADCZXJ2JjUvYTzYzOfkJyIgbnFHVic4eM2T0Mdq1DmqyNf435v4KPNT5EHj5zYr
         9M4sfEPO7u9bsjj3UgLyBdl5OlcB4lgl0dvDKpXWc/ReqQMrSNzK8Jrqim0aj2iJIVEz
         ANB3SuX/emztJQoDU5qEYMWui9tvCdB+5SpN8DhShbSdf0ecxYTQBAxFu39k0RFLmfMw
         C0dC2OiR0a92gRj+3DyBmKYdwhuQjeB7wrj6p+7MFoJdpW/K1Psxoa0v1vENn7rt5ZM2
         un/A==
X-Forwarded-Encrypted: i=1; AFNElJ9cOw5QkbdPUMYKaz5OOh5xtOndvVx1EPVNyv1yTFM7aJkM3fbIA5GMAcwfo3smvA1BQhoZA6D5Y6cF@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx6S3HWN3cgWFTUXzi1AqxBJ/dcZZrdZcK6VFA8k5qGw8Rezvu
	Qmj7Qtj+He5TuVN9nWUEXztLInpFtDDLhAFBmzXnRgFYMD2q/SQ8XcsqS9NJJWOdGAnZhLG/7Ri
	83iKsHOOOXz862IuJqi5uXG9oah32UMbillo4tqwV5iOAxZqesU+YZHQQcuWq9Q==
X-Gm-Gg: Acq92OFq5uK1Nwtpue2m6x9+nRQ4s7MyDVGOeQgEF91/6LT2TdWc8ut3IHSKDQlDlr9
	n+s1GVjyaIczkPURTUT0tl6TTwEmj3G5OzSNoK8l8jIe0QFvPEa+PrgViCrR2dm+4cbzak3gJdI
	8aA1zyAyRIlv2unElrwUSeaoJ0JSUyry58IVLXv2wNrmYL/CfKfVStPI9Z1YeXmDgxIJjeju32/
	iYLsqptRuHTkXt+88SLfxicJp7ZA/XLond2U4z0JrDshOetAKEQfSrEsopZ6K+Ho6H24L4eCkpR
	QR4B9SEVmLY4289Dg8ej03Hh4uZaFd9rDbU+EkkDXJkuTpkCyVo/mRiQplaKeBl4HBs7Jk6uQxj
	6Yw4hLwWYJTh71HtYG0ATjvo9+m3QFzsbNDOdO+27t1KbspbhS7uy/J4=
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775935e9.2.1779356536299;
        Thu, 21 May 2026 02:42:16 -0700 (PDT)
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775515e9.2.1779356535822;
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c9abbadsm13930015e9.8.2026.05.21.02.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Date: Thu, 21 May 2026 11:42:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090705.GA14254@lst.de>

On 2026-05-21 11:07:05, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.1-rc4.
> 
> How are we going to merge this?  It touches at three subsystem trees
> (fsverity, vfs/iomap, xfs) so some coordination will be needed.

As most of the patches are xfs, it's probably make sense to go
through xfs tree

Carlos, what do you think?

-- 
- Andrey

