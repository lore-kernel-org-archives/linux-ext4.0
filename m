Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49088240611
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043281; cv=pass; b=sbVTLjiHzCo9QymDg+AnnuJ5FRalikCCjbDY1N77wzs7jZwyx4zDTw+q4TR0QbKuv2EjlkbEUA9uIRsq+56ozwYFWKgRjOpAekSVwcbq45XxwTB17ZYpn7FsroeZO8kB6xQr7ML1LamhuOQoLk/X6Ygv66VsjcmDn6mxVIZj74A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043281; c=relaxed/simple;
	bh=JLtvplRuOrV1XCd+vmBKYGpvhguS1Ynr34OsxGcjbOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dttXwHcANOa/aNJRDG8NL3x/WPh61Jio4XZm90xE7VK1fxsNSb2eM8apVO94CShsCgr6cMIi32vobi8xP2NCbePlpC1jFfzzC6oLTUriIAtR676lDLNUlcutz9kN8Z5k/XUzSNoBf/k1SdIhvupQkR+CyJSD9qG5nkogTrKIRYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dufoFZFh; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dufoFZFh"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4758bd3731bso37154f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 18:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783043277; cv=none;
        d=google.com; s=arc-20260327;
        b=iomG4RPx31MUwhMQjylNpixZ7T/q8DkAilUEFRsToviqeoQ5ThFZWx3AvqFO++IChf
         Gtpzx/yu6v1Uw0yaNfc3vPvCIwCsZN/zu94NJcLOsrNxyqi1LHTZ4eEIb/Y7jlWK6rGH
         jMULdm/DUBfd6p1zg+IMv8ORSVB8YkPivJQSgr0xvQjrj3LoO1T8DSfoLU3WCkdEijGR
         b1UF/oIWyjjJxMt/xPB2xlZlMUlHTcGVVesvkdBwd53xcisw48ph4YN0CgZbdltCFK46
         EfTHOT1BK31zhyRTjMfNiLjzUpyN0n7kerbKkDvopB8KXb6Hm67B61rZZSaXq36/t3wy
         KCdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        fh=9BAbZuMNylwEljCeSwjfHNv/BX5TVBGk10X3Yh4Ufgw=;
        b=D2XzQ0dZSoMoZ3D3GasuqNaHzw+0YpMgOPaKZN1JzZJIwAKy3B5I4U3forCMtnONHK
         pCm817n6V8MKYuz3lNzjiariJMEd5Y2OhyqyVYvrRMHt0Mxv7eTHIWm9Qy/tsrK8uxmP
         DhJrfloENVMq/gXl1I+g+k2EtWWuzPX5hdyDZG3GI8ad0NBcIamb+0Fz37dQn25paFQP
         JW7uqe99Ky8pvVUzJH9rVwGdu1mH2tAPkTOLBUPXJaBlsYHAF8A+dn07vvQ6RXaelnce
         BSWWaC2VcwtBtUv++3kD8SLJ+3zUP2vVipEXyvkr/b5i3hI2DBnDw3nJvjsskToy3Muv
         KtoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783043277; x=1783648077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=dufoFZFhKQJbHC9rHylIz0aof78rVCYT3QUD5mRkGhy2l7H+cJFcrmx0ybWXWVb0Bz
         lrW7QlHAltzBw+kvMLizK0YEHAsZoyWS0+XBAoIi5xhndr82fJHS0BTO14xA2bp0pF09
         V9ZauT/73+0QwIKwA8dZRxz7vTpOQodLMGz6+b6JtbzgHZWnE4U3ZSPxEiq9b/IPAP61
         XgxOaQaSXfFyC+6XiKajOM6iaFL3E6uuC8U+Vp4QxuvemfkTSW28CH+qwU8M2vcSQlbp
         EcQ0Cc6bpR44VXn7DnhTNgPmvFIcLFMk2xzoNdLcWJ+zRAytywpl/r3mFm9GN/af3ipm
         Fn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783043277; x=1783648077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=dUU0SajH9asQJWe1KKH5wO4+rwZ6gR1lT9qy6lbsx2ozRRMezT/Y2S6aKdNHI04dDl
         ftWPP/utX1ABcWZ+f5b5FTSGz0L91PVAVrS0uQZwZHu+0c8uiVdpsb7k2fkdMwsMALc2
         QFz6gtWAU+Dl+S5Gf27cDHU+vGG1jT66toMDmdWthiRUs+mLhlgdGdGh6KFVD31mkaMR
         aTbrVPHd8QTkdns0umcf4cyoW8W1doKpYRsMH1xWi8AS6d7USMGYP0qvBMy24+G0yuFp
         zc8AfgQuK5nIx6kU6qg/BgaoDFdtnB6qVFjneghuJvrhebcZxAYefxQEBzb2EmgkbBZc
         2Rpg==
