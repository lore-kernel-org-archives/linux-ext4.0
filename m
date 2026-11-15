Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774469;
	b=1/CZAko842vuGcQs9hcVPyUR60MjxWwcMOGQ0bw5GGDxb/bObb8e+AvcbHwuNLSfkh1P
	 gCtQi0y2QLR+DAGllky9ULTb1YxLWMbl3HqVm7J5FpYFr6nqLgwLFxHiCtrH3ZlQ77z6t
	 uR/DN8E07P7qIhs496/2kjWup2YNOM7rlX2TJEzu7wwtgiBXPpMKqoUWyKG2oEmGN47l+
	 L/El065opD2PbkbOlZQ7CHg8oBN3zFCHq+NCVR0J8kiNKnI9v9t40KkGqq8jwu5nDmBSs
	 tFk+oHbQnGpKdNEPdVO4B39J4YJViE8/XNgzN6gke6XVTF04GfO8/alXxSpefN91CSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774469;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/EZ7ajjAPy+geL9jiheP5oyIpkFUIHATHBkEuv9sOHw=;
	b=zaOJeUZkoREjN3Eh+asPQliHeF45EwkJ76b1oO27OyjcPW+6ypxCr7UXSFX6To/d/qUB
	 JPIm257foTKBfvTzo3WXyQYwxgI6DD2NGCx08gRP66Z3m8b3OZ/IjLS70JANOFyTLW3dq
	 ddyH0AC8oz6nAsJxTk27md3eODp02uMUODo6zjFq0rO5aYyqIPlaczKtnMd/sVR9syI4p
	 EdvFSWM7OFmp2rrN2GOIsiHkr/9XqERr95GedTFJ7aFZv9T0yJm/h+72PkBfODsbLDzjM
	 r35NXc3sH0FO8xah4IVyGNGoMFPXipfTZP4fI3nZTul2GeN8TS1Tz8mgN1G985oHZxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uuh0Aogu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1939B606A8A8;
	Sun, 15 Nov 2026 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uuh0Aogu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9347D1F000C8;
	Sun, 15 Nov 2026 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774469;
	bh=/EZ7ajjAPy+geL9jiheP5oyIpkFUIHATHBkEuv9sOHw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uuh0AoguQi+gsuLvCdLF7RJnh4UYWICSB8mfSIkhzfBH3EimsET3WtL9qjkq2gPdI
	 CB459SLFdnxdBQwrufeU6hj8Z344r+lddFO0OD2IMh8PMGQRYU+rYsQpinA0ZFQzId
	 L2mYNdGZrfaNTbGLSIrOFjJf1qJE9M2kHK5xRpM3I2EIjRihz4BPjfVVNO3I6rtntc
	 CDDIJ+n9KhUGSBmJ50sAbNENMDTB9+Ujs9e28GLnuDYpXUyQxmjjYOxrWGS40blCrv
	 RhsZ3HsNCMi5/VzDF2t2SUz+m2d3DMwJJSv6OQZdymK/l9cVySiu8ar+Nr5C+DK9/O
	 hiizJIqK/DOJw==
Message-ID: <sashiko-outbox-215806@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/12] docs: ioctl-number: update SCSI entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-7-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-7-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:48 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where SCSI ioctls are defined and update the
> ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D6

