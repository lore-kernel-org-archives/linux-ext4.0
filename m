Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795725811;
	b=KMNYzNEQVZo9Q+nCKJOHB4NklvKCtLa8nqw1UUqGywEHmIy1xG+iQMk8uYOJpMgCh2nV
	 jQRs9RKq7GLpHM5fyzPUeKYf9ML5ttwVUlJUORkyNfer8Zo+4EFf5Gz2GfKSvNn7AIgUf
	 r3JCarwn2kyli1suG9DkG9ilV3keIEi3x7G+9zIGY98H2r8us2MNyBeg7aF/gxG80YNhD
	 bUrL0/EY6gmAnwpkG4E+33yfEYul+SM4A57Jjq4gOmhKjnUSZOaCus14+1umiJdTfflyB
	 tIcs93cfoo0eOZFvcoxpi8B3FqMIlxuKsar660VCRIamTMRvlzV2RIJTJ1OCc/Kc2Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795725811;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6imt2SrgRzeD7oghE9LskLBA9FtadbVfERa/w5jueE4=;
	b=rlGGPcDprCuIpixVNf9gVgubx9aTfwFwNKS81lznyS8R5iG/queQ9c9ecYDWHBok/n4R
	 b1OIkWAX+GxWrLgNLx3W3zOpeNBjX1OqFmo+FnUrOnlzE+mO235gauRE/jzKEM8Ys+P4a
	 GEC0rHrQ+JFQIN+Hq4pMSLYJsVctaFjxsWK8e6JvEODJvJf8MKYGuLNfMXUjY9sapcFLK
	 0Megm6s1ctIQTlY38aijpCByrA0kaxfQR3FLAyBnxqP3YNDs0GcUABc5EcopQi3AxDfAp
	 AdvELjgVWhyxEP3vBPAwuHNjwQ0TkXvBqIxW7tjleU8yw4rUuGSGDhIYiLu6HaJkYAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2Tn3cFJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BD6606A69D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2Tn3cFJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9700F1F000C1;
	Thu, 26 Nov 2026 20:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795725811;
	bh=6imt2SrgRzeD7oghE9LskLBA9FtadbVfERa/w5jueE4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l2Tn3cFJVpTXZAhOxqXcQOlWs5Dup1Sy2e1vJGYHYOxQXN7u32YudmqaftP0pONg1
	 u1xeeR7+TiSeT8Q1u8FSBGqJ3jjBuG4r7pIkSz7BcDpAPR+eQ6TVt+1KLxLWpMHu9N
	 mSxtXMczhkROIbpxZ4wr3scHVG+T/qDMFaqneA1Q+QYYUHgBIlK6k0uXa2uubjtFL2
	 T+BIVaZXFM5XvpifkRk1RLSRJ+wi43WoFEXC7vsn6XIXSTokc6TPmkqp6dvehfWdYZ
	 7FoCTbdE/ojZX4Fuui3rtOrPzuX+zofebUpmke5JHMA89aZC+EjByyrOVojqNzSgNB
	 QyH+c+Q4BvdIg==
Message-ID: <sashiko-outbox-236165@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 0/3] ext4: fix data loss in inline data conversion of
 regular files
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGV0ciBWYW7Em2s=?= <petr.vanek@e2b.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261126201258.1553196-1-petr.vanek@e2b.dev>
References: <20261126201258.1553196-1-petr.vanek@e2b.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 20:43:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 3-patch series:

- Patches 1 and 3: no issues found.
- Patch 2 ("ext4: convert regular file inline data through the p..."): 4
  potential issues (2 High, 2 Medium)

A detailed review has been sent as a separate reply to patch 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126201258.1553=
196-1-petr.vanek@e2b.dev
