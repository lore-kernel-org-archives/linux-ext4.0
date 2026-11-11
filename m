Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402567;
	b=B3MTKGKevS7IsoQoNTn6hZZtu0iz+9eYiNChuyW39rKcN5OoVrE3DuEhCCuxvg+3iGW2
	 W1/8PUnSZqXvopXepn4tv4puzbUKqNO+RwVJS7IsTDm+OoXbhKG/dT1ip1+KhT9XgzffV
	 6UXolNd+jBr2+jhuv20ZMCcI5v7umZu3qrJEgTRhxM9lO5YNoWvhM8H50WlKnP8J2wdZm
	 4nq2563VmJDUtKAu4quUaC7n1c6f6nBjEAuiRCKsHnT/2H+jgqfwBEmQbELOaIXbl5DbU
	 N3L0vowTlvgqcRVlQonGlX9evXHhp4J37gkSQMWz7hT8tT0xRXBZLEc07X+gTbJ4P4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402567;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7WQPXmMCdL/oSBc98xllPkC6U8Vj2IfeiZRXGopSSM4=;
	b=flKq10VbN2OAAy3+mZ70F1Bw/Iiz1zUPWDLkWKHAdmt7nqD3ttMdOPiiCSJG1amyIR1b
	 jXp8T5tspx60IbPupbgXiVVAsaFJWhgfn4mnnfWrOTPtB3HOy58qMyt5xY5mhv6xrxFw2
	 zOm7Dx2e2ZeyPiq6khKZQx3bLbnrvJVgdKG4eFyoZqAu1DQHdzv4dS90xMH0+uTp2J/WG
	 XZCFyHjF3nouxVUSx+7aZr2aSB4CNs937Koqx+HctRnBj+Hg+4aOyifItzGjHC4fwhmdX
	 InJ6Qw1ilriZgihGqIJ1nDTBSDxsxKbZwKAH6JzuyJednBsZdV/dP6wbs4Qku2a0FNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJnBExhB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3208606A33F
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJnBExhB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB8F1F00A07;
	Wed, 11 Nov 2026 13:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402566;
	bh=7WQPXmMCdL/oSBc98xllPkC6U8Vj2IfeiZRXGopSSM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GJnBExhBKc0WkZ85VMmZzsFGWM8VONqjg7ZGeYkzc3ZeAWX3dTD02hFF1oZL9PO6l
	 jRmrOIJk1POsKSKBQ8DtHjAZnWod+jTBVBZdiMmMqJai8FYOJkozKjA2+CLBmqkU26
	 KPWRdu3Nk+49D+IrmuRmh5YcW0on2X5i+kUx66hXnl+cEe6e1TJ4RDp8Ity3KqtFqi
	 16wmFi+fBeqAy+Xbs/hlgKnlflGGJcPzffTZ5V3GeLSYL0J5S8i0iF9bxv0BrvkdPL
	 9cgb6a9TNyT7HGelZ0qRkVwn6qoIEifGUnzCq3//YNVRT6l4Tayz3WoyPA/AWHjGGd
	 ZvfnBNGADOkoA==
Message-ID: <sashiko-outbox-209045@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] ext4: store creation time in separate seconds and
 nanoseconds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Max Kellermann" <max.kellermann@ionos.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261111125242.1078620-4-max.kellermann@ionos.com>
References: <20261111125242.1078620-1-max.kellermann@ionos.com>
 <20261111125242.1078620-4-max.kellermann@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:09:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Keep 64-bit seconds and 32-bit nanoseconds and place the latter next
> to i_raw_lock. Preserve the existing on-disk encoding and timestamp
> range while saving 8 bytes per inode without fast commit.
>=20
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111125242.1078=
620-1-max.kellermann@ionos.com?part=3D3

