Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770264;
	b=Ic5RPcLkAVyBlnkaL1QPbfRXGsvb2RQd86OL7c8JuC0yRJ2ROtJGOT8jB1TgLX/jRKcC
	 pcim8YcD81wo9p02iJfX02xk+avB1AD9WkttxbBUCifii8WGmB1VS0kmERwH2sbG8rh5H
	 UvTYGgQcqR6NOYEign4fMmeibyUe+4YrpXkbqvhVgVgmVeoGFF3ka/k0EMprCKfZr0smy
	 H3MGQRmuACRzQ7iNECEWD5Q2fU4fHdca+lhRTVsTvjLfoBg44n3Q3VqgcKimV1k5qs5dc
	 khz/YviOYbXNa/AHunNzrA39wVuHSH1Zgidla9mGQCobmBsBpZMAvHZIVjLnYiLyQWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770264;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=unUNOq/FceHqZkXI2goxUFVHCiJ+AIGN13u3MIlnRq0=;
	b=NGAfOmrMbiHUsr8/3cM6rILeqvPHOxZ1CB/3o98so0ksL4n4tzh2Pi+7ZbJUZFWGfi25
	 y2dZ7ZIGS2713iuB/n+rIcrS/G5UGZfTb6Q747ng8MqNZ1wF+oi/zEX0MAGDcCDdjo0bD
	 J6sKFYsiZEM6jIzQRprw3mMm5yZATtGZBTwoLbTjTBT5fpCfmP2jdjKSce/+gZ0HMqByF
	 SYRQvLba9Uqi8gw8W6p6iwkqYtnDZUDfnhhn/fPVE5R0NJKCkP3aHRGLWUGT3NWVneqZv
	 6XFjUqbtsyMuBhJ5kkML7GxY3pyivJinOYvLMZv1Qa8+5FwKUrI+OgHKM9fV94Cyd4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=kr6TGBN1;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=jZm5UvhT;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754EE606A321;
	Fri, 27 Nov 2026 09:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 754EE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=kr6TGBN1;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=jZm5UvhT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770261;
	bh=EQkPeK4wWZq9QUG0Xhod0W+KU3dneE25SCANwvCk2p4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=kr6TGBN1PhJk7SdCibYWPGHDq6Il5L4LjgY0DBRoOcUGc/E+PVvLIxtIfU97xHDTh
	 IaIfJM+6zWwCAKlHsnZ8DTT5gtpZQ43UNjRPC1opi4UFGHrKnOMn3x/NRISF/hdBk7
	 pSdCGy91ns63Yt7a/pCywaGAa7oFazgcy9QmFbGfCm09dSJfRNSLJwUn20HQjKtOZQ
	 cd6iA59DYWThWEO3yaEUhat+c/DKNKcPmpuqS3AEkiQ7taYdE1ypRCNrlZJ9bPEsmx
	 JqOoetTV/I0Pn0ieMSUmY9awtcBp+hOAl/tvoB44O+CIMBp5gDpb5NW7ymNCBuQrKw
	 Qikp5BI/Ai02f7s1hUscCigJOMlxIE9FYASI3FMT4Yq4Ba3kQYTqDL0iv7eQnAeAeF
	 nAlms4LPCxvPeLowOEKIlNR8Rws5PG5Dm1kPSnl7Ez+B65nRVCE6omQMuesY7BvZqu
	 JKFGFX2QA5QaB/XJdizlI2jVVa29xmEplocVLY56a1tgCOx90gcv2b5i14WQMmFR1K
	 hfzRdNFSPzGAVPzJiODsj3WMnOxa18WXkMrpGB1isi9f4LaxdWRLwrMRrRk7/Hhr5E
	 w/5XQ7qlXtSC4dk8wZD/qV6u3u9s3Nl/ZPze20lShxZUzBvTpaIrpRDCzeW9vSpz8O
	 ShpIG2Paqp2IBPRohP+S2g5s=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 934D0200204; Fri, 27 Nov 2026 17:04:21 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770239;
	bh=EQkPeK4wWZq9QUG0Xhod0W+KU3dneE25SCANwvCk2p4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=jZm5UvhTuKaSBb8Xh2UJydsnS/09wetd2nSKgxKIIEn/zP38VpJJV4nKo08FPgmSZ
	 rR2ytzygcIUAvXaq1Gl0YlUYi3uEmqb+GCU+PGalsuydvVUOMvZD5bOL+TSFrABwm5
	 U/HiiOB5fTjvbbXZi3W1dlc34o+/bIxTLEckzdw5gGAsbMUvxcEmseUVPmULHG9/A6
	 PM0Nt9ue5F9WOViVC4W/KgeH7n/NjLPj5S51xxLkyEmmGENgXPd7zCNMUrKq0PKmyD
	 WlLQZJnnAeF2o2MwBVhNxXosKXGfWbuxcFlx/yqWwsmynrFGGn3wKicxuF6Gs24kbI
	 NhTMkPMWSfvKLo/MwPdv3+NmH2qmjhnifoIOw0Tp9H74X+khL+LQtbnj3TGV4WnQT3
	 qxZWHa9UTVQxkAHYVeMetSuOexQrO8Fb+z2pSJBjecpDD2TlL7RHJsRHwpk1DkOjo8
	 JIL0OoxeARIcci0S+zGCV3vjXwlfVVEyHPzTL5TQzikEwqojsvDZ+RtZ3dRrY5TEy/
	 sH7bLn05JO19dANWRB9c1Lf3EeY79aDQf6Kuap3Ke8xze2vEzGVF+Ki3jJ0z0/rd27
	 G4JnZ84nmgwrgxHnouSXcN5NACUzdJ/QroNQpFyx9sOiPIU6AF0okDjvvcR1ZeKWIF
	 N0lR6MiO5C6N9CkKRwBk1+Gk=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 2AFC82001E6;
	Fri, 27 Nov 2026 17:03:59 +0800 (AWST)
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
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 6/9] firmware: cs_dsp: Give the wmfw block error
 KUnit cases distinct names
