Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795158206;
	b=cmVArxvKwRYAXnw7pMh10pvNZrDbTWI6tTUej/gnUiR4Rg/tgc5gsz+wSP9aThOZG3NL
	 PJZ2hqRAhF9DBprRaarVSjKr7jo1x3rqUE4on/8BZEdnZvBrYFqa5d6WcfiddVj7e2+ZC
	 wu6ddcTKa8CHwsM67QKL7F4BwxX/JhaG2y8bKWLUX0zzVUSmpg3TMrnzC+exRj/jmfgJs
	 OB/HTqeoOZxeCH+fvAFn4/Ib5ZfqNgaR3ihmkt6mrMjfRfLWYci1TQgIv7a6ieeRu0la8
	 OTYv0SCrBxCKgyj9nWG7eEtgZ5yqTkbyWeDgOOoIEz4Y+vIO6B2rGBm8EYud5e+lj5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795158206;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=VFB86YOhZBmk4seGZnsJZoFfyiAxjLxMgBF1WsmMK2g=;
	b=a1aMaBIJkQgbKUhGVURiXbddu+nXiHy8sRykIIU6woJatw2NUdoE4vog3EXFszOc8QBx
	 2vfUJK+OcuFDqNbReOIkqu2WPTMv27H+WrNBzDP4gJOvDna/JJSbYw6CvEyO71dSNoWZ/
	 H09Y16MmiQcHi9XPWiEd8gaZnuffIXFp4SGbCXwMDBQkwuh3L+ZVor4BLuRJ7sA9IKXRC
	 G8DxrDi31+9wFuJlj7icuNtFk/vg3hDcKFgT4QCN2q45+MeGJfOhrnOEHXTQ4TDi4M8Sp
	 WLn8Og2odcYN/Ojb/ZhwePR3/wacW8af+H0IgBFK6DDzyEZ0kf86minhZh6ApT+LysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yw5ZJds2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FF7606A32A
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yw5ZJds2
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB92D1F000C4
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 07:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795158205;
	bh=VFB86YOhZBmk4seGZnsJZoFfyiAxjLxMgBF1WsmMK2g=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Yw5ZJds28evXWAj2mgCASbZF4NQiihs3V50bj/ONQtT+Rb27OzY/YagbC8HIQcS74
	 G7aNbEZRb1HAIZ8nwmXzyDwfw9hR6nkZIxT/OgX6bDmEaexzVtijSEWPcMF5fVOfT3
	 j0oB3ZXXQsaUGlnfIuLDPcWfbOM9+AvuCLbxHYWQhLeLUCD3K26CAkMOysBltpoLQ4
	 oaQN0qXV/8cDLB+TsaPTjfFE4MZAYQQ2PRp+uozaeYVotcL+zpyziIFbAlnIPLCwI3
	 F45PiASNVELYnFg+E2RTchvrPtcRBPMoDTIJdIVVw8NoywYSNkU0f54L539Tg7t4JU
	 NxV3z5dUvNz0Q==
Received: by aws-us-west-2-korg-bugzilla-alma10-1.codeaurora.org (Postfix, from userid 48)
	id C7FE2240040D; Fri, 20 Nov 2026 07:03:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 222294] [REGRESSION] 6.1.191+: NULL deref in
 ext4_mb_load_buddy_gfp() after a3a7d360252c ("ext4: fix e4b bitmap
 inconsistency reports")
Date: Fri, 20 Nov 2026 07:03:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-222294-13602-6SCOgEhjKh@https.bugzilla.kernel.org/>
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

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #3 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
From a quick look I guess it's the same problem that is being discussed her=
e,
with a fix already queued:
https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-0-4fd9=
1ee23a4a@elliotjb.com/

--=20
You are receiving this mail because:
You are watching the assignee of the bug.=
