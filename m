Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257274;
	b=2DspxKZa3N1wSD1uiwXjbE/lXVaFVgqAGUchUf8hWmOt+rO0ctf//Fh+FkR/WrpenfPM
	 tuym2hBHeR4QrLptO2aOJk69XKjfbw/3/k7BDrbBJSqFxuoQSjpncis2TWr0Sgv4BiFN/
	 GH/ju9WSX1KMi4Aq2S+y6Jv3gwpe7gs7mFJPThi7xJpQHxY/8chjCZd60S6oBr1TZ9zMG
	 Wf/jfRkH8kRLkpYh9sbS40SahElo5Xc9xpvNscvWT38kZX4mWC5+mrcsz/oEPtQ4wNpxV
	 p7InPXuIw9WFR7o8M51jGWwWjJWE4GpAg0PZ0so2o05WxyYbuQLKE1egQVoTUloD2zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257274;
	h=DMARC-Filter:DKIM-Signature:Received:MIME-Version:Date:From:To:Cc:
	 Subject:In-Reply-To:References:User-Agent:Message-ID:X-Sender:
	 Content-Type:Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=Qjc3lND2Szj+ZbTboPnK/vG9bXC4WbRqnD1x9RUtNhU=;
	b=MR7XC1sL4AKaIqE6eHNbbzsiHqwWmjNRgQ7XIvkvva7CReepKARQYm86XcXxXJG81luo
	 YppJSCUDEdQb8mPQVF5ApCaj4l6EW49DmIxhZZm704uD6BpOA0u63DzIMmf6vcH6BgELd
	 SeRj48Khb91Vap0p/ZyEmD5RxxjANIcNZzTFdCTC9j6x0WVZYIP/WzD9XIrVcPQHkyu50
	 AFT/9Q9m0eUxwVzxWUYI5NRG0tTY4hlw33GJbv7QNC2pMshJz9pELpjxf3w5Zy7KgzHF/
	 4nTTD4LZeAqX9go4j5XZMMXxhz5S2yfmWeOjyREf9QT6//jHRgXD0fsdYVoSoUvqCug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=mpG5CXlN;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A3D606A321;
	Mon,  9 Nov 2026 20:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0A3D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=mpG5CXlN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=Qjc3lND2Szj+ZbTboPnK/vG9bXC4WbRqnD1x9RUtNhU=; b=mpG5CXlNlPYFghudAsxPbpQbhu
	pZ5GpX195PfyZU6zwJ6KgrFHVBQF6c+n198g/P2cqQtXWngP/N2UZKbT9X5eQCLcrUcTUtb4xn/+i
	nW/jN3Dr0hOhIpNsX8zyXz1zuG5U0z9uLPkOkWXCEJpRQCBWsszSg7x9kKeAdGmWY+VnvzRpPdknh
	Z3lBLXE4riqv24BSRCAv611VqjSK7y8lBC9cRXewdv/k4jJiv1RofEzjXCNHJPLNwhrRlYtEPfHWH
	OMOC+l4wKsjbu2h2whj2C83inIlw3bgxCkPq4W34IGT5VcenhqQbVv5hZ+ereRJ/+pTxxGPfPN0hZ
	XUZLyNZA==;
Received: from [::1] (port=46436 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xQWHQ-0000000DrgI-1qSY;
	Mon, 09 Nov 2026 21:47:52 +0100
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 09 Nov 2026 21:47:51 +0100
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li
 <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh
 Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix OOB write in fast-commit replay
In-Reply-To: <idqh5j5m3rhjsdu77h7dchk5vxj47fcsls7tcdhu4wdf75cthu@sxwipa7u2hyl>
References: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <idqh5j5m3rhjsdu77h7dchk5vxj47fcsls7tcdhu4wdf75cthu@sxwipa7u2hyl>
User-Agent: Roundcube Webmail/1.6.20
Message-ID: <038be9b9541cbcc43ed35cf7950b9361@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-11-09 14:19, Jan Kara wrote:
> On Sun 08-11-26 20:43:46, Jérémy Jean wrote:
>> Fast-commit recovery checks record bounds and lengths during scan.
>> Replay reads the records again without these checks. A corrupt 
>> filesystem
>> can make an earlier replay operation overwrite a later record. Its new
> 
> This fact looks like the real problem. I think we should validate the
> replay does not corrupt the journal. How does this happen? Otherwise we
> have to fully redo the validation of each record done in
> ext4_fc_replay_scan().

The replay can corrupt the journal because a corrupted image can make
metadata blocks used during replay overlap with fast-commit blocks. I
agree that making sure that replay does not corrupt the journal would
be a stronger fix, but I'm not sure I see a simple way to fix this
properly. Rechecking bounds as I proposed fixes a memory issue but it
indeed does not address the root cause.

Regards,
Jérémy
