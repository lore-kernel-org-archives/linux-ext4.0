Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76A9134B7
	for <linux-ext4@vger.kernel.org>; Tue, 14 Nov 2023 05:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O881WO3M"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5630DC433CA
	for <linux-ext4@vger.kernel.org>; Tue, 14 Nov 2023 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699941359;
	bh=+S4K3xyrKdZJUWVnjHPf64a1dOahTUbQGUiNlpeQXZw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O881WO3MA2RHDkfpkMR169D0R4EltuYMbbez7xFnK8t6Q0kLQJ09J7LGx8G7uKtEw
	 yhVAnilRg/kh1xPP5lin3VMysA3VlMFPD8kZYbyXobsn3VrLW9bYrGJcfTuvFBglia
	 XyoDOJTbOWtJOx//G5f7XI//zKytGXz926L6H5qDQdnNvYc+navaF1zp6dci+UGpPm
	 r8uR3SUtiGRZqC22ATTRHBQF2HaaPOvlxukuHw0FTyE5hZRZ9b40Wj7WSU6cEdxn7F
	 AcUdhdDviG2WGOrLXGO0UQ+ef3UaQhTtpnjqTedM/OE57yuC2a3axrVP62Ze0PPaET
	 qFVlX4nxMHpcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 472CBC53BD4; Tue, 14 Nov 2023 05:55:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 217965] ext4(?) regression since 6.5.0 on sata hdd
Date: Tue, 14 Nov 2023 05:55:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ojaswin.mujoo@ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217965-13602-gZ8oJP5zG4@https.bugzilla.kernel.org/>
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

--- Comment #20 from Ojaswin Mujoo (ojaswin.mujoo@ibm.com) ---
Hey Eyal,

I was continuing to look into this but had to keep it aside for a bit mainly
since I got caught up with some other work plus I don't seem to have the ri=
ght
hardware to trigger this either.

I see that you are facing a similar issue and have some more information on
your post. Thanks for that, let me take some more time to go though it and
think about the issue.=20

Btw, would it possible for you to do a git bisect of the issue to see which=
 is
the bad commit? Since I'm not able to replicate it on my setup that could be
really helpful.

Regards,
ojaswin

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
