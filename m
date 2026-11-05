Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908666;
	b=IhSlLNY3wwiScyHprRHX7JWn3/AciO931zPnIPmaceYtyw/V3Yp+ya7mhbtHKzw7x78n
	 cvfpdlqX1O5xX4MTXhqR+ODp7gf6ZdBNC9I8BBKEMbUK13Eu82RYH4WXgznY1ZdNrw8Dr
	 eIciEFZMTXmYrzE+6rZdhUHuDh/ZHS6Si87kjZo5oiPvhlBJvZlpT2VQXgitz/0TTmtAy
	 rqrk5Qwd1HS6fyWAco+Y/vXqzIIMWyzwIoF5mPHBEm0H2bSLLq8xtmaHilgs9VjsSjWuK
	 Ud6fZXD93kmwiLXHsbAcPs8uIrOkwGfhIFH3QVDT+kYd7aUsrqEpq/UySHFebuwEtCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908666;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+0ZPlsJcgC8fQm/9DfIFcHmBgWnHYRqC6D/F0NL9Ypw=;
	b=SnBsxh8zlVB9GFaF3BC35Ei9LQhl//8jDmW3LNSljUoxBR4Yra0ZVMN78pSZmRhFuenn
	 xFtceB6Y3Ndpfc4bojtaMiH869Yb2KFNK235ROexni+2+67CEoB1O++j1rhN1jTTnBhSX
	 o7KOVnBNcc4SXonugPu7/I3JaPw70SsdHdcLcMWzKWFgA3COoojiRwDak91Gj2WZ38++Y
	 4cVBuXu3bKumCXIBdqyyNhdRkIKdYGlk9Z4ROGybgr1ymXjjbmOIjIp5qX+bbe7Ezt8x/
	 3w5gCR+DSrf5IxlviEKEnM6BWP5ynoMicjUGEqNlkUbsWh6TknwuWdyb2L3n23o2iVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGM3e2Tc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A64606A6EF;
	Thu,  5 Nov 2026 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGM3e2Tc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38B81F008A1;
	Thu,  5 Nov 2026 19:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908666;
	bh=+0ZPlsJcgC8fQm/9DfIFcHmBgWnHYRqC6D/F0NL9Ypw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YGM3e2TcuStLuMJuOG2RpRafGnpgCJEdfRcmM9LL5DdWr6N3sFR9a3Cfc0Q8vWg/s
	 7VB698L03F5heHclmvlh2MufWY99NNhAUYjKXdEiGZdV6X+rMeenhBy7Ncax/PeOXv
	 +jQhttB7U5sm2rhvXAlRk5w7p3OreWYgEQx2WyKancCJ/gZHmqLBJdFdi9GuGPN4jd
	 eqpqsHlDnGedCaSvvukFQmbjNkJJDTs5lSbSSTggahIpQ2vEt5UK+QSwAFzCOBXLrv
	 PSAijHaAKCWhRqAZ/JOy/skqMBdWpo9l9x8Q5hD3NgUxf6hpk67PJVMxTAcZg/PLNi
	 UfVCy6pgzZWrw==
Message-ID: <sashiko-outbox-200042@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 08/30] smb: client: let procfs own the
 seq_file of the smbdirect files
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
In-Reply-To: <20261104-work-procfs-fs-v2-8-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-8-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function in PROC_FILE_DEFINE() and let procfs open and
> free the seq_file. That makes the open functions unnecessary.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D8

