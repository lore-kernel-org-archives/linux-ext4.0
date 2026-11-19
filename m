Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082799;
	b=a2+ibWbJYqTOobQbsL3Rmynl4L0yNQe1GkfM1y20PPzX9Q3cobz/5Q37HHPY2qp67ufs
	 LBhHuOOJGtAa8l5tTFQHqfmyWTPr//H/5OjQWyEXW/0XNBqSjz5h0fHOXquBsV5xhFDjU
	 gmyQiAlTkvRLHUCoCIeCXIZLc+HF1D2T61G6Nr8ESxWK5t8SQmwR1dyAfuJ43Qx7woP1K
	 rtho8ThwHRJtBJkaF0ccDHqW3C50yvy1jY5ydGU9mdhtRR4uOCZYRunuGa0N1EsKnRs9/
	 z3lQxjlksY8TSvgv7VNjsRJx2PfzPX7UqGQZ3fnAXX3Di6rdjq+rcPGj+/iWPKspisg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082799;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=E1pCsl7PTAcI4S//BsIM05SLO+pLh5XMA/WKpkB3C/0=;
	b=fsVIQ0NqaXdraqSzAccNyeSNc3qDfFhJO0yEZwuYdKN35r12PofN/9IjMPll3sT9hmIL
	 IuplhPT+jiECNWbvXlUVHV7Jrh8BRzkBMfntpO9xDlTbt+mD5/Sk3Jg9sBmYt352SivdD
	 W2WC4RXy7rYr54hRFjZzTxm+7fD1jUIS64M0PHJv/YBoBVE5ir7LnZF70dPJAPR0IDGdK
	 gT80J9UZ5z30fxAqKQlzgWe1WOqJ6iML4VzBsbigC8w4brYdB58lG3M9kfI7dOoZOQv6f
	 solLBufj/Xb40MwJ8jmyPNxrHqhzKW3sGaQhPyfTJxXeYcaQrefhCmw65odGJvotRVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=axGnpUgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBFE606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=axGnpUgB
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BE471F00926
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 10:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795082799;
	bh=E1pCsl7PTAcI4S//BsIM05SLO+pLh5XMA/WKpkB3C/0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=axGnpUgBTUbWxY0lshdjfaqw6Pj3KpAXi/VyVlvTl3IEf3hBSYYZC6kIN9mGBSC4O
	 fLwtKIj7GLLmhQmq8GKmrDVNNorJ/CUrDzMtPWX1smOVOxDo9rg/UMA28PBODwxndJ
	 9xkJcowb4unSIHSZh873Qym67ldaVfGB8NriOB2XiS90UkB8L7eeox+gl/oEkdyZq1
	 jt5TRiAopi9JgLRkoI0/3xC1c3W5O9GeRLkJrMBHAq4NRyeHbFHhr+OxJ9h9nkRX/a
	 tpIMjb7jGWpz9hZqgUgaCjhNKUag7ZAP++f6Qc7FapYmsuAVKNoJLybESiFCDshABr
	 Wpn58Vy3DQgHQ==
Received: by aws-us-west-2-korg-bugzilla-alma10-1.codeaurora.org (Postfix, from userid 48)
	id 08359240040C; Thu, 19 Nov 2026 10:06:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 222294] [REGRESSION] 6.1.191+: NULL deref in
 ext4_mb_load_buddy_gfp() after a3a7d360252c ("ext4: fix e4b bitmap
 inconsistency reports")
Date: Thu, 19 Nov 2026 10:06:38 +0000
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
X-Bugzilla-Changed-Fields: cf_regression cf_bisect_commit cf_kernel_version
Message-ID: <bug-222294-13602-CuRpxdaT07@https.bugzilla.kernel.org/>
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

Dawid Partyka (internet.jejkowice@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes
 Bisected commit-id|                            |a3a7d360252c0d84ae8bda067fb
                   |                            |296c9e82928d3
     Kernel Version|                            |6.1.192

--=20
You are receiving this mail because:
You are watching the assignee of the bug.=
