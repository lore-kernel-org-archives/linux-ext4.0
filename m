Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715505;
	b=hdQbl6dSacdtQSHGeNemK+MppcbJxjF5GwcVMuPPZba1WPKwuLH5DqtObKaFRNjCdXdI
	 xKLRhZTO9BT867+2jvhV61W2TctaFpkIeFJRSelgYjn6n1Wj4Bx0XTbdoCeEQxgz6u+Bj
	 YyQPK4ByQady/PTkzY6Xwic1GnVk9FztVra4oSsWBsPOPNDT8fWQi3/iBJdmpZMWs71rK
	 5vNDmb3em/1eQjoT6EW0PPUhIw200yeVZtLK6caYL0Qs6P12/eq+/HGts4TO9tdT5LMim
	 Y1QxX5lMdL2tDzuKb9nklFYn57JPVlc/cgwpTmIy8SJnL5Y+Px1zMPig7M8tmvB1wEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715505;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HlffhiZySz6EOARuLYjj10jf8DDjQ0NXhw6o6mGyp/w=;
	b=zO4eLDox92CaKAAzqWmywwL6BZ+QUn+JHi41FPm5tThCKQD9BfQfGjWbkcLbcv1XJmEU
	 VvrkNFZDlWjiRf8NH+FNIWcD/be0z753XOPVFMjRPkywyleWEUWOAmJ3RCV2o2LHMEbE9
	 f9/wGtG6b/R4vG+lYXjSvYU6cwVT0a8VTbl8gGYy6b3A0gofEOlD/z87O1IxaYYk0nSrE
	 s9rh+oKKCeLKvf/ip+nXKQxjnHyZE1cgcfw0Gb2XpUwO0Es1/x5wvcI9KQa4P4P5noV+l
	 8ojUaSHqZNXdPBfNbi5BH5oFGogdsUw4eaRcCVUdbMiOLa6WgGUBJt8z4SIYbbqhbpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIBa9vE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19DE606A327
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIBa9vE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6FE1F00919;
	Tue,  3 Nov 2026 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715504;
	bh=HlffhiZySz6EOARuLYjj10jf8DDjQ0NXhw6o6mGyp/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LIBa9vE7zLChaUbtAEwIcoEJnJiGhf0jKQVTRCqiLarX7gn14YoLBbMcXMWuqzsiw
	 P3Wc4WFtqi26CH02p+WITUodMaLOXHTjpK297rHPhGSsj5qQNwXqzLGPFKy8P/bkcS
	 EPikXaokXtjUEa4uQnXDvP1pykZALNGBpb/wYwmaDONrf6qKWOLb4RkTcmEUaa6EXT
	 TL8PYhDJSLz9c7RHnik26Btm66Rgb5Y+iW/u1TUTuXCOl1X3DzkRFozIIerm0r3gSw
	 SD/A7Vq9PnKk3oiaaPT0EI60oha6hInjTtdpYRiWiQNnLqWU5zZjukmaCUUsI7SuFM
	 nuCglhpVSVMWA==
Message-ID: <sashiko-outbox-195434@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 06/12] ext4: refactor dx_root to support variable
 dirent sizes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-7-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-7-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:18:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: dx_get_dx_info() offset shifts after dotdot rec_len update
--

commit 73068d5241d832480befa7394ccb6a8830dc1e0f
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: refactor dx_root to support variable dirent sizes

This commit splits struct dx_root_info out of struct dx_root and introduces
ext4_dir_entry_len() and dx_get_dx_info() so that the htree root header can
follow variable-sized "." and ".." entries carrying dirdata.

[Severity: High]
In fs/ext4/namei.c, can the offset returned by dx_get_dx_info() shift after
make_indexed_dir() expands dotdot_de->rec_len to cover the rest of the bloc=
k?

When __ext4_add_entry() calls make_indexed_dir() on a full one-block
unindexed directory, make_indexed_dir() calls dx_get_dx_info(dir, dot_de) at
line 2323 while dotdot_de->rec_len still holds its small pre-conversion
length (for example, 12 bytes).

Inside dx_get_dx_info() at line 556, the end of the ".." entry is computed =
by
calling ext4_dir_entry_len(de, blocksize, NULL), which in turn calls
ext4_dirent_get_data_len(de, rec_len) in fs/ext4/ext4.h. In
ext4_dirent_get_data_len(), the dirdata header for ".." starts at offset 11
(EXT4_BASE_DIR_LEN + 2 + 1). If dotdot_de->file_type has a dirdata flag bit
set in ~EXT4_FT_MASK and byte 11 of dotdot_de (ddh_length) is 2 or greater,
the check ddh_len > rec_len - offset evaluates to true while rec_len is 12,
causing ext4_dirent_get_data_len() to return 0 instead of an error.

As a result, dx_get_dx_info() treats dotdot_de as a 12-byte entry with no
dirdata and places dx_info immediately after it (for example, at offset 24).
make_indexed_dir() then wipes the block starting from offset 24, leaving
dotdot_de intact, and at line 2362 updates dotdot_de->rec_len to cover the
remainder of the block (for example, 4084 bytes) before writing dx_info at
offset 24 and the root dx_entry array at offset 32.

Once dotdot_de->rec_len is expanded to 4084, the bounds check ddh_len <=3D
rec_len - 11 in ext4_dirent_get_data_len() now succeeds, so subsequent calls
to ext4_dir_entry_len() and dx_get_dx_info() (such as in dx_release() at li=
ne
2424 and dx_probe() at line 853, as well as dx_root_limit() and
get_dx_countlimit() in later patches of this series) see a non-zero dirdata
length and compute a shifted dx_root_info offset pointing into the dx_entry
array or fail with -EFSCORRUPTED.

Should make_indexed_dir() or ext4_check_dx_root() validate or clear any
inconsistent dirdata flags on "." and ".." before expanding dotdot_de->rec_=
len
so that dx_get_dx_info() computes the same offset before and after conversi=
on?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D6
