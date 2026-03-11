Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1FA1DF74F
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 11:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773229671; cv=none; b=Bn1G0scu/XIF3ZmYWDHwauAAUz3Q96o0cchKXbHcVZxTapfeNpLDud6BEuDLJm8BaOFGJn6ZeBBb/eZ6q6TZ2fYEopDTN3P7U1ndV26+D0wBFrSOf/UBqthESyC5ylNWG4pu9nvlJMB1KLWHmVunpBL0UBCffTk3ZZ90YvF2xok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773229671; c=relaxed/simple;
	bh=Hot8zhdh4os52H/bQtBLbPFsGFzTkd5c7ypRjZf9624=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyBwz5E/qs2wwc+z8dK5sDgEbmKGPH/m0HV7gyQyOdDeHZD6NReEeln5DP58/7zVGnFWV5TIRoUTGtBA2BKow2MR1pgSt1VBEHi3WTLoVglIUG4IqK3d8VYpkETacATgX6M+XZE1ZB36Kf+iqB+cd/4dhREAan10fVBlSPDKqI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ih7sYP2V; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nlrWJJDN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ih7sYP2V";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nlrWJJDN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773229670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asRPjwI5YmOjCP6UVRlsstGP3cgkUliMF2dXi85Qbqg=;
	b=ih7sYP2Vjjjx1VqtqmSGwp9rOd1/3CqpElEce91KvTTNipUSrci7oCF/DYTF/VzG4QpkNQ
	AzRjJv2HnFG9x6pDfpak3Cc6sjIK/DHaJnDmjubwO8Dv4AInt0o82wqp2rRxbi8wWA9K4d
	UR2gaXVE5DVygqgGt8JEywDPA0Ehu2k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-eV5CUxObMXC75SoHMr3U-g-1; Wed, 11 Mar 2026 07:47:48 -0400
X-MC-Unique: eV5CUxObMXC75SoHMr3U-g-1
X-Mimecast-MFC-AGG-ID: eV5CUxObMXC75SoHMr3U-g_1773229667
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48539bda3dcso31037835e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 04:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773229667; x=1773834467; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asRPjwI5YmOjCP6UVRlsstGP3cgkUliMF2dXi85Qbqg=;
        b=nlrWJJDNrqzuaLdO7weVeErzoXcRpDb+mroRiA4Ojlp6ftlQckim8mzmsdEK6w/MRL
         tTEdLEjKzJFNg1nRQA8NPfBusIK0FQTzZUZBuOrUZ/xCKnETTZB53aG7ubUnFEW/TKqu
         hU9Je59avigpmas8q0upYaifR9Q/Qx6aWKZ9YX+s9pspxSpYMBE910DXGQn/Nviwe2c2
         ORKDLw2T+YerhCFi+urov5IPaKvNyyvL04z7IJrWgpmICgVLS3x8LHPPibepVEiRAySz
         tXLfdVEoSrrxTrowIUGkVCDwn4ATTNlUHlM6+QHEpuPsVfQIUDBCcID9anBQPvntf71I
         HB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773229667; x=1773834467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asRPjwI5YmOjCP6UVRlsstGP3cgkUliMF2dXi85Qbqg=;
        b=UH6JTgZ7a8fy8hcAWUQ8IPlb/NstexaN5nBaQfB4BTzvmODJ0d+WDQnl5f8ip4/pul
         +JzYMmqe70P3hSO6xTQkLYvA72ptFp8hdJkP3Az2UgbhA1i93HU8iJ3Xg+ZzeGQLMX7Q
         yTz9ACGZK97EcDNEQ8il7q9TBtmbhV/aa/PDxDLMQ/TUKKlK1UXzx/JauiijWuKsP26D
         EFCoU6KLBr1lnrRH5Jaw5v24hipOoPp9ezYCXQDk5cCxJqi8Vpl4Fxho7KSmZu7RYkOM
         MAPf2Al39MzJkmoIWD8EADh9WeFPMNp4UsIWt0iQfLhgMkInGkw1xBVOvww9pssUOq7m
         eAZA==
