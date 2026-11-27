Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770274;
	b=5VdwRedjM5AoVscVFtFKleiRGXxVEMFfGoyEv3yPkH/fkeA4uTEjRv5nww05QpXXFaia
	 mFOAyG4n2HI4H6a8o0y9WFfayDUU2ZIl5i+rEIZahMGNovuAQZviyeCEGcim+sud2LnU1
	 cEnz/sngYd1P8bda/Q0qMvgtTc0znj6RB+Br0MBDKThvO01+Y+/FbBga9eaX6Dac+PX/T
	 nAoyFUW1fvoZ1km70w7PPWo2sTkO3Rqz6Wb+nhaGs7Ta/8Kx3oeEgYKhRONhSAhkWL6at
	 Kz5GJ362qLXTcPimasE7uJpsfS3PMOJi/tPBgF+JV2NrPxQR56EmfV9Fha0bynL5npw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770274;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=/iWatvfDmv0pHpD/XJlzh2YcDLt444S1WAw+wz3QFZ8=;
	b=0x7VUQxHMLtieRdv6K8cVBGdzHtIkI7N3p8hia/Az9eDo/kZIcYY0PiM51vVB6x4BICD
	 Wcrv79s/UMkve6PrlUOJgHEKOVEdsAZ47XygVvc6Rwus7+TZ1M7s9+T6hfmFkl7lGSM2x
	 Wo4syqERQqCKH4rBR3zuXS64A852Q8zzQuDiLbAc7CrU+AezaImQ/p86TKwUjjwkDPCoN
	 VlCkUJU2dtmk4ovwSbgAspwJ2FPawcB0WGyCVSDiahAleCSw9sIbVeiJ6ngkGDW2XmG7Z
	 rJQKuSA1T1QGZ3FqpoJhH6PK8Lfdm1ti0q9Eg6L+QFQoy94UcfLfvP3liddOsitTMiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=rZmmsyCe;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=MKi+GUXB;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DB606A33E;
	Fri, 27 Nov 2026 09:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 982DB606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=rZmmsyCe;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=MKi+GUXB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770266;
	bh=4gXbW299xxN6sUKmkYLY2MNTykOrGcfSw8aMchTBdA0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=rZmmsyCeF1DDYzbLcaSqWiIRbRce/Po6gU+cDiqcgJEZHAev48aLarIrydYpf2nnP
	 d2bot7WPKVQiY27QgRk3wiuQWW5tvZ4lmkBuIbNzMvIyvpGpyY7b8KC75tmSm4VGDF
	 eIfpR7//couqTMQ6553sya2PkGdxnp3wuorBXmEHhEGg0WQ1JKuZF7aWiAY1TMuWgt
	 8M4G9ILqu+UsZM4t/+D2O/a78FARCCm6/Kb9JYjmOzZODE38leGsj2VfGoqRvxueUP
	 gX41Ylas4TQYVJqYS2V8ep7+ZbLn2W4hRlNatyfcM+4+qtOxjfTBzghGWjRKC3XEPG
	 BBrqZGB0aWHIrV7lCBPReYyVxesJjtyZjtpv5R9DeG69/WTiZbvM0iG5KX1US0XVr7
	 BerIzGPmdg9L+9UiTYkuEWJ5itCpKO8swUR+t+FyPomI5xH2SXDtaTSmLKuNXu55V1
	 3B7hx7CdaNA5YFuVZwCMzb60HVAIBI3GkOk5aMCfw2pQ6eGGULn4TMxSK/l7FBPe9A
	 L2gfOtKSdbnje3JoZMRXfNcBGjaExj7JkZs1+RKRBmd21kIs2tA3w+CGIoy9XgRqia
	 IrPwdQTmGsNTtttdEA5CFbhkppxZ76m/N/8m9HT63/jwPYWyS6l9Wm9zuzQmV/Ea6U
	 3dgPXgnlleGY6oU4auGwDe7o=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id AC14820020C; Fri, 27 Nov 2026 17:04:26 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770239;
	bh=4gXbW299xxN6sUKmkYLY2MNTykOrGcfSw8aMchTBdA0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=MKi+GUXBCzA9QzaBAFK+4+fB3ZhfgkzQIYBVkLLl9qe6vMr+fcpynmvcz1sMA+JfN
	 YUzhlWZQaeRkcFM+lYOu7/PQjOadncff+wWVVymgZOYhgEEx+cJjhFGBEQzY12V3cM
	 XZmxDWCz5DzpWGPncINAQKKdqi6R7H0mJmlYd0IfX3/q47p7ID+r08mqpC3s1S1nFT
	 /uwA/v+CkweiL2YLKLF0y06zxdlnHxVbu8brCUuDm6HIJvihum9pAbrfkH0KyXlhX/
	 ZXewUXy2PZN8RR8c5/UmrDagmiYLf46btPPE9Ea3h8lPX/aMtlnZ1ELtmb354mQz0p
	 CV01Y4E4IZllipcEPhDeRhN7/VUIH3Va/vUqP24CjamJZutK8eqK/38MCF/zdJtRdQ
	 ykiZqjIoooKPRmlJVw9foAhEQJAH8mQa6OmVgCnqK+krYxBkQ0gzn/FznXZk7BZPS1
	 jo3dNxvCcEcA4lMDTKjl3dVQsy/sQlKlfN7lFqZL8c53qxuhrDLNkecHLCytbtxbWN
	 UGYJtxlrk8js3Ak63d1R7lChdHrOO+VTRHRdmzgBI5YoLvf9SUbwVusCV7Z3PyMjrB
	 QNWTase7kkLklAUoDTrrxhMze/4KjtxN+iMwCbiaejzhMj3uj4KRWnSyJBi3Hlf72C
	 DMMSzn7OCDH90qGAshAFfNE8=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 876DB2001E8;
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
Subject: Re: [PATCH v2 8/9] ASoC: cs35l56: Give the speaker ID pad config
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
In-Reply-To: <20261105-kunit-param-names-v2-8-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-8-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021434.2515039.10729117939482115625.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=837; i=david@davidgow.net;
 h=from:subject:message-id; bh=4gXbW299xxN6sUKmkYLY2MNTykOrGcfSw8aMchTBdA0=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd7ZYyfGr0QQFIoDZr+jLFhpWZNm3D4eq+cf
 qFSAtniEPKJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHexsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20JSKQ/+Mkko8+b0d1AH5Lu2Ck/d7kOz8jeDqlS
 I1NgAaF0bED0nkKUdmHcanN2L/3pmXqcKEdYfJjzsvCwC9++BTYtrC/4GeDP4kqR6LXVV3Ss6Uj
 R+Ong1beisFKNQJr32n4o10n0QPKU4qj6Xb9C/SGe8TOOo8WSn83nz7FmrOETv+2empGbex2jrn
 2qaroN7TVlzngLHELIePeNMpI4FbBl87iDWEic2r1PayX0M15MOB2rQCNNieMmRTdpLRIS6qzIq
 vNY3Ybh29l48BIKhCIZ1Zqh6a49PtBWdwMMyaweahz56LnzuqDniGyWmYNd+G1cXhUG1epYxhMx
 4fIKJSdVAFQy1bHYjC2BeEPR8JOhFISkFAq0OscT80Jln7rtyojby0wyxLUKx6BVozbjfkS+RyK
 v8aRxt8fJ2/YWExntXvKwIaPa2i+w8J7wA9mn8jCJ+JXn5fLPqLM1hx7j+tlIZdUwsZd5/D5hBo
 Zd0S9AKEZ0U1t01GNNeClaDGs3CMc5nOFivled7WD2VX3je1wjlhuptYUKKIE/iQlrqReV9dTg4
 88ZTrRN1wc+1kyvkh/819GbCHD2pbLodCphj91PKTOFMECz0s/O8/d2zWurMIRBorDn/Mb91Pe3
 yRe9AO462NOYLJAD/EY0KFGJ/bg/YmnMBDIgqkmO5f6hkpsflCJ4=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:35 +0000, Mark Brown <broonie@kernel.org> wrote:
> The cs35l56 shared test suites run
> cs35l56_shared_test_onchip_speaker_id_pad_config() both with and
> without pulls configured on the speaker ID pins by listing it twice
> with KUNIT_CASE_PARAM(), which names the case after the function. Both
> cases share a name, so they cannot be told apart in the results.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, giving
> cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onchip_spkid_gen_params
> and
> cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onchip_spkid_pull_gen_params.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