From: David Gow <david@davidgow.net>
To: Mark Brown <broonie@kernel.org>
Cc: Simon Trimmer <simont@opensource.cirrus.com>, 
 Charles Keepax <ckeepax@opensource.cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, 
 Rae Moar <raemoar63@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, David Rhodes <david.rhodes@cirrus.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>, patches@opensource.cirrus.com, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-sound@vger.kernel.org
In-Reply-To: <20261105-kunit-param-names-v2-6-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-6-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021432.2515039.11236938523373993492.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=547; i=david@davidgow.net;
 h=from:subject:message-id; bh=EQkPeK4wWZq9QUG0Xhod0W+KU3dneE25SCANwvCk2p4=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd5Tm+U5iXIkulvVJ1/SyPf/s6HouwRTqzbo
 MRgkq02Y+qJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHeRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20JdFA/+JWS80cloWq3czeRYIZhdbjr2PrumHxQ
 adF/6wefgLv/68+PsS6tnBZOxjdXuWFTfj6164f0XK7AfW5gA7f+81bQ8w1anav42usEbLph5fY
 1y/Xn15wB7FIjujIs+8mMhAlhysWT+PrEkWPuWNEKAWGMJLMk18YiM7kgqXn3+Hh9h8cGjmWuwV
 kkHHnRucCDJ6V11ZMySldO7pZ4xNA7ZsF8PjJ6+afrn41EpYqT0868XXf5llqDy8ojQ4a+557yy
 UUtIdRUJ2TDPl8uhfC7BCFgwxkONvPvVwbBhHR5MHOJX0+GQifbb1zYFyMA8kJYv4/uwgmExcTM
 2PNHy3/uq61HkVc94Tq6SOmtU8NVZja+Pn8Mi70JqaxR79bmmHq4PKxGnx0dP9UPYh26u7FNzOg
 7kcjgz3CjNtZ9c4kYJn802PzJ8H6RrAEAnSd4SiSKUosjQhEIubJ5+fYg3ZY7okuCSPmGidZU/I
 JdPc9E/SLOiLoZINiAO+UAfopIkbqJRMxCy4yhZyBQTXYLD2sc61pQR1PJsHkKEkU3qzZnudizI
 TqqkwgwxA6sGbwzFA6cmYKchnTO4hUaP0sw9/KEgG+a3GWINdUnGh0YqKJAtzMu/G4ej+NsGund
 o+ZZgCRgH1dEtjRyOW6yj6a15S0AY+fXugjX3d7ITSeEKmcujmr8=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:33 +0000, Mark Brown <broonie@kernel.org> wrote:
> The wmfw error suites run wmfw_too_short_for_block_header(),
> wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
> both with valid and with invalid block types by listing each twice with
> KUNIT_CASE_PARAM(), which names the case after the function. The two
> cases for each function share a name, so they cannot be told apart in
> the results.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
