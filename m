Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804612;
	b=AhcIyhAVJCPlFQ+uGhu2t2NSK0v0vwxwKOzVeMst+A9jkKd104td64ZRa6CnSJPVUflS
	 6chd/QS1GhQyJ7In6yuZXYFhYdZDuHRQWENQbx9A+J6ztV7AXK8i9GeSDKPQAublLZc7l
	 S8eJfWVxyvWcO5kCpPDUngm/SEcy6Zs6UBRVOr3atkQd+Si8pV5hXwRJyhwhUvRp2YGHG
	 6yJxfTX1y7AK2Knr8UiXD1GCbrlrRqR75Sb/yp9IlCMW9VKVi9Tck970Y+M/yKW5d/oyY
	 qUa6tVJ+jnScQTqqGdHD3Y8y7WDBQavovNRm8KUO7BCF3whjsAMoKkPhsaCW4N1elRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jcuK5iLQbBpoNUcGNqmSkFEid/wes9Tw0xAICnEgk2I=;
	b=luth+v9R9WxmFeNCi0R6TfFeJKFj1M0/2FW3IiSMLEbkm4fESPjIsmA2UawVNNZgr10e
	 xWVKljxxbA95nZkAE6NNXJbghKXq0JXgTrH0ScFpPoZXSj8sxdIa2FFhJ68I+u52sXpw5
	 JKqZhK8uZyqkaNarftvpNI5vqi64TufGAiqZqWv5NZis1bAuppb6V3tbcdFHX6GNctZNS
	 Ek9fcIsnegXoNPpJJwgxnd0tIIQrJ1G5J89R8Xs+78cJsX6cwNNDK4mQjws07/7SmkdiH
	 3AIA1I8EIE1G1Fn2uyJ5PGpEskwV3rRzyQVBxjy7Db1uKKIdRNrgET8GvktOhOB6fmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIrCEFfS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EDB606A329;
	Wed,  4 Nov 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIrCEFfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751941F0093A;
	Wed,  4 Nov 2026 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804612;
	bh=jcuK5iLQbBpoNUcGNqmSkFEid/wes9Tw0xAICnEgk2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIrCEFfSSC3DJJemsJ1SUXjXY8yUkE4yg9cD/telo2KbgxpiuDRXdHES6CKYP1E79
	 iVzm9jNzHBGXubcKZHtPPq3+0UbMb9HicYLdCLN5dA/fF7fYOGvcgvdZ/mUgv1sorK
	 i4EJUXUfvu3hJaqXkiZR8SW7sRmW3WJ9Xtwt1JEb1EaN2jQ6VWDWqTF28DXjfN5i6e
	 V0x0BoN1I7nS4jbhkT/jqTbJXghxAOLpUse0KcuWvNTg+2faSp1rlhEo8Qnj9EaWUG
	 VetEJVD0KvQ3LwCux4vlvTa0efI+5NV1N4UwCJmAcFghukrCbNvlGIYP6LXkfhSG3K
	 pPGzzumzC24+Q==
From: Sasha Levin <sashal@kernel.org>
To: Elliot Berman <elliotjb@elliotjb.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org,
	regressions@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ntfs3@lists.linux.dev,
	Tom Bereknyei <tomberek@gmail.com>,
	Kevin Fernandez <kevin@findhost.org>
Subject: Re: [PATCH 6.1.y 0/2] Fix NULL folio dereferences from IS_ERR() checks in 6.1.191
Date: Wed,  4 Nov 2026 10:03:13 -0500
Message-ID: <2026-11-04-1-daily-reply-0004-re-ext4-null-folio-61@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <auk775zR0FCl4L0X@hebergement-securise.com>
References: <auk775zR0FCl4L0X@hebergement-securise.com>
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

On 2026-11-03, Kevin Fernandez <kevin@findhost.org> wrote:
> Is the series needed on 6.1.y at all?

Yes. Elliot's two patches are queued for 6.1 and fix this oops, so it will be
fixed in the next 6.1.y release.

-- 
Thanks,
Sasha
