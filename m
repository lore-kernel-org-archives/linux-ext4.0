Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC13DD504
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775745030; cv=none; b=cQv7EueAVAx/OEXPEX10A19tvzUrU7eU1zxn2BB6grgljINYPKyTS13LO97r/J9kQaiC3xMjckii8IJ4SyC0IOt2sRlUtEtjAMlzKSWiSOyf6dAsUWAfS38VMVBDMr9E7T+fnyaYyoE/1arkdvrSdfQxczSPf/X09T2Dlk+YSdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775745030; c=relaxed/simple;
	bh=PSZ3kYm6/hZx3uQv+uKUMfOQ+CsdQ04cCIOA9NkTMFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3/z2Z7a0DmgoTafzaQYpelAIVZjaw/+jZwa21QGBtxR1O3TeoN27izds9ZHXdDQ9nsqZhw3fiSHo5qndI8OGjvO4PpV/uYtaEJ08ns9w+fszErL+epTWzqt/nBNRnlejAxoFJsB0gEksrSaMox+0hHf5mB0SV56So2hkXVdZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=WKIe4GnA; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="WKIe4GnA"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 639EUBpg020093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Apr 2026 10:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775745013; bh=RGU6xn4qpJ67/Vz6kOaAAxMEgnnqw9cTmiw8IunIVmE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=WKIe4GnA/SqYH38UcS4dlNcvJqLd9tBr5yfZYyfEAhXJp/XqcLyBeryxs5PX+DpPD
	 YuRSbXIBD0abMD/6C7gdRcgO/wS5hENDTufz6OzYC3qoY7ihWvrwpp5ziT8PetJlbJ
	 0YbDQ4wMW+bAugybcLAXW2iIPFqMGmoUA4MV5QMvi8XdN3/ZXqIu3MFv3aNgM/CpHT
	 rzNSzIPZ79m+L8M5HGw+srwtpN2Y4AJZwmt/aY5S793EAFHa1Eq3CfCAZ/4hBXTMen
	 F7Uwc3aK7r+Cfq2bPcEqOwRrHYjI6SNc4FcnwWd+mtwzI25cUdnLeS0RzHESuGvNIJ
	 LBSmKaKWiGBhg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6B43D6264ACA; Thu,  9 Apr 2026 10:29:11 -0400 (EDT)
Date: Thu, 9 Apr 2026 10:29:11 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: align preallocation size to stripe width
Message-ID: <20260409142911.GB59468@macsyma-wired.lan>
References: <20251208083246.320965-1-yukuai@fnnas.com>
 <20251208083246.320965-3-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208083246.320965-3-yukuai@fnnas.com>

On Mon, Dec 08, 2025 at 04:32:46PM +0800, Yu Kuai wrote:
> When stripe width (io_opt) is configured, align the predicted
> preallocation size to stripe boundaries. This ensures optimal I/O
> performance on RAID and other striped storage devices by avoiding
> partial stripe operations.
> 
> The current implementation uses hardcoded size predictions (16KB, 32KB,
> 64KB, etc.) that are not stripe-aware. This causes physical block
> offsets on disk to be misaligned to stripe boundaries, leading to
> read-modify-write penalties on RAID arrays and reduced performance.
> 
> This patch makes size prediction stripe-aware by using multiples of
> stripe size (1x, 2x, 4x, 8x, 16x, 32x) when s_stripe is set.
> Additionally, the start offset is aligned to stripe boundaries using
> rounddown(), which works correctly for both power-of-2 and non-power-of-2
> stripe sizes. For devices without stripe configuration, the original
> behavior is preserved.
> ...

Hi Yu,

Did you see the build failures reported by the kernel build bot on the
i386[1] and arm[2] platforms?  The problem appears to be using
roundup() and rounddown() on an unsigned long types.

[1] https://lore.kernel.org/r/202512102331.yweFnVTU-lkp@intel.com
[2] https://lore.kernel.org/r/202512120613.mM5COVWV-lkp@intel.com

We can't apply your patch until this issue is addressed.

Thanks,

					- Ted
