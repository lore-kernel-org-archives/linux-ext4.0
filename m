Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082002;
	b=MVmIYdkAtLISGn+f3p1CIggHcP9c9iHkPMvtOQm8wjMi28Ctla97tW1cFefs99LatJ7r
	 eWp3fSv4oDW/tqOZXYiyqMgWG3vWi/vW1giBGOmavDZVuHVvS6BcI4+6MNcXL6dji4K95
	 b98Yeni+3v0AnkCJur6xTozozejTFKrCCxddb1zAFUPDFPWsQQrwUfBg7NwD6GjFrkql2
	 9YXbwMf+GboNA2A2L5lNr9Au0omC4ji6MxrCits2r3zzreTXx/5UMiAAZFIIy1PLNMklw
	 WnET1K56JG1ZZq7XWGCck0wuylGn6ahdsefU8bESo8k7JRU8nRilAH+N7aFlbM+nUWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082002;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=QSSbECispc63tOyPbZxowme039vFxcSIl7UgBxySBIo=;
	b=afLkoxi+zv60ZWbcH1Z8iHuMDbsE6TNzGe5O7gG6iMnTS2vFPEEBRRgxL72K9LAj7/GD
	 4at15RpXrWNse2X2hTldcG91/8E91KSFxrYNFDjmp9/1rVvwIfOIx25MWIPycdq5fQetO
	 ZhofliPsLeZ0l8Mr4iT5KZRLwUU5tGnZLXidoz5dZzcVbWmB60pZgtYw69Nk3YZsZo3fS
	 XxzS+Bwt91uBC66zPbgesNpSRZQCjAEOcf7V2f5h6V3y5I6azx58KRQwDvzN2RP+BdqB2
	 S7lvrPXhHuHIAd4jEp6Mb6QoctnQaYHBwotaBRJyNp5RhKepvUTe7b5JVzeMTYI1NbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JW5z9/C9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866C3606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JW5z9/C9
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B01C1F000C7
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 09:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795082002;
	bh=QSSbECispc63tOyPbZxowme039vFxcSIl7UgBxySBIo=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=JW5z9/C9YLdqgSgAwg1vOijsA4y9/v2hjuQ7m6TeU5JHTuC/AbW+n3eE44bLhV8Ld
	 kKynP1oC1CXqWBjM/0Vz73TaZH2KgdkbTpcXogg5ao8pmbhw1IiPxKSocgtLrOk83N
	 zaSnEkykKk7ZWXitygB6Bbcnn9JcE/2P+GB6oOGinKYcnZPUsGfse0gyAXdqfacQp1
	 tE398JOD/gdw2o7bpAHAyW01abq+i/pUuzG6WJ57Bi8jjjZDh5uqbPXhdJ0v5PD8z5
	 hPPRG4QZVyWPYvMjC1L4toVfUBbydKjhGHYr7/gpGxpa8h7QD7HILtZDVOSrA0xNJm
	 QCroSjNydOYCA==
Received: by aws-us-west-2-korg-bugzilla-alma10-1.codeaurora.org (Postfix, from userid 48)
	id 27EF5240040D; Thu, 19 Nov 2026 09:53:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 222294] [REGRESSION] 6.1.191+: NULL deref in
 ext4_mb_load_buddy_gfp() after a3a7d360252c ("ext4: fix e4b bitmap
 inconsistency reports")
Date: Thu, 19 Nov 2026 09:53:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: internet.jejkowice@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-222294-13602-dbFjTXGtMo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222294-13602@https.bugzilla.kernel.org/>
References: <bug-222294-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D222294

--- Comment #1 from Dawid Partyka (internet.jejkowice@gmail.com) ---
Created attachment 311519
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D311519&action=3Dedit
.config

--=20
You are receiving this mail because:
You are watching the assignee of the bug.=
