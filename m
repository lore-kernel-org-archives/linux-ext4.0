Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E3514774
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543222; cv=pass; b=h0JNoo/y8PYGhI82hrCop2mz/n05D1ghMiNwRR3jthM/5ZQaHFpCJIGIC3xmIjwn0T37DU0wD6Fy8UEWdur9DbFmeTbN7sa+B5YUopbJePcfyXTs0ys3AKaRMMPQ/fzuVfXih6tHByNDkE8o9OtDoUy0uBA5yEbevNhLVJLjiyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543222; c=relaxed/simple;
	bh=+dxsPdcG+42yJ1jF2czoqDuFc+SMLBZvLdpM9geZ/gM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pno5R+pHxTk+n5INRe0WQNJx1pl5Zn7a3p7Gz2xPylzVyKJ2WZ5bG0wWwasrCMoDs38LmIbrRG0h5wgjbSPjBcsm3kAyrxQIii4XimW+JEV3qaig1/CwF4pmcFfmbFJ5xDWDycXeYdC3v30jZ1UwBIs1XtXOiXLkJF8bQCui+Ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrfKcEPY; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrfKcEPY"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48589798dbbso896762f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2026 10:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788543214; cv=none;
        d=google.com; s=arc-20260327;
        b=Pn7ILfQTL5DXaw32H2THdwifHNuYBQVruLVCTkBGbcoXmj42ZzOo9sONFq4tBhR2K8
         +MbLOGuFp4dnVCXBgO7vMGvm5PyMk8MkFjQs0VgY1AqC61WJWIdybjQkWR4a+ze/qZ7E
         FQHtRbU/OYaoLBrm246Qa/HfQESSO8rzG5DIRsCMUKiB7F0Gwd5VtT3Dv9JxaxUCHqwT
         wJYBRsGuUqkAGKssD5rYIVPOBIn0fTtJXS7qNQa8gwQ6j+QYrnOcQoEMySUPMXZCk2VL
         +/LvfDj8QjPpU3EtERPlPugrHNW/bFjCcgH0SOoWP5OdJF5ln3GUJFI2Fr3rSAhP5Kb5
         N2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
        fh=zx/U+L6gHnjPZpe5CBxj89jaWLUygI7Aogw26HGD1i0=;
        b=Dt7thwjxEp31fv3gm9Gt8R9aKIlvoTxerYkETk7PE5LBJmRtSyKwbIU90pqiEkAuIY
         xIzgEGxKyCqswnB0BQu1h+tX1cSLCuUJp5kT2Op1EK8th4HFKrQkDMqm9TzREjP94+tE
         B/WFR1lf4VU7NB/MWc06syYuIjPhngkJbP8CNNtk/SPXBJz/OEK9WphrkbjqA11c4+90
         c0aXIzhTYvZ1pWfQea4WfdAliTgOL7TS8k/axBkrTB9VUhNaIc6Fkctt2MjiY212T9Zi
         1lFVgNfJrJJp9NUiJWUBtAbo3dk6eppVlghc/cH5Of6xdTkmvxKQeDDf2d6R0UA892Wp
         3xjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788543214; x=1789148014; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
        b=SrfKcEPYEZ66jVyN7RYZa0gsikH15ECqcg7g9v0Cllrb3/RZvJ0FlBWcm7vqAgMxn5
         BLCXhkbNtGyWk3udifVhjHzW9IHthVaca8mtm63Ievpd4B7/TI0Z6m451NwEOtrbLNiz
         FuLvUxMO1G7h0smQalOS08Lm8r3BSmDxn+bcazZQEfiCZtINSvO8ECgRkqIZfJZWM1XA
         q31Hkv0gkfVmnpG2rqDRoTPB09qHeHPeqI/cdnMgSrmLxhK94ugxhyarNuSo4zDz0CrU
         pDlt8LabAuNEgqkcu/8/OHjC/nlENPYIM4HwKKeG31oCYVQ1weAdhYDnNKzlYiPYkAZX
         +kjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543214; x=1789148014;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
        b=sQ6hQ1tDtcwM4Mq3rCdcBmdn7s7EkrtfDTEz5H6/Eqq3B0Jksl+YARNsSLtgVkFdL4
         a2s2AE3SXGD1t4LQgTlJKbMJ7ZKxbk/FPv2WElQhZffRsmkykUqDsyoO0xUMAt0X1Gob
         fHikBdDZKjk8IK1vpH3HN+bfPIwHVH2dhu+cS324fWZXAOA2eELAlJXWL8Ki5M6LyVin
         wRGeTe3JWjSR51ZiCxyv1d0QvzYZNizY3YTzUv+Dxrz9vQxEC9WkbCGVf0ly2VNPHLo2
         0AzeQThuL97z0/HLuC7MrQaUC3a4hr61rAgASLEJrZh7Gq/cgyL8KPqqyJ9Dj10+QsfZ
         ah1g==
X-Forwarded-Encrypted: i=1; AKwUvBwf+lmD/jMkSZaGmyGhUPeIBIYXrsWBkRspmSG88Ry7EVwVEdEyguharmC+whkR/CawjQXU7Yh3Vy1y@vger.kernel.org
X-Gm-Message-State: AFuF++nxDzXUWdimDSpnOpPTmyOHDdROLMRnxdYGsXuRfkGS0iz1sOUe
	ZhX4k710PdDyi4c3fG3k0qQZT9ihgBt8aLW+y6LSPueyyBYZPefR76Kz6PEH2swjt7iyxvBKCdy
	Ne/iMURIYGFbU+VtDTlGipq5SkvNoYRM=
