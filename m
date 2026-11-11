Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.152.32.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794398982;
	b=Dxnya3KdSjwV7C71k/eRpOUl5ekaYpe0to5Vtv2znSm6eyRsjG7VmH3teasOAPdWEckc
	 2te/4QwHzn44Jlta5fFMLlX0jyfcR3qvL4MnPlP+m2hXI7QX9jx8+pVdvMTIEz7RBkEDA
	 vtMNYtFfrYRhq/uYSG5BVF0Vc62I2nW2xk33et7zSxmsu2ZdAbXO0u1tUCAeX+Sdj6sIX
	 3jBullG5pthmFgCVu5Nuxq6pg0Q1tTnxsVQLp0RwhKKI75OCHP5DMCml078nRpwvU+ErX
	 5h5ILjY1ixpQF/GXx03LlVcXuINm59+p3ilZ9dYgDBsFaHpOXkQTpzQq6xAd5tqPwPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794398982;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Virus-Scanned:
	 X-ESPOL;
	bh=RZ0xITXEUc1lpNXnnJOkSDf4WX3X09bzipLCgHiCBjI=;
	b=fbZkzXJ7dCBg4TbllvMq7Tvq5JZbix5wCACH0OCqA4Fgez04E82HyzS9bMDgcetg26C3
	 Dl+gKtKmwa3lne3XysShbSuZ99OJtM6HOiucBJjtsQFQpGQDsTCydeqma8nh4Pvu2Raj0
	 DuYJU0gDJYZ0SH9KpIwR/YGUotoOJCJmHYII4TvwOlg1F8uOmgn2+uSCH5E3UY+rjeAl/
	 v+kc/QNQ7O5z6g8JBOvjoT2GU6e7dr7UMzyOWGueKH/2lUUQdWpdXNcD/I9yncO8sx78D
	 aD2YakR5fSS/mfi3iKy3HBuDKwKNAVytowMoTZQfpOLAUOQ5+6MP/mphpb3bR+LpcfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inbox.lv;
	spf=pass smtp.mailfrom=inbox.lv;
	dkim=pass header.d=inbox.lv header.i=@inbox.lv header.a=rsa-sha256 header.s=p20220324 header.b="y/t3vslx";
	arc=none smtp.remote-ip=194.152.32.89
Received: from new-shark9.inbox.lv (new-shark9.inbox.lv [194.152.32.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1603606A89F;
	Wed, 11 Nov 2026 12:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1603606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inbox.lv
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inbox.lv
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=inbox.lv header.i=@inbox.lv header.a=rsa-sha256 header.s=p20220324 header.b=y/t3vslx
Received: from shark2.inbox.lv (shark2 [10.0.1.82])
	by new-shark9.inbox.lv (Postfix) with ESMTP id 4jPj4g46q2zgZQQ;
	Wed, 11 Nov 2026 14:09:39 +0200 (EET)
Received: from shark2.inbox.lv (localhost [127.0.0.1])
	by shark2-out.inbox.lv (Postfix) with ESMTP id 4jPj4g3XBdz5vVq;
	Wed, 11 Nov 2026 14:09:39 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.lv;
	s=p20220324; t=1794398979; x=1794400779;
	bh=RZ0xITXEUc1lpNXnnJOkSDf4WX3X09bzipLCgHiCBjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:X-ESPOL:
	 From:Date:To:Cc:Message-ID:Subject:Reply-To;
	b=y/t3vslx/T111EMWetYPpN2Ro7jbLZKHty34sZ1wR8KkRxI5yz7Dj023GXEJSR/Rb
	 C/o2OiMXDdM+sQOIBF5wgBl0jYg+q4GZ1zG32nyRuV4GDfnpDPcOrZqeQVybMOhA1Q
	 pTaQOML7Ek4CjGFTnOtQyKN4hKnRRjlWTDdYy5d8=
Received: from shark2.inbox.lv (localhost [127.0.0.1])
	by shark2-in.inbox.lv (Postfix) with ESMTP id 4jPj4g36W1z5vPr;
	Wed, 11 Nov 2026 14:09:39 +0200 (EET)
Received: from shark2.inbox.lv ([127.0.0.1])
 by localhost (shark2.inbox.lv [127.0.0.1]) (spamfilter, port 35) with ESMTP
 id bZKrpRR7V56w; Wed, 11 Nov 2026 14:09:38 +0200 (EET)
Received: from mail.inbox.lv (pop2 [127.0.0.1])
	by shark2-in.inbox.lv (Postfix) with ESMTP id 4jPj4f4HJcz5vQZ;
	Wed, 11 Nov 2026 14:09:38 +0200 (EET)
From: Aleksandr Panfilenko <lexpasss@inbox.lv>
To: Matthew Wilcox <willy@infradead.org>
Cc: Aleksandr Panfilenko <lexpasss@inbox.lv>,
	linux-ext4@vger.kernel.org,
	tytso@mit.edu,
	adilger@dilger.ca,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] ext4: fix NULL pointer dereference in ext4_mb_load_buddy_gfp()
Date: Wed, 11 Nov 2026 15:09:33 +0300
Message-Id: <20261111120933.3299241-1-lexpasss@inbox.lv>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <avN0AsI3MM0XLyl0@casper.infradead.org>
References: <avN0AsI3MM0XLyl0@casper.infradead.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: OK
X-ESPOL: EZqEIBwB+wpLv9zHS4lo4f3gzsiwV0QhviPmvcM9qS0ZtK+jx9N0d2aRGIfrGgq/bg==

On Tue, Nov 10, 2026 at 07:44:02PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 10, 2026 at 10:37:10PM +0300, Aleksandr Panfilenko wrote:
> > We have hit a kernel NULL pointer dereference in ext4_mb_load_buddy_gfp()
>
> https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com/T/#t

Thanks for the pointer - we missed Elliot's series. Please disregard
our submission; it is superseded by his.

We reproduced the same bug on 6.1.192 (kernel-lt, AlmaLinux 9) and
re-tested Elliot's ext4 patch there (three write/drop_caches/write
cycles plus a small-files stress test, no oops).
