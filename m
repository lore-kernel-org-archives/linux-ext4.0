Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.92.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813192;
	b=dqC0bE9pu2vjYyg3VM/JTXdCafQ6+dTF9GGnBF/RaLJjsaqUFKJLgPgnmWmt52m0wiF0
	 rgUPCjMeJNqYSW8UwJtv7WCI7wkb32cwX3xVxQrjjElFiUwXo21EU1srGpcrk9AtGmkjp
	 /KTvwlxJdtjfgsTD1r2t31boOS0OsKCMKuIs4hKFY0iZKNEgO4SeQwzaVbnHE8DjjvlnO
	 wISKMTFC3JUCx3AveO3JYqXa2Dwy4X2JD5c1lsDRGZqEvpyXy3nCLzD3c4AvcCrxt981L
	 sFAlcGrtD6PGkEnCuCuXgHuwtRFcNDRiaOYkRDlP3ysmVQrnxFDmr2eInArHHbfZD0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813192;
	h=DMARC-Filter:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nx/7/iJOB/tZxUKVWiV4exeTaEP20MfsyT8jDYcPfKs=;
	b=0EkhHYWTGkEUq83aqcJb5xiAE71jR/0ZPxnNOyGYwfcobw9SivPwS2DXmSbtfyGXZIaa
	 FHarNrkPb8goTiLk//H2tDZDHzdwWWIzlyFtQtaFgMi1CuvF6BgEiYWJ3C3akwvZrLL8f
	 ic7QZE+ioxfwhEYB2BIGVVAxIxAjqcGK7ndXc5OEG14Ou5nn4EIzFaDDtlpHlW0Z6iQHI
	 8ppZ0sCyxTjimTefJCQj2D8Ws6dm8SZpfxRusXE0DoQ74DyPyIJWeTJI6XVkiDk1G997/
	 xFPos3h9HqiQZvUopI9VeG5V7UtZsCI5y3TN18FcoToBR9GoUacouOUlXxNrT2ctgww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kite.hu;
	spf=pass smtp.mailfrom=kite.hu;
	arc=none smtp.remote-ip=212.92.8.81
Received: from gandalf.kite.hu (gandalf.kite.hu [212.92.8.81])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C319606A329
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 17:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C319606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kite.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kite.hu
Received: (qmail 14381 invoked from network); 4 Nov 2026 17:26:21 -0000
Received: from 78-131-75-249.static.digikabel.hu (HELO ?192.168.0.24?) (muszi@78.131.75.249)
  by gandalf.kite.hu with ESMTPA; 4 Nov 2026 17:26:21 -0000
Subject: Re: PROBLEM: NULL pointer dereference in ext4_mb_load_buddy_gfp
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-ext4@vger.kernel.org
References: <6b2dbf1d-43b8-f9e9-a2b6-e538f295bf94@kite.hu>
 <20261103181757.GA2224825@google.com>
From: Bartos-Elekes Zsolt <muszi@kite.hu>
Message-ID: <103a4ead-f818-3466-4897-ab2975289cd2@kite.hu>
Date: Wed, 4 Nov 2026 18:26:21 +0100
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

Hi all,

> Yes, the stable maintainers broke ext4 in 6.1.191.  The fix is
> https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com/

I applied this patch (and the fix for ntfs3 too), and everything seems to be OK.

Thank you for your help.

-- 
Zsolt
