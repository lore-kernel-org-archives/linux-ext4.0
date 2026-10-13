Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31609384245
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 01:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856088; cv=none; b=Ni9O+4s1REGe6yoKMF4dG+GMKbpNfXTYPQ2tk7OAjgBRGTEojIu1RDFLdbhiC5r57RmK9+MLssaxO1x5qzpuXWpx46v2WRG1AzozAuHiOvUUoPicjI+xiJKrHjQRi7GxmaA+C/Y4Pgql0irCkc36lAlvkYd3Emky3wvxXwPG9jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856088; c=relaxed/simple;
	bh=+B/g10a+bYRYCreA574duaVK17RfWIvUH62Y9njXAxg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LoeO0nnCtaeulSzdTdV4av7Ah81zKq+Jvw4OtuZgIlOV6jCz9uTkLulCli7ubYH+dNb+yIYgHD3L1AQUNJFsH63eXCNCIpBxbOMvYjj9nNNMsRHDCs9ZPz9ANo5hiDufVhs06yi3P3NLKRg7gTQmgUPsgzU1tEQKfpFAdaGQCSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwzK7Dgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwzK7Dgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27BF1F00898;
	Tue, 13 Oct 2026 01:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791856087;
	bh=gml+Ok7cejuDepoUUojKw8tHuccsJAW1/jh7OM5MG8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PwzK7DgnRG6Jw7k+mGbbrW28u+TG+TKi1X6Y+kEHnZQUSXYX3abKBXv4P5S39yTBN
	 acB6O3Ct+tS5dkYlE8xa/xJnDPtSHWaAHUg5Vc5POr7Wupi+C4MXKbT5oLTD2KyGF0
	 rXE6Ji5xiIdwf4+WtG4lYhCNmAwVvTrBfJKF1EId+vq8U4FXZtoyeQF2Fw8nJjMT88
	 HhalLKU8ajcf/LafRmoHHzWOl/3B+3257kytELhtn8DQe0tOI+F/CGXfEIDMBOsXYM
	 CRFf9PDvrXV5VYyymBnxXKVpsaoEOnPI1df7RErOWEY4GFNdp+Ug7BLhQnQHli1wUq
	 JXuET1BZumISQ==
Message-ID: <sashiko-outbox-168841@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] jbd2: check return value of blkdev_issue_flush()
 when committing
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013014028.1152277-3-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-3-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 01:48:06 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013014028.1152=
277-1-guolingxing@tju.edu.cn?part=3D2