X-Gm-Gg: AYBFou0/1pevLr6s5Q+gD7tlxWlW4bwtjyUP6xrpScIDZFP9sqcAKMakoHlD2bpXAuB
	3z7ni1Csv6C81LuJvXAFzj7BeOHQC1oyfXKvOsyCb6CDb3JDMwVKmgmDCkb15O6EuTv4urk9rFq
	zbf9GgGkE8nExVWdVXtPleoZ9afWt6NSF5DzWeHWZEz0viJxYrKql714rlLR/6MU+EZRMIqN93x
	wvJmC7Ay/YcqdmyPyVRIPylYg37NnRx0j4CNivwQxCanN7zdPHF1XsAVOd8HonITS99+27AlX+W
	sGlmXzvfdWiBSWnVMmcKUkUmntKrDNq4vSw8vVyJgVndtHmPGGKMnU04JlRKEO2vEMZF1TatuWR
	PS8EykzphiwlnUxNJ4r7njRtzkbk=
X-Received: by 2002:a05:6000:228a:b0:485:8fe2:ed81 with SMTP id
 ffacd0b85a97d-4858fe2ee3amr163801f8f.26.1788543213669; Fri, 04 Sep 2026
 10:33:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com> <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
In-Reply-To: <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 4 Sep 2026 10:33:21 -0700
X-Gm-Features: AcwNN1WC5_C19pRuHFRSSvaEOgUDXw8Fkj4YdviBWSd6-uI0JItHi4sYChYNXkU
Message-ID: <CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in truncate_inode_partial_folio()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 11:27=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> On 9/4/2026 3:01 AM, Joanne Koong wrote:
> >>         /*
> >> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *f=
olio, loff_t start, loff_t end)
> >>                  * for shmem truncate
> >>                  */
> >>                 struct folio *folio2;
> >> +               bool tail_isolated =3D true;
> >> +
> >> +               if (end)
> >> +                       *end =3D (pos + offset + length) >> PAGE_SHIFT=
;
> >
> > If I'm understanding it correctly, based on how
> > truncate_inode_pages_range() uses the end value (eg the "while (index
> > < end)" loop condition and the find_get_entries(..., end - 1, ...)),
> > end needs to point to the start of the folio if the tail folio from
> > the split is a large folio, in order to exclude that folio from then
> > being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
> > calculation here, does that result in some cases in it pointing to the
> > middle of a large folio? Maybe some logic is needed to make sure that
> > it points to the start?
> >
>
> Hi Joanne,
>
> Thanks for your careful review! I don't think that case can actually
> occur. Let me walk through the scenarios where the
> (pos + offset + length) >> PAGE_SHIFT calculation is kept as the final
> end value:

Hi Yi,

Thanks for your reply and for walking through the logic and explaining it.

>
> 1) offset + length =3D=3D size:
>    The truncate range aligns exactly with the folio boundary, so
>    (pos + offset + length) >> PAGE_SHIFT points to the start of the next
>    folio, not the middle of one.
>
> 2) !folio_try_get(folio2):
>    The folio at that position has already been freed or is being freed,
>    so there is no folio in the page cache at that location. The
>    subsequent find_get_entries() won't find anything there.
>
> 3) !folio_test_large(folio2):
>    folio2 is no longer large, likely split to order-0 by a concurrent
>    operation. For an order-0 folio, the page index and folio index are
>    the same, so the calculation is correct.
>
> 4) folio2 becomes stale:
>    The same to case 2), folio2 is removed from the address space, so
>    there is no large folio straddling the boundary that needs
>    protection. The caller won't get folio from here through
>    find_get_entries(). Using the page index is safe here.
>
> If a large folio straddles the boundary at (offset + length), we will
> successfully get a reference via folio_try_get(folio2) and
> folio_test_large(folio2) will be true. In that case, if the split fails
> (cannot lock or split operation fails), we set tail_isolated to false
> and set *end =3D folio2->index to point to the start of that large folio
> since tail_isolated.

The case I have in mind is the case where the 2nd split succeeds
(returns 0) and tail_isolated will not be set to false, and *end still
gets returned back to the caller as the original "(pos + offset +
length) >> PAGE_SHIFT" calculation. I don't think it's guaranteed that
the split will create a folio that starts at that page.

The example I'm thinking about is a 64k folio being truncated at
offset 0 to 36k on a 16k blocksize filesystem with 4k pages:
*end =3D (pos + offset + length) >> PAGE_SHIFT =3D 36k >> PAGE_SHIFT =3D pa=
ge index 9
start: [0 - 15]
after 1st split: [0 - 3] [4 - 7] [8 - 15]
split_at2 =3D 36k / PAGE_SIZE =3D 9
2nd split will try splitting [8 - 15] at split_at2
after 2nd split: [8 - 11] [12 - 15]

in the truncate_inode_pages_range() logic, start =3D 0, end =3D 9, so
find_get_entries(..., end - 1 (=3D 8) ...) returns the [8 - 11] folio
and truncate_inode_folio() will drop all 4 of those pages (including
36k to 48k which might have dirty data).

Do you think this makes sense or am I missing something?

>
> The page index from this setting is only kept when no large folio exists
> at the boundary, which makes it safe to use. What is particularly
> noteworthy is that for cases 2 and 4 above, aside from setting it to
> (pos + offset + length) >> PAGE_SHIFT, there does not seem to be any
> better alternative.

I think if we just rounded down *end by the min order (eg *end =3D
round_down((pos + offset + length) >> PAGE_SHIFT, 1UL << min_order);),
that would ensure end is always on a folio boundary and can't be
inside a folio.

Thanks,
Joanne
