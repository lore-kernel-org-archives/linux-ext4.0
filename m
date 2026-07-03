Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D49285CA2
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 03:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783047959; cv=pass; b=F9puHZKRotXbPUmg2AS2HX8g6JPBPmaDnWjJweQdpsKUwI5ucucime80GLffgJ5OXGm2dXt2XfC6gOEUfXyhMF5KtP8w1AeYH5zNOytrz9AY2eOldw+Ja7DBTFo/F+SzuZVMIUi2z7pGMF1UX5tEb/Vd+NbkpQQjx14rI4J4xEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783047959; c=relaxed/simple;
	bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rM+QcRjcp4zqc+DtWdWA9zh/ZlSjtfsEVHs4H7cPGwvRMYnmwO+rSNThvHmnnXH2mCDe58GSReKDxc76B6QXn5qxp7BtOvCqBKlsAecJoX6mPw1jxUYDiWWGLIrIWQ5ABijSHIBWGCmNMpMx25zGxxiSSlT0zAciw0AWvSuFCs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EeDkho1p; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EeDkho1p"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493ae59eca6so346215e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 20:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783047956; cv=none;
        d=google.com; s=arc-20260327;
        b=ei8LC8obIz341sIYsNOqUrboznl+Q7vVOp9JI54KUmRZc0nlsoapg7V9jxWFrKjBWI
         srd05rxhbYCzNi8JZ53Mz0rqXs0IkkR55jJ77lfVN2hYSYdb7TMG6OqNZqDdjYkkCvGJ
         TJH481PeCF4O7T9BshMHu16RcyYA/3s9JI7U5++RjMpex8hw9gcJcVxliZGFoTKldzQ7
         yhsFZvl11bW5AnQDzrnumvintR5xPxFvaPL1uFenC7XiHqJ61L3POyQBKhqHVcqQ3YjK
         yGM1k/j8SdAOrPeNiOVqbp/8Bq4UEmYW9AoSMsUSySJ+YEnZeRwGVJz7dghfWIYs7J9J
         2g1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
        fh=5t23YIxqmwLECY+WDkDBY8SveG6KzZp2ZO/6QJc/j8Y=;
        b=AQ7BVHxdQ+bqTESiOUAYmuUl5QdB06VOen8Vt/G8hSoDrwPKxP0fIrsZBHAiEGnfkc
         st5cCMbfHDGVPnMqnrdZWA17H13M1QVzi7zhKrZiJkdM5YNb+OkT0LUWhO34Ta9i7b+Z
         hnJ6pjNRhKzqlaQsZQ72zQ//WndRM9waFzCRzwc0h3eP9my9cxbEzVYly4X/1RQNpWb4
         oZLjrej/IRuR0gyJJIjQkdkm1ZXu918y396DH6hyvjtk0oPO0sXX1cgyxioVvRHXub/h
         rPhXSafZQR+g2zoqqr3FkenaYNATgRnOnRs7HzPV/X70cos4zzGZB4oShTyoQO9HtRDf
         2RDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783047956; x=1783652756; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
        b=EeDkho1p38ZO22WDSFypik9GdRJBnA+hMGgltuEEi7yE5dOIEj9CVMtTfHZXnCeeh5
         5S3nGoLhb/sTUnk5InAuevla/JvQUID/1utipgwbUYEX0iHlWRZtgVke6p//pqLHct1N
         BeLworJR14NmtSnzoMrQjZDD7QNBrCWnJVT9EsYFsyOVGXxL6760xBoOp/3PtYJgEYay
         4LkzdbbfFhtCIq5Zulul3GTsnoTlZijODF8NTQy0/q9919N14dHXs3fRvTY/yFx7LSIM
         jVYnCfrOrRnwp/WCXDXecj4nyLPui8a+HFQ2IDvL/fLLQiFRfbbB58e6wrwns24iukZH
         gg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783047956; x=1783652756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
        b=oKR4ESxZjArOxb8kdGfQwQrdskQJybmmPLDAYBy5i9agnZdFdegRGNK0ifM9C/d0lk
         upbsgZJHoasWD5yzNy180v06ag6VziLsNBYTgSn4LUAcbFI2/Lo0wYZa9ldOXh4pb/v2
         cQD3P6sasWc/cKgVtOoYUtOZTpICtxf3CPykDGsQvO7ehDP5cafTil+Ab3fWb0xxtnUF
         8g8vvBnsIHsFE+D8TQhDYBvbLxsKfvUyhKHl/okyxuwd07SXiU5uasiBrUswKhEZe/YE
         yXbNLcHLRllu4WZdR1oRiDcxnG9BVzuv4kZMf4Ke0PbJ5hneuZqeOm4eCy46Fuxqm6n0
         CKPA==
