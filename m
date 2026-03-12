Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536D32D97B7
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323465; cv=none; b=MIeJQ+kGAFTejLCZ0vFfJD0ILFQKBeO0GoeSHMQw8yWVYlQKrB/zZ7mzawVpfwBawRfcQFRaR1EzFb5UB/IYV2QZlDAmga9G7nIsP35XqTebXLmlXv5lKO/TYT7hts1rAl89ia1gceSiWqkk97DkxacmorOyaNczPN4ZPmKaY50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323465; c=relaxed/simple;
	bh=m79QPg3lZxtO3qB8FGmL4feJvOHf6hv0uj9IuHB+gbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7/Bl3Vujoq1uPraZF2emd76hdiq2PtfZSfi2I9bIBqXBWXIFFuVUhYQNn88gjC3exoaXrKPDOLu+HR7oqxR6iZypzH3tUYuaFZtZ/etHI0ChKy459Ae7huCYyCZt8De3CBMcvk0rPxxavgktlk56Wk9cmNOIpkUXB+IJsTGjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlsVTztL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKkFTRLV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlsVTztL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKkFTRLV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773323462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
	b=WlsVTztL9Q7LVBAKNoZOhRHsqYJFjMRLCEzzuXMvsNKwQYfyT1pwl/DnxPa9WNqHvUDBJo
	vyf28QBR4OzI7ioOciTAFIJxcTMoMe+DuhlB1u0efcGmlCkJP+4RnZN4MbtnH6hQCaHPg4
	TaKkerjrhWVgTFnzT0gTWQzXRiAvog0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-AQqVzvLJOySq_0Syynpuxw-1; Thu, 12 Mar 2026 09:51:01 -0400
X-MC-Unique: AQqVzvLJOySq_0Syynpuxw-1
X-Mimecast-MFC-AGG-ID: AQqVzvLJOySq_0Syynpuxw_1773323460
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48531e8ae62so7679415e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 06:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773323460; x=1773928260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
        b=UKkFTRLV/0FpcgXxXaAqKqccZ+9UaoVYGX+kZeHJOOWrZj1hl4Pm7YWUH46/PUxJpR
         JiHomMvQ9oq2nntEilD//7XxR2aeabWZujfCvZvx+y/D6LFXN3130DKQl5bQR9jCn0Nk
         luCI6ukJKDwcMELQQFIKt90G3QIDBejsjAAFW8ge22JgldGzs3sRD2xxBUEb1FSPOhjr
         bhkAbZyY6BVEUvWXfHfdXBiYE5Boodi3Xeuz0E79EcAcLYH4cDiuE21xHpiitsXzt7jc
         yrR+1ajoWsiUsOqXxcpNCTQAFZFYKR/Fkuxy4D7CxUgHgGbg8i3gklud+A/F53XZG9DE
         cGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773323460; x=1773928260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
        b=HkloZcDd78zrFXDdqLQI4d3jwRO50/2BckTRXEiIhAPs2lBpkMT4yOOuCj++miRLmA
         5JIgaDgKcT75d6FfPKH/ZIDdEvexs5DBi9jhAUdi7FWvDRZGkN68pFcdKJp3jN2IFHTG
         qyXbPqG+oHG+p0bYDYz2Qq6EY9Oq/fFNB6f8uzE1NyIBqbHEzwYKm84lDdmEILe1tKKi
         5ErCEKbvk/yX7a+lrE3PS/3zbPRL7a/K4ekEKybzNPpRpACMrRyWI1GkszQJ44GcB4yw
         b+dIDf2hXHooe5TJB/vJAg/UnqJTMhx5d00bZCtYzJHAh0JY+1QIjoB3dda2nerx3hvY
         ecoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEvWHFagHpp1x2fLGFB6K/vT6/1S4y2j2CE8wGbeof2JLz+qzi5/JJw3DYfX+J26vXdmqPgQJX28Mr@vger.kernel.org
X-Gm-Message-State: AOJu0YzjAyR0y2sTz4xMDid9XBNymDX81voDYTayloVqqSqfpYwoJe+D
	qBXrFlLNZJ1S9O2KudrI01yhRaL1XBqauXoMX354EtX+S+8sjErWiVXoWWHnIf7DoWAGHxW1HnX
	k9B4ttZ+4BaRAB5BEizCvQBQPo1iMqj4id2Wfb7kgmkUG06gNxq/oU0GhlxAmkQ==
X-Gm-Gg: ATEYQzwTCP/4O0b/vNIe5a4DVJ9MprQqjUyFUlvswpI0h73WsPF9ru0ID10M2hOzwM/
	8AFfsBUjgMtoc2Adj1QVM5Qsv+4VgBQ1vt1Ejm4ILaGpEXJXshXN7R+CJODNG5gRYc6R3oZNjQ3
	6j2JK96Ztht6+0JrXkJW+Fue8c5XvkDCHhEuBf1KiG53/vwyHtGZVhDeClYwqi3KwOP1/1hpU4v
	R8K9ffqlBvlnBMxztnlzRzl06k2eYE3tRQtSZXjAeReGhlBGHZ3DdFIdFzN3s1RafZAfvsZnoAQ
	uSap3R3HHolfC6XRx8w6A13IigUGAdSrmzK89gNm4dQAqi6wQJvC1iDDM4ob71tfEoGLM5xkFK/
	zMYRpQ6ofKTo=
X-Received: by 2002:a05:600c:1e8f:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-4854b0a4c24mr109097945e9.1.1773323459794;
        Thu, 12 Mar 2026 06:50:59 -0700 (PDT)
X-Received: by 2002:a05:600c:1e8f:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-4854b0a4c24mr109097485e9.1.1773323459224;
        Thu, 12 Mar 2026 06:50:59 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fdf09abesm8106385f8f.0.2026.03.12.06.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 06:50:58 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:50:57 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
 <20260310012914.GG1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310012914.GG1105363@frogsfrogsfrogs>

On 2026-03-09 18:29:14, Darrick J. Wong wrote:
> > XFS preallocates spaces during writes. In normal I/O this space, if
> > unused, is removed by truncate. For files with fsverity, XFS does not
> > use truncate as fsverity metadata is stored past EOF.
> > 
> > After we're done with writing fsverity metadata iterate over extents in
> > that region and remove any unwritten ones. These would be preallocation
> > leftovers in the merkle tree holes and past fsverity descriptor.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---

> There's an upper limit on the number of blocks you can unmap/free in a
> single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
> loop body?
> 
> Oh wait, you skip the written extents.  Ok, so maybe just roll it after
> you've done a bunmapi.

I see, I will add a rolling transaction. Btw, why skipping the
written extents let's us use rolling here?

> 
> Do you need to purge the cow fork too?

hmm, what case are you thinking about here? The fsverity is written
in past EOF region, I don't see how COW extent could be left there.
Can they somehow be left mapped for blocks past i_size?

-- 
- Andrey

