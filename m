Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F43A1E1C11
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2026 04:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784953899; cv=none; b=gXqAIeaaXajKV6NPKIq0EqFI5wy2UXrtl0XjDw19alst+9kmT7IhPMmHmLnTjNDWJPEBdY6xnvPRgtFfQUgl2CJPQas5ZvTztIk/gPum+kTq2hG5G3V898SqW8VYthB3nPN0i1aMAqiTWFzr/KdTbWRb+bLe8BW9l3IlTirbLNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784953899; c=relaxed/simple;
	bh=Fzc8SW25R2RhB10CmllkJ7pj7t+iDtaS5mHUO+DEEJQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=i4WbX7+DeJ3oSPi7uM0RxKXA0zNWC1Em2tMHHDVDcyztXt+xgXDEAr4JWpRrLFUTEblreweCNH2Z6eoWt0K9WaYyOoRH36TPDiLMhZGqyFIrGpzp7QZECd4f9AxBZ2nthQdfYC7HUBCWiwpmeeZ/PrgxgltymhHT+SYBAATQM4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0zwiWxWl; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0zwiWxWl"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=B3IrAEzsg+NV9dxyTUdKDNuvOt1rBFSZVXw8rckA9KI=;
	b=0zwiWxWlZSECMSBp3CfpBZ4bkXBBJ959UuQTU1IOI5lovTTbKMrkOni07bI7dzTlLAKekQb4/
	rVMlWcPSbQTJF7iRslMdZ7VVwTXRZ6Eezs0w0S1/URStU3uVTOLX2cqwCDQc9xYfuQ8kYcCBkIE
	zesDVLqBOYudebhALbAmFhY=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4h6WsR0YvvzRhSs
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2026 12:22:03 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 4466A2011D
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2026 12:31:26 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Jul 2026 12:31:25 +0800
Message-ID: <37ded662-3f66-471f-bf72-f4b33a50a2a0@huawei.com>
Date: Sat, 25 Jul 2026 12:31:23 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
Subject: incomapt inline xattr between ext2 and ext4 used for ext2
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf200016.china.huawei.com (7.202.181.9)

Hi there,

For a ext2 disk with 256B inode size, if mount it with ext4 driver(ext4 
used for ext2), file xattr will be stored in inode if it fits. And then 
if we mount this disk on a system only with old ext2 filesystem driver, 
the xattr will be lost since old ext2 driver doesn't support xattr in inode.

This seems an incompat issue, is this a problem or by design? Or maybe 
we should set sbi->s_want_extra_isize to 0 if EXTRA_ISIZE feature is not 
enabled.

I know ext2 driver has already been deprecated however this use case 
seems still exist in some old setup's upgrade/downgrade scenarios.

Thanks.

-- 
Regards

