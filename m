Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717530;
	b=nzhOi5U5bWleWERa7sd/4n7aaF5Fc1iLnyT1MmYTazDwJ5x+g8D88q0I9PcNPJDI0O/g
	 +ajzXK0gtwsptZqebsOAp4zxp7qRl2Q0wu6ekQJy9o97yT8/xXlR0GDothxHky67kVJgt
	 6ZrN+/k8yUaNK49hB2RGK4i600v3fveQ3Ft0dfDGWVTn5gpQDuuHDIcbhBEm//ma3ZJgU
	 5WdD6J5tNiaAbO0tQQ3CDfRaXK2mZiSBVHigy65YpiA974oSWBLRcVEJ3LnnwVrZOyTy6
	 mEdX4pMQDnotwQCRlTA1JRb3OW4lfVcNYjnjIA7Zat0Zr5/1q/RhjNydBADke5q6m2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LMyRWZC45eOWdRYTp9S1dshzyIL9S0ThqB/6dV7aMIQ=;
	b=RnwysnXosaW7eMnsD+P1LgQLp60zrlHbxWNZdyjaISxKl+A6G8k9FKPoXasquZutSxGK
	 pLJOvE/FA5/uIUuH+AlTd2s7+dJtbNx3niQpbqq3ib71HOEujhjfh936Sv2WXxsVgICx6
	 l9DhcIHMAyQde4jOMcvJO36C7fk/2RVkkF/3UN2FMP1st4LdJTtLCkh6VD95i+M2bwAcu
	 1ey4b1JIh0QhPb8Iy1xUsrLvplUj9ymRvr/htlG5kcdrvzxCk/PAOjz8FTdhX5yvwtyAC
	 qr7rlMGhAG1IEg5PeKgdBYSG78j6XytIj9/ljZgZkjgrWLuXxCMCb0tNmt6Nu8EYh7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iBQ8RpLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E9D606A789;
	Tue,  3 Nov 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iBQ8RpLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC91F000C1;
	Tue,  3 Nov 2026 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717530;
	bh=LMyRWZC45eOWdRYTp9S1dshzyIL9S0ThqB/6dV7aMIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBQ8RpLn+4J4/cEkXnFrVxpDoGHc63Kad8Kk1J4mNTWElKzbolQi90qtwjU2mDFvH
	 TqZWzYOq7/o3yWt5k1JYSeBfBHVQeEyKJPJmZRsFg2BCUkEjg9Nq80BtbaR01oj9Zt
	 0FLB0oAr4GBp0n6ha4+zy8Zj5/t6io1gBlDQkEzdIV0rPDq1Y3dBPiDD3Fu7y42Rv1
	 RmxW1EC5vFHOz9ZcAlgjUCSO3H6zRu1TfZ7OGY8aqOTFJ6tIsxxDkwmKd2jd+3gBbn
	 ZJg6QL7pthOcPFaQcraSrE2E6RD4FLpO2qsue8R1r9IZ6ttI10Q4VDVen/+vcWq9y1
	 bjAEa5FSDSt6Q==
From: Sasha Levin <sashal@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Jan Kara <jack@suse.cz>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	regressions@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ntfs3@lists.linux.dev,
	Tom Bereknyei <tomberek@gmail.com>,
	Elliot Berman <elliotjb@elliotjb.com>
Subject: Re: [PATCH 6.1.y 0/2] Fix NULL folio dereferences from IS_ERR() checks in 6.1.191
Date: Tue,  3 Nov 2026 09:51:49 -0500
Message-ID: <2026-11-03-1-daily-reply-0001-re-ext4-ntfs3-null-folio@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
References: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> We hit a kernel oops in 6.1.191 in ext4_mb_regular_allocator(), When
> ext4's s_buddy_cache pages are evicted, the next block allocation
> dereferences a NULL folio.

Queued the series for 6.1, thanks.

-- 
Thanks,
Sasha
