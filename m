Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3168D3C1D64
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 09:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452648; cv=none; b=IVLOVpfHOBdn7StrpohSifJvdSMuxePYHBGiDumB0Yv9nW7mYp9rmX004UZhzFdEBaU93GiAXru/nyKR0iQ2pFKcIXQ/WfkJETLAnwIvaevOm2bRUEKXWD2skNJfCXFFST+XLRK7wKEi+PKlKCIG0wN+pmW/49rsanDQRiXsT9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452648; c=relaxed/simple;
	bh=MoO1BniUK6lA6LOaVU2IfbZtn/LgMxFvKQyVaOeSAo8=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=KrtIaD9KjqDFM3WamtwZvvGFG0kRUm8F9ze3DUI5UjSgmR2EqcNP3OenArYHIaDb1djlKo6pRnq5x7rPm2T/KEEcs3dsu3LetSSTyoIPPqkZVnlCYU4H4XUcwTdiRgY33M5SpN3DEXbG6gq+OSkNiwrNKAZ5hfXO5/A18Q/+lac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UftqkZ9a; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UftqkZ9a"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261008094405epoutp04becfa25377903d5ef0a06fe24d7801dc~chLBw1Ft30840408404epoutp04Y
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 09:44:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261008094405epoutp04becfa25377903d5ef0a06fe24d7801dc~chLBw1Ft30840408404epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791452645;
	bh=MoO1BniUK6lA6LOaVU2IfbZtn/LgMxFvKQyVaOeSAo8=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=UftqkZ9a7zunJIkQTju6XIX7dkQyxn8S80uXuth7IKVIkpvtQNSq4eRL8Gdq97PVE
	 9UfBVCrnFNLAELNWiu8BTdznMVmgQ2WtAEA3jG9OANlHf8Iv28WO7+vPUPjMIMALE0
	 qPWiHpT3KWKTF0ImNGvKfDbfV4A4wajtf8GEX4i0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261008094404epcas2p33188459486de511a0c3a1c2e3089204e~chLBK1Nc_1141211412epcas2p3d;
	Thu,  8 Oct 2026 09:44:04 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.212]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j0lSN1204z6B9m6; Thu,  8 Oct
	2026 09:44:04 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] ext4: test reads after a failed zeroout of an
 unwritten extent
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Zorro Lang
	<zlang@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara
	<jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <asdkh5WVi02SHuE2@infradead.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261008094403epcms2p53d0ed88543e904f519df15a394904d18@epcms2p5>
Date: Thu, 08 Oct 2026 18:44:03 +0900
X-CMS-MailID: 20261008094403epcms2p53d0ed88543e904f519df15a394904d18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261008093820epcas2p31827ca7206b7dbacf5cbeb207ddb8b81
References: <asdkh5WVi02SHuE2@infradead.org>
	<20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com>
	<CGME20261008093820epcas2p31827ca7206b7dbacf5cbeb207ddb8b81@epcms2p5>

On Thu, Oct 08, 2026 at 02:38:15AM -0700, Christoph Hellwig wrote:
> Nothing in this looks ext4-specific, any reason why this is not a
> generic test?

No good reason. I found the bug while testing ext4 and wrote this to
reproduce it, so it ended up under ext4/. You're right that it should be
generic: the nodelalloc,dioread_lock mount options and the
extent_max_zeroout_kb knob are only there to get ext4 into that path.
I'll make it a generic test in v2 and set those only for ext4.
