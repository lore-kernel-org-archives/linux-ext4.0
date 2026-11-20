Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143857;
	b=WqlZg3DAGT2vnMtbmTcpsFDWO6emw1F/OXiq73KaaExoGuWFCcUvL0Kujx3IEcWQy0TL
	 egCZQ1pFc1pSXGsb7w9PIgVsi7dIBGpunFEJH7oxZKaPmOOeus2qV2JZwmqJNOP9KFihY
	 Y7CqerTDzP/UsPkav7E4yoqaZSsIwgZUHzp/BvpnQxBa1VUbphJqlhEhX//S/2o0Yc7hR
	 sH1DU6pP5lH7M9HRAybT+kSI4gbnp9LQL8UxOatTKKSVNz8vafj39etqhGsLCykm26/jK
	 q2wpJpD9vMzL0O+sQvotSWvf1wQCWRsuBNqhaZGRyUQyLE5alKVhklmUDr2aBCy9HhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143857;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c/qOQTeSzQs/MvikvONJh73uZhWTKTnyNfPyYupTUZY=;
	b=ZBf8KKbHaHwoJJSJ+jVIwIBj5xT+/NKYX46pUinUuecm8bfCMzt3sFmosjyAsFIvVByc
	 GWr9Gn7RCZozfDSY49wU1CcCRv2pd28Evz8xrcwsEt/oCr2OEmB5DMQJNT56XjeZQqk5x
	 2q5A+45piRqE117lkXIBbSaPko78opuOsDZWbQH/wNzCHoj0JY928aXryIKk1VOhQhw4L
	 YazUD/WIGQmtrjHZfbFcMY4RReRPbxaPGh6aWXHD55D1IFSk7S94MPHQfG8OdWqPP4V2z
	 xqIwgvaja0wh1EMw3wwvliZyLfI+BtRzCUFMi02ylO+E9VJx6lJANV6BR6s/RT4iSSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1YEZkjv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60516606A320
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 03:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1YEZkjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24D91F000CA;
	Fri, 20 Nov 2026 03:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795143856;
	bh=c/qOQTeSzQs/MvikvONJh73uZhWTKTnyNfPyYupTUZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X1YEZkjvx7ipTgAnB+lcQxynYam1VeKIMhZOyBW/OT3qN6x0IT6EvrPv4ZU4JlPPY
	 2jpm3H67X0lO3guGM6Z2l5ap75EVHX5Ic5aDNSAVUSw7IxEoUnFbP9IR/OORUo6NZY
	 fOYumo87cjG8rI83botBzqDcAMfZG+rYO/PxOJeGgqph4cdt3UQE+W1+bq7XqiqRUb
	 +dZaemZijneF+JZXgVSbXyjzj6fXF1yEdwd5YVQgUp45V3XHXQUXvlT9CfkVE6cx7m
	 R+ScWfjWIylRhu0HGaGFDT6hxlvn/7cMmYtp/dIcL/PZy/NQ4g3Jsu3ogtRoA9IusA
	 4Nzf3iM+XxCzw==
Message-ID: <sashiko-outbox-224389@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] jbd2: add a metadata validation hook to journal
 recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261120025459.70290-2-zhaogongyi@bytedance.com>
References: <20261120025459.70290-2-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 03:04:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Filesystems can need to validate metadata that block replay has changed
> before fast commit replay consumes it. They can also need to check
> metadata that fast commit replay updates before completing recovery.
>=20
> Provide an optional callback after block replay, including when the
> journal is empty, and after fast commit replay. Propagate validation
> errors before resetting the journal. Keep the existing replay flow for
> callers of jbd2_journal_load().
>=20
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120025459.7029=
0-1-zhaogongyi@bytedance.com?part=3D1

