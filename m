Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798917;
	b=ajuW9ljQmvy4AZu4Q+RbVdLJr5c1eUhlNdiy05AbbzQ35/0PuBkbMZ7i/GjnPNqIqMU+
	 29YbqHZAsqiKsMRbKnZ269x/Is/kVPDA7LDPkXzjWZPO1RzMZzWGPo9nQcSI22y/9hVeQ
	 qS2oxA43zzI9ApqPQnFA4ff3nOyZFBAyYo0E+0ZiHoW1HrLPYPdWziPSdnOccX5o2R/ni
	 eleBjWgJYePmO8KsgNrybo3ell63KnvHtVv5JHIvG4EpomWPdo816a7HxeIC3/sHctrSd
	 nwo/ffIg9avyhdLvjriwyRZp/Hbmcxmbw5KoOtVha6h/IQjpbc7uAeNIKcsSU7i5nvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=B3PU0DYkyYw1m9+DGPyM9r0Ea4Gx2mCDkHQSz3ft29w=;
	b=fwdqtIntFUjm4Q9X9tXvA4R80ESInfaiI8WTA1lOt0Eviv9XHqpVMn6vrtpwEyAIubMv
	 p4LGiQoctXpgi+bKG8gEW28NAv31YWchMqIUPwa0UnM6FzlrZoE438ahDNW5qUeZMt9Ym
	 V1nApxCzuqgBxSXI8frl6a2PMMN/foTxiy/Z2cLLD5VA1QX7fK9lsVL6WqPopQIS2TaqB
	 d+WtW6hqRBpBCTtuwE/VzB3WM5JXuUZuW2+k+3palGAQ1O7MGCp/5wyfKmIcO00rrUUz8
	 0QsK1S0fhF2/1EqdZGP6JP8LARkIgfncv6nLnO3+ygrOqTIAz3gOz+TTdlrqHJv6whg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKSUNXYB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA44606A335;
	Fri, 27 Nov 2026 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKSUNXYB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834601F0089B;
	Fri, 27 Nov 2026 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795798916;
	bh=B3PU0DYkyYw1m9+DGPyM9r0Ea4Gx2mCDkHQSz3ft29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKSUNXYBlUStBSI5fvJFpyVNbRGQ3oL2IpKTfdaft3cHuBaGVfinlhl4XRSIoKOOm
	 THjAkqDGA+eFsWne1OrgmQRJP5O7rU3zUkdFyoDKEHmPV2SDzcLch07D+iLb+Dzear
	 5k+yVSQ202mUXQVsth1z7S4JJJ/+ujBNXkGMAdinTzQjEyNM3TYb22z9CqXuCaCE4e
	 yohlQtDVA52QZ2wKMceZbHN9KBBffTKFkme+He+nTQiC7PnMna1rLU2WVjHPz9Q5eG
	 TPH0hPZuye0mKdePpPoDn8qDjWLCIUoO1JKyEeRROX/MHhstNvKYNQKkPYxgUvymuT
	 MgbJOf1wl8rHA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	Alireza Haghdoost <haghdoost@uber.com>
Subject: Re: [PATCH 6.18.y 0/2] ext4: fix transaction overflow during writeback
Date: Fri, 27 Nov 2026 12:01:01 -0500
Message-ID: <2026-11-26-1-daily-reply-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CA+w=M=R3eux80Cz3-ObXzQODAq-Pukj8R9gqG+zfCNqB5Wv+Yw@mail.gmail.com>
References: <CA+w=M=R3eux80Cz3-ObXzQODAq-Pukj8R9gqG+zfCNqB5Wv+Yw@mail.gmail.com>
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

> The two backports follow as replies. 46e8e31771f4 applies cleanly.
> 25b2a7e8d420 needs two small adjustments, also noted in patch 1/2:

The two patches never reached the list, so I took both from mainline
for 6.18, with the same move_extent.c adjustment you describe
(block_len_in_page as the new alloc_extents argument).

Queued for 6.18, thanks.

-- 
Thanks,
Sasha
