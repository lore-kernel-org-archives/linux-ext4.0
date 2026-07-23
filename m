Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C81E19ABC6
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812150; cv=none; b=MoUgOFnxniaOsImsJV/WyzlV8VcZ3Wqm+c82AMKgTk9PijGZpYmBZ2O4GaQQ6pdYn4cetmTzA1EKuPkR9V6Xy2CQ+4DsSWs54LNE/OqoYcUvdLvjAh4oo7zFw3V1E0uE12RaQPc04NmjIaxZBfx9Hk4/9EL/zycdtiWdCZHxxug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812150; c=relaxed/simple;
	bh=0b6c0LoCPz87LYB6NrsgxSFwMVqj5Muy1nHiPOY/WHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f/Na/slYtM9OG2fUkvFCLZlO9uAQ5Qb8WvVXJ902QP/r1dJoH4Gxw7O3p2EcYSImEvdMfToMTW8ddOF8XF7/QQFn325ZMRdNNpWgC32pb5nwB8SsEwXWtUKaxMJKYHJjh0NwEL4PGpAvVVqeGb/5dnY7soAyc9WEOh4oW/47i5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=I9qXwXNd; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="I9qXwXNd"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND92Lv017882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812144; bh=8KR3Drlv0gWQ/tFjIBnHfEw0ZqdvvAHr75SJISJAumQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=I9qXwXNduFCWo5/rJGhyQ01zbi4JneKclDBT/Un/LA7JWQHrUL+CGbF9HkxrF4UYm
	 WUVHmiCeaciIVKnt8o3pOFwvc4B0drIFttdz5rOWizkP4XH6eK3N6/EiWB5omU/nIB
	 KMwdqgfeQ1DjM+dD6xFs9C2fO2JstVOJbjKjb9VqewnlVzokSVGJ3mbTCCvgR2pOjy
	 xrGsMGcQKQirQTW7irxav4aqgQyicW+pRA1Oamm94mejgfPqOnhc6wtANrFBw4LczX
	 NhxfNDS3FnuSKK/LF+OHHVlJVviBTFZLZ/mTSNzRJyNajcD3xzEe2j6rCWAmDqTerA
	 UU/TYyiOnFhHg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id B7B492E3F19; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, dardaoe <dardaoe@proton.me>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: linux-doc@vger.kernel.org
Date: Thu, 23 Jul 2026 09:08:41 -0400
Message-ID: <178481171737.796182.11536080923580598143.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <F6-Nv2DhZIxD7g0KzZFf36UXOLn6D8qTlOQQFjIuQb_GyiQtoEQCvvRzDKnpYeSrd_E9H_DQYygw1zBDzlR2KxqqGsmYjODQr2qmRdjuixw=@proton.me>
References: <F6-Nv2DhZIxD7g0KzZFf36UXOLn6D8qTlOQQFjIuQb_GyiQtoEQCvvRzDKnpYeSrd_E9H_DQYygw1zBDzlR2KxqqGsmYjODQr2qmRdjuixw=@proton.me>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 26 Jun 2026 21:09:09 +0000, dardaoe wrote:
> Documentation/filesystems/ext4/group_descr.rst contains a slightly inaccuratedescription of the meta_bg layout.
> 
> The current text says:
>     "Note that in the meta_bg case, however, the first and last two block
>      groups within the larger meta group contain only group descriptors for
>      the groups inside the meta group."
> 
> [...]

Applied, thanks!

[1/1] linux-doc@vger.kernel.org
      commit: 91949729befb819c8748f9bd75c74ad5696dc090

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
