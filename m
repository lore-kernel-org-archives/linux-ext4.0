Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770253;
	b=1TXsPaRbpoKYllsKjCBvZ9cRMn+Kcb2KgQFM5/LbHiMPSdz2ZjwajEElGEy9WOunWSv0
	 7L8ek75ncIhvrZtEG4wX7pHYw2crcI8u+o9cw3PdFpA3xyPLJAMkI21jD8NlcPoQJdral
	 DYM0arFbLnln4kT6uW93oI0pLefaRjs7Qz5+4vqlc1rrT8ISPLtGDalBBKkzDmpUw5Ii5
	 FWDnPynETVtYfAzi2rRSSudWkNPbSflViBwGUUNEzI6zrx9FXkwVLUmDXUZbo9TZqsnpi
	 j04TRLoOhmyGxJV3BTmU+PpJO0qp+TiI1Bot3RyaEIeh89DZwDh6ZPHzSImnwUzkPqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770253;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=4yo5+bJTkR2GBlokbheYyh+82e4bW2sTNcYpJe3cwCY=;
	b=rmXlvCx+O3OFmTgF3Chk8cUp98ve9ygAyBpzOb1uoffxhGPrUBxbTt6A8GHSq0ytSP+x
	 bIg90/rvM4BMcpfcMm8MjEyYFHXVP78F2CAAfX5UgvI4Br81aXx/PgqTQ6mQTTZDSn2OO
	 c35Digpu9tJIxeD8ikQbnE0NmXncdPsmcDlvNfDHx1fJB2VW1Pk1fQo55SyZrvCSxKrue
	 X9Ja6TcEv/g3z0Y5n6jpRtXzm9DB5km7+ipxqZugEqz8MydhOeS+wsBAykxDJzUrtc3Ie
	 3H6K1+bPqV5q3Yju5OJGeZ4KI36CY3qc/MhijtQg5tjhGA6ThhSlOFW2EAiSYF7Bk9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=P9m6+azV;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=qI2XjGYz;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23241606A332;
	Fri, 27 Nov 2026 09:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23241606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=P9m6+azV;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=qI2XjGYz
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770251;
	bh=ZBbdVU5fbYlYguDvKqeMhKTzbMkCpTEkjuYwpOoVqFE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=P9m6+azVVewuEGbDqdecdIGIVnPXAmnO848uEbyg4ulqHyTcK0n7YzydCdvNVZUwI
	 xOq2SE/0DJ0ZR6v8xJXn7vuVSX4+CS8ACrf9Tm2MsVFxosUJL79A83wJITs3q8NnOU
	 EpkKwc/Eawm4Dw2A4DZ0rXghotlQGrT3H2FWE+gAP8DHeaxenSVfByYxm2qZNKfXxX
	 IxBOJch/pBmEjVUxyg6JBKl3+YM0d7yAd02ABdgOudw8nuKYvmDPlyDK/1d81PrDOc
	 LaMhdhf7zRysGVNV8XZakgvoI7/RzfbNZb4CFTQfmcameOJaTycaM4a4rfff4qcSjz
	 SM7rEtP2fQdbcKBRHlAo7oPdIEXeITKiJWuhoX6ufSD0wQHj23VU0JIFqAW57HYYK3
	 nsVAJG4dKH6LB5+ycl/8+I5hja9n2RqRovUeCZ1zsCQenvAQAdHw/NSB/ZB1hWUdtQ
	 4hTncHj/3dWm51CWYQyS7l8Pe/Y6aAiWUNzlKl1oiwPWEgvhYnyuTzgRBYZYmKUg35
	 7RYgytotzv3ZdF62adrYBKWcmhIOkW+EL4gxsL48MRP+JWWXY8dOniOjdP6MmeCkzz
	 3sUhlaTmToHbYH19RAYazNePOOsKHPbprsbGoSQk5b3CJXx1m2z95XilRdYP6EXFnx
	 bCWOYCdWpzBc0TsxXvvbJnQI=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 40C5520020A; Fri, 27 Nov 2026 17:04:11 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770238;
	bh=ZBbdVU5fbYlYguDvKqeMhKTzbMkCpTEkjuYwpOoVqFE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=qI2XjGYzPob/43bPoGDiMopMiweCg3IQxIAXXC3vQasEeyOZU/Y0QyI3bDvW0iP62
	 sb7EgfmruAGo4lmTV5ligqvQuE6DMZY0u1+tP/iArdifllB3ChmdUVuFBsi2lBaV3W
	 Fvh3vwTba4iVDqdAdvLwRpbISAruXqQpUUPCCytXhkeHcj1+VVyCG6EIBNxSRgiFQs
	 2gzJIZkr9Q6XQ5wzXCx534EZivkKqq568xnHHPv216/guBo0Eed8Lw7sYSAIq1NIRl
	 BS4nxBe5Qk4UzfFJNxNaUnT1Yjs7ocai/6mfgs9tFlh4ClhvXCoyowQ1rd+Zn5vmnP
	 sc/NQISmQ3mZ9FEdvuqOvn12fm+KSNyM/fEMCjBGjnDbEP+5altqQETvsJyCysBluP
	 3nWvg7x4j2BkbfUDBasjK/rbXeRZFqbE3OF3AD6w/hxTpsMswcn0Fd9muM7C/qulKl
	 RNY6G5U5nlWN1g8dPb8+TZ3hTbmenZ9gsxzn8Viu6FtN2J7je5jKDhK/fESSrgvxyA
	 eIH49l1DNImjqBWewXrgHaSfAkvqq7N6+B/FdKlpugm4CM2C+zG2KsyY1pFc/4pn/X
	 1lwk/Txc1Dv88EEfcm0CkRg9E59oPyuOPbnguBnCwj6gh+jUGWV7+df1E47BDkyULq
	 Xx1Me57J/W2MoAk0V6X6h+eo=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 880382001E3;
	Fri, 27 Nov 2026 17:03:58 +0800 (AWST)
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
Subject: Re: [PATCH v2 3/9] ext4: Give the extents KUnit cases distinct
 names
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
In-Reply-To: <20261105-kunit-param-names-v2-3-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-3-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021428.2515039.4493251096187566741.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2123; i=david@davidgow.net;
 h=from:subject:message-id; bh=ZBbdVU5fbYlYguDvKqeMhKTzbMkCpTEkjuYwpOoVqFE=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd15U8vQqWtnvAJYnmInZK62SdrgbhMQ1pWn
 CuQCWCZG5qJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHdRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20IXfA//Z5lm/C1Mlme/QeMYkXgvePUTiIrc9Dw
 YCo85Em6ZuQns7qwMsP+fsVne1+toaG2S4U4nEALrwcp4AQtt+UtzTnCdmzcvnv50iQ8n9CrCOx
 qMH/zg8cWS+aQgBPPnJyJRo672aZKZvA8BkRvIcrNcvGJiCkOpLuKE5gP7IXp9wHSCr42Fhx4GN
 NRbVnHa0U6noYdaQ/Z4aYgTpw9cDZ4XrsH622+i4g1PxmYe3ft7/WfQSzP9lL4m0YUENtisa6iQ
 JmYWLysLMouSV8sKMZZ8wkGNICD+VhnaWDD92/JiSfQPWT20kog/V3wAMeTJhjpBaUxWBWVeak5
 p0YCqfHUKDNLsFyhs6NI4GUjF1fmt9A7qDrPyS90knw3mDvEm58CVC3ip+OvZWtUgVWv1riUIkM
 F1VTsi2gHb9cpgGjMqPwg0Bo1cMScCSNNNgNRmZo4894DPrwIycPeDNMvRhFbvGlGRIKIHCH0p2
 VkWv78cmGfX7R8EPHB+Jl43XgWVT4MsJ2sYNE1BWklCFixhnJsDHA8JnoDjBU7v1XjbXzmqy/PK
 NqNQoKbAvjDczDSJ2X53Ty8bRM77G1SPxv4nDa+dT/7tgAuo17zpBj4h/S5lK0HJRKlBdI1jiNe
 QFH2MgmGx3ZZDWe0oelVblLrOYaQ6MATFTTTSzJqSsOtJyJQxTS0=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

