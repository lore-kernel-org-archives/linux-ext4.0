Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719106;
	b=cRi3szcoD+nsuqMLqDQIC/u7sAzKjlWDO2PHxTVLRls/A7kUGq/ndCRiNCkRNapD+zaT
	 PUznP7WAQty+x/1LkomlF2bAsgC/Z5mImKiov0JXpY7hif//SF/PhFd4f2Ie5z31eukd0
	 w8ApB32VZmjYyBjxdc5S7yiyfMP4da27ekIupsN8tWENAeGh202cqoWPqp7+x+NQcvTiC
	 gQPgsDQJnbzIgD/VpuLU/Tok41W2B0uIAdnPpLmQos4Q/iRXMXLQZDlr4gwWISl9DZ7nR
	 qe+BtMspTo4DbyWurVDN2/h2VyCqIlzENdRsp9RCBC10Bey459VX+TYtzIo4GPMVFJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719106;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TWqkS1sJ4J8AwXzUcvlzgctqPmM6b2lbcq1mti3FIH8=;
	b=NPYhJHPY9DTP8hhBCUmnTD2Px3TAGYbyddT247LBtDiNiXYxWltoMdVAae4n8CRtUsSH
	 1mRxMem68sxgjzDuKsBH9ooZoeh2diI/jh+A4DR/Kq1Jz0amJN0xaBYJJlNxn/Ip/ogQl
	 ksBxfTBLNS0YieEPd+Obdvm1JLQvBZLFdioRIjF7sG2oeQlGSYneLkOUmgKOTwdYI6TZG
	 pc2m16ltm2lhZa/1+Jy728CeW7+SINQApf+soVs3i45galkfkmp1QteevltpiOdI1BY7Z
	 vg2fPupBvSmvTNBffqWYjqAVSg3GYUbu/6blywmKCg+K+xljVQQPMF3UhM9bPfQsjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QW0wK+9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A880606B27E;
	Tue,  3 Nov 2026 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QW0wK+9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DDE1F00A02;
	Tue,  3 Nov 2026 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719105;
	bh=TWqkS1sJ4J8AwXzUcvlzgctqPmM6b2lbcq1mti3FIH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QW0wK+9Y1KwBPZU7ppzTMvKuZjZxuXlhpn3SCQkaBJrmEUyVUdnE0iNshxwlgWwb4
	 ElXh6hlb6aUOZ3Ou8PzTVbMD0zRv9e2OJ1ipj8atTY+9KG1zfBr5oCoLkcX0qHjvT+
	 qKp5fcTxYxy+nUqS+gFuk16CXsPXTIziLXEz5bZ+3EHQ3oIq9tx1nXVvQIwjvFk/lb
	 P3Yx//zLB1yLXUbZPEpGBZAJwU7vchbgq5u9OgQAgzW5BDfOMIa9ON8O9xKP9zM4Bv
	 aW9hYzFanu821D/9cq+XEiKabPecbwU0KXXmiBxRuv87/QHzN3gJX3EAnwpcmMtNGn
	 TLa56w1fkY8rw==
Message-ID: <sashiko-outbox-195581@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 01/23] nubus: let procfs own the seq_file of the
 resource files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, tytso@mit.edu, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-drivers-v1-1-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-1-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Get the inode from the file instead of ->private, declare the show
> function and let procfs open and free the seq_file.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D1

