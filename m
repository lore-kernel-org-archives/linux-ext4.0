Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585130;
	b=sC4EhNaF7x04Dj3Ud75lTaP9SPnmewSWrog04yf6voUMOL3LN04K+A/7K+N9Ak/MMrbm
	 W8s1XcDFcgWuIE09nOAIvsqKPIeYHM6QDeIWCQOgeiAxdc8Zu+2qxsauI+6ktqFaZdO6F
	 AguLN41J5zWtXsmtPbcfQdlQQ2eFtqdoVPsIcv99I67wKdShodtiKzFBaOk9QYv7Yw579
	 3nhV2TOUejAWqsDBz4iKyP28dJwaG1wqJSprgN4G5kMmRxQalfkJiw7quNyR/5EDiwKKF
	 g7+yPsEiuqAPBBURHegZqI8+JcGUrg0lA9vnbnYS9lQTwIX8q3O7ZrrsMYZj1ez9Tbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585130;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=KHKRzuRqJbvMM8jMXEZUQ77Kd9LmEb7HaN0asWKp3Fc=;
	b=efa4BJTO7jWo5vudu4mUOku526wX5hjnZggvJFDnmvS1su4ZWwubksVlgvMF7PdjwPHK
	 ah2Ulq43xxIJk7XoiHrdepto6b57oPXA29bWrgAzez1s4N0/cHT4N09lqiRCIAp5TPGA3
	 QUrqLt5TrW4s+sBu/EUGYaRW8PmlmMD8I8m9XWfHg5CpB4HrLmJMrD7TW2YGeK6dPERQq
	 jcBkER0cV7QuqgKbemslMW8o5q8nROiXrq14dViAnC6ApCtYBeQPoJ8NGJCHapaqW1wNg
	 FGxR4LN0An4O4oe2L4DsfioIpnhm8SIiI4A3GFX4GEhYozuK7j9DsgqzvaSHVG5JaUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=tju.edu.cn;
	spf=pass smtp.mailfrom=tju.edu.cn;
	dkim=pass header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=nR96Ztcd;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEFB606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEEFB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=nR96Ztcd
Received: from localhost (gyproxy-mailtls4-entmail-gy2-virt39.gy.ntes [IPV6:2409:8d28:136:d3d:cd91:ad5e:f000:5295])
	by smtp.qiye.163.com (Hmail) with ESMTP id 531ab434c;
	Mon, 2 Nov 2026 10:05:14 +0800 (GMT+08:00)
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
	yi.zhang@huawei.com
Subject: Re: [PATCH v2 5/6] ext4: report unwritten extent conversion errors to fsync
Date: Mon,  2 Nov 2026 02:05:08 +0000
Message-Id: <20261102020508.2677348-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261023061851.45579-6-sunjunchao@bytedance.com>
References: <20261023061851.45579-6-sunjunchao@bytedance.com>
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
X-HM-Tid: 0aa19a00ecc603a2kunm12357fc9cb1ad
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSxkdVhpLTU4ZGEgdQx0fSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSkhNQR9IH0EYH0JKQRofTh5BHUtLS0FOSU
	JOWVdZFhoPEhUdFFlBWU9LSFVKS0lCTUhKVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=nR96ZtcdzTFwD5NhqI1E5TQpH+S4LHLI/VLvsnq5RlrNJXutR/qak1Z3ROEloPhU5WC6nlJMq1tjesIyvr0ZqBjCuo/5fl0cwyOdvgf1yVsX0N0dCPKle0TqTKpm+IXybz8HiNQHESzr4QGQ9Kp7M5sWlk8YWeZlvZBYWBHwKTE=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=KHKRzuRqJbvMM8jMXEZUQ77Kd9LmEb7HaN0asWKp3Fc=;
	h=date:mime-version:subject:message-id:from;

Hi Julian,

This patch duplicates an earlier patch I posted on October 15:

https://lore.kernel.org/linux-ext4/20261015102943.74632-1-guolingxing@tju.edu.cn/

Jan Kara reviewed the earlier patch and provided his Reviewed-by on
October 19:

https://lore.kernel.org/linux-ext4/sclc7h74z7nwfwnx2r62svytfaxquxws5chnopgryh2lpwqqd2@twxuiugbudw2/

I have sent v2, dropping the incorrect Fixes tag as Jan suggested:

https://lore.kernel.org/linux-ext4/20261101102145.647496-1-guolingxing@tju.edu.cn/

Since the earlier patch has already been reviewed, could patch 5/6 be
dropped from the series?

Thanks,
Guolingxing