X-Forwarded-Encrypted: i=1; AJvYcCWoqf9f48SlCyx5RNe1nldfjlcAyDjmz7JhSWnpVlxx+8PeBD73DGH+kH2/zsZ6IVwqtdRyEdYaQjLY@vger.kernel.org
X-Gm-Message-State: AOJu0YzlFChOzgPPKjzk5ZBAykZ0DtNo+SZXbaUysRQY/usfoSadlSfx
	pqJ/SZizaJ7lrFKpSXYT3ZJCCNJ0ul3Psduc28PGdWb+yHpr79UAnapWcBgH5GaV4rtZy2Tor9O
	mOyL1dLVm1gdQSflhFwRb4TcxFhDZnc5qxUgjjxRgLyP+yIkqgReknPYNfP0w0A==
X-Gm-Gg: ATEYQzxclYY0/aLYeDL+Qvqnth1FuV5X4Ll5uZ3wuvsPOcQw87GKPlDZ+YuwleWhZr8
	m+4m0D7PS+jMHHHDOlRJNf9xaGD1QRxFxP0N/9kf9NUVx5SrEOTBtLTbR/UmGeINIPCZgrY7Zr0
	r/r+5qz1TvHABUJ6tt9eZNzPa/ymtNdkf0hpvAeXaVuLr/DQTJqp4PK/Tqj/PG7XlYyhW1gQ8s9
	IBxQhiBoP29TQCaPHQQQ3ROC4cbvHUNYI57zskDl6/FX2CGjgaqMs1iZ8kA0+JFkpd2YDPZZABX
	uFqN54whfwJQ3rR+87c7GbhS6JySJX3kAoBaDRI1OXVlgndBGHndS+i+Np+EoeNpYyqpgz72B6J
	OfI5xdWZgWKA=
X-Received: by 2002:a05:600c:6818:b0:485:3ca4:4eee with SMTP id 5b1f17b1804b1-4854b144e6dmr35215625e9.34.1773229667261;
        Wed, 11 Mar 2026 04:47:47 -0700 (PDT)
X-Received: by 2002:a05:600c:6818:b0:485:3ca4:4eee with SMTP id 5b1f17b1804b1-4854b144e6dmr35215345e9.34.1773229666807;
        Wed, 11 Mar 2026 04:47:46 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854ad5ee37sm37540885e9.2.2026.03.11.04.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 04:47:46 -0700 (PDT)
Date: Wed, 11 Mar 2026 12:47:45 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <jezqpw7mjdren3gzvmkxv7dzviisf7mx2n6dwtq3iwgypghvne@z76sdkkk2x7n>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-2-aalbersh@kernel.org>
 <20260310004627.GV6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310004627.GV6033@frogsfrogsfrogs>

On 2026-03-09 17:46:27, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 08:23:16PM +0100, Andrey Albershteyn wrote:
> > Reported verification errors to fsnotify through recently added fserror
> > interface.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/verity/verify.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> > index 4004a1d42875..99276053d3bb 100644
> > --- a/fs/verity/verify.c
> > +++ b/fs/verity/verify.c
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/bio.h>
> >  #include <linux/export.h>
> > +#include <linux/fserror.h>
> >  
> >  #define FS_VERITY_MAX_PENDING_BLOCKS 2
> >  
> > @@ -312,6 +313,7 @@ static bool verify_data_block(struct fsverity_info *vi,
> >  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
> >  		params->hash_alg->name, hsize,
> >  		level == 0 ? dblock->real_hash : real_hash);
> > +	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);
> 
> Don't we also need to cover the "if (unlikely(data_pos >= inode->i_size))"
> around line 199 in verify_data_block?

make sense, will add it there too

-- 
- Andrey

