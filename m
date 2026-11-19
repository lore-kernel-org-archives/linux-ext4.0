Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099685;
	b=ExwkrPt3X1nzOCeJ2dE9iYkV45o4junigVeqGgsVE6Yqqr8s2HCIRaZ5xvrV6iuM+Gge
	 sHcw8R48tBPQeqCFoJkvuZhitdKryKLYRKUlKUHgYsNMDxfgYtNz5PuM4iATboNYNXba+
	 K0t7JnhwseYKg/1bSEI9BzdNmxB/hUYx2rFbzHzzvmtOKgIT/yWEbKMb++FaeSbvu2pqk
	 Y1SKLS+wSofOjdOS9u1fckBMc9Nf7GVs/T3yaeOxHsoI/xNDIkbbvf5vhlXj+1yQe7H1I
	 q0K2GveHW9Sa0FFiPkjVcTXBYVBbDrJCmYhz9eFd0G2bB2Of2X1Uzu9plxZusk1xswg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099685;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=6HBvvlIub12wrSr52ZlJQDUQHfx6B9c7JQjlNcoZPgk=;
	b=CXlpf/qsuFnTIeADLFooGUNVl/644p/EPzAYBJPHDwFqrxkuI4w0bL9P2ESVFAB35p7f
	 mFDWERmHUda99abbjXmSto8pl2KkH6SO6UTxmkWSWcKnIVnXzXGolngU8W/n0hSUB59hn
	 FEvwtiu97VvRl4w1ZrACrY2YUjturX+QPhs7xo2yGyyqfPjommBOWo7bXag0zlLSaThWk
	 Kp3ZDPOGT0m9hnLWaEenNr/aO4Y8LYsjQ0uk0sT0FTuSWhlvc0h+lAMPHkU/Ao//AjLV8
	 WBRfg7Wc6xOMqK2GA+Xqfb7HJppiuogorzieuVB3oivoLBNCbbRl9e/2URrlHa36E9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="aNvEM7/W";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACD760A2619
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ACD760A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=aNvEM7/W
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfSP018223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099664; bh=6HBvvlIub12wrSr52ZlJQDUQHfx6B9c7JQjlNcoZPgk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=aNvEM7/WCycX4QKbTcA1DaaI6Mf21EFld8dhfYgMCqJHKmAbZOLiSzQbIS35lm8s6
	 qew5iE9JnIPX8iV2q0S59LgC+Hi6AcuAPm56IaGApuHk50Q1Oj837jtcTe4kKHY96u
	 R6/W6erKGjIKdMRleMEu43/uZJ3hH3S7C7jRWCOno8ldiOD9PtJ/jbTnO4Ld4h91xk
	 izYiEPehsr1b2KwOrU+3YQ3qAWtEZxIJATlMxKXWKgLl6kV0QB9fhKn/KO74q52jch
	 zIDfl3SpCwcG8X1sgwoGmG6ZDC/etl4043Dto0+bDp/+su73qnB7W+pF8Kvhfr+Msz
	 PDsUi4Lud+akQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 65C862E0197; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz,
        adilger.kernel@dilger.ca, Jiaming Zhang <r772577952@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, libaokun@linux.alibaba.com,
        linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, stable@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH v2] ext4: clear in-inode xattr space before adding the first xattr
Date: Thu, 19 Nov 2026 09:47:20 -0500
Message-ID: <179509948712.1938961.7903640953071741786.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021085635.3633692-1-r772577952@gmail.com>
References: <20261021085635.3633692-1-r772577952@gmail.com>
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
Content-Transfer-Encoding: 8bit


On Wed, 21 Oct 2026 16:56:35 +0800, Jiaming Zhang wrote:
> An inode can hold extended attributes in the space that follows its extra
> fields, whose size is given by i_extra_isize.  When ext4 loads an inode,
> ext4_iget_extra_inode() validates that space only if it starts with the
> xattr magic, and only then sets EXT4_STATE_XATTR.  Without the magic, the
> space is treated as empty and is not checked.
> 
> ext4_xattr_ibody_set() passes the space to ext4_xattr_set_entry() whether
> or not EXT4_STATE_XATTR is set.  ext4_xattr_set_entry() walks the entries
> there to find min_offs, the lowest value offset.  That offset decides
> whether the new value fits and where the value is copied:
> 
> [...]

Applied, thanks!

[1/1] ext4: clear in-inode xattr space before adding the first xattr
      commit: ab7d0fdc084fa3812613378af181fcc047c81beb

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
