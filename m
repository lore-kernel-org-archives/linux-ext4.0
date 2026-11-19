Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795091682;
	b=wMpx3QCemtJNqMs4dR0f/JLCAhTlBV60UAvaG+hgiC/LnXS5ZAiVttcOFJzJBIkRWoGT
	 vdkLD9p271TJi6WNevPUgvZzWwbFJsZUHqwVi3Sa8qNcucISGK7htuzXcnZLjaUJHwnAF
	 NVXyS/Y2UiZvdUPlabNegbQxbD2kqmtZANtUGMl60eUxSJoZhPWWlAL/ZtS5ERpYuylkq
	 OQuMZ1CXfgJApC8TQ991aMElKQ7zLYKwV7JRdttsVy18cJoqWuE45vNATQiP8liX5qVhf
	 zJrGZ3oUOMmJmSWJ7rlJoyH89pvMWVc7WO2xJSu5QRvjpnMNisqh68u31Uwb1MuzB2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795091682;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H+bPiMbkW0u7q7XpkuiXj26KQeSkKFQhGKAo5KsI+Tw=;
	b=ETI7Z7rs9Rx7vK+fN+/Q+XVCjQ3TaehByF9SQOBtP6zsLWebHEMNqc9nEMFR63Lgpkl3
	 3KZ5lyKErNt0GxGat3elA5ALP0IZSU5QZ0iEhJ0/6AyYfU0vWXaFenB7B2F9It99LKZwE
	 88lfsZjAKI6WVlkufaL8GWBxh7hV240q56tYlmOzrkGIMtZnXShDR4pnDX3e71zUVraRz
	 HBdKmyudYKbvsl437lrGdYpJx1WfbbfebQtY3mQNGwtP97bVNH8N1P4wwWFb6NOzYnuif
	 OBM/167vLvwQ3V7it9G8dwIh9qdykxHTkcEVzidCdXJgpf82uEfrjCqRyWOrEhwpq4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtCUr9uD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D2D606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtCUr9uD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830F91F000C4;
	Thu, 19 Nov 2026 12:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795091681;
	bh=H+bPiMbkW0u7q7XpkuiXj26KQeSkKFQhGKAo5KsI+Tw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NtCUr9uDJfVk/7KdSaHjnC/nF5dx/LCqNW7x8ATEL4T5dpAOjq97WJ7mqsLfPTVAr
	 b7yMJDv7JfnSEnCApOIYqVMBbKxNno3uuc0F9Fb5iuAiSaA1f3nf0biyTuwby4RMYq
	 Su7nsRhhpY8jGY6QVRQW3kTsUyB85fGBiAD/JL9AWeUnzJIE7gm9PWlERzDFJZcs7c
	 Qx7suoIuY7Tn7XUCFwdzAEQK9vrDzKa9DNsQ69nRr/Qpv1eGp3/z4U0wOsNCbtnkuU
	 NvZEbFiRwbcamauGvWB6e1EJCVjmAPgR4o09c5EduBp0Lk6M2c/+7o9tTK2vJOFeg3
	 g1uMRhqydM0/A==
Message-ID: <sashiko-outbox-223094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] jbd2: add a metadata validation hook to journal
 recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261119122601.85293-2-zhaogongyi@bytedance.com>
References: <20261119122601.85293-1-zhaogongyi@bytedance.com>
 <20261119122601.85293-2-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 12:34:41 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119122601.8529=
3-1-zhaogongyi@bytedance.com?part=3D1

