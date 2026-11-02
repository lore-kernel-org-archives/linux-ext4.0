Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608631;
	b=ZwsIj4RnVQu1+lcEnpo0R0buN9JtPpsi7oWTDwfh0N8rjpLNLgQrcautyC4ev4ZJGehn
	 57+n81IS1jhpII3x2azEkzuiP3JbHDzRbViTXJx7xjljmASjRDRU/bYjRrHR/bq/18tok
	 cDyneNm+IgxZEmNPiqD7N5GhCVI/yLa9EeuQMdaqkS+7Byi/cRFLVcVkpsa34yr3URv0z
	 d5NNxL+CFQzAW4N6btoN70+TdD3f7plkMOtRh90tfNwE6E+cbZHHhrH7eZqil73nRhyMs
	 s/S2gD1C0ibggQ5aV2ge9m5wNTBZWJkz1etBM4maPuaqAJtDWPGprJUPp+kvkmjVYvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608631;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=yzXseiMIZr7N0dWirYcZ+U7lpx9OdFBrYRkW0qlBAag=;
	b=t5mcXdDXXf9YJksEIyTnysRZnHXMBlBmSbQqUcu1M5ACebvxn6w4KnFGfBM9KfxDQym3
	 Jk7S0SGXZzpj9wgxby8kKe7DePz5I6AczxTDY4fm6lyHJAsaOf1R/22hcOEs6F+X6q/XP
	 ONKYd89TiDc8F5ApM+m+iiPionciizoXSfOc1dRVh0maJv+g8+/0w5xlikD62Petvkkgn
	 /o9ok8qb0B89nLSEDDEgT02HT65f0QwQXbHimIG1kh2yGL3keu6Bd1FUlQ86Zg5iNztLe
	 kVcqemSkBm5eqh298nEpRD6nf2pGvb2p8nuiOf2JSHAmH6QWkvJNRjRsywF0XbZ6IDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=tju.edu.cn;
	spf=pass smtp.mailfrom=tju.edu.cn;
	dkim=pass header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=voeIEOpR;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0019C606A324;
	Mon,  2 Nov 2026 08:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0019C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=voeIEOpR
Received: from localhost (gyproxy-mailtls1-entmail-virt216.gy.ntes [39.144.128.111])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5329f41ce;
	Mon, 2 Nov 2026 16:36:55 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: sunjunchao@bytedance.com
Cc: linux-ext4@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	riteshh@linux.ibm.com,
	yi.zhang@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/6] ext4: put folio on partial writeback validation failure
Date: Mon,  2 Nov 2026 08:36:49 +0000
Message-Id: <20261102083649.3798099-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261023061851.45579-5-sunjunchao@bytedance.com>
References: <20261023061851.45579-5-sunjunchao@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa19b67851203a2kunm832f224fdf066
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGh8YVkNPS09PSU1LQ04eT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpKSllXWRYaDxIVHRRZQVlPS0hVSktJQk
	1LSlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=voeIEOpRVZ0zZ9i8PBAMtyopQ/dWG8HRbXPqS36kXYruYdZ9Ab15QaKHHQu6l0VrOCoItX3OpFvm03XtfV8FfHBlor63dTjqJZbB/h0aU7dZ4IR423V30YJEac1w/HslGB8R92Yrs4FTN8z8O6PB3XAOBmy8wcauawNfIqg2R4U=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=yzXseiMIZr7N0dWirYcZ+U7lpx9OdFBrYRkW0qlBAag=;
	h=date:mime-version:subject:message-id:from;

Hi,

Thanks for agreeing to drop patch 5/6.

I also noticed that patch 4/6 duplicates an earlier patch I posted on
October 16:

https://lore.kernel.org/linux-ext4/20261016142524.655789-1-guolingxing@tju.edu.cn/

The earlier patch has already received a Reviewed-by from Zhang Yi:

https://lore.kernel.org/linux-ext4/743d1d96-40f9-4dac-839f-5d5269364b50@gmail.com/

Could patch 4/6 also be dropped from the next version of the series?

Thanks,
Guolingxing
