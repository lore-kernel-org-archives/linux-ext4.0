Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7976835BDC7
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 06:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791266846; cv=none; b=byuOFsXmk5654oaAMQz0anwVJd/kSrpDKU9+Rb3EbfWZuKkGfxQ0m8ETjt/cBYnsxfp0pG949aPzHLYVjO17S7ut10xrgKuqMr94Ub4WlK/xpUz6W1weF8bQVdH17BaDU9wYUQC16mY+upHOeI+ilD2xKrMsOC2l9i+wk8SuHDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791266846; c=relaxed/simple;
	bh=TE8xW/rePZ8lYMEPE+eewSrKv9vN5z8gCIyfpLaNndk=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=etdMdtyu6hJ/cmHREijTYWoTzAcpmH9Udn2oMb09Kz5y6/FYZZR64G1fIliFiWh+qILwOj5ZK8kfj++jlKAZ0e44sUDu8w5VPUdA+4s6GVZk6TicQDeTcMhas8C+qLFG8sNBVK78lplT1YlELpd52yFxDvfBNRtpG5rbOPBgQu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FCUJ7Jae; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FCUJ7Jae"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261006060721epoutp0433b9bb3e57bd3e6c7bde466b7eb592d6~b27PHVtac2003520035epoutp04L
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 06:07:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261006060721epoutp0433b9bb3e57bd3e6c7bde466b7eb592d6~b27PHVtac2003520035epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791266842;
	bh=TE8xW/rePZ8lYMEPE+eewSrKv9vN5z8gCIyfpLaNndk=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=FCUJ7JaeDGjS0HzdSBggJgavXvFOVV49lV7K4rMOGv5B1duMpc4859MHI2CP+DjdD
	 a+A23F5t+4IrwZDGcjCm47pccLnhbIG2jiBPsZuaVKQnicLyjkYcOxFnAOuXXBbkTW
	 ZJgKQTwljEXnTKmDaUTAadzgZcQvGxzvx0rEzqd4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261006060721epcas2p29aec8222e2b21b98790d75ce42e164c8~b27OqnhCw1215912159epcas2p2L;
	Tue,  6 Oct 2026 06:07:21 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.206]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hzQlF23Yhz3hhTF; Tue,  6 Oct
	2026 06:07:21 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: Re: [PATCH v3] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>
CC: "jack@suse.cz" <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"amonakov@ispras.ru" <amonakov@ispras.ru>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261006060720epcms2p3c656cc553e67bc79ec1623b71a78a6af@epcms2p3>
Date: Tue, 06 Oct 2026 15:07:20 +0900
X-CMS-MailID: 20261006060720epcms2p3c656cc553e67bc79ec1623b71a78a6af
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261006060720epcms2p3c656cc553e67bc79ec1623b71a78a6af
References: <CGME20261006060720epcms2p3c656cc553e67bc79ec1623b71a78a6af@epcms2p3>

Ping. v3 has Reviewed-by from Jan Kara and Zhang Yi, and still applies
cleanly to mainline at 2c3418fffa9d (v7.3-rc6).

Thanks,
Daejun
