Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B942ECE9B;
	Sun,  1 Mar 2026 01:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329204; cv=none; b=tZxbc+Qq/T9rv5y/8GqErNaJlc3bJKQbwP/9CUxL/NUwglMW0F26j4gcXBp/PLki7Ao/YA2E+rdc4yzgq2LkzC2Nb6eg4Vtbq8epgyVh1uHtzqOoRQ459cikvrK+vhdcK4EDn1GRVLY+0UVhpU+NoFfMqlwqoWi51cdwV+WpYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329204; c=relaxed/simple;
	bh=ODrn3M6Jr3beV7a2aRS3xw2ATsVSATCbZsZgBhqyZaM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=eD1uuZFkIxpc5ggN0kqmNgZqlhv6ubGyb3gWMALAfSEogg9tTcDj5mhKH1us5Ps/R88azatNycSZggSdVfAMgfGvPrDsUJjDDbgy/I0WDQz8xPYL0Q/2hwZoFpTR/GD5Zla9IyKFTPXedfOBRjbuUeH67zAxq5p+9Jn6NKeueA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=zKDS3vo9; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="zKDS3vo9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1772329196; bh=Kbc74/8gkbupiUo832K7qBuj+rh3bGkNGf90fmBXdAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKDS3vo9d+ElUSf3FvaNfqpykgEZElAXJySsbsLChLazwH+ox5zhFhwE9R+dXWiIn
	 9/EaLS9eQNVrtSQQoJ+nLNVxfJPv9F+Wer9wmAmokH6RtzLedoN13/Usj/AKC1e9ZA
	 dQbKpXdOSTY3MfPEYpPU/xdr3B7iorT1xLZ2xKjg=
Received: from 192.168.2.102 ([120.235.196.245])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 9AE004FF; Sun, 01 Mar 2026 09:38:46 +0800
X-QQ-mid: xmsmtpt1772329126tn0w72dmp
Message-ID: <tencent_7F28D03F5012FE947083C5B3B2D613D93007@qq.com>
X-QQ-XMAILINFO: Mpk1SqVBRfAQZwZp5kLZF2RS7aeghlKlU4UpKfAnjDb5J/fZJNyHCdKujGGHib
	 Rb7mkUpTphek/qkFrsXJDn0IzeV4xWBdGJsPg1grkLFBRJ/bq+TWS1Mjci69aGdfg8Hk2+AuaIt2
	 9wsLdaBayAZDFSW2AIubiN6EmyoA7j0137RZWKIO3yEL/Dbl93d11/GDJcY9j1vTBeok7iykNVjL
	 A86R3HIClEKoj9eccp5FfZ1rrJjCW9XNjDyxbDxO7rf1+b8W0LsYwaP8NQlM3sq1H0ofSL+27UVn
	 b3wfP6xstUgmys63mujtkkYMW/3/VMvJdKu4S3o6iVBV7PoCHeQlw3KFQcMYCoAZBsGxr3pQJlR2
	 Gv0wRvPJSi+sfCDIZ6lgzrSxM64rjBytC4FWL2nBz4vU0xPAP7FchChSDX09RmiYBXWbT4mxRbWf
	 rAj7Cu96MNsZCC20q0RUNZcVtkdua/GOvXxjpnxWfYlzzbIvkQ+5DuxYPRrH/n/BbypKtQKk6gYL
	 RBjarOdMOxiip1NVvh0MCNq0oHeJXk00GUFvhtuxjUB0WX+VRlRP7nRR1fPK+epE1fmEvfwA3/tY
	 FHzZVR9lh5I6Hm++eh2yzYIy8L3foibS4TwUECBuBkaMc6QW7XKNlW7m8J47EBar1x7fkHwAulJM
	 hIyDlurg1ul527gX2CWwZmbwQISFRxk5RcSFecta9HhTd3g0dw2+bEgE9ng4gTdYDUB2Lzh8QjDZ
	 TIFiIBVffMU0vT0xNVO6novL6XlCNzmq9o16E0Zonuz4BuY0LpFj/OxHEg/M4vMQX/+m95Gw+ovB
	 fbIk20p3D2oWinnRvo5P06YtPklOGT9USg6qkuKsmZnreUj7moOANrSnU1Jq9zb7aJSyV08l3TVb
	 IzlerPdK2bEkkLbzcUL+mSCFumkvTEdZosjz3PkPDQaLsbzTPTZHwSQG/BVavx0omIr421Xgysgj
	 oS+OaGLTPfH1tyxElLSHNAinjSoJNkQYRhQf7HbANvuJOLrZJCihvYhGPk+wnd1fvRpu/neNpzna
	 5mrs6WeGm9hX23SMkjWbK3wupo1Tz0QVhvaPs2fpO/cHkIoEtoZtNrNUvTFBvSindbp2PNyzXBxo
	 +LPRXPew3KCPhnoRR8jGpRXUnptELTStqBCXVKMv77nMmq5jTgcuu1jo1Ym2R76X5z/HQOis3v92
	 RgpNE=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Weixie Cui <523516579@qq.com>
To: 523516579@qq.com
Cc: adilger@dilger.ca,
	cuiweixie@gmail.com,
	dilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ext4: simplify mballoc preallocation size rounding for small files
Date: Sun,  1 Mar 2026 09:38:46 +0800
X-OQ-MSGID: <20260301013846.74244-1-523516579@qq.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <tencent_E9C5F1B2E9939B3037501FD04A7E9CF0C407@qq.com>
References: <tencent_E9C5F1B2E9939B3037501FD04A7E9CF0C407@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

@adilger I think you do not review this new patch because it's send from my other email.  
my previously patch is send from cuiweixie@gmail.com. But 523516579@qq.com is my other email. 
So can you help to review it?

