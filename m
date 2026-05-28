Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33A628488D
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779978341; cv=none; b=hN7kiXVrKqW3boIJvRVERioMtYYUbiwtY+W79nrNkFFl6BKT8agovOB1iehqrQB+FNIa7S9MrEs3/g7wIXZRhZ7/SROk2UloUtxi+6vyCof5FQHb+b2OBRfeGchlZhOShGLHkXZFfGWB2sp7SlEMa1fuKhi1cUXKlXzdC6sFcYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779978341; c=relaxed/simple;
	bh=BpsvskD5wGtm+fNEsmdCh201ROnQWZkcNYuNK4LTV6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwksxHvCgcwYxiwotcyBC5vGif969gIE1nZC7zn2YpWrEomZsSPxp176qw2KUHNrf5cLQaV8zMcE0BcVA08seao6bfK+d5Wvma3UjdIZEHjxkg09pJ1loeAWdd6cPTMsNN3/zrx5rUDgvDSq7HApTB6hBA3v0A+53wLrmn3Hs70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxsJd3IT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YaJfxumc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxsJd3IT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YaJfxumc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779978339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dETrkfkZjpOGKeS3HifTKOdzV7lpxcD3Cmea947aREg=;
	b=bxsJd3ITuv0b/LaR69pcTwXWunvC1vXtWxUUyoykTb5QQBMT5arztkzpRc+YtV0v0sfbEb
	Lbu7h86z0kSc22Qc0uUIh2u9m+K1HN2POnjehb61ItByNSy7nNfG58jZSRr+LEPNSo84TK
	F0Tqa1ZhcuIeSPqqofAsLiO9gPvChug=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-cFPv9N7sO-uGzMsojcd4qw-1; Thu, 28 May 2026 10:25:37 -0400
X-MC-Unique: cFPv9N7sO-uGzMsojcd4qw-1
X-Mimecast-MFC-AGG-ID: cFPv9N7sO-uGzMsojcd4qw_1779978336
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49049100a40so42083855e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 07:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779978336; x=1780583136; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dETrkfkZjpOGKeS3HifTKOdzV7lpxcD3Cmea947aREg=;
        b=YaJfxumcKakXOF3LaRLcP282b+Or2GxbTwXcN0J9S9bBpgkoKxeFwHInlxIuZTVMQu
         EJm2sWBmKN7BmJMnd1LQ88/qvCMLEvfQ5MosGyZa+d3p4pqvMJwvoj6m8aOOXNT3hUQr
         kw5mG+w0DnfiTIpET+xFiVXvJqUTAQOXuBYGjUH/7ErWt2wZda7p5ydTgIUeKzrCo8sc
         F19TB0curxqaZLbL/Roi3CsqHLtLwqY7b2NyAkesN+DsLEuo6ktdy4ehiJR3Lk/5ygLg
         lPQygRYT3lQmj9WHNVrFDILE8bAoe+VOC7vAvzhOA62dWDO/RoVXlTzXk1m9dgBJIaee
         XDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779978336; x=1780583136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dETrkfkZjpOGKeS3HifTKOdzV7lpxcD3Cmea947aREg=;
        b=TIsP0g8O5mokVeq5wnuRmutjUTK4QSADAFmN79f/P+4hoIfGolOjQDUJGNeubv294/
         1slS615vyI5E/86I2W3k+8SdZV4f+XJfdYowUdLXqWwfBumdHLIplSPo4oBd9w16z3iv
         YYB4qg7mC4PVlBywnphlRT2+I+9E19Aay01SOyS1poDF5Wj/Jiy9Y3jUp/A/jFVwxWc3
         HcYAiFqt15K1kMQXwHlLTIM40mah5a1TB1mq/HYki7Q+ruQSJ+qTydncsXD2zdeivqmi
         em1ZD+l1q8B5+ld1uc5ZykAAsb82urr7l6TSBIkPAmyhpi0Uhlf8yubTqcEzBga/Rbcw
         lr9w==
X-Forwarded-Encrypted: i=1; AFNElJ+8BtwODbnwtNtq5kukY6tmkEEJFU/UOcxJmYwcS+A18vNPjpFg7k3sRWqLfj9zORhOOGTpNVCU40u8@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr5Z35rO3oM3Y/+v3fhCtHufXaFJ19bLGuz2ZB9aDRpxU0tgvt
	WSzonCKZBMAEPeEtH6FSIdonlGjlV6ULOaKLe02/tK70IFXY3NHYIjBc+ThFDQgMwxbXkXH6Jd/
	PzZP72o98c3pUBadtxJOv7vXNUOi+by51OSriwYtoaYYoT+zVNElGT0McQn1rKw==
X-Gm-Gg: Acq92OHYqps9Vr9WLZZu3dMkR9I+nZMwt/hGfV9+RtqDR72OoRAJFt0IN31pNFmhr0L
	PARvTn/aiZfW75E1Bk8ywIlXVcJiT3Zvgnzl/u/SJvBmZstJTREaKQVYjVQW/0lnMHyeZdmoEcI
	/IgKA2NHsAUcNfwK7g3hU932urzhANLPvw3EJp0oo5uR/YUHL1mOQNtFcEhydrKNlAd9vmY2wHb
	JJZzABC9bGQ++ML0MzPRb6wFiOmSqU3nLEI9se6i1c5Lmx5Mb+2CveM9O4D/9DotVf/C1KX6aU6
	au4o8ci0OcmcSFqDg5lmz+JZd1GqtTdzTrYJ2fFLHtoCil5tQMpNTvmF4KKiqLaQxoOBw6mkElZ
	MuPeTw+B3seWFGYQn4juxFHKJTU8MON6sPPInqRi0x0iPinN1wtQZzUx6wzKp8+DlWA==
X-Received: by 2002:a05:600c:8207:b0:490:688b:ece5 with SMTP id 5b1f17b1804b1-490688bedbamr260601775e9.30.1779978336134;
        Thu, 28 May 2026 07:25:36 -0700 (PDT)
X-Received: by 2002:a05:600c:8207:b0:490:688b:ece5 with SMTP id 5b1f17b1804b1-490688bedbamr260600915e9.30.1779978335469;
        Thu, 28 May 2026 07:25:35 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49092a925acsm77606985e9.14.2026.05.28.07.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 07:25:34 -0700 (PDT)
Date: Thu, 28 May 2026 16:25:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <k2g674gytgm23ef6jfhfikckpnnw4evuobkxxhn2quwgr7dplx@432kdgezw6nu>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>

On 2026-05-28 14:20:08, Christian Brauner wrote:
> On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > agree.
> > > > 
> > > > You may take it through the xfs tree if there are no conflicts with
> > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > vfs-7.2.iomap that you can pull in.
> > > 
> > > Merging the iomap bits through the iomap branch might make sense, given
> > > that iomap usually tends to see quite a bit of activity.
> > > 
> > 
> > That sounds good to me. If you want to go ahead and pull in the iomap
> > bits, do so, and give me a heads up when you do it so I'll pull your
> > branch locally.
> 
> Great, can the series please be resent based on current vfs-7.2.iomap
> then please? Because the iomap changes in this series don't apply
> cleanly on vfs-7.2.iomap so we already have merge conflicts...
> 

Sure, I will resend soon.

-- 
- Andrey

