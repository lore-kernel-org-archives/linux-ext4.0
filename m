Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90055486E67;
	Thu, 10 Sep 2026 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049833; cv=none; b=KMwQTuiqXV8mgNqxJ8OQT+IJB/c7hZb3A0UleSyJNYo0CRcJ/75o2JgOVxodxjaim9Gpg+y0eY+0c2ffwu4fb/7/tkbLM7xin4wCHp9ArrplKPHl2pRb64jkfWBDzWuDf+vkVd1KIOYvH8K8PJluknQ2GAxyZdJ2G7f0mIn7mWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049833; c=relaxed/simple;
	bh=ouLSzFPPywcWEjItXpm/BdFxmrrlx7aKIKZ1q/voZWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYP1TmGbjF5BPGNLIiuYW+EWSnl/uZD0kuCMmhfzWqsoCSa7018YfAtr1nWio22zwu2hSKGwOmHsp4GzMrKxkwjf5rrd0D5YO8LEJqPqNGTeHnG3MQW7ySXql0sfT0L3E2KYrXfOY6lPrXGXMyAbsPx+40l5rwLRMTJmscCDl8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=LhvMGG5D; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="LhvMGG5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789049734; x=1789654534; i=spasswolf@web.de;
	bh=ouLSzFPPywcWEjItXpm/BdFxmrrlx7aKIKZ1q/voZWk=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LhvMGG5DzdYI8DqS5YqGNKz6TQL9GIVQN587L5YBWaR3ZxwGh1q3fsORx9ogHMZ7
	 OpLpUGtIvnnynrFZtbhDTC3bsbxkKziqvJ8cZr2xJC2Fy0Gdvwxg7rGUiGazCB4p5
	 lluvrmgGRm84qmsDje0Fq3sU8IpOGUyerTEExlv7HJo56G0nM0cnGGfla13fLFzVU
	 wppgaTNr4orft7UUvOKuhcdRKlZW+nqPNZINJ6Xtg6pI4kyR1vmMf7KtU6A4Dmoyi
	 Tav6PhyiIj/hZRgwclLtfVLvdtI3S4bVDaixSnopQjF2Y6pSfY6g+aC6eijtxNsoq
	 6QWXUPpXinHPVcycDQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MLRYd-1xM3io20cV-00XlJW; Thu, 10
 Sep 2026 16:15:33 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: Joseph Qi <jiangqi903@gmail.com>
Cc: Bert Karwatzki <spasswolf@web.de>,
	Chao Shi <coshi036@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Venkat <venkat88@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org,
	Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data directly
