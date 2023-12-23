Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69D1656
	for <linux-ext4@vger.kernel.org>; Sat, 23 Dec 2023 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6IBZjMI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47640C433CA
	for <linux-ext4@vger.kernel.org>; Sat, 23 Dec 2023 00:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703293016;
	bh=Rzj2ORZKOYJFgr1rP/R7hlruQW4T1yI6+5nsugCYR64=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=u6IBZjMIkDYr1qO9S08Okk+EjW3xTkwMnbUgE6gHl6LwiRH+3UAOGbxPR6uPmqJCj
	 FZO4I/HMz4LUObUwljyXR/9Eh4iOb2EMbOpa6xVAhP4itQE2SmkluCeAlsLxT+8p2K
	 oM5J0ru4hapw9zVAlq2QrDWo6lhHdDzBB5Se502QgGgS1XT/J9rfC+DZJpTeCSwmju
	 0gGKjle0vr7AtW5vXee8tbl5ZROE5fk3k8tsh4cxxElZd9fUimWiEpee7e86tRFuO8
	 VEYSUxyx3YEka0I3F0vVrvTxTMArFQrEZSvyQ7Ip0ZKcZSQuYjNZS52wB2vCXuAmpU
	 9U+3/iEkDSpyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3046AC53BD3; Sat, 23 Dec 2023 00:56:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 217965] ext4(?) regression since 6.5.0 on sata hdd
Date: Sat, 23 Dec 2023 00:56:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: carlos@fisica.ufpr.br
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217965-13602-VvgwdlMObb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217965-13602@https.bugzilla.kernel.org/>
References: <bug-217965-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217965

carlos@fisica.ufpr.br changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |carlos@fisica.ufpr.br

--- Comment #47 from carlos@fisica.ufpr.br ---
I've posted an easy reproducer here:
https://marc.info/?l=3Dlinux-raid&m=3D170327844709957&w=3D2

You can adjust the vm settings to make sure all the tree fits in the ram ca=
che,
depending on the ram of your machine.

By default the FS is mounted with stripe=3D1280 because it's on a raid6.
Remounting with stripe=3D0 works around the problem. Excellent!

Also, this affects all 6.* kernels, as I said in the above post.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
