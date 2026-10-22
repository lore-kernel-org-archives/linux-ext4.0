Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639065;
	b=v977MnYxDXmM+FG9QKrGX5Ma6JId7N9oZ4qcpTjazwIoDzv0R4zgJXiymApSLV0qwYqz
	 L6pHwsUaEHDD9fzHNWRSmbNLwVxt3HktBgfNQoCZQ8W01C+a3L+lSpCVkDWjERdYokr98
	 zd3NmqqyPAoXD8ZuKdxYnKCFAO24ZZ881WMztVQJLvbJFFr+WmM8w96bQ4P2VntjuSz18
	 iPsq+FxqdooqlMRaStYOSqrpiFla8ultzbvbA/c0HJjZ8NEqU6k/dS0rnQncnvWCpBEEq
	 M/AXdZFWSUAmrfXP6hJ2WjLIcatdu9LSsECyiqSuz2Dm0ZzKuzHkxxrTQ1RvDvFDhVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639065;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XP4LnVbteu57Kyi4BdTk9SSv8JM1TTsQT7lRbcaPnno=;
	b=lfc2/NFRF0lYk5I+67DJNAKQ7exCYR9u4K2KJRN55PRS5PWsoSWi1rZMZTtG5YX/3AHT
	 eComiLteNlsV/oyv1u8jXMn9wEPFqTkYX5xd2ZMzaTScGM8Ap1Sr7KXecL49CNEaR/WIz
	 RbeYCRCWxEsdT1D9+NNZ+Q4qOGw6iKV77bxWiSTwFYN2IkOCcRmDxUZ0WvwdYAN7QRojy
	 vLWcYmUQ//73GaatH2n1+NLsDIUbOKwl5nrL5ehDeRUTTbauZZC5fVaU5bUYggjWzW/eM
	 acaQAH83uxpXBWYc0L9xAp781JWj/sd60hZwcYVyteafwH7uU3eutg/FAkccXuY2Yow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4qURIr1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E22C60A4AFB;
	Thu, 22 Oct 2026 03:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4qURIr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E1E1F000C5;
	Thu, 22 Oct 2026 03:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639065;
	bh=XP4LnVbteu57Kyi4BdTk9SSv8JM1TTsQT7lRbcaPnno=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j4qURIr1GRbxcJLsGG1v8s99dok6KgoxbnD9UfNUqAWHAzbQCO1kcRvACpITR7L8h
	 vO52YKn5bdGi53VUdipS0GS4atrGON+tcygmooxbyJQOYcqQtYXf52Gc/rd6PQiJ2P
	 yqnCMZNzD7V4z6oH8UMnvNE6YwAqYJBQAj+/DEyMoJ+FC5ZKsziWPQ3Z16Ix1AV2qA
	 +ChNU0nVkHdx53aXIWJPqtGU2QY4Tkdn//aDkj2VwzXVSXIuM/QMeZAmbaWzIz52C2
	 u5R/Hy3ypsWL0eGdCxcjE+h2sEjw+LDPPDVAloeQcI48H5C1rewYl+D7wvhDMmVWPj
	 DaDZDGHB6r4Ug==
Message-ID: <sashiko-outbox-180921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 20/41] groups: add getgroups_r() and
 setgroups_r()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <f96af98f97ff569f2556381499da586646273c3d.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <f96af98f97ff569f2556381499da586646273c3d.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Supplementary groups as arrays of __kernel_gid_r_t, so they can include
> UUID and GUID groups. Unlike the set*id_r() calls, "no id" is not
> accepted in the list. getgroups() reports such groups as the overflow
> gid.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D20

