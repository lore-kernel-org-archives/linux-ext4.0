Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7F836897C
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 08:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783930606; cv=none; b=qp7t3kcdSgmcFKsi4JQ7tERM5MI7e7PZ5n+rU05Q80Um2ANPXtnE/ANoHBqYlSoASZDHJ5kUwxNEqheVle7mM3Wv4AvIWZr0f3arE6YM6l73mWNYZ9/+Gvcr6I5VT8YLkshsxk6WB/3Oe7MdUaBc4gFPVW+oI852IV3VePXAoa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783930606; c=relaxed/simple;
	bh=ZtGi/8vtQN7HKCumPKvrusANeC8z6jPebDpLjTiSNQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtWf4aTDCSfHiEixfa163pdNCTw98DwyOAeCec6kv9F0ASZTD4RNhnEnANUpsFvuK/OBJASvspHpNUtbXGqgp57MMNcqJ0efWaoP8TTa3colbMuHD/PXyOEj/q+ZDXYzu9Cp/V6HDC2htZbYNx1DF4ijOLTfpSVLQFuLYLuHu3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjF7/HKC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JoZcPSTB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjF7/HKC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JoZcPSTB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783930603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qitVlXfkVbLZ19rYAoRnVT8+321wabtilZzFTJ/EX/8=;
	b=IjF7/HKCR/qjv96qzWsH/k/tx49fge58hjdVAHConhqrDl86W5cPt2iFUp2k1UE/Qx3yxL
	xr4vRNSk3dsg4EUn+pXuvRgZVdXwaVC9u2FU/o9w7vDsMy4mxdw7MeYpxBZ9r2ZvUzr5P/
	lM2yq/fojRNb32FyWCqzGiF1E0S+7Bw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-4Jmw3LAwNJaM3I8PWFsOsA-1; Mon, 13 Jul 2026 04:16:41 -0400
X-MC-Unique: 4Jmw3LAwNJaM3I8PWFsOsA-1
X-Mimecast-MFC-AGG-ID: 4Jmw3LAwNJaM3I8PWFsOsA_1783930601
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493e0042895so21213935e9.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 01:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783930600; x=1784535400; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qitVlXfkVbLZ19rYAoRnVT8+321wabtilZzFTJ/EX/8=;
        b=JoZcPSTBIA8C0VMqpeV+NwwXHySPC7QVYnhz0G6CrLn+Ub4jicawpEuWLn3rpOb0xn
         msYhDG/Aa3Nn4KxGBdUm0163yAKCqNEMy1OoAUucWEFfBSgihWl4u3NM+2lGEj51ACyU
         u/ml2GcABAibjmkVy8HkUXchbvToiwWtMLt4GXz6pJ2dD9t5xCIG7U/7sOpGKtiImP++
         pK6665MnK7ll/LXH1w8ZSnPMjS2q+LfZ7IKo3u2ZZOZieZZJLTzmgHujf4UGMeskyYhu
         O6lsK2tUyvKKYItmTu9a2wMKaO9s+crk4oOt9NJ8HGMLd5/o5p/jVX7hiI+BP1/is1u9
         mDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783930600; x=1784535400;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qitVlXfkVbLZ19rYAoRnVT8+321wabtilZzFTJ/EX/8=;
        b=NXnSLpndJ42Dc/BMZPWJ8mwAUlXhgPsDiwycJ13TkdGQZW+uikLq4pwuI/qruBAKqc
         SWAN65YsT5aVIwspI8vPaZbDAQKuvB1CFwIeR8cRLqpmdHKhj8gOO+KCQ8xuZx3ap16a
         PtDJXMrIJXqJhv9SkaYsySxzYL0dFxO/CysSqm49xVtv7XKaIarKIJzM8LDKAfWw7s0O
         hDyhO6HMZ75/BniDvJPvFwezN0+PYCEk6tTMODpWnVMa8J6VZ634NmjQfCVFpzzd68G4
         oJMzltAqwC2kiC7VFZxu/r4vtVVLhdI1cDJJ3/BahBE1e4we8VAPl1/1nrXLq3IBW7Mi
         Fcbg==