> The ext4_extents_test suite runs test_split_convert() against three
> different parameter arrays by listing it three times with
> KUNIT_CASE_PARAM_WITH_INIT(), which names each case after the function.
> All three cases are therefore called test_split_convert, so they cannot
> be told apart in the results.
> 
> Use KUNIT_CASE_PARAM_WITH_INIT_UNIQUE() for these entries so that each
> case is also named for the param_init() function which registers its
> parameter array, for example
> test_split_convert-test_convert_initialized_param_init.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Note: This is probably going to have a conflict with all of the changes to
the ext4 tests which have just landed. It still applies cleanly to the
kselftest/kunit brach for the moment, though.

>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 2e997f228330..ebef078e292f 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -1045,12 +1045,12 @@ static int test_handle_unwritten_init(struct kunit *test)
>   * https://lore.kernel.org/linux-kselftest/aULJpTvJDw9ctUDe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/
>   */
>  static struct kunit_case extents_test_cases[] = {
> -	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
> -				   test_split_convert_param_init, NULL),
> -	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
> -				   test_convert_initialized_param_init, NULL),
> -	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
> -				   test_handle_unwritten_init, NULL),
> +	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
> +					  test_split_convert_param_init, NULL),
> +	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
> +					  test_convert_initialized_param_init, NULL),
> +	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
> +					  test_handle_unwritten_init, NULL),
>  	{}
>  };
>  

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