X-Forwarded-Encrypted: i=1; AFNElJ/H6h0xYBGri2Wk3QnvTJCwwbTXgTLLVhkEgwyq6aqXNyhIY3wMr6UTFZNupN9zgE9zG6Ud5JCYHpj9@vger.kernel.org
X-Gm-Message-State: AOJu0YzG1ZLnL25TfQfZkgDXsGUyAH5rH/CrMCklcCYUhChJvb//pesQ
	G+0vm0RO74zX/NKWXkcjZyE3hQSVunuAujcoX37eAt6yT0qOgoytTvDCIc6najC2pevMqtNtToL
	fYZovG+V5CMHlowxAerReVboVwuW7pOU=
X-Gm-Gg: AfdE7cle4cvuuT8p40la8t8gAnF91zzrhQZguLyJG/8XDIGOfvPhvF8LyvYfMtBSs+Z
	aUaYAJgO4ey40TyAeokmPRU5By5th3jtO2Xd7GWPdSL72q/qSRLB5LciZu3rQFarvODICXnQgOK
	jc2ol8lvn1ysSJbEYJE1tTxH+OJwJOFNWIhDv9qX45qmVA8ZQ5G8dpRoj0EKGPR2xiw8+9Xx26G
	BwPu0gq9FtNMFT2QVGVUufkVRhqs6IWCUQtmHWBVK7MhkcIBeSOHeUU6+D1St2HgZanglCkZavC
	t8k09AkiAKQwa+EbvnOIiwNyz4mrmVmKWivZiuXIJ9HnBdENDcGL
X-Received: by 2002:a05:600d:840c:10b0:493:b9cd:1272 with SMTP id
 5b1f17b1804b1-493c3cf2f50mr85170315e9.23.1783047955834; Thu, 02 Jul 2026
 20:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org>
 <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com> <akZ3GErzJSTtOn-H@infradead.org>
In-Reply-To: <akZ3GErzJSTtOn-H@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 20:05:42 -0700
X-Gm-Features: AVVi8CfZKbXMpL8snbpx3vl7cTayO8vf5li7UT5PBriPQUNElwm8EQYO8_inLP4
Message-ID: <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengnan Chang <changfengnan@bytedance.com>, brauner@kernel.org, djwong@kernel.org, 
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com, 
	pankaj.raghav@linux.dev, Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 7:35=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Wed, Jul 01, 2026 at 12:35:24PM -0700, Joanne Koong wrote:
> > I think it ends up being pretty simple to get it integrated since
> > ->iomap_next already contains the logic to only begin the mapping at
> > the start and only finish the mapping when the iter has been fully
> > consumed, eg
>
> I wonder if this adds overhead that the simple path removed.

Ah I see now, the whole point of Fengnan's series is to k eep the
logic minimal...

Fengnan, I think you had mentioned earlier [1] that enabling
iomap_next brought the simple-read gain down from 10% to 7%? Thanks
for running those numbers. Would you be able to share the changes you
made to iomap_dio_rw to support iomap_next for those benchmarks you
ran?

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/e85e73bd-5fbe-4d11-89ba-7b42c237d=
d34@bytedance.com/
