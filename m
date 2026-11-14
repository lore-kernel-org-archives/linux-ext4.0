Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794677569;
	b=0ES0Ow0KjwzwFzUheOMezl6d5Idv22G/h9pA/7ma6Zfe8gqOjDEj4BMSEMLYVyO6Unqv
	 3kl+U4wiqxqUpAG0Mi1WT5jnxriCnmTNnlAN2r0kLOrh5KP0LGS35vLFjjiDhAnykXXMU
	 /IPmtti729lHZryq02DeAZBzQ7mrFHvbiI/R3Au727eUk6i/Xs5OLAz9BDGhhNL4FvLBA
	 5QmqWamGPUoIHHiMDHfLpNpvWQydDsJFyEykF3Fq/SVfAp13WmUKZkHjsPMSMk4lF3I9N
	 vYfSgxx0FdYbFmPxjuWTnFP61cwmmznp4OfhmfHvi014RQ6TKWJnInJ3geBMCXw9/jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794677569;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D2ZmexWZkQT4JkJHjKp5/yH52cEp+OP5RsfVKHm0+cw=;
	b=yHBTkVmZHwitd8KDukVPrM8TqDwZXnWwxNIEyKJMs8X31ve48Pirp0g2zULGkNFERSaN
	 k5weLVihMONVTH7AUEUYooGj/AtMDK+4skrcdbf69ul47Vb/L3Kuy2rs/o02RHbIAgLxo
	 Hd94bXV7zFHRGRD98xNttO14OqDCFf880U5qCrDOXNOzTsNwTcDoBd+ISK+2D2TkZv1Wy
	 fZvT+9slbxw5EWo//Kh1sLrIPYILyYl8P1SyNOD35/3zeZalWsJ6oFk6u/4a3E146O7l6
	 a0GY3SfgcWID9zUOAAY5/YVIoIEcKXthgRykbCJqOhLx87mw3+qVXoKbJsBUed+ipwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3P8Z2Aw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C9606A327
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3P8Z2Aw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F11C1F000C5;
	Sat, 14 Nov 2026 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677568;
	bh=D2ZmexWZkQT4JkJHjKp5/yH52cEp+OP5RsfVKHm0+cw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f3P8Z2AwA8codPBYNetw1HWvKaRrd0gJnxAvONq8vqBAWq3xR+3bgyI4msCdpnqXW
	 l5nVZAaQuoA6pQ7+ffmweCQL3sPfKXgMYvVAKhQwPWq/7epSN/oE5vnIexcvwRLWSg
	 XMd7yvB/8EAR3QJ1UWxJOkkX7dx7KXn9C5aHA5pqzDGrncRur/j3Cn6nW933lVpV/M
	 5JsGMAOtjoDA6qzEV4z3rDrOE6DAzIiO9dhPSu7KOXVHeeScUFhfkg8pA8Th+UtnvO
	 yvtBD/wflYJf+B+OEbcA0lPPn1BAgsXusiMh8wFsorxXsVhNhrpCfCffhpVl1in3IC
	 NCooLrcDaAllg==
Message-ID: <sashiko-outbox-214838@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: use a stable source for the kmmpd thread name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261114172523.5888-1-zhaogongyi@bytedance.com>
References: <20261114172523.5888-1-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 17:32:48 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A concurrent MMP mount can make kvasprintf() warn about different
> vsnprintf() return values while creating kmmpd. The call chain is
> ext4_multi_mount_protect() -> kthread_run() -> kvasprintf(): the name
> comes from mmp_bdevname in the MMP block buffer, which may change
> between the two formatting passes.
>=20
> Format the device name into a local buffer and use it for the thread
> name while retaining it in the MMP information field.
>=20
> Fixes: d6986ce24fc0 ("kthread: dynamically allocate memory to store kthre=
ad's full name")
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114172523.5888=
-1-zhaogongyi@bytedance.com?part=3D1

