Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E926A41B362
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 01:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856178; cv=none; b=UGs+RMGHYnTw0/wYB07fI2cCGy/AwoVXq1OC/mnCrDoJGdhGNKksq4XwnZWHfEWoeQ7doMAPKd1nStDmLdLLpjPlaFosldKspJLXdyDawACfEPqkoqF02hYGTsjolMY71jowS3YMfm8LQ/T2kLj8QwDrFGmOISm4OC3JqXzTpCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856178; c=relaxed/simple;
	bh=yVrVHiL3JGAcxKPmDZTlEiAQcZWBwXSBfCSy+HXosRI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CchmdMdKYvY9+oqlGXwac2vvGsjvSHQvh/Qggi97PE397gsfMXQOorNr/MZ6wAXbDCpYkUGxf6n+0yQiod7b/nwmumSB69JssNOeum01FDa2QEQG8OuJm3Wl4XqqwZqxnPL+B5g7MN2KWhBNTO/T1O+kAo5oOFERXQL8Rgqh3rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTbXsfvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTbXsfvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D631F00898;
	Tue, 13 Oct 2026 01:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791856177;
	bh=a0EvBcjQjWQg3O8ULXC1GLC5v5tchp/VUs8yN3Ghw74=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hTbXsfvSGUFrtGtwa/SHKUd+lWE/yKjHEum89/+4mDprEzxzkYy54odjNkMb+MW4b
	 deZuAIRJh6CiIZPlsuT+KgQT7xMWRj7xd/BWiqbSlaFpIUCfYMepaI4VzfRXGUwMFr
	 hUpBK0SCloj4kb1+qVZXEFaFkOmKY3Qs0q/XHTLJb5uQu7Kod/7wcxqWdXOb38wTr6
	 sPd1OKhsK0vTEe1+2M9dDbDo7ax7ogI0Y+asRN4XDnFRFOeCDW7iyE+1MjxXKkYlUX
	 S/PIvwjLE2wspKX3IVFy1kR52aGGbrtVRmgqYXS7XsCPgoNMi0fVeLOL20jg0qnYPW
	 j5/dNEaW3801w==
Message-ID: <sashiko-outbox-168843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] jbd2: check return value of blkdev_issue_flush()
 for async commits
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013014028.1152277-4-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-4-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 01:49:37 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When asynchronous commits are enabled, jbd2_commit_transaction()
> calls blkdev_issue_flush() on the journal device to make the commit
> record permanent.  However the return value is ignored so if the
> flush fails, the transaction is considered committed although the
> commit record may have never reached the disk.  Abort the journal
> when the flush fails, as we already do when waiting for the commit
> record fails.
>=20
> Fixes: f73bee49855f ("jbd2: Modify ASYNC_COMMIT code to not rely on queue=
 draining on barrier")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013014028.1152=
277-1-guolingxing@tju.edu.cn?part=3D3

