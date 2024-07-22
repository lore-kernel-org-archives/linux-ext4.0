Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D6D1863F
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jul 2024 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721674989; cv=none; b=lzopejLZkJQrmfYV3iJAg/412eRXYIkOyVuLoCfEn2PHIeF2FZJlIL1bJ4mYGsUmP04eZqhZeTXQmzcT96evetcXZS6ibXGAYermyaKou7oo+WMjKZvdgbYkw9tRadtzIx74mxL22bclE57RIJueoG2wASOB9OHC+cD0++VtGoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721674989; c=relaxed/simple;
	bh=k4hPFOQO4L6eckAyWr3QFCWd8ZhWETsG7c3T1MmOIz0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EEn3ftGLQamdGqWFChSl3UMptSnb7ZRQiHXd5ixLLQd8Ve+5O6ZRcJr1bVVDKBdo+ivPDkJPr1Ynd0iro1HqXCPbpTMTJWRIAHey85WgSU3E1MeJBMgzcHzJSp8kDbc3OH/LLywbCrFDDZdrWpKe4JCb4wg2B7gaTRNHXztELnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqNIZel3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqNIZel3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89AF2C4AF0B
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jul 2024 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721674988;
	bh=k4hPFOQO4L6eckAyWr3QFCWd8ZhWETsG7c3T1MmOIz0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jqNIZel3CVHKN+pXz6fz+n2BRz+SL9w/JqLKNK3VbcuoR2nguSEdzu8umcfZ1rXMC
	 crsMzdrZ93/gA6atYEx1TaEvGVBPjAQDa49eiw8AYGq4CSLRar0JXDdnMxa8BOA8lo
	 06DVOAbM1S8Y8ZldNig7FJbh0rLCgqCIpUO2xwJhcoHKKl7thV/KhOEjSW2mdl+eE0
	 yI0NtOcpaGSTtGluu4SzGT1pSqsqJGAwUZ2elt/qsbi2PPh2eZdB+zKIi+SOgMcJW1
	 rBpy8KCWOYlnQ64X7xJsIows5Nv/ULIuuxunen3hnYU85T0buaL1HjCHwzzCOf/GNT
	 HKDK03Gvcz4XQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7B069C53B73; Mon, 22 Jul 2024 19:03:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 219072] After updating to kernel 6.10.0, one of my Western
 Digital HDD stopped working
Date: Mon, 22 Jul 2024 19:03:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219072-13602-FQNdmPMxPV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219072-13602@https.bugzilla.kernel.org/>
References: <bug-219072-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219072

--- Comment #6 from Artem S. Tashkinov (aros@gmx.com) ---
You could just wait for kernel 6.10.1 or 6.10.2. By then it should have the
patch included.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
