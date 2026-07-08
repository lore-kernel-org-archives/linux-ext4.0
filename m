Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E303E120B
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544247; cv=pass; b=MI9rlzuE4F+AfSsSR0RxHCdGalgFr+ufSD9E9xUfN5oSlBpKBb/7WT7dkVWAluYD6FT3KWyAk5a73Vc3gLRH1UAI6Qg4ciJ+Wvxcq5ZSGzLMIV6JYggfKAQV6+f7tsyN8y7L8z+YZrU/l45SyiLdu7xI39XTNiSeyCMtnMGBp3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544247; c=relaxed/simple;
	bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dOvhXPkx2yr9rsOcqBlGlblqZFaS/pxeYdrEA8w3dz6FKETBXbzJVhG9GVawXk/8Ym6++mCU47CDbw8LerME17lgkWvlbi3460UXqBkfJ7uNLh04XrBTCJMhGka53q1RwVqUMm9v1MxilCHnXhceD+P2mlj2EiASWHr+sQ5uCPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRGL3DYF; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRGL3DYF"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4759b4f0897so689047f8f.1
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2026 13:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783544244; cv=none;
        d=google.com; s=arc-20260327;
        b=ilN3YsQCau2RK2XVRbAJpSBZRpPmQq/l1xirpaLy8+VUvmaNz99mDh+KKLr86pzb4A
         tiADkLgFtFcXG7xH0FFpvmNGiiQV7Q9UKm2to1BabCAEH8oJtj1abn9IUJPbZZuEkgo4
         ngyuX/blqg68AwWwnyf7dSSd5Qx1z7IgCozT5n40t7/mGEf6utGOWIYZkwUziAJNXwZa
         Yi+NM/5WSWuD6N4a8m9sNYyj6C8+kw/oOTzrtM+q5HufjgMruorCHZqImn/tbJhOJy/M
         EuWY932DjMXXER3lwMUWBBJ5YnMhX/ZIYG9TrcoRMVTD3ij1ldWdEMcLsPCntTLEglkw
         1KuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
        fh=2oBhC/GzeJQWvt5WI+6DQ/m6HEOswY6mtIhjnDMyV18=;
        b=HBatJ6TcFhc/FRaGlkFeHLw9PBB9cj70lGrtPiEbNN/fSXkk3RRYbUZ53nml8AidSV
         IkKr+joZjhaRji3GPlcpytvmJDZYcVzwEcC/UVuUlgMU8x6z72kOSnUrnsY8ZDwe5FNQ
         Fp0lPDBz97+WICTmLAlDxfnLcvQ5t1OEyqBSoLZVU9XYJxpRH47e6hLOlJJtkUyg3BV9
         rFHH8B+sSrilHqSg6v6FRpLCpn+rwf/jJZHRk9UvadXsJuJawmJ15HgGClBYr2Y+mKBG
         /WYl153I0UrYLB6B+xGezwMkUURen/xPpHyMah1onc0oTfSEK9Jc3hj2othSe7P7ogDo
         b4Og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783544244; x=1784149044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
        b=VRGL3DYF3/HWVEPQi7js832v1iGwNNDxbVIjK2dD/vjclbwE7Q+2/dIWXK/OovusOG
         zS5AKlAaNWBdp785L5E0BUmEy2qVjTMdECIWVBy9b4MuZijB8M4srfZlOx59GhblSRse
         4mHQ/wfv9+5p34DqzI/Vygjgonp5w3jF3xtaGDtGEoT2oz6bAM/BO8NQ1Ywx90EdbnR3
         1vvIbj9Kj/7tVK0XcKg8X3s2403H1aGOHVBtIMrmA/gzhnd6GEmW/nVUOjnMsxb/qn29
         5UWPHdpFL37BJWWrnrGpwQWuGKUCC7VSyRnM0wrTiGDsgjw7wEJQSudH1V+cqA/2v9fW
         13vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783544244; x=1784149044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
        b=buUHCAZk5W552QgRKT75jMj1QqmStWmEW1z9Js0pc33/m5dAGPayEv6AL35rrycf2w
         bYV4A4sqT2zP5rMsHup6NsPIV3W4l4LC+szOUAECeIxam1cNw4byNCWXdarPhI6cNvMG
         zRkPOolyC7fk/tvqmzQes6JlXXhz3tcm2uaNyEzt9APRA4cPLc3uWKyJYwv9/80AQikF
         P2Ajccya+cc+y+Jry/vJ5mvm8LpodpRJglR53919FA+yue+NpaniW1hldi8wvh705JaC
         GgOukiyM79mVvGKDWcBOJySNCNjjmiT3ojgKGBoQnU95Jg3NgqqOcoOzlGouW3YZ/kOo
         6V/Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp/+GQA66/OeQA0fmrVFw38z//pJHjby2U5I72DbBJZCPPkhHpkP95wHeHMAkaGVLVN59Yqve0mxy7c@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxgjax3UsQsHSuRr2LFiqCNS9+DV5x6KbHv2oCjXi5xddS1id+
	fDonKGJ1TN6Nv2/NlV80AVFLGfXjVtpu8FTlKK8lJ6dLN3JKmcNwwg5+/6tqGpSmC4Plza31Z6R
	UExRdpMj5vhf0KA/FOUrNV7FCRbNYkAk=
X-Gm-Gg: AfdE7cnGWomv4kcUnoHyaPldfnk8SsWmJzYWcrLbFtkWguFh8lpDIFv/GoXeZ8igwJu
	qn8NlQKwZ5itlQDdKLcQo93kf3k4Pf49Z7WSi0MrYsR0TiAshJH5WAJf2g7dnvd5TR9ux89ItVo
	AXpbEudB/3YSJHnr+mBQmggN92XTHiA2NRvn/DrBXMoo+3GUwteNTC1+BPlRZwlXcypllZoLLO9
	WJvn1nQkKHaDMefPy6Pww5z9g+ZTBh8f1P+5p7IPs20mB8WbGXag3aBtxjeW2MPv0LsYByqdKAN
	NS6k8QJLB/EeOo4YiA7PFkASqla4yGr0ZoWn1PmfpHNF6LOcvYV+
X-Received: by 2002:a05:6000:2004:b0:47a:c103:8a2e with SMTP id
 ffacd0b85a97d-47df0808ff0mr4522829f8f.45.1783544244470; Wed, 08 Jul 2026
 13:57:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-2-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-2-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 13:57:12 -0700
X-Gm-Features: AUfX_myQ8YTw0YdCEbZNt9d5CTUFLRbMZHIi911QIv69S8S5We_R1LPqmYg6pLQ
Message-ID: <CAJnrk1ZnO50z7C_e0y-0SVUXtd5S39VMsWfzuwD4LEHmuZw_wg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] iomap: correct the range of a partial dirty clear
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:09=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> The block range calculation in ifs_clear_range_dirty() is incorrect when
> partially clearing a range in a folio. We cannot clear the dirty bit of
> the first block or the last block if the start or end offset is not
> blocksize-aligned. This has not yet caused any issues since we always
> clear a whole folio in iomap_writeback_folio().

If this isn't currently reachable, does this still need the stable@
tag? My understanding from the stable document [1] is that "it must
either fix a real bug that bothers people or just add a device ID"?
[1]

>
> Fix this by rounding up the first block to blocksize alignment, and
> calculate the last block by rounding down (using truncation). Correct
> the nr_blks calculation accordingly.
>
> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improv=
e performance")
> Cc: <stable@vger.kernel.org> # v6.6
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

[1] https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rs=
t
