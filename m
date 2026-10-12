Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DD5438466
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807031; cv=none; b=M/F9mAMtCW29SV6fi7sk0Cxl6+uU5Y4f69xtEARYS479DFYVHsewthXrh/oac9TpcfyCn0mPwGR6ZtURCY7QxiY+bqHG3bPJ61x/2Bo047Owq9zrAXeRjTneATO7rM7VXd1tVrRaIqSYMcaELklxIJKnhujz2qi/q4xK31/qliY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807031; c=relaxed/simple;
	bh=QNZ0LWN9hM37U3nIAiOZxTCzsssj1cZzdJSlQnTDf2o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Kfgqqxzmw0Npy3GVUelNBmcx+DUpqNs6x4b4CLsFdhlN8knEGBRn555wM3vkLNitTmkF1yxoUvO/0/8CNDovTjvttuPWr8Ii7gUHJo1tqbBCGSjdM2m9djt4qdFCXVWzMN1lCFBzFCBDl4ZwK1pmU+b/GJVkcZ/Oy0c1iwI78JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHKSYo0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHKSYo0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064781F0089B;
	Mon, 12 Oct 2026 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791807030;
	bh=VjrqhsWuGbOBSJLlqYDeStlTVa9Uj/zp2mpOf48Bq0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QHKSYo0vbEbhQwc4Qi5uHzteQLvtOiCn202lwnT6o9dgtqbsY8vt6g8mdS9bthtpW
	 fWn6/ULAPjrg84GAjxyX6RpoET0Oq1brxT8hW6znfkV84JZQAL+9eHV87m9cNYnMgP
	 BPZZ6x0AxVPilL3r4p4IwyhzZKOnkotSm3fcJgzqXAKl1SLd6KEzfGUgPvHofU3mp+
	 etrLuloqNmcktdNwV2RCgVKcqFT3n3cv9+sgvfa5tY936kr13AJ3QeIJmJcBHuj+v4
	 AXTpOzNXtk3cAkf4XXQokq+qOT0UFgdbE2LetB4EQDsR6I291VtIl6f9F+Z6jDZiCG
	 imnk1R6SxwYKg==
Message-ID: <sashiko-outbox-168069@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] jbd2: check return value of blkdev_issue_flush()
 when committing
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012114713.4049391-2-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261012114713.4049391-2-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 12:10:29 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> For journals on a separate device, jbd2_commit_transaction() must
> flush the file system device before submitting the commit record,
> otherwise the transaction may get committed while the ordered data
> are still in the device cache.  However the return value of
> blkdev_issue_flush() is ignored so if the flush fails, the commit
> record is still submitted and fsync() reports success although the
> ordered data may have never reached the disk.  After a crash the
> journal recovery will consider such transactions committed and data
> written by fsync() may be lost.
>=20
> Abort the journal when the flush fails.  The commit record is then
> not submitted anymore since journal_submit_commit_record() checks
> for an aborted journal.
>=20
> Fixes: cc3e1bea5d87 ("ext4, jbd2: Add barriers for file systems with exer=
nal journals")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114713.4049=
391-1-guolingxing@tju.edu.cn?part=3D2

