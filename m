Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243471;
	b=D4MfcM/xFdapDe2t5srCRz308eD4zPErXnf8GtkOsiJQsQEPc3nIgSHf0L/ZStQWBOkg
	 7X7jql09lkmRNpZdXvxef/6nflTVmlDztkhN5nEyCK3lehbY39yxsQU7wJ9irx26GH6zQ
	 ly99aylBx6ImF0O1GxaoyqoIAlF5QOZumfjheZCR+dd/CQfIlEOoGf97NdnVsLKwLHZjF
	 0Xw+DVvWdb7MfYNfGI3Qa3eU5L6FrxInICNKZ0zohivMq5zfNAXwX8fWNmQYXXFgJeGHJ
	 ahVJ9kp+u8JVkhQDaWGFioJkixQKsfaetcw1mgLvLDw0Js+bwGChNTqzr0z4m5cqnaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243471;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VA73D6RUVVD6d76RFWcAFsW0jty3owWKWIpY5JGsBww=;
	b=NDxp4y95ATE3qILlocSHoxcF4R6/YLkoGbnUPBAWARfLwQbQTDKhfP0EgoFjfW6QCsOa
	 i4ELmq1lu2bBAmTBfl7njCylx6JxqAsRdr3xCjuy0okkt0Pse7WuI/2K2ih/UwWZY3aeX
	 hB9/L6DYFsnsXh23xiPehuwFQbMjj/a0ZkxcAxzcjtUSrS4ukMy3ye8NfyBwUjG15xd2w
	 F+BUOJkQqUva7NGYljSZnTFZfNNSjUzqBCPbIJFkDAIAYCSqfm9EHLufSK5svNgnnk+9N
	 RsL4y7LLE5a8cVZJWhArdtF88geGYRo2dMsusuM7uqCE78ALGoY9CuAlzwry7UO5WbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i3MwS+Ph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF30606A33F
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i3MwS+Ph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438DD1F0089F;
	Mon,  9 Nov 2026 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243471;
	bh=VA73D6RUVVD6d76RFWcAFsW0jty3owWKWIpY5JGsBww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i3MwS+PhmIayku6A46pK0nVJlXI7UgzcpUcUUDAymhDKMJ2vXa1/moUEHEWg2zzaH
	 UFd/h98kPCy9F3Q/zxfRc3GAUIDAKMSvxFqzLVXZd6dq5ez4ksrgSujsrOGghFLImy
	 EFLqi54/K8y3Nxw25rjMKW6HLSb3fawAyYSgv64kuwjbkgA1KvKT2IE5RmY6FArM6F
	 4bentOy+sXEti4Ybw6KpnS4aEit0wh+vWpBFHmPz4iYXIWD2Uic+H+u6YPbZfWJ+fZ
	 099nGNINs++AKzMdAzPMnUcPLWoIdcg0YTlBu2+45sdQbeSCXCg8nJY1KIumtfEcOt
	 cWNJ/CqQOMerA==
Message-ID: <sashiko-outbox-205255@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 01/14] ext2: add ext2_inode_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-1-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-1-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 16:57:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the inode table block that holds an inode out of
> ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
> use it to find the block without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D1