X-Forwarded-Encrypted: i=1; AHgh+RoFC/cdBLNk98WtP5kUS5Jffr2GFTmNJREPO+LU4T/2NrIZiafEi08Tu7KMAPTA4EaV1GuwdD/0lsGx@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgy2Fb7h7XZMV9O/1oT+Yldo53IZkrhs7OL6aSUgT4nicte1Kf
	2hispCiIPypo1RPv3MDxegCAJihktasjKlDPJwNoUK3eEC/D3VMnn/FBpROWp9J3Z4XB5xxNQ3O
	K90ntMTkyisvN5Fn9CsU8bsb6WkGvqJAVAYjznFwKm+Kvv7YmfHjH+0PwA8HxPw==
X-Gm-Gg: AfdE7cntR/LhPl3M5fcL/UzIey7ybuhGuflu3N54A/pKi67gGPHMzr+pmrOjAxxktdq
	VIQsV3xJ1OgeJpbU8X9EQ0WSF3uh+x0EKxQA0Im8/oqUgXsTnxNpbCbQD39RgyFE2iOxqS+lHrC
	6gK+d4/oeXZZuAbk8RYLV6MHX1w88Lyuc/Di4N9hZVuKRA2L4tKKQKLccjm5JAjBkiqirVUxY7i
	rQ9o3VpGqE1zpuR5awZI+790Iv8R0wPHzn0DyAi49smndN7VBDOaTsm7lAiqEAKN6ZkNJ9DD6Z8
	e7wz/qIk0GtRLqSoW06e7R/Wt5Nqw3CnpQz3fgt4Eb7sxDvfQH1YNcQDRtbGIZeLX4shHPR8nbN
	LvnwbCtL2BeLaiHLHpfh1wohKIPNLXI9EY0nuR4XHsYUwkg==
X-Received: by 2002:a05:600c:674a:b0:493:f80c:5455 with SMTP id 5b1f17b1804b1-493f87d85a9mr80792595e9.5.1783930600536;
        Mon, 13 Jul 2026 01:16:40 -0700 (PDT)
X-Received: by 2002:a05:600c:674a:b0:493:f80c:5455 with SMTP id 5b1f17b1804b1-493f87d85a9mr80792235e9.5.1783930600066;
        Mon, 13 Jul 2026 01:16:40 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm82014266f8f.8.2026.07.13.01.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:16:39 -0700 (PDT)
Date: Mon, 13 Jul 2026 10:16:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v11 06/20] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <alSdUBiA6n40PKim@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
 <20260710085256.3464201-7-aalbersh@kernel.org>
 <20260710234643.GF1911@quark>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710234643.GF1911@quark>

On 2026-07-10 19:46:43, Eric Biggers wrote:
> On Fri, Jul 10, 2026 at 10:52:34AM +0200, Andrey Albershteyn wrote:
> > When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> > it checks if file has DAX enabled and fails if that's true. However, the
> > opposite case is not checked.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/file_attr.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/file_attr.c b/fs/file_attr.c
> > index bfb00d256dd5..5424ec4e3949 100644
> > --- a/fs/file_attr.c
> > +++ b/fs/file_attr.c
> > @@ -246,6 +246,11 @@ static int fileattr_set_prepare(struct inode *inode,
> >  	if (fa->fsx_cowextsize == 0)
> >  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
> >  
> > +	/* Can not enable DAX on fsverity file */
> > +	if ((old_ma->fsx_xflags & FS_XFLAG_VERITY) &&
> > +			fa->fsx_xflags & FS_XFLAG_DAX)
> > +		return -EINVAL;
> > +
> 
> This sounds like a bug fix.  But actually ext4 already checks this in
> dax_compatible(), and the other filesystems that already supported
> fsverity (f2fs and btrfs) don't support DAX.  So I guess this is really
> lifting that to common code?  

yes

> But the existing check is still being left
> in place because it's still needed for ext4 specific flags anyway?

The flag mask seems to be used only in dax_compatible(), but I
suppose this's fine to leave verity flag if EXT4_DAX_MUT_EXCL will
be used elsewhere in future.

-- 
- Andrey

