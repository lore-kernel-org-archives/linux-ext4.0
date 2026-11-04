Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.192
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817524;
	b=FneulyekR4nPFP9l/9+7m5igHADTajpGnkfCGMARyOw7hOxWH0x/yJ6jgIfOB6Zoa4hG
	 /Wdlin3CCpyWJo3yniUa88lYDIYEWeyvFW5bI+uaVCU+SLuHZtW1sYGhpu3SlFZDpFYeM
	 A1/BbiQuc/Wf7gpB8QdAs+qw4vfrMnIN/fm5pRaIyzIUbWlN/QuPZC14Cpb5iUlQvTyf/
	 BKsoMPdhdM8lpgM3SlyS8pwkvKL+o40lAs4mCV5sQ+AwFhv4LzV93gwlTU09ifpWEO5ep
	 A0JsDCB2XwxyKT072THT5X3jo3a2bXGC2vxvaSAU/mBn7weQEZ/wb4aFXq7Y5oMkdaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817524;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=xi2CTq0sctSpk2rBheKo6Pp4BrAIpJ2VTsphU+x+0aE=;
	b=XC7Av4/WI1Cse8E8Us+0nPsksSFsSxykba3pORoHrtdjkJo4P+B7faHfSEBbs9MgEt4C
	 IkXMYZW9XlEmUsZ3hiMrWkWUnooPckFoY/9cIlECdh6EOaQGrtUAFtDOedm5I+/w3Qmi/
	 9DP41TOGjaaLzgGHN7j9tSaM+lZPrgRZnaS2MBr+lgZP4UrGbkgY9Pml/Vj+yuv/vkZJY
	 8GSiElzNogqvwe7U/Xby/1gmy0faPrRn3YkydjLREV827fexuHJQLRaGfciH2ijgdAsl/
	 cvuD1PIv9R8EQP+S52fTdmFwXj5HDrn/MDESXWqeyMwNzCGPeA/IPiuHZAykQsr+cXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ml7tXF+s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.192
Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AB1606D83B
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 18:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25AB1606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ml7tXF+s
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-533fe730856so454493b6e.1
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2026 10:38:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793817523; cv=none;
        d=google.com; s=arc-20260327;
        b=naYxHMSeFlJmxASSxGtegMTZ0yNCi2sse+jKR4/x5o0+B1mM4846WksUr4nR5d4i8T
         acMqWG1uMu/ullzpeEZVzDcNznDPu9iLeSPBojMFpW2l25HDRzjWeIVOz55dthmuy4xo
         gmklGnoJPDsGo3kzpkuMvRSR5mcsBuNwj3m6FgpTBLpANHk9jrnESZeg90is9jtZrsI7
         5h3Wkx4OMrxn7a6hHWdj45+Ti5fZ6BwdHvEdGbMj7tAF05E+uFa8Utjgs9clNcY/8TqF
         i5cAlWt0sgMaaYmbZuO4XdFumZKgBBdF4D9sP1q5Oas4H07iM2rk32/WbKAR4Dz5tdzG
         t3vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xi2CTq0sctSpk2rBheKo6Pp4BrAIpJ2VTsphU+x+0aE=;
        fh=hOez9hTm5ITlYie8zIvSt/M1G3GiHTRVYWLXh4rKKwo=;
        b=b9XZLan0CRbav7qgKMcwuyue3NY2CBiX4TguilEG8W/ExtTZrwA7S0/XMR5fmcmTd0
         EnByF+T4kfCtSgpfqZov3WKw59hkNaBp8MrF5cZjKBAc05lq8dtQlCRaMy0ICcKZLiAw
         NPGW8Q4Hp2hMAPB4GKsSdnCPYXLSkT0rS91wCYf6wAs4+TU4g8nFKcy1GyZ0KXMhYaZp
         1MDKT96j1aPm8kaI42IU6qWjJTklSvjjBRBXFtwGpG6VuV4oJdVypaWGc4p7+ll+KdEl
         bYZDVvbD/uMxQtMu/7LIuocsvGu1DgLRs2WSqEH7FAxlbBs8XhHo6rKxlptK7rY5iJSN
         cQog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817523; x=1794422323; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xi2CTq0sctSpk2rBheKo6Pp4BrAIpJ2VTsphU+x+0aE=;
        b=Ml7tXF+sVZvkpHkBr8/idNrFKfyY8PoYXpBJtAvho4ovbfG5zcGskW8/ivtnErEmZe
         NkBxWzblx8wNCyDPxt5bwvZNz0Ix0TeSzUiejal58hT/OCM0hTnBVHmyZjcRMYPmNmho
         zTL/Rv8Mh5U89IFQXczgPMALZMMUr6ldEXR2xtQqOAgydoaNpvagj3Qxr5s1pyPfYgNX
         DMrdh+xY5CDGQIkrgBb6bMsNunx3wZBuAobc7xPuzMDPob2V6QSE866W6c6l7PPx4YOM
         HCDDxzXAzWhgiwUXwpr6jeSVeyxGZohqp6bnZ7dLS/MHAq2jA92b6iDFM6DfoWjo0cOx
         MH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817523; x=1794422323;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xi2CTq0sctSpk2rBheKo6Pp4BrAIpJ2VTsphU+x+0aE=;
        b=0/FnCK3zCeG4B8Ucmj0p9dIrs5DObkVqi6aZJk7Hr0Xw69TbNzgjLu6gIsoZssFMNP
         pSy2JdK4OichnlrzEJV7rBk1oMGuQBt2sIqKjB9VCkTXDAOFbPplD3qZsq2wAmhOQayR
         cMsq3jG+9jW8qwLRZG+VnpZeHdTDn5zQo2MsSprpL5v/CjEMFX3J/QjsPkupqkvOWygO
         qd1q83w9bP5C/gwdaL4ONt9/85BuUKdNuPPeK3TEz5gOmilmZlEDmkQjCbek//V5Tzst
         efX7OCJvn/z2Fq8DEX8KLeGo11/XZpqjavglIn3ehqQSroh/bbdwyXiyCwvh1hgbK2AR
         bymA==