Date: Thu, 10 Sep 2026 16:15:22 +0200
Message-ID: <20260910141524.12362-1-spasswolf@web.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9CC2EE8A-9F67-408A-87A1-62AF671B4BFB@linux.ibm.com> (raw)
References: 
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Ul/2rW8Q9s3i94Jp4a/pwfqq/0kVSRETu0GYy0OSrciaIrmj7oC
 /VGMb8bYZHZTZpM3eCw2U9OdkOxr9fhS7hB5W/AULwFivn+5qkqvwV4jR963HDqY5rw6OKb
 n4kIetFwotCaeKUKCRTIbwOvanzg0SOVK9CqAZymL0DXh82HsPZNW+zd+ccRyTR6RkxmBe3
 iQj3Pui9AvylTp30cam/w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:h1+fjtsb0wA=;IFoDmys7j1uXJOqLBetdwENOFSk
 KjmO7xqWl67Fqp3fyO6XIwSpae1xaAex7FEPM8cEQTbsaUX8Ov3BW5lkMrVB9UpsRhrBRTl3x
 nPzBqyd71uSfymSakDWsMPFHcsL5d/Fe6OxHBJLh1KGkxPy+H5soYqO9AUEERDIy3x1TZ7za9
 BjunaIaPFdyysW/ZK5TNCv8S5ApsrnCpSqAJXBo+q3v5fGrl9MtCfcm+lD6DaDUz3DpPF06mh
 5yElci0+sMC2Ge8+6sp+mFNtd2AuNUKzjo3sNmJLLpq9vSxnciYUVbx3CQ6xEvRSifpDqIko0
 n1pUz1bVakFbgdWRzrA72Rdm43Sil4CQC7LmAw/2m7d87zgwWKakHFMBEYl72YSWDW+TTGyOQ
 RsscsKL+2P6hfsZNUheWsbxtGNSn9Bn1HQZ6y9mejlH3dE28B9N+1DYSks5K0DNd9IuRXbCjh
 qWTAOyFDE9BP59bQBqSGYmmQWUNCW3uf93s3oBaxodXnb9LEh8EVD2FcoqHJsUIxz+Zr4GMKr
 t1LUmqBa/pzzSqURdoktCRe08mSJixy5HpNqSLIpAJSlKB6Kk9iyP08SWtHQu9yL9w3eXwv2U
 EcXH2PnG/qu7zhfPOEuCdJvlq7ol31jd8fvSiFyD2dKlKPQuLO/hTFOjmzh4i2BnEqBdlHzZ6
 eQ6BAJzyI1jK0EsU8BYeusboUo4gwT0VcGyViwGjnGmv3xhhcXtCyKF12tbLzFMgoMB9rtxl1
 ItzTrp2l8ZmFgeH+JZ1LLTz9koUJwu3wDofzI0xCkUztDroJWHrFccDl4xV473zNnDIcfOYMM
 A/tGzDNkneIAHYe2Md4uuJvtVEpSZYPZz/RNjHX4F8rzaQju1KTLm0goCH6sI/NVCoFRDybUF
 f9e52B3I4tXfrthGC56+5O8izpm95eXEYc1gwV+fZJ1TEmsYl1xaxBWHeMpJ1RxJVVPJoCqmH
 j4uMrn+KUQBQCDjNFsaMEnRTMUsSX6nBKBVTYaAH+YYruTuHoav/B8Lq+Em4CxWVkkl9ZuI0x
 3eAIt6zcigbaKyWs+dwHv7/OH30X1yM7MAy8He4TiaIajk77fVZM6AhUKINLfQDH5xb9qco9m
 bfXg+0c8vy6TV5UAm475u31JDha2oh7T1O3rsIaHGV7NWvpYo9Yg03qRnBnWIqCMbHLxeJkvi
 jC+lBCeV+ZfJYNJKeKQAAWCnfl53autIxVXwmegEvQ6hMqEFpYi5RvIfF65F+nOBtH/NVka8D
 b0XEv3K/6PZcH1mukiXPRCR6DaVPOWMtD93ooE2X0OlR1+pU4FLh6PIxjV/sSgIU0s1ssYRNu
 i/+TvVB88+uZlcJ8JaO+M7rFXayZMCXN8YB6Rht1YJz1Z87aRCW1/AGY19qOocvhdK15MJ4zk
 ZhhNaFfn0jmfm/QlJcISWP4tPuf6Qqh1HUgADzJ5KscPTspdKuVUXalBsF979I6dEM59lZUNe
 KAe5ZQuY/0GOTrauce5DTheM9uPNYrIq74YdjUIbRcYWgcizSs7PNfjtFhUmdkyDvKqy4x1xu
 D3+8fa9m5uI+30H1BoNw/dDSQmmS8wXKatPPg/IrcP5yPD5igMPps22O3q521ZSfFr4lmf3T6
 YQoomNg4l2n7QVhZfMioC18jglmSoGCrq5m47l2JbLaTKXNIdULKtHat9tawF1vxVUkB7zSxt
 R/g6gfLveEZyZG+m/QsRW8tTULmW0fHhZFfqY+nbC8fXyy07tHauOZoTI0dIZtDNRo4RuaFbR
 ntZ2iyeCKcAwmJWgfKSq00RKOdtYTMV/L1QbvYZcAB3fztapQSf4cF7JRynLMHLqqQ0O2D8xU
 pjqbl0CF41UgHc/n9MJwvMyuAgw4Twr5bV7pESVxs/kZq7vEVZK/f9Mf575+qNCeIrlN+5xxN
 vz2H4tUL6zIk1M7Csp0tdFQA9xUrYqNbPdGxVfYfjRR5I5SaF6cYSPtyGXb+fnbRYiemYIeA4
 AfhMyB1T+5xQkA9Tu7XMKeFrYniakrcMbNSVb2T4x3n3ez0Funjm9G+sTmCEpJvmBR70KNyFz
 Mz3QJF7cpOI2eQCz9qtDP+ExHXADaI7lnFEWg8KeEPvndybu/Zf/CSE2FNwtLhD8h5F+torYz
 WxVplXq7ltr0xNE44ZeNE2x6o3MUoq8dM6stPfbDc4f4lqMGXo+fgu4Hed2eTElrdGOgA4/Pl
 EwicbGmd1kFWuSKrMTnzLCq38MOgy7udbMIsC4EVDaZo5Qe8IyBMtzmv5lT6Uug3ZFuljDlAk
 W6eEmgPvocEbUjzQLuWknKzXI36kUIvEq3nBIp2NSXIaNonHMPqJYg3VgfCM/23JVunqTFC2m
 SZ/BwsDXDVgiAevzlrZNgWPMDXiXXzuaVsnjX9YuZ7lAd3lzaRQnq4I3uQOVDwOlzxAeNuWP+
 WaPFclojjl2sAQ4a/GnLl9qJnksJlT1kxgVu/fyxxRFpUHF3U6PFJ00pUa4mIJ8ZXFTDJs5i4
 KjngqlDZTDitCNqeOmthZ65KJQFSVxd8ZqQ9bQ9I2zZK+sWPfIuELeY5YSuj/RlQ/oHoW86+s
 kjzuLofa54V6q08iry5pV6eU9QiRGSCiZfzO40WUi0IezmepNRLpuAyiCtpkr84goQWQExJjM
 lR29t3RG/TwUUVAkMs5ptXCB1LOXcCgm2MivydojkmDDyJ5XZ6Neow1ikE1pE8BXdKni6ZJ/3
 CEnZr123sDtfwCuwyyyCq6L1U+62m1NE+I6HJDHtqX+X3uNpTkk6p43FCih2Xf0yUUeULz+ms
 h5iJwsut5+wTNcLqNdvOe600VwR/bka4Ug380s/jAMgNnnjSPuYirt4M7JtxlA7C3rouq1uay
 aDYWUKZZYLJQXyaYrkQR2+LydTI2Axvl3h6UVhpwf4POUMB0xetOa4YMmeLYZT3HC1imgz63x
 9Mdts9mDjmvcEvRmI+Ry6oNvpUF2Xyd0Ne15QtY0K+Qwac/9WE2PG4St7Cd2BJDasTRJIgyGV
 AjJqGkT4EdtsDzY6pIoIss7bV4Q/sp5QNl25oEx8+WGnXe0tj76CTvluWm43yuGbz5mqIV4wQ
 YoQRVdJmT4JTwrf0ztfKkFViLJv/dNz12wQRowQFa3asgclFbQDEnChFT5eHcgE6kwlMQzDAQ
 /vd3uPzEQDqlGC9XRj7x7s6Nx832Fb/1Zwev/TWS1uv01FHNKLAu095jLVkb1VqZqNSsyt3B+
 qvYFVldPZARuzQnY6mVH+XTmNVXn1g0Z1y7dAYtXDvOMBDqlDftBbXqCCVrBcUQrs4D3rkQUn
 sjZNXcpAEgvoBpOS7yjzJoS0YhCl6rs7S+/L2XGgP2wDmm0n6n0m2NM27Bw2kjgJKNG0A2inG
 9bkRZ/XmOItrz5soR+Bo75Voz/PEvagQYMaSUZGjktAN0Cp0z6/xjEbomb7GvjX5IlgSat9te
 Z3L4YJraawMWy78YVzWD5U1XufAj6LFIpCKqzCsDqLPNaU5Xteu8QlZv3Brj4p5dOHCQF2ZJX
 2z00QjUea3Myi36uCQr8a5rXAAznv2wDjFAmi5c6FMEI+Lsu/IkWb3EgMgguuejXLlApPgTem
 kFalp3NGZjs26X8c5ttpvCMBF6fh3BtfvP86yFCFTvZ3jXSTE5fD1t/hU4Ezc6XaGK6enkfNp
 xp0/SCa1BgJClGDjWsqH5zSGVNBO9rWbZvbKIsBWRiJ3be+PS2XvfmSb6KJo9zt7DxmG7zgWc
 AkRMdHhA9bA3bd4c4mtcDmwi9Go0pL7+nO4up24DYWZyY4fzl77i5p4r6G3TcnLgH8HwwDuBN
 mCxHpxaJApbC7AUV2vLERJT1iMWXPG8P1T8i9/9HaQ0NJbDGjQWVSUiez/1wWQacW3hdKYdq0
 XQw6CO7KXC3x5hvQfTcrCW7czH/qtt2o/Sc540lHVeoKdeHE+eB8RYEMlx9p7vlLafWlPnjUI
 cm9BMQok+lrwBtw5sLUvSWT5xADfyz0OWULd6CxD98Y/JbvpkZaWKjkWmoDovKHLKzI6UiJSj
 yb9+V57X18MtPqd5MYgJZsSSzeAKj0D4RFg/f6zPmB+eD7RHb4o1vm5vcirjawnFjLm5WZ+ur
 K/kXMWevIp7r3k0x72fhLyYElSN+FK7Ks+dfURVCDCriOSR+JbUKZz3QLoyFjAYqWY6DvdSWl
 vhZKwuD7oKGIaQhj0MpR6iuXFxqRO1s3Atpd6UQAHoovFpGWV6mwuBpWszPr61JUN0ftFYtsB
 sdZjsW+L/qJgyxxoYMI/rD4Er9XyqwqJOo58dYCjwD39/cSnP6+/FUB5w29sBMIqV+AoaHHE1
 Ww1RskybhIR2198ud2jXFf3jhSXyGCRXJ17CjyVOpb+2HD5ZZ6shu5Bqr9yeKl4110L5UHt7X
 ysLZi1UCr4DuvviTnXtrRB1mpqHTTfXfiVVY1dILNk+WVb1aCcADRSNmc1rFM5rjVolcXaY3I
 uxX+Dx2DW43YIGkPTO+txJCx+kptxmfEpDVx3tQrMuWUi8rJp9bd11RM9bP5UxIimDvsTFVrg
 vcC/TXO+7E7knJsviRutGhzgaV6/qwk+suAanBiEP7EAZQzkpmuNDokAQJDLMH3epygV5plit
 rcv+iCQ5HN2o0xWifMv5SCtf1AsTPsdwqSuNTjsRY0lc6poZlvFk64XlnD9abyNk//OIgV2RZ
 YeiIo5rvBmo5EMKYRryhpqjp+ukkXEaZL4u06iNW1ZyywRu7BaOZi8CkCHjvHKxZQzxNgp/IA
 cEbP8985NiwHnDcQvLFgl3YGs/M0Y43CAwMf0S7I1Hklgh7PusaI2qKohXjK/XuwTkifenT4q
 mjnuivfFWaFiyVGfeUMNccw/Fsu9wvVmuAvWgM/OOVKvIY4Cv/MhaNz0v5ofMrKSEvE4x/V+p
 cArJKHt/6U2mKboy2dw9LROfviB1Uf6NNhTc9Xsxlvyd5AfWxYAapIzSceoXkYYyLtjF/9jLW
 KaXvMxQqrbSCCQhFZYrVNcgSb44dDiEp9cv85R1YRrDF1LI8Uijx+o93A5MY9+32vnOOFS2Tk
 WHdxGTF3LEFGUoPBicGXQtNPJUt2gm+ILdLS9mj/5cxJ3t8bnGoQhdd/CBoYP4G3UpUcPR37g
 MQ0SHYLRbUmTqz5V+nqmajIVhuWGeqvvcqUYAriGF5Fc5LyHX9y8icyPgRH9mm2lEaOY6ZGlk
 MBdr5MByZmZhs6uYnrFrfPJBw84vccAs9J4krpQoUhI8o4Ajn4ivZX1VwgNK7pQGLL+5EjfZe
 2zZ0YmhHXi9CI9Mw6nNew38s1sn2EqRPe9BPn/2ZztLvHf96p6odD7fvbM2G0UVRsY/8BzyCd
 c0tTD2NpA9lwX6XVUJQdOUVOeEgQSa2QmyqyvCptV5cgQ67TwxRhPbh0I2VHx3XfUOg2g5n50
 PwuaApQV9+269+DmjRYozrJBC6N6hkqT9ZyrUmZlGIEoQAWnFlP1JgwBvd55ZEibBy53C58oB
 7q30thYF2AUEF+GFjsB6ppiEdjPGEm8jOgRB/8LBT0lxzX52vFy8R7CuKGjZyKazmZngQ5m5K
 rMMxu8T+qs8Fdcvcy18hFoYx48X7ZS+jXmBOHmsQAJmfOfjZDN0qJKw+LDxrTrOnuFDZFAlQl
 oqmZkOjEz95FjvTkiL5krMCXro5Nzv5xxU4LH4fDn5R3SqU8l7JQR3XKDVmLkzOxvJc8+ejiI
 irbNlv+ZKtX/En8nYiehSnu1Urf2SwAid30dVp/67ZeK501QUdRLbyogj/f01dHfTUBChqK9C
 r2D6iJRnVOD2wdHXJ7QILuJq+iw4ntDms7us4uoET1dqnYgR6C0/LW1NBQGQvcM6Q6XJtzCWd
 Lm0lnys9JrhchWlQv4H5fDszFiICH9lqTxB3b6P2k1/+R5e5FG2dm7FrSwY7nzieWAHS8rVEX
 v30fLMm52O+HQTPjUSiYXOHl/NyTa08W6CtKfSAlRMoX/8SKMLJhdN18qqdaAHymPqIjO2W/I
 6FnjcJDHwmJALc+iVeyN1Y2HGlbEgJLzmioQh2aHG5PxLOU6h6bzX/Pp3ky9nv2RgSKX+oOIR
 BT+R5JtaS/LCg3SdKU21pgAj6r82VQoW5gvAENaVw7gIF0cHjSKHlFhF6DzE4fwV4p3X1CVMj
 zUWsIITmZ50NNT+vnQw9BWjXoBKqChQcrDBFZFxmM0a8gLSveaBxNLS+B0wPvkzQqHdcJXXQQ
 sgbKgsZiN7mqLforSoJ3PlM3Vrs4pT4N3Bu68WyiINN590xOA46Vwq+dQB67nocFB+MdFlMYI
 mbteIBUpUs=

Just a quick reminder, in linux next-20260909 this has not been
fixed, yet.

Bert Karwatzki
