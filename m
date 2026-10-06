Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1E837C926
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791266685; cv=none; b=ZHLZ7NMQh9ERvEI7rHxVD/c1/DYEbnSfkxQme2HEqsm0xMkD827kH3HPz1o2xqfmIWLBPyGVBnZrD4pyywEazSB01o+KtzAtNe4CeSwPVXmI8o3itFVQBZ6G8ViapoE+URwr4Nj460QrNCJvhhYsdqjKPp06g4nsdC7c/O25Wu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791266685; c=relaxed/simple;
	bh=jQA15vSspK+99zZ9bCLzEgwZqJuD1CLcDFJl62nPAVw=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=JFteHSGrPQj2Xzw7TtGy0ABRwjXu42toKOWSv+p4CXFQntETtBs1CPX1SMciIEB+7qyRpgfH13nSYNxhesF1UsFnhDBfZV1IH0+lYn87JWcRTpV9/S1+V1/+tj/+yKH0Uxb1DOOi5sGDKyixhrVslHalP46BTYvF1zkjiqTmazc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=doTOpA3v; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="doTOpA3v"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261006060440epoutp0122ed43f38ee66391addcf9e258aa9ac0~b245Kjw8i0568805688epoutp01e
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 06:04:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261006060440epoutp0122ed43f38ee66391addcf9e258aa9ac0~b245Kjw8i0568805688epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791266681;
	bh=jQA15vSspK+99zZ9bCLzEgwZqJuD1CLcDFJl62nPAVw=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=doTOpA3vRB3ZlIO4YiReq0/UCQsq018cY/UtAZC/UTCHhsGATggWnaaxM++AYsRZP
	 0KpmsCz3tUQbF7cpj3oW1rcT3o8pNbqcHITQ3hGRSqSv1+rwlF4jeVOcnLLDasX/K2
	 +yOP+lXETgwqLP/Vmh/mPWpOJsok1VWJkQtk7t50=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261006060439epcas2p42726599451c62c45535ae3c34ac98e61~b243ynRHn0129701297epcas2p42;
	Tue,  6 Oct 2026 06:04:39 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.201]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hzQh722P2z6B9mQ; Tue,  6 Oct
	2026 06:04:39 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: Re: [PATCH] jbd2: don't advance j_fc_off before the buffer is
 recorded
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	"jack@suse.com" <jack@suse.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"junzheyu1@gmail.com" <junzheyu1@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261006060438epcms2p3e8cc06609134f0348a38a49e3007caca@epcms2p3>
Date: Tue, 06 Oct 2026 15:04:38 +0900
X-CMS-MailID: 20261006060438epcms2p3e8cc06609134f0348a38a49e3007caca
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261006060438epcms2p3e8cc06609134f0348a38a49e3007caca
References: <CGME20261006060438epcms2p3e8cc06609134f0348a38a49e3007caca@epcms2p3>

Ping. Jan gave his Reviewed-by the day this was posted, and the patch
still applies cleanly to mainline at 2c3418fffa9d (v7.3-rc6). Could
you pick it up for the next merge window?

Thanks,
Daejun