X-Forwarded-Encrypted: i=1; AKwUvBwft+j9Sn//dhr1z00yH7ONVMIyTA84lTSsbLD2I9WOMpWVjdDjOhvamNvkPg5bmjk6ZWNHaMmjLexD@vger.kernel.org
X-Gm-Message-State: APuU4Z+LJDuePetU1EPliQ3I+hb0z4A/1S9Qe0h+sunKXqTgJQS6EqO8
	y6ex+B+jDwtFs3J7/5s1h/LMku9K8WhvIoce8Pk19R18n2bmNxB60f1NW1d+iYGp44qJBxwWB6p
	mj12/1xDv88LgLb6/MmfL6gTJZGDbAek=
X-Gm-Gg: AYBFou1wHJ7PX4nJwY9FjuN/l0FzEwGIe1irhZNu36nPpJfrAIfS8upwsZP6cTWz3Ng
	C0tEgjZ/WkfLshwRUU93jfiKX0f+K0ZrEeq/9QnUCQ/oyd2gEJQJ7/sxLWa+mgkDzo98NbjMBJB
	zm+OumFkBiXG0DuRCRzz6eXhWYAlsgcjtKdJYjWOhiQnxYukI13lytPRhoeP3RvuRnJ6G6tE17p
	hkjnuB6iuAsEA2l7eR4Rx2H8UbdmfW/GMj/e1Z/0jmZHQBb++/MvmpNAAbdV1rR0+5Zw0/RtX2U
	Wgpq2/VRLyEyFZ06/9JNE2GpkpUpJHOa3/YvEewgLF+fOhUVXMd1fWZuYyDcru3f3so/2MuEqXT
	ZACqk/QoGAOfTu2SmDgT3htAYuy9Be/HleiG2IShitGRgIPaExoy1p5r/ZwF1gXGrTcKAw/T8pS
	vXKxGPR+igCylwC5cbgJdkyhQC+MQQa0sfdS2hVuEAj43f5oa4U0sS
X-Received: by 2002:a05:6808:1209:b0:4d5:295c:a82f with SMTP id
 5614622812f47-5640df1c57dmr11547296b6e.60.1793817523087; Wed, 04 Nov 2026
 10:38:43 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029013616.97194-1-dennylin0707@gmail.com> <jnqgrofg5eh4rvmpqr3wrhyimlux2cwtguj2o5d3tjzdaqq6nc@xsxxjpzmpomu>
In-Reply-To: <jnqgrofg5eh4rvmpqr3wrhyimlux2cwtguj2o5d3tjzdaqq6nc@xsxxjpzmpomu>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Wed, 4 Nov 2026 10:38:32 -0800
X-Gm-Features: AclHuK-r_3WJ0ntTj1FvPXP3r8tt_m6iclxJZOkDMnSvHN7BvKNtxEkMKUL6peE
Message-ID: <CAGEkeHeBgeDM5_+ncjKspqEOw0CnVBsb5GJYdbQ+rUJ-W3ht8g@mail.gmail.com>
Subject: Re: [PATCH] ext2: preserve IOMAP_F_DIRTY for extending direct writes
To: Jan Kara <jack@suse.cz>
Cc: jack@suse.com, ritesh.list@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 4, 2026 at 4:44 AM Jan Kara <jack@suse.cz> wrote:
> Thanks for the fix. I've just move the setting of the IOMAP_F_DIRTY bit
> instead of moving the initialization. Functionally this is equivalent and
> the iomap modification is better localized that way (the resulting patch is
> attached).

Thanks for the adjustment! That looks good to me.

Hungyu