X-Forwarded-Encrypted: i=1; AHgh+RrPHyoMrP7VWDn8qWnrbkz9EvzRvV8og8/ZQKyH9h91eOl1mjQGfYlYP3PmfebCrhHDXnkGBhLbmQWP@vger.kernel.org
X-Gm-Message-State: AOJu0YxUfv4sEoEoOr7l8OPT06YLw8Ws89F3pPwI3YfC8qzHri+0bTas
	1S2c5Zqsd1rWZiK/nE7ldijZy3bxJWBf5qV/nBOI2aPAPeFObXitMf1r5ylw1UebTksdo+zjBGh
	/JpzDockVQYVUkm/AjDrHtzLmxsMCGeE=
X-Gm-Gg: AfdE7clHLMv1WK5c71y7QC0yxkH2g1QNeT/T06KD124R1opMjPquXx+x0bXTgkIAEEl
	0tz+ClBWZJtl89KkyFKQ9STDBMjfTgdZPgtRqQFIOPO5NiX5+NqO2mDw0ibarY6/Ypg53F7wfS1
	d7WlixJzbbTHtfZKcOUJ4c6FKMqwhjTE26CRXJWUkiAivWMss+kYhn9ptVbRdwzk16R9paofAsq
	OV0H+2w0aYbC3hlh3ZBIVDcSma9aVpIIDnR7nGShLJQOrYsUGNU7Nb2MJNAQZ+ztW65F99aeoq6
	HwjCQzuKWAd82mAiMcverbLpXedKwH8Gvl9sBead1wxIB5CTDYx5
X-Received: by 2002:a05:6000:188a:b0:474:88ef:cdec with SMTP id
 ffacd0b85a97d-479347abc89mr3414307f8f.6.1783043276701; Thu, 02 Jul 2026
 18:47:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702140705.GE21339@lst.de>
 <20260702165117.GK9392@frogsfrogsfrogs>
In-Reply-To: <20260702165117.GK9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:47:43 -0700
X-Gm-Features: AVVi8CdwjVgCnc8OibEiAJiLFqrCHykAhTtcw0AOMmm18cQj3dSCo5Q-SEBvMhY
Message-ID: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:51=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > In terms of merge logistics, I wonder if we should delay this and
> > the previous patch to the next merge window so that we can minimize the
> > cross-subsystem merge pain with more file system iomap conversion.
> > If none of them actually happen until rc6 or so, orif  the merges aren'=
t
> > painful we could still pick them up late in the merge window.
>
> I'd say everything but this patch should go in during the merge window
> for 7.3, along with clear instructions to brauner/torvalds to expect
> this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> the other changes that come in.

Just to clarify, did you mean this patch and the previous one? If i'm
interpreting Christoph's concern correctly, I think he's worried about
other filesystems converting to iomap using the ->iomap_begin() /
->iomap_end() functions still? That sounds like a good plan to me, for
v3 I'll submit everything but this patch and the last one and then
submit these patches (and any cleanup ones that become necessary) to
Christian right before 7.3-rc1 gets tagged (which as I understand it,
is when the merge window is about to close).

Thanks,
Joanne
