Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.92.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735250;
	b=mJCeIoGKCk63Ii2AtK/JPKA38xWTlF0se7Y3LYikv0C9iqsGG5DrLKeanJq45ZctF2fc
	 3Ce2x+dHuOn63kR6PpGktHI20eUMOTCm/VFbpQgbc09IgJynwOnfmikptbPZ4R0yRCtDt
	 2C2puZFcejw/MIuBxzwEwi9wYaB9Edhgbpb9cOp2IC64eoSbZ5RxU7+UfCAhap2oxK+8n
	 oxljGAXVyiWe0P0CuXaVTzj9InR7crgI66ldJ1cveO7w1NZMiROVin58fkVopf0HFqFjg
	 fyPEOWhPuTA9rR+mODlojA18EhYpQXMCuWEmDhTNyBSftAbQS3U9VIn/6+aEU3Zr/mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735250;
	h=DMARC-Filter:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=EaGecsk4anmbeLanJJ9ZiL53Pxgn45GffW3rICWod4k=;
	b=US9aO0ZzNUOrPCEueOBbGSsizEXqVsGvylskjw7C5yE2wq1UEVPWyv76E8tcvRgDRX5R
	 s+n0YPj13hnDwK6R6/vTWvrwcpTONxhm/O8GPKJma9eGIiOH2TJSaGBtM/J3v0eO5k7tC
	 YIIExHrE1qB4VUOpgszBbk5tCo/BUEtZb2+BoDceGYaGR3RnsgQWLyDAkH9CsN+Am6hVw
	 DLif2mzoX1Pf1SNu64+wr+If20aeLzodXXpzH3m5psJ3/xc/aLcOaDeXFf6KG/O8yPRTp
	 WlZlbbLeuSsDo0PL9P0TpKbr7RfcAyXoKl51U55CDS34RqoEboGOaCMuLjsOfF1N7Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kite.hu;
	spf=pass smtp.mailfrom=kite.hu;
	arc=none smtp.remote-ip=212.92.8.81
Received: from gandalf.kite.hu (gandalf.kite.hu [212.92.8.81])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B9C606A31B
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 19:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99B9C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kite.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kite.hu
Received: (qmail 18675 invoked from network); 3 Nov 2026 19:47:21 -0000
Received: from 78-131-75-249.static.digikabel.hu (HELO ?192.168.0.3?) (muszi@78.131.75.249)
  by gandalf.kite.hu with ESMTPA; 3 Nov 2026 19:47:21 -0000
Subject: Re: PROBLEM: NULL pointer dereference in ext4_mb_load_buddy_gfp
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-ext4@vger.kernel.org
References: <6b2dbf1d-43b8-f9e9-a2b6-e538f295bf94@kite.hu>
 <20261103181757.GA2224825@google.com>
From: Bartos-Elekes Zsolt <muszi@kite.hu>
Message-ID: <f900231f-259d-c52e-7b53-ad009f992fd9@kite.hu>
Date: Tue, 3 Nov 2026 20:47:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261103181757.GA2224825@google.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Eric Biggers wrote:

> On Tue, Nov 03, 2026 at 03:26:08PM +0100, Bartos-Elekes Zsolt wrote:
>> Linux version 6.1.191 (me@hostname) (gcc (Debian 12.2.0-14+deb12u1) 12.2.0,
> 
> Yes, the stable maintainers broke ext4 in 6.1.191.  The fix is
> https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com/

Thank you for the patch, I'll apply and test tomorrow.

-- 
Zsolt
