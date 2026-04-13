Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BED3BF688;
	Mon, 13 Apr 2026 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776091635; cv=none; b=IV5gPyOMinZ2CXSgjRAdLPQRuWeCXwJdmRd6kTY4KzvqS30jFtXifbTRo4PsTK0mWVE/W9HiTVUvTYjxuEbK5JKEB4AEluUiW9SPQX5ac9ufoQNKpz28r1FU8ztem4wgqiuoUTDEn4xyTVcCE3SKtxXGdOQhuOTIke45AiorL/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776091635; c=relaxed/simple;
	bh=ccx1+jkkLB7Tf4UGJS5J97TEDRY8WsVnf6JE5Wy3IZo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=dzVw22tDkQboZ3gEAfdstCdCEEhIZbEisdw6bbGJHiGngy8cC4Igbu5kb0yJJ+1NBn7HQypJzyV9JF54uE870tywC8K9LJmTq1hriulGcxemLtCU1NrHuzpG9rgLceyHGV2yMHlrk+DaAM3bhYYwwk9efYPBUF577G7uoc5TPYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=LmjozJUZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=P0Pt1FmZ; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="LmjozJUZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P0Pt1FmZ"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 9D38D1300479;
	Mon, 13 Apr 2026 10:47:12 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 10:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776091632;
	 x=1776098832; bh=W8U2X4bSWSk5VTnZUgN69eu5y1WQZmUIaZ0lY5fFNYs=; b=
	LmjozJUZ3Jo4aDvRnxjNH6xr8327RRDJ6AyS2k2jkDl2R8fkH9iYi8hT1huSnuvC
	fDXAO9TCtk28z5Z0YRzjvQVLbECztWiZU5NNtbQMRNzTIEQrOcdJnQGPD479uwHR
	1Q8ok3Usz/sph0Zc33WNDHZ2vRiLAUdkasmWlryN5Yu1+0d+T5ZkgPdaZcIJ9UoD
	LUtaK6rfdZx/q8xdekwLUdfJgdU2tYY2BZBNb9nIAqnbcU5rOmuWMelD9Mi0vAHq
	QCAxCp3Z9MPSmP03naZuWjoQXnxN4zfhCwznV9CiO4R52VmIdP6Rcnf+zUDjPDtN
	UXIkYMXlY1W1R8FqtfdOMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776091632; x=
	1776098832; bh=W8U2X4bSWSk5VTnZUgN69eu5y1WQZmUIaZ0lY5fFNYs=; b=P
	0Pt1FmZA3nT0gW/fGFJhGWUXdXBIcnOnTz8lnGNEggRDBNRkkIRZZ0rbNBev1XVe
	zzRDGJ8xdI8n86dT020680Fi59i8OYpo55O8jaokE2rcHortABYU2ULGblyCdcE3
	N7NLqkhP0h69s0MdHh8xGt/qaV3yIfjS2nWfiqQJrucaxHGogEVfeVOAY1wEf+xi
	uch3DjI8PEGZovPDIghE3cw7CjHIO63YZV2H2BcC52PGMn1wht6rI8JJJxiiCxXU
	UkCntruu9nNGBjU41kcYr9A+IW1YiAyNflF4aBilp4WdS700qNhK6R4AGl4ZTHZ/
	zTr464QHWbqiGWfEZOjQw==
X-ME-Sender: <xms:8AHdaV4EBY4AfwcF1maxWFQ-UReN_owOou9m4dD7NbRoLveor065LQ>
    <xme:8AHdadsjRmCe9WprTyyNQkCK8SO45WF8KHRoafxkQdvsEV90LRX-MaXp0aVyJYDZ6
    EmCfA1Y7H0u_e3mR0Jcw_jjFYyaDaWXBKlPB5CHolc71f6zGRLy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepthdrshgrihhlvghrsegrlhhumhhnihdrvghthhiirdgthhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    lhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegurghvvghmse
    gurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhi
    ugdrrghupdhrtghpthhtoheprhihrggsihhnihhnrdgrrdgrsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggvlhhl
    vghrsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprg
    hnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:8AHdaaT0cMKbTafw58cG7wQ0Qv82m8qZTRYyny1dj-38kCZwa83j9Q>
    <xmx:8AHdaeqogwjtF2ldxXkdqczEsPcfDM_1nEYFfwCk0UufLkJUoruyNA>
    <xmx:8AHdaYOz_3J7HsqPIEODLkY5cvhuJsZCBlh7QMGV8E4tu7K29uhBUw>
    <xmx:8AHdabApMPQo1X_BPzpLf70mTWvAAr9UgFJYBxC3fw_K7vhbYwNivw>
    <xmx:8AHdaZoXgvLSsnx7srnkGqW8Du6l-JaiK78sBGKrQgfs5kgyjB9M2EbT>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E812C700065; Mon, 13 Apr 2026 10:47:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A4mZ2Su1YSkV
Date: Mon, 13 Apr 2026 16:46:30 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Thomas Gleixner" <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 x86@kernel.org, "Baolu Lu" <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev, "Michael Grzeschik" <m.grzeschik@pengutronix.de>,
 Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Bernie Thompson" <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Marco Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>,
 kasan-dev@googlegroups.com, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Thomas Sailer" <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, "Dinh Nguyen" <dinguyen@kernel.org>,
 "Jonas Bonn" <jonas@southpole.se>,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "Helge Deller" <deller@gmx.de>, linux-parisc@vger.kernel.org,
 "Michael Ellerman" <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 "Paul Walmsley" <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Message-Id: <90a889aa-f204-4ea8-8642-6752aa1955d8@app.fastmail.com>
In-Reply-To: <20260410120318.727211419@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.727211419@kernel.org>
Subject: Re: [patch 17/38] ext4: Replace get_cycles() usage with ktime_get()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Apr 10, 2026, at 14:19, Thomas Gleixner wrote:
> get_cycles() is not guaranteed to be functional on all systems/platforms
> and the values returned are unitless and not easy to map to something
> useful.
>
> Use ktime_get() instead, which provides nanosecond timestamps and is
> functional everywhere.
>
> This is part of a larger effort to limit get_cycles() usage to low level
> architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org

I think this is technically an ABI chance, since the time
difference gets exported through procfs, but the new version
is clearly the right thing to do since it replaces a hardware
specific value with a portable one.

       Arnd
