Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A86430CC8
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702097; cv=none; b=OL9hW4ieyWsAN+hC3z88wUDgqIfgd7c0Dkuu5lEajmvrcUbF3RKzhBXJyL9CSGd4LXCapY7W/IzkTruREyX2uswRv9N9vRaRlFOzT7QlsbGGG++korQKybsemY+KvO2cLOnZHeBZxcwUCOySFOLUqRYxGq3VN9C1GgSkts0HP9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702097; c=relaxed/simple;
	bh=qkO39kTKESEfFXo+oc5acBOMTcQZIDZa45HoU/dG6s4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ca21MCEhTPswZuVVZi7Kme1eY3pDGHKLDyTQ3XfzouVWAN/LB4OdKSXrHa6nNKDtB7Zmgillugtg86Iif9G+1FbNJ8dOQUc1NKkG6kl7AJ/gqWOsY3V5TZCVbnSNNg0gyhuwzSxm5aSKsgqzgxa1HV+rjFxOfEfyxJBGOtvFI3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UB50Ut4i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB50Ut4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A42A1F00A3D;
	Fri, 14 Aug 2026 10:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702085;
	bh=qkO39kTKESEfFXo+oc5acBOMTcQZIDZa45HoU/dG6s4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UB50Ut4i0a0YLxXGq+WBb7ix/yw6/+rWOqX1HQGp3pvaI+/wxVEx3vSajW153x6fS
	 sMngyu95HEwKLl3WqwtNeMJptaz8y1dtONcVMN+LKXmks0RUTPAKJBRfbah08W68OW
	 AudHuih2gAvuiKHpXHG9yWAlwO4ZaYhGxSZhf67pNSMXX0KeJss+L//DCvnHMuZ5Rg
	 P2V+/KNmpG2R4TOOr/gJXThlyj0Ie5+vNU9AsWIcruXFJNVWHGXIIx7iD+NmSKGJe2
	 MuEjX16FfP1BoOSIoZAzVHYUnVlO+CH92XZrBSfhn8DLF0Y3qoXbWQ9umaMu7aX9QH
	 h7ffqbLoRs0nQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 20/32] ext4: add block mapping tracepoints for
 iomap buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-21-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-21-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:08:05 +0000
Message-Id: <20260814100805.8A42A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add tracepoints for iomap buffered read, write, partial block zeroing,
> and writeback operations to help debug the iomap buffered I/O path.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D20

