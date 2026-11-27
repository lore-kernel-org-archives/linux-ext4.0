Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770256;
	b=PX6jrVrxrCwF4bWO6thzoGxoIaSi/vd+IkcoPU53NYFqBNW2E2w6KRo7bkheUceLXrDt
	 GY5JqvfOAvoBYqEPSH0wezgsdSb6cs3Axs9wtmSJh1EyD4k2bvSrU5Hzp8EOoCER9YX2R
	 3SvE2KLfDsjMOAxlRG8B22jAj0Sj/0Ou88udYSj5HOd0pUtR6ylSnMdsd0HV37VLSIRSr
	 QC7KY2Dv8+MNYxbfaPMwpKEZ3HxePwJqVkani9FA8mbLFxySveRu14cSDah6iDslQk1Yk
	 V633obf/t9hxBh37/o9gicRNFG5JJ1dijxjH7QbiYrGxVSqzufYVVGe5mDDnA2cQ9wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770256;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=3rf7gmTQw9zZ2c7CL9NL5ImQ0nbHlwUiHGt3Gu3Ml0Y=;
	b=JoaCoc2hC/tt6mDIyEirDEa08Nkp7OjI2gDzwIKOzXc2KuuLOaOMEEngcVtrJkNncEYg
	 530aLSsFdo78TbU4rVRd/ytF45FLF2pwc0p3SNz59WTrJSDIM/yswmtC3Qek+5neSSpRi
	 NzqMcCVopBPA+c3yBSbaWSp3uiGca5uTbNG4B2U6dFsvE7tiVDIsmzMWTT9VbWY1GAliW
	 bCSfTAfTnEcyaluMCOX94UgIiaqmVRq+1S56kz/w5Juzq20fki7QCOCNiZIQ1xwZ9wvv1
	 iexrZvBwbHyWPlWA9kskwW+glk8aftjEZgXqmpO4EOhKwR7pWV1rpCSJhlzT70MXizA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=pPGYtBaC;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b="TOugT/xC";
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8F606A33B;
	Fri, 27 Nov 2026 09:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54A8F606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=pPGYtBaC;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=TOugT/xC
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770254;
	bh=I/pmrcoQZTETf+jIv152php3CCVthxPOL0TuI3MW8ig=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=pPGYtBaC/cIKg+Lk6zFK3np3gc6su0mkJNg8peuxTEmF2ipiaAR9cKuv9Mg4709En
	 9bujhUXp39dRA34na/5eOB+I3ej7y8u3hGqWT2wtkQJ9044/kGCiHpf4C7dhPtE3f9
	 6vjTI7ZlpXaUV6zZRnh5VUsUMqt0KE/1jDcvRC/KArF0UZITsYi+H46GivTmffmPil
	 nxKS5I4qGM1h/GpxYDFnJ/Kz8iL2t0w+HeoYKWksHPj6eJO9Hku4Dql4kFMMiAFk0x
	 lSLGV3SQQwJfCIFRqoKxcNiwb8j5Fkv3u7zxiF5bKgN24JhNLCCkrzZsm9Qcx954kl
	 /EDLUTtyVlWer7moG46NwVDcGRrf7GUtuL1upDj6TliGGM3lAwY+ZtBx5euUXz+juE
	 oiD1ZKbvquow8HLbrWQwUXWL0jJVLRuQLj/BTvSh1dnnb+8V7xTlQ0SSdmFKgd/mCF
	 aZTKq3VaRWUOYsZI/cOcpqGEqHmpqJuxjxlteDgXuF5Z/wIDqUs1QL7v5P5hs/Mmv0
	 AoI3kZyb3yJLAWAtD/WQ8OLT+nd8plFUoOcfzYW8BYfM0FgndnN59Kk5iIY9xjz48a
	 K4u9/G272jpJLUSfVv9nTeTaL3I2y9lJ7caciLpeEdmco/w1xZkUgEsTVX6MHdO815
	 wer2spTdWEhcL63FFiU14HpQ=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 52BF72001F5; Fri, 27 Nov 2026 17:04:14 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770238;
	bh=I/pmrcoQZTETf+jIv152php3CCVthxPOL0TuI3MW8ig=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=TOugT/xCgsaUZeSQIfQ4QLSRJrJ5RT3ToIMeLf1eam4ATMWyln2p6wggibGc89pJk
	 A7QLBpM9/PLixS0Rbopl5l2hN1Hwbs1YpNInUwevJ39dgpcp7gOOreRb0pX8LIZX7q
	 7a2Wu6vg2Wp5LY8/bcspDtOhRI1qw/7bjV61scqGWDqWzOaq2g2xRdeWtotFYTtHRP
	 18O/Sb5989e/G+haxs+TlpOlMtAuUCoCdUv/6oXSKPAUtrP91scS4ARE7PHowXQTbN
	 +U2adpOynJUc/alY+zVK9jwdqwHCUM0InFJYuccBQWdxLTuyL2t3LbGguoyv19kTSY
	 4qPkgp4T9U5jMZ4XlgJWxsQMK1Op+e0mNamfTgRVP41eh82t3qqYAqZWP2ismAagUZ
	 4TRXz4FQDiNpa8DWbiyCk+LJSGpfiLxzBFV72BwjgwnXyO88pGU6OfVMrBPyEt1Kp7
	 3WuWdIoxV6wjq1WyXsR0aRqz4IXOozh74A2A/Cmkw1jR3KAMLNWEfG0CUMKVA+VoW7
	 17VGVTB8CPmmJGjHmH9Nd8itXurb9FkgJVXuak4BatWBslYRYhvljjj/4r+/vMP2Xc
	 i/VDjvLpJguNg5nXZgw2TnB9Rg5PELDJ94iBddhxkyqW9sie801f17Uc/PUfJf9Em5
	 IYrFUmV6nRbRnruGbO8b+0vw=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id B9C5A2001E4;
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
Subject: Re: [PATCH v2 4/9] firmware: cs_dsp: Give the control read/write
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
In-Reply-To: <20261105-kunit-param-names-v2-4-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-4-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021429.2515039.2916234303908279556.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=711; i=david@davidgow.net;
 h=from:subject:message-id; bh=I/pmrcoQZTETf+jIv152php3CCVthxPOL0TuI3MW8ig=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd2egjEyNB9uVnj+7din+8eUDH/O4v5RIPVl
 DP+k2ws1feJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHdhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20JT8g/5AfMYBFMeXi/OtjOBkumJkI7E9kZftzU
 zxfXvDYiMWlkF8O1G+wVxo2OzoD+kBr9bVnw6szycp9GdoG0FO7y/IZXIuVr83uRYfRj4a1L2GO
 +7RxYQ23GSqzhYP85Lw3nSik1u4brlQnpz8spBp5Qv/G5loM7aavsQICuP1CfOLQIuhsFdNkP1F
 zfXKypBhJY4OphFreiMmIstiVeUqQWOeQ7ANC9Tq8fyZOLNINGpt3RAHHUboxRWj2p6ms+avnbR
 ABmT5Rl048F5FqDbFaeBidX9n8fYZ3rUsjWG/EG7CPVzKkydJsKojHPm+dkSU5Suambv36lCFJ2
 jEo01DhaCl5xQ7ciS4SEWAkKEJuzEcAG+mz93GpX0d/ydEl0eE23T1dHyLvFWDmjWS/8zfcJi6C
 F8HVsHKgdGo3VIQfBuRj9GcRTlfX2jZU3A82GB8qdGSXMcT/PYzumoZcDDQNt5C4DkF0TjMycUm
 SZ9eVeUM2uU/61221C3BdtFMx4xlDwBK0B70J/+5houzGhUkJSBSfPh9mLUHMkPX69vF9oG5CNd
 3cao23h+oha7Amempned4oT3r6px+u6GRRc0VKCURrv8O8u3+tzGtWMIYM6W/zJTFWDEZihqDkc
 8eOPC+e2kakzbwkoBzg1Ew96VxA+hUaALxpkSWB/5MtwbzNXifqw=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:31 +0000, Mark Brown <broonie@kernel.org> wrote:
> The cs_dsp_ctl_rw suites run cs_dsp_ctl_write_running() and
> cs_dsp_ctl_read_volatile_running() against several sets of parameters
> by listing each function several times with KUNIT_CASE_PARAM(), which
> names the case after the function. The resulting cases all share a
> name, so they cannot be told apart in the results.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> cs_dsp_ctl_write_running-all_pop_varying_len_gen_params.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
