Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795123416;
	b=o0q0rOsI4zmrdtx5FvaSFqaNSfRoj6cvZuKmjjLIryh2l9jhAWJFFILdCWUpKf6Ucptb
	 dmz86fkjfMq8xUFeaTNF/7Q3ti26j54vZNpv9pMM0EOktEPZ/il06ShIGEZBcecsA5W6C
	 s5QSq0vOBrp1BKndP5N6OMQdSkPO1++5Khsrhqxyfr+8mv+huexC3cHeTkxmhNAc6tYDS
	 h3wpGxX6dEJAf6/nPrQ7V1fAP45XhGpPo4JS/NU4xzxFK1SVwjox+wYOR3zEkdJMU5HDv
	 Zqt0KZVCNsPYHLRZ3heYd23NJ0xEKto6Xf492y8lxJbOdM/Zofb+Rp3FWwrtoFrdaOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795123416;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=9XwAo03nGDUfHZMAPg0nnz6ZbR2dq5xffwep78zO2r0=;
	b=UPeS/jPEa94IsQ5K97cVHQWlfkLxzSVyWrvKXqqxVUbsiRp52dePPz2KZqBTRxR6zcXM
	 L5J09rWDzGJAE5fAwLAFI1cG4O17RcTmI7QAoXEXjsYiOJDvp5YqJdK3cExJdO9EnzRAP
	 htpQnCKZYy7X+qse0mbLEgGwyee+0mhLP3H2d/abg58IHuIEGSd0Im5WxvCNLF2tNpPzk
	 j2seYzK5Dox3jpqrisJPI3+uK0wDP69azxg7YeneX7fOps4nUS/zA4Kx6BQr+kFUukF8I
	 sdPCdafDYC8ujivVlNz6pcSrLyaD2eADpl82TVXbWu0/PXn/vlIiXEbsUxncSMEH6Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=S9QWJko3;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D92606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 21:23:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71D92606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=S9QWJko3
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJLNUem012716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 16:23:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795123412; bh=9XwAo03nGDUfHZMAPg0nnz6ZbR2dq5xffwep78zO2r0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=S9QWJko3wEuAf2MwOHfM+K+to/LvkcCtxXHJ2yym9L+8grx4CNZ11vh3wTR1FteyJ
	 yqytx6DexGDiZb/0FPE/KC8Wl7bb3fmFOvWSdFMFNwiWG4eTHkGTz4f4nbSA1YljSp
	 KiOEw9v5JjxO4SN97dIYXREcWue5VKX96v5ebsOFAPky2SUMblICHA6IMbr8l7QrkT
	 JMSAC2yi5YTysRJHdbKFsR37Zg05mDQoWUCECzA/+aSXUQZS5U7IG7wM9v1/vzbaXP
	 KK38AQXoH3u4kOSUHBCwemCA4cySFi87WmTxe0DSbTo2ySObt43Z+UIiAG4ADO+WEO
	 F8hI1EvbidloA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9D20B286BB57; Thu, 19 Nov 2026 16:23:30 -0500 (EST)
Date: Thu, 19 Nov 2026 16:23:30 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Transition to patchwork.kernel.org for ext4
Message-ID: <av9gH-3h9t4Uy_xy@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As of today, ext4 will be using patchwork.kernel.org[1] instead of its
old patchwork.ozlabs.org.  The reason for that is that ozlabs instance
has been hammered so badly by bots that it's mostly useless.  :-(

[1] https://patchwork.kernel.org/project/ext4/list

I've burned through all of the backlog of patches that I've been
tracking on ozlabs dating from August.  So moving forward, please
treat patchwork.kernel.org to be authoratative for ext4 development.

Cheers,

						- Ted
