Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D00378817
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749095; cv=none; b=XLWtXvmNVbdppi/qaW+SJ5wHaI0Fx9u8LmF8Sst5rpzs8BNPveAMxzX7jxLtOydacXo2Epg7uRKi37luZv//RPi/v9mvuj6/llKMRME71fONtKsIm8pxponVLiA6bzVw7OV9In3CMTIbrGdWtrXTCPOzxcXymxvEuHTBHQruZkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749095; c=relaxed/simple;
	bh=PqPVYuoHcB9VbWWRLwQgWRPkMClKIoD5tzzfx+rg4LY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=squINQOMhjZWuaLMfxWuZjsLpHdNzNHyC5meJ8gyz8Ip1WXeZ3X67uToAQaMjeptwySPC5SVL8CqRpq1J+CjXnyaDLTAjRvdYM0DNlqhHssrWfD3f+x2NwbVztOgiht9X47F8sIbVcKaUrwDJppXb8FPbD7vx2IQe6Jv5ovk3SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cLZzMzAs; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cLZzMzAs"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9c280322e0so125909466b.0
        for <linux-ext4@vger.kernel.org>; Thu, 09 Apr 2026 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1775749093; x=1776353893; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=umW1IQdOAOPjgPj9z57AnteG7vvMbaLS+TiyzZ/vV5U=;
        b=cLZzMzAs8HCLvFlUXjShTcjUjsm1QdXCEDL5RC2to1vkenOgQ7S7nskLRgBKkWv8+z
         vp9ier9gwheWZ1o60Pf/clTIbOevXDvvmiYmwa/rdDu/4MhOdLx8nEBQGw7GCQWcwcNM
         PHvYpqHjB+EAUn3rs4qqOf8rJU7vyLO/ElzOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775749093; x=1776353893;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umW1IQdOAOPjgPj9z57AnteG7vvMbaLS+TiyzZ/vV5U=;
        b=l1VGrWYti/k5BlZKuJF7lelUwSfQ6LwNZGgg0lYFXhr/cJZ89m1YCCbfb8Lnmi2nw0
         Nuof/fHxWLT3H/ZBllBtpYIcmI3pB3kwi1PSojB6DmIAsIbjjMWCwVT3G+3LnLdAvyzy
         iHTzA+uqHxD51GC223RzojZAEc+/NOpV9m7dUAtKtWe750Nf5TTr5DnN50wYr4ubNab4
         wceVOXgZkqZvdLOVmecg+yn9rn69EAUixEzWJ7B4cjIIwWBivmkuEDDRV+8LIbC+vd0h
         wxhGYbmFVm/oIPc7b68MzYAHKpVFE8HPxhzr3MoVwETHYMXoqwGrjdaBtIjXuNrMDqwP
         /Bsg==
X-Forwarded-Encrypted: i=1; AJvYcCU3XX+ezhWj2uLbvNmJk9xyqLTHcMSSN+gx11ErfvfpfDPTZMQq3119jVlrhQMDNPDNtreZizgq6tNn@vger.kernel.org
X-Gm-Message-State: AOJu0YzoVjrLgVnTh32awL2GfAyqgd42ey1RX3SpPErQ024L25ru4930
	3gMrSzfHk0qAUgcTXveFSPcfAEDhdfFfPOmcbTietrqTFNo2HtzDNSdNakIVUrJ64a9SBersrin
	ZhKLB8Cc=
X-Gm-Gg: AeBDietzqslIdKuNAuuOjrGvOH5JgiZ/d/GCbBmF/ILIun1PuW/CE795UibnxWWkCv6
	5tyVbwTORsillT8Vp1+bmhRW3Nf6/hvvIcB5Bqek0iW/XAG3rm/Fct8x+Aos3jrS+KFQC/w6PaO
	/fmQXptvE7/FXGHdhmIwUDyh4R4Q/01VX09W6KGo2cQPQm344mH7jJGSi1oUmHl8HcPzIjWvvOF
	082aHIrVjEqwsHYDm3NY8o3G49ew9qSdcheibI3Zf7OPtdjGf5ZwJAxXuuD2ZKqHffGcmvladZS
	4nQ0xa8AhEhMGoQI0fv4UuG+6FsVTlOJRU1QBOG192OWFTVu3rftamUkv8nEkTXGb62FcI+yeFE
	WDBuQGQqacDszpVIRK22j0DpVly83GnoK/tEbOUovKz9rmxRSLFYCLNhkkKBuQ58nj3AZ2MR9MX
	/zHHmzk6emVVaf2h2eYmUUGjY3ZaJdQx9HBeDTma5ETN27dIidcA3Ui8C4nrXOVJ+kR1nKuKXj
X-Received: by 2002:a17:907:1903:b0:b97:1d24:c004 with SMTP id a640c23a62f3a-b9c6742f6b4mr1391502066b.21.1775749092618;
        Thu, 09 Apr 2026 08:38:12 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6e7f1765sm2595966b.56.2026.04.09.08.38.10
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 08:38:12 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b982b0889d8so142682966b.2
        for <linux-ext4@vger.kernel.org>; Thu, 09 Apr 2026 08:38:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWqU08pi9RsTg+uT2CSKzd2jsdSNZP3O4P2e3aLfAozfiJfRq9IqWwP0yOPTldqpL9Af7BcdBNqN8He@vger.kernel.org
X-Received: by 2002:a17:907:6d0c:b0:b9c:94a3:317d with SMTP id
 a640c23a62f3a-b9c94a3345fmr1104212166b.37.1775749090683; Thu, 09 Apr 2026
 08:38:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <adZTGOjjJrVJOcT8@shell.armlinux.org.uk> <adZfTi3R6jtsjXx-@shell.armlinux.org.uk>
 <adZ9grUg71f518Fg@shell.armlinux.org.uk> <adZ_ZmjcE8S22vR1@shell.armlinux.org.uk>
 <3a1d0520-3402-47b2-9d7b-4e14a3cd07a4@arm.com> <adayAMR_dEA6W5vW@shell.armlinux.org.uk>
 <adeaiSAnkaggqPsA@willie-the-truck>
In-Reply-To: <adeaiSAnkaggqPsA@willie-the-truck>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Apr 2026 08:37:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whO3F1u+nme4cnYMy5baYmb7CH=wE63dcNaPLWD0vKaew@mail.gmail.com>
X-Gm-Features: AQROBzBMqgTUhWghYpRNIZDpsOWA443UoVRzdGjObC6SoT9V2ssj-2Muj4chrOs
Message-ID: <CAHk-=whO3F1u+nme4cnYMy5baYmb7CH=wE63dcNaPLWD0vKaew@mail.gmail.com>
Subject: Re: BUG: net-next (7.0-rc6 based and later) fails to boot on Jetson
 Xavier NX
To: Will Deacon <will@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Robin Murphy <robin.murphy@arm.com>, netdev@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-ext4@vger.kernel.org, dmaengine@vger.kernel.org, 
	Marek Szyprowski <m.szyprowski@samsung.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Vinod Koul <vkoul@kernel.org>, 
	Frank Li <Frank.Li@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Apr 2026 at 05:24, Will Deacon <will@kernel.org> wrote:
>
> On Wed, Apr 08, 2026 at 08:52:32PM +0100, Russell King (Oracle) wrote:
> > What's the status on the iommu fix? Is it merged into mainline yet?
> > If it isn't already, that means net-next remains unbootable going
> > into the merge window without manually carrying the fix locally.
>
> I'll pick it up for 7.0 in the iommu tree.

... and now it's in my tree.

               Linus
