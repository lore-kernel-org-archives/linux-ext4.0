Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770260;
	b=nPxyGfNGb6n4D2aO80MUyJhM4VopPXaCee9oxv9Ju3kJHjX19mlEKVH4L7v9RVRXGsZO
	 vIkR90XZUE5IPkR8H5mQKqOfHfO7px2mmiJlG3ph9PD2NanB5Zv36wJB2umDUHtBCCE02
	 2DdwqbBzLMFlv7xjpO+ecdMr5HM9CfxVy6zaabo+Ss4IosW1YyIYjv9xu5ucklIAy3cpc
	 TaI15NpD4+potbefYagsDMMjHBawp1BFOQ9nMbR3jIdXM8gkwMhc6/9mAg+um4UZbXCpx
	 HMlJ/3nJDEK0HtwF6g8enYJghQFZA/YxTl7Ma9B3SFkZeaZ35YSgR7xJX23XnLvgU8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770260;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=lB83OGah4djfGd+z8tF/2NWKCF/mjSptP0M5SAduMRo=;
	b=U/PczZZgXegK9p8FfmA/4vRrcPfcvUtB9jDJxxG3J4VeLEWnrCeRiiwhfH3vK6Qp8uKf
	 Vt4e40TZ2m6BzQVLPHZ0Bc6vNasD7Ume6CDwJqKvCX2+OJARUlTe2a53Qrj/jit3+hpbR
	 93OuCenJdiYsgUMyuhM6nz1WyYD2/f7Ke2HzJczzr2VBghJr5uLz22BeaJ5wttmIjUfEj
	 GQhcLrz0urcWkXL1+3LFYOmk+r5ZwOdc3Ud2J74pO9noOL7kffGIViFIQXArPnpo9iUAh
	 tWXYdapsWpxzgsUvt8YfDxZ/Ha5qbfKP7DThWZAxmh9NsFdA3+Ui8U+1uM7zhFka/tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=OQ6oOTRy;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=r6K3Erpu;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED175606A323;
	Fri, 27 Nov 2026 09:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED175606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=OQ6oOTRy;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=r6K3Erpu
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770257;
	bh=FGKZ42sJ/XYfEgbzrVYLVBLbdNiAgMFOIzYKegnqyMI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=OQ6oOTRyH0j9VUFiF0D7Yvno1yJvjFvvKkUdVE4ZqDY8hyfHhcL3HZFU386i8FmSU
	 o63t28vjhc2sZqp69a/AupvAJ7TafZLJ/Xhk2fFl3FnB9NOyAVHt12cbir/syMn2cV
	 2JZc6TX4Mf9GD30F13XIqLr+ftd9z0R82asOhNeWHE+h0kl2EphxAB+bxfM8I4FPeD
	 K07IW0QNLK4SZTn1Kga1I7onsCuTOx+7MFxFEE52jurykUasBZ6+IpVGBCrjykTb8n
	 7+zFnDhsNiaEcen56xga8khdBSixaBWgB8slynP6eWXh+NSfucbx8UeJCeUhw5g5pv
	 OWRiEYswQA+vADULq53BDyVcmdoDEM4cSAR6GNtaRvvDZDt8tINjt2vwhL9hPmEuii
	 Jw3QWxfy6HVmHaHmwhT1eEA8fJV40DN3xEBx7ePEDutuDA/i8Kh5vW5VSh/kL/2iMw
	 qDS3dJc+X/x4oEyYpGqDdEEI69kdqDsUjx/mMnnj+Q0hgLW43ws8x45U/N/7Uh7rck
	 EJXHGJmEDIYmDKAG3kHN6RZWsaokCuTakeDao7ET1Ju2uT/01iIhHa/j0biRwtP+OH
	 Tg5WySvl9KCSu+cKsk/lR3JUqQVrSFPv7zx9HUfqQkksu8qfZ+F7OoPye8JGysSosK
	 E3pekDCYvHv5PxSP64vPW364=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 25755200201; Fri, 27 Nov 2026 17:04:17 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770239;
	bh=FGKZ42sJ/XYfEgbzrVYLVBLbdNiAgMFOIzYKegnqyMI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=r6K3ErpukQxTynDdJdA4CaIrLQWMy5EKXUF46oVrlMb3/EOzq0oeNy4nGwOLvZmxF
	 LW47TvwKc6JCGJn/KvYCyS01Kb6cxQ16JT1FYfEDFmf2zK53b495OZ8TE5+IzK2PsH
	 u8p7JMk/AmyZ1Rn4ll18uzRXc/hcUGYoljUnaRS6w9PTPmhpCKJK+NCC8MVD+CnPaw
	 hQpcgZzymHfXTrylajOSjhzscS9X2siuMVYp5vNdwE4hB9pnFnFeAZ+4VId4mJwgaq
	 c/rbIXxwFbveEe4Wbi/h4DB1rv1b3twBaY34IG6Yu57drTZP4I2lUCE1LpgYdeE/1z
	 ZbOZIhwJKENuaoyZSXM2+sNoJmPjKQxhSt9khRhX92ntlR74A3MwuPcb2buxHvsrdv
	 G6UmqAZTjK8D6jKzczOwZT9Rr2eBy1V5C0xW+8ol1qS7Pties2BncTQs4RZoRhwKB8
	 cM5ALz1AhHmUX6G2coUpBVekeg+jGHtQR2KdfVZvDYH15xXxtxlgdY+kh6m/2Lq/gF
	 QudADooFfUi6qYCC6cooqDb+rZx9WrQKb6Rrgst1YVGT+xmHOg2R10Yi+bWsa6NfCZ
	 8aK15hxdHhovvsCcHHG2GdltEYIFbt0lp7fF1+L0ESiH8PeaBS4HRZXC+ezPYb7hfs
	 SrFjIHjXbRf05BlQUYShuVsM=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id F06D82001E5;
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
Subject: Re: [PATCH v2 5/9] firmware: cs_dsp: Give the control cache KUnit
 cases distinct names
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
In-Reply-To: <20261105-kunit-param-names-v2-5-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-5-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021430.2515039.10102791444201384742.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=551; i=david@davidgow.net;
 h=from:subject:message-id; bh=FGKZ42sJ/XYfEgbzrVYLVBLbdNiAgMFOIzYKegnqyMI=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd4M0Se56zcAO7VKsxWEvtmKQK4H3k44bNgH
 WHGxx1orQWJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHeBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20LjCQ/8CczGMbIWddkeKSt8+WVeoTb/r2XpqAN
 GFQZ44LPWdtZmbXCyJbyfHHzWEA4QVA8knEsBDJRAoeOf6G60NfUDWlY9QhSjNVrtp1GWnCkL2z
 AyuFCScABBFVVHI6kfVsaL1ZdjE7bG8nT5g6YPvPVN5wQpE6lNtwZtNaO6+hHV6Wl1LLZMnMgoX
 7uTl604nRS0+eTfYWsmj+7aQ8E6URKrGlg+XttCdJR+4o9yitE5utYlXQCghSnoziIHxhxVhPB5
 8jhl6oK+jVQQqwSRutzM2GAHX7C1DFdsG81JDcl84K3HdxyJ7aqa0eZx5T8cdi9QA450LMG3QNP
 WJMnwPavqTYTmY3VByl9bEDzVWA2bpNRYmOUZyVyZYhqjlRPt1dU48c6Df2xD3liduPWkOFWm3W
 ijv4/7qow7A7B7bpwgy816eTf8MiLEA5SRJzDR+rsIXI4Ehn3GdXN5ZM7c39cJjzwRB2MfyU6KJ
 cS2PN7rBCB+JkLwk0cYrXkmP4pRk9gQfMJgQFAJz0IlNkdgKXWA2JN8AUgke2810M/CzZZ27P5r
 eYQhAIrzOvDMLThoYl8vm93HhXYi8mmUxiIuf3DTj9dYMCMohPUjtpxnwjLv0ynCVNMB0S2i92j
 1vFhrrr59vRPKbvAGeJA5kOUJiizMsOvYm6y08rdeBd2LXSEeWlo=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:32 +0000, Mark Brown <broonie@kernel.org> wrote:
> The cs_dsp_ctl_cache suites run cs_dsp_ctl_cache_init(),
> cs_dsp_ctl_cache_writethrough() and
> cs_dsp_ctl_cache_writethrough_unchanged() against several sets of
> parameters by listing each function several times with
> KUNIT_CASE_PARAM(), which names the case after the function. The
> resulting cases all share a name, so they cannot be told apart in the
> results.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
