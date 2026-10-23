Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792737075;
	b=T1zYonmEo8Xpabr5VK5318bCvxsBynjFE2Uvc6IsmJahUuwpc/AawdjSQ+TmGkwxrTTo
	 MRtmtQYyXISSfCkKH86k4xwMS2oZaljPl74VMCvWyzWpyhHG9+l2vVOk1rE+1BxbjA6Ej
	 rk/J6q9v9UfqctiQ+LhTOk2Yihy3Fip1xGesKA73JQbb76elgLTfqxzALqDxSZpZjSz4Q
	 8TftPbRamCRjBW/mKyR9YosSwf3n9ZcRl8Xa5VCDjKewnPLuLOvYxVpQhrpiBLkFXXOLC
	 meyp/uhJN3IPbFvGvuyCA9gZnI9dSk9wJ3o6GiMqus7M0x93YcQe0tfTFMN8fX0tyXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792737075;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mdqaCzUtv+fZ0GNpYnvzcLS9g7ZFSG1mGxE5wpbkS5A=;
	b=tRyfNsJYZFVVSnqmxKA2T5hZ7OWGh9XWrLn9x271F8aqIUT52FoyGGT5W+rn3xtI09FH
	 bO/rwaBUFO/06aPfPE0vvreXXvHR9w/JxeV6YBgdmtxJ6jOVxOe6e94JyCsPszNqR6nGN
	 FxSgLJcknuH9TS3J+/fYWXybPbISKA5GXMJPBuA3mZgRSCPcl3wFSbOzjj9CmjEia852Y
	 j/OG4NIcO4IZP47Lm5Qa4MqutSe5SiQq1evgUxVJsC6Vm32eKQbiS5eT0pQbOEwOLYrBI
	 LSql538/TuNlEolHlU5ta6cgjqaFnO1WLbu65auySn/ZtALEY7UgoWFZeF7LxRQfABQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVmZxEpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545EC606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVmZxEpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78061F01825;
	Fri, 23 Oct 2026 06:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792737074;
	bh=mdqaCzUtv+fZ0GNpYnvzcLS9g7ZFSG1mGxE5wpbkS5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lVmZxEpeufzSilfJjDqitWgFRju2Gqrax+EJAOM0Ebkraqr/P80NQkvFpzsXTp89l
	 8WPVZcDJUdUpXXiGj06l4KYw5NOdxhDoVwXZe1iRVaFYyQxsdHJiKX7AKo32lRn3GQ
	 CdLJbZyuuGMQNHF6ZbOJZpdxKSZ8tLIR23GiOxTGraZssL57jTY07gBAIhc49HMBbX
	 1HMEhqC8WNvSO6Zqb1ug8RXESSio3EdD5I02jeEHWzaaGxfd9yCk+BfQki7bvRN2T5
	 9X5qCOiZKF0Fj8XCsc6I/QJrcVK8qzJR+hpsOL+WFix4owm/hlA6dBgLVV7yUTWF3D
	 eoqgY/ibrgQQA==
Message-ID: <sashiko-outbox-182351@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/6] ext4: use atomic bitops for io_end flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261023061851.45579-7-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-7-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 06:31:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Before EXT4_IO_END_FAILED was added, the writeback thread set
> EXT4_IO_END_UNWRITTEN and final completion cleared it after the last
> io_end reference was dropped. Adding EXT4_IO_END_FAILED introduced a
> concurrent writer in failed-bio completion. Successful bio completions
> do not update the flags.
>=20
> An io_end can cover already-mapped folios submitted before a later
> unwritten extent is mapped. An earlier bio can fail while writeback
> first sets UNWRITTEN. The non-atomic updates can then lose a bit:
>=20
>   Bio completion                  Writeback thread
>   --------------                  ----------------
>   read flag =3D 0
>                                   attach reserved handle to io_end
>                                   flag |=3D UNWRITTEN
> [ ... ]
> Use atomic bit operations to fix the race.
>=20
> Fixes: e856f93e0fb2 ("ext4: do not convert the unwritten extents if data =
writeback fails")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023061851.4557=
9-1-sunjunchao@bytedance.com?part=3D6

