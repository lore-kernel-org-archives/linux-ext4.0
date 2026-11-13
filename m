Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554908;
	b=kWwImVVq0SLhAc726rLPFS3lScSLBNxdsnRW1X63CreEcuRyESdC0mZ2L/xyfZjgHbGZ
	 7cB7GQfxRU/Qe9U3CLxqOb9LWIAQtsxzpKfBmrdRHGMa6p6oZt4olGBY2V1BsPN7kIZis
	 5zQKLFeqiFAmPYCQzkBUnzhjpKHnQl6svdfMmCUi5YtoLGNZbxZO9yC7jW+FJnJC7CYgp
	 w36biz7bzODgdRMV0wxQOPL47GQ9b4zGwQvT/+biv9RAgpplXrSQFVMj5L0QcOJYs3vFl
	 fMmmi0nAppt89S/boFxKTdQrY6Xit04j+4UQPGPRbEcKD1d1y4jy0ULQ+PK+gcDRLmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554908;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/3Dt68gX+2smueLMVZ+hG5GjqXN4NOBsl+vEefgb44Q=;
	b=hZdNY1Dbzi0lY/U8g7oV+tEu9tRcGEtWU7eaTZBb/WWZ+b95PnD7bEhqiz6Ui4P/WZRo
	 UxbZauJ5UIz5l7ms5SWVRvYltEkI+C12qqjOGFCmI83VEsoQcXU+LDSDHQ+RilYqt8mZf
	 jsXRWOS/zivdF09pcCwRJTyZZCCJGTjEe3BvxmBKzZgrwMZ+sp0qDiOBkaZH+F+FPDikj
	 Snl3fSZ2suJ6A0wfSPLQ9pZxV84mHhpI243xPH8kamKNM1WMJQqaNN3Aem1U/n3QbQqKY
	 ezCmePwbKqlsaqWyUMtyJWB9uh1+COZZO8stxiJleCqpUa01M5p2D/sle/KUX3WwEhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nLIPSk/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD94606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nLIPSk/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55651F000C4;
	Fri, 13 Nov 2026 07:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554908;
	bh=/3Dt68gX+2smueLMVZ+hG5GjqXN4NOBsl+vEefgb44Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nLIPSk/skF2AqWmLFJsympZMRl0Sohgqmlozo0cNworPjtSlyyR556zGYcqpaWwKT
	 pMPt0RQWvv5jmJMcuLtlBJex7WLQmEskYFOyxDXRFwPIdRCou3KMxMDpzMS1wzL7Cx
	 VM2K0BolzFiUeSWDBIF1NGIfCfJoP7btVcJFaSe+hoJnTFSZFaXoAxlPea8rHG/b6r
	 uERwYEfIrlMSTwagftX0VlrJAPcRepYsongTnM0SErJqp0Vig/quRKJJYjmQA/hT/h
	 XNsLVGCjLSDCi33nhz77t3B8pWIJCWb0wKooLfBwB55YVotkbInSBQQa9yUuHQcXVc
	 HK9hOMs+vtMUw==
Message-ID: <sashiko-outbox-212349@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 3/8] iomap: don't ask for a buffered fallback for
 dma-buf iterators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-4-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-4-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:28:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>=20
> -ENOTBLK tells the caller to retry with buffered I/O.  A dma-buf iterator
> has no pages to copy, so the callers refuse that fallback, which would
> turn the error into a successful transfer of zero bytes.
>=20
> Report the reason instead: a busy folio becomes -EAGAIN, which the caller
> can retry, any other invalidation failure keeps its error code, and
> -ENOTBLK from ->iomap_begin() becomes -EOPNOTSUPP when nothing was
> transferred.  A partial direct I/O still reports its progress.  Both
> branches are reachable only through a file that opted into dma-buf I/O,
> which ext4 does in the last patch.
>=20
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D3

