Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177F722425B
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 02:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784688813; cv=none; b=Al/7gfKTI1UaNkGVjdzM6C0lRN7zm92h3sX6V6xtx533IBxmPzZQd0EkmpoeS2vuzJriY7Ilk9RrA3Q30UjCR9/SeFnB2/8/4I5UXzYy+m3IKxKhATTLv1ERitVJ/kqLWlD9ixi+w5Jni2VUf1rcO7vhKrxrkpgUVDA8ubrApy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784688813; c=relaxed/simple;
	bh=SNQnNXym9YB3gHnYQQYVi1ddGyx5EhRt/q5NRR120HU=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=ZXmQ6BjzPEHU7KBD2W9DEA3wtYwBxmbu0794brWZn+mcrHHv4PQMLf8qbzn66RLzrLKJ1+8NwkASkZhd0mFEpQLMFqlOKfBTzW1es90VBxjV7+gRTbhWyY6KBgO2wLicJRfLSPCNiEqAduDMz+eYqliwdPcvkkFRxu/VAugp/BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Nn10rbNE; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Nn10rbNE"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260722025328epoutp03244639794e1f61d419f220812fec6796~EfQQZVTD00490104901epoutp03F
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 02:53:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260722025328epoutp03244639794e1f61d419f220812fec6796~EfQQZVTD00490104901epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784688808;
	bh=Fjl4AgxUSJDlf7lyzT6nMPHBeTIJD1X7D9f9yqceaPM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=Nn10rbNEqSowp0FSpXl8knH4OrlFC0UXSKC+bB7BvswPIoIeZwDEtXQ5Lp9M+9Ixc
	 3jqkMRNFbthrKkqAce25qsYM7HEwuXVZEol6gl5TV4CR8eS7AP8pGszsyIYN2z15Zf
	 OM6q1HNf08+hrzjcOKM4juDAYPOQ/0dlIeC+b2Q4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260722025328epcas2p2cfa7862ba93054cfa7b688636a2f6287~EfQQAlKGi2224122241epcas2p2F;
	Wed, 22 Jul 2026 02:53:28 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.205]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h4f2c10T5z6B9m4; Wed, 22 Jul
	2026 02:53:28 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 0/2] ext4: reduce fast-commit write amplification for
 scattered writes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Theodore Tso <tytso@mit.edu>
CC: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <al-FU9wu4bZ5Euqa@mit.edu>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260722025327epcms2p152732935ad0e5251143e7e5cc04211bf@epcms2p1>
Date: Wed, 22 Jul 2026 11:53:27 +0900
X-CMS-MailID: 20260722025327epcms2p152732935ad0e5251143e7e5cc04211bf
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9
References: <al-FU9wu4bZ5Euqa@mit.edu>
	<20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
	<CGME20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p1>

---------------------------------------------------------------------------

On Tue, Jul 21, 2026 at 10:44:49AM -0400, Theodore Tso wrote:
> Unfortunately, this patch series doesn't apply on top of the latest
> development branch of ext4.  Li Chen has also been submitting changes
> to the fast commit code and your changes are conflicting with his
> work.  Could you look at rebasing your patches against the mainline
> development of the Linux kernel?

Hi Ted,

You are right, thanks for taking a look.  I did rebase the series, but I
posted the follow-up as a new thread rather than replying here, so it was
easy to miss.  Sorry about that.

v3 is here:

  https://lore.kernel.org/linux-ext4/20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5/

It is based on dev at c143957520c6 and applies and builds cleanly there.
Li Chen's snapshot work replaced the commit path the old series was
patching, so it is a re-implementation on top of his work rather than a
plain rebase.  The on-disk format is unchanged.

Thanks,
Daejun
