Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47063C1F43
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 07:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371569; cv=none; b=ArQzLb1gzpE+59J+swUTFt5/KVYv88vnad4/rKm4qx/g7unlxdDUFPwg3YbHEnJPAksCkOt63YlCjVa41vxkccbDtgymqGk/4pA8ZGComOe6hPIStibZDkZxphIxOVZuDEFeW6PivoC0siQkMzJPrpBMpZgiysqf4B49Y3Uz3/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371569; c=relaxed/simple;
	bh=hhTBSl/9Bo13LwX9h54rEc/AN6RIkc4qOBlHl07onHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C4BBWMsrueRWhAVU05VUJyx70g9/yd+qQ95r1E4wNGd9mTjrp3/1FUzldhBbD3zXt6DOQQCDveoHPDqKUyc0EJ0xC2RkD9YZwEZ4zpnuhJrtKjwBDcGeJfZuAgOfmaLtpreydb11pDT3uB9ULOfmdWekNeXFTEUIVgV3SVi6kzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=SPhZOWpL; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="SPhZOWpL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789371531;
	bh=mWxUqOtwCSjuLuS6xJHKpKjKqiBU+1CWzzpioHUgQhY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=SPhZOWpL97LMsih3nCJUz3dZVSHAJ/tZ8fYwXSNEN7pvQFHZQbn4Tc7nIuMnSgsDz
	 HZbgNf5xCtSypCNyDYryrNquaZsXmQz/BRD7GwoPqSWeETh1b2vj4Lcxx3E1W5ccR2
	 RIFzDuVB6XE1Eq2SCNVPE+bWK0X/3r/6yK/h96Vg=
X-QQ-mid: esmtpsz11t1789371516t130e1278
X-QQ-Originating-IP: 3L0MRMcF60zrouqUqgvQQ1D27LcswZVtj692IhPKdIE=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 14 Sep 2026 15:38:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2539614377018134341
EX-QQ-RecipientCnt: 5
From: Yichong Chen <chenyichong@uniontech.com>
To: sashiko-bot@kernel.org
Cc: chenyichong@uniontech.com,
	linux-ext4@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	tytso@mit.edu
Subject: Re: [PATCH] ext4: fix the logical block counter overflow in indirect migration
Date: Mon, 14 Sep 2026 15:38:22 +0800
Message-Id: <20260914073822.3440595-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260914071853.ED58F1F000FF@smtp.kernel.org>
References: <20260914071853.ED58F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: ODmRr9XAsEUIYFZc+vaV9Of8LQ21Trln+SyOD1+2Vb0BivNbEGEwgjjR
	UbdEW1zpLDDyb1z1LqatmnBr+0OY6qZZvT/53g79hyyCSEQOrXIE89YyatmA7njxmmuITfz
	+gHQupvKP28/5dIJidea8lpCrC9nntpu24CMrdNWjuhgZ58g4XjF+Hm2u/9RuvhvuzN8OYw
	F77b+nBSIWMVpb4ZQ/HSrBdfTx6I1D6BYqPpB1AjbadWzFKGBEojV6ELnDHD5Bdqy6/HBfo
	6Cy3twlUA8C6zH3AT04UdH0eltZtRoh3WxVSDECDvNqQlMEEAyonqQJRaJO7lUhWXGf64rG
	f6qohclilFi0vcm4fXtGVEbbKDM4RmxHOsbtN3NmfI9D86MxLtHfTo2T5UiveOFx3Qbg5zV
	n0VoDoo9Z3BbeiT+yAk0dvlmk7yxiVEWPHJCcUm2M1DSc0EekxBH1ktJjLQYQKQfaZIRE0N
	eQI6xyesvDztoQpujAteCSYUH8feLbr3CemhhOcrv3eizMr81AZ28erhiaBbIfaRfNSRs6I
	3YkZ2QZamm/lbd2TWkeHz1UdZUVUNRmMwfGPiiUUFLQOgL7pDYY7pakoQIflW3BUAasN0OS
	CwnfSUoDJzKisdpj1nVn+EmlX5sS4CD/NmsPKOt0wIknIcOq6qs3UpzdgeMLYECgDzhn9T4
	C6vof1n36zi9Md7wafQ60xNpeKDDsSlUVqh/cJr+k62AJEyDEHwnBLr2xS9sJSmYE88whGi
	bTNzxVSoRa4pvymLRR7ldMK7mDSfWEOQ9dqLFWNXe+y4xfvjyB/hNvckqeUORBH7+gKowqq
	OQ9WyEfqrl0IdhdtGhv338mYD1qKpWUUzwzWDt4ZOld7VSBHWjgcTKAZI/Vk378Axkdrl/J
	cHvPn+pqFeyNeaOWfj9ttZwntCsaRHOeZgv/K4bZ2/ZY3atTTLg3gj+f3FuVYF9XTWIKaYb
	WvuqbZw03x7WcUfzxQ87dCAfrAFii37/ua/tYrLj0zfyjRD77vfOYYBC2wf0knF7lYbhxZH
	JD+hbJULF6w1iQC88jAZHzrmtuntCEwEBPvvIdabKO9SSefjy/19qoNy0f/WU=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Hi,

Thanks for the review.

The EXT_MAX_BLOCKS point is valid.  An extent may not cover that block,
because ext4_valid_extent() rejects a wrapping ee_block + ee_len, so
ext4_iget() would drop the migrated inode as corrupt.  The bound has to be
>= EXT_MAX_BLOCKS, not > (ext4_lblk_t)-1.  I will send a v2 with that fixed.

Thanks,
Yichong
