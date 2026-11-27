Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770274;
	b=Zx6nSyRkvFC63AOfTo/8F/WtDcplEUgcjkVP4Lb6+6Y/PEDhBjd6L5FvVRCIOTU1HeZP
	 KB3PziGUKoZFLintyeAAJP5ZV5TBJlR7w2McE15O78x4Lcn1+LgXpCol5ztuadECo/65s
	 4ZzsMqGgFv4WUOPeT+i6D//7hV6rm3K3arzOBPkkhZS+vl0FSW5t7JxQ1vj0HmPhfObBH
	 rL2PIwwj8WIoqtzuxu309rvlFG85CAnxfpirLUSt32nB4QXIr0KUTBC5wBb+oFEKeIbOe
	 hDsmDuXS+2h/a12bssctSQMZjeKtTgUN+hX5qo7ovOguTdqfok6o3nChLjXFi6T934w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770274;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=lpfzV4ZPfhSB2yFX8wBHSMmSZfHEIK5ehQyugWvGqMY=;
	b=zI71cE3svqIqkyLXVNDL05VKfMxt6WZLNpKGMS0zBt4R1lfMHMP1BJYyAm0BlG7Yifhj
	 GZRdmphVXy/KOVcPJ+vHGYy+ouG7dbceK/uLZzjA+d6KTUpfMGB5B6QQ5jyVNUAfkQ2FS
	 bUhpiN2eNdYy2HaE1YZQA2n0vcC0X37cbmDitO0+M+l03xRhQCudhQzaALvtwfBy0jlkE
	 1OaRduc0hS27VVS7hD7cHCo/Q45mlMG1NWa5Xh9l6cHp3iMV2OS3kIZWKLqNk+ccRLRxU
	 n8qtLk/2JDHb0IkVo8n76EXoRHAqKMxZHhyJcBvcMoQBdDWW4wtfvDviamOcVuWY4Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=XZuvlrbT;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=ezMdi1UZ;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBED606A681;
	Fri, 27 Nov 2026 09:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCBED606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=XZuvlrbT;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=ezMdi1UZ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770269;
	bh=PrRbnl3eCdJsYEs8z+yJ1rw3/kHiSNTuwlE/vGjZCv0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=XZuvlrbTYpGLH5ZEOwA00uMkycwizq3Sc6Voxn3loJB2jjIrObBdnn+O+BbJ/JWc7
	 bJuyfItsYHWMNMebj1yrK8CZ2eK3HG1LFn88YegJAxjymdKlyCB7o53+y2ZfeyFoYh
	 1e/mkvZMKMqtBXCyCSe3iP+hvlpQeMbtYBbD9tXJwRjJhynr1uR/MUolr8e+Ct1d11
	 kSDbnpQUHPngDgWaaD6xinOZSdjxyAqWfCD2RDEc0yd41E5Z6fCRLyOFCNjEH7O7lc
	 eLr1syTxL/dkkApgo5xPz2a8L6ceMtCVEnuCxfZokMBX0/rEU4n+El2Qy8JgsU5nDo
	 gkA8qJMf2u7dauvLoLThghDDemq+0VBwRHiV3Q09PEhOPdawvXjy/T53T5mUIEUqtd
	 o6aqRYam606wCCcfTfAEAYxKlu6ujoRutDtbTLEzipEWtrdzgtX8U+Dzwc88tSpqlO
	 rzA58LwqmH/sYysQErQlLeEQgUzT0ijLN483r6DYARJPc90jGmgUHIE2Qtg/8ixwCR
	 ZghJ539wqivbPG/a8XkW3/uS2EqljyqFojxmsx2ym9H5HkgeZI/As8UH1aDO8Jjv/j
	 rbzlCmYoCGg1gzm0I8+lZsJT1X9ax1xznV/5wznpl2xO+V9YC15Rid8g9Z9gz55jSy
	 jTKBYlpyqwNWS30uptStJh/A=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id EE6AE2001ED; Fri, 27 Nov 2026 17:04:29 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770239;
	bh=PrRbnl3eCdJsYEs8z+yJ1rw3/kHiSNTuwlE/vGjZCv0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=ezMdi1UZXQpvcq3IhYmNsgY/v+SxUE8NnIKKVQYjPFetLlgPnfhy7KZH0R7yyJuV0
	 4s40VED3jejddFVew+9J2RmSY1feRRkRfpElnYubnsd168bzJLLxvevaJOXS/0MxIR
	 1b9qVD//OOKfuXZCuH0Ba1CSkcJLTkNmged3EqbCzcged17G1yWbGAJV9CxibRguKT
	 DqlnUgdZIv7Kusef/FoKA0aVaY1Wi65+arOYsLlw6GSVkW8JWKnc0P3vrLmDyQEhQo
	 Ni40gnHn8NSzh9+hkhH5Gr73ekYo+xmJ4TXzFKrp4LH5adK81C4S1vLJCl7S0o5lN2
	 5p7ne7KhdMjejUltsKV6tbIBWMRTS/LCk9ykXlvi0eHnhyvge/6t1ssgOfbIOSAjzX
	 6nk2fa4+/20YRDr0ZxJpru0NZwK+FRSvM6N4owWfAGxLE3fRrZFCWC/kY0CZ7I1epl
	 F/2XndjjnYrJ00AX+4t3TlN88qZhU//rrd7hzRfJ0omjPUljDhRkLJEzwk2rxMS+5T
	 nwRNxV6aKaGhqngPrUQ3Y7AHJ+HjJfn+/v5dT4bO4KZ6euUOdpb7kHtzIxd2IXFffx
	 DbVTxu0HuqBc8Bg/H9eknq1UMhpcANPnLww41BThbUiX3cLpFJ4wnZsJDIqp4UdTbp
	 XpECU04kd6ikksr0IIn2v6hY=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id B865D2001EB;
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
Subject: Re: [PATCH v2 9/9] ASoC: wm_adsp: Give the firmware search order
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
In-Reply-To: <20261105-kunit-param-names-v2-9-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-9-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021435.2515039.9269894071838902808.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=714; i=david@davidgow.net;
 h=from:subject:message-id; bh=PrRbnl3eCdJsYEs8z+yJ1rw3/kHiSNTuwlE/vGjZCv0=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd81GcWtV6ji765bHt+pl1DsAlces1cgoYhU
 Kd7t0jlnfaJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHfBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20IUtRAAq4jSf5+n6dtxQKvuf7ts3qajvgADo6T
 4Low1CVWVAckBh/+jOnf11PIwVFti9X3my5tee6pRxHddTISttnU2PItovkOracXXNG14fZqhVu
 p1TU6uMFDFZNsuQeLWVaBu8QigtMPfQnNnk0/1ztcnRu6DggYmbdcu7spT7FJId0KdbGUQDRx0/
 KS4nDlb6aTz+mqSOcK4It7+cuekpZZ5SYUIxMF24Qw8LfjiTsE3ZMg94DTy9gPV0sXL+l4Gi8o+
 9sQ6EvCN1tSwqoWxXg2AF2/DePM6N1hBhGA+DmlchJDvCwKZD97uxjen6Z1/zDK4kMZHYOJNDsR
 gNEoZyA7r64VJujl9DO3Drh7uyCGohnAiHO6h6Yq+u4p6IR2CjYFHpmMsfTUNLJ0ghzFg7lNvzr
 2JakP33+JtG0ArwD8tvVlNHL+Djzpga4thYdLkgMCeZ5SGCsFauah+Tm05WL4BGgA4HhY3efhYP
 5f5XSibNQbK/pzIcR713h0IRUPlDbpXYct9mU60kfojIFAEdgkASndOZ1W/7pZKWpudq98HI8uA
 01A4ATgWxjM3VbqmiavPuEsspCZ7sbpexvy3N40GPiACQ670PDCyx5P0CfOm10I2gV2s/fc8/jZ
 L+u+0UGwUTvUszPWGqP25ySeq4wH7vzfZkQP6iX8ij1Y7zS9x2Lk=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:36 +0000, Mark Brown <broonie@kernel.org> wrote:
> The wm-adsp-fw-find suite runs wm_adsp_fw_find_test_search_order()
> against six different sets of parameters by listing it six times with
> KUNIT_CASE_PARAM(), which names each case after the function. All six
> cases are therefore called wm_adsp_fw_find_test_search_order, which
> makes the results ambiguous.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> wm_adsp_fw_find_test_search_order-wm_adsp_fw_find_full_search_gen_params.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
