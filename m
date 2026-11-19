Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099721;
	b=WjthKPI2g5ukSNgdP8uk6b/KaUoifXCD4O5PpvR9YaFfQ7bZr5f+EIZf83rIRnHtAAXJ
	 xcHpV775Xt0wyb2ZRcxjw7lz43yqRJhsf346T5VhDYgi9cXfaa3Lxi/aZH2WtFom6owKp
	 +5cwZxGmbtfGGsCrK8muNr/gqfX2bLqY14DRl/QPH6YKf21FN7qEWMYqeoxRydb+6K+30
	 XmpKTuvFBYjZoOc1QbfTeUJ1UKSjoxL+WoDA9lPKXs/5rsGrUxNvJMPAUhM571dYfHAS5
	 jWfXLp1xlvbg4n7tZER2QwtzRNNqD4kMaMRtf+OQPm2zOS86yrUlVveJuHNWt0/cmSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099721;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=k5Ay93lTreufnMslyPS1TOVijAohRFWaFxfRbnmd5vU=;
	b=mBkdniwOV6GEzWO8lI2FuONIcumIAlVEHR4uuHiNEDk2ophPMJsHKjqlcvslDsEC2bxE
	 03ywInNlCghUOclEflnyP1RQhQya5hCtWGbOEVusKNRSQmCrkoiyvY4Y73K2/Jy7JSWG/
	 hZuQXd7pSHEY53EtKNZqOKMlF0kwhoeefmAPkYX9wic9YMxBt42fAezztOv5VZ9/o+pq9
	 +W+ZZWdNbLqX0BEI3boFVY/4GnNSFQyaJSdv2NCxNpzgR1o3xuH/xV5Fwrmn+B6+m+z42
	 u7B4pvk5RYSBSPoJoEzCd2ThQqH4feJ+AR73FetYNPtaaehL7g2Gw/uZATdVYWQZK0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Oa0XLH+a;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157260A5BC4
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F157260A5BC4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Oa0XLH+a
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElf7s018135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=k5Ay93lTreufnMslyPS1TOVijAohRFWaFxfRbnmd5vU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Oa0XLH+aJluZAWT4czR5YOuU+I+CYQmz/8IlrK14LTYZc+5v4Q5JFyjVDWoWtAxLM
	 rNr3sbAjoU8iuJuanP73LML/LQcekfgCA1Ddhe/d23Kf4K0drjWjz6vOkKVWnXAiHB
	 8nUry7msF9azIZaJv5kYsSEgEfImLpNp7ZeqOpPbIfvWuSKWUYONr+R0Vw6uA3PC/a
	 mzZ1LjHdUJr+bAQ4UVV9T4WE3OVdew6iEAiYUwBGMhYJ7rUJ01MAfvwOWg2jDWgaPn
	 r3LobdioGOzTmH3hToKx8Uu37N7PVQ8tpzc1NYfoosCD43NyQMwhzbMfPGFYTDUfae
	 6VoclW7u3LLLw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 39E272E018A; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        Deepanshu Kartikey <kartikey406@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, boyu.mt@taobao.com,
        linux-kernel@vger.kernel.org,
        syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: add bounds check for e_value_offs in ext4_read_inline_data
Date: Thu, 19 Nov 2026 09:47:07 -0500
Message-ID: <179509948682.1938961.10650869150256670424.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918010558.8210-1-kartikey406@gmail.com>
References: <20260918010558.8210-1-kartikey406@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 18 Sep 2026 06:35:58 +0530, Deepanshu Kartikey wrote:
> ext4_read_inline_data() reads the location of an inline data xattr
> value directly from entry->e_value_offs without validating it against
> the actual bounds of the inode's xattr area. A corrupted filesystem
> image can set e_value_offs to an out-of-range value, causing the
> subsequent memcpy() to read from an address far outside the inode
> buffer, including memory that has already been freed and reused for
> something else. This mirrors the check already performed in
> ext4_xattr_ibody_get(), which is missing here.
> 
> [...]

Applied, thanks!

[1/1] ext4: add bounds check for e_value_offs in ext4_read_inline_data
      commit: 17c7e8552739e8bdd5345fd69a0d92e47f33eb9b

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
