Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF17235E949
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 03:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782273402; cv=none; b=VVGmciGGBZ07o7DSYn0YYXfMw+KCPE4Fp/20XucIsRhB17F/sQCDfbpFckfAX1z92bOzuuDG/dFOHdB4kEgkKFsk85qCMwQDsF0h6NjvGmiZ4rHoaYLrSUSAxDC5a3Hv2OJzDHggBvvXp08/dnCkkbgpejpYz3hElhIyM9IwHjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782273402; c=relaxed/simple;
	bh=VJ7Hoclrb/Xv1lULjZ5wZqHGyaaBTbRTw/6FKRHuFxU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PG3g7LgNikMrr47u0xGl+L3dmc2WgwU/jPUkLsI5iTC2eIyGljr2siFCHfzxAFXG12fWU7GN5+WcYeFoYm8Qe5+VIY/cJGswf0Xt7aoleMLY02HMrOpyIVe5r0gOguupJEAQtXRYHX09LsTC8VK5oDz2/hyqhHOCJpuBkZg4KoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrOFfdE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrOFfdE7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C234C2BCB4
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 03:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782273402;
	bh=VJ7Hoclrb/Xv1lULjZ5wZqHGyaaBTbRTw/6FKRHuFxU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PrOFfdE7LhpEkiUzxOM5umr0Q/sUUR4weo/zFe2oHsOunuHiSgjdgerVYMbVjaxJX
	 LXrb51H3B7QDNdsSjYuQQ92TBguPBHfLv78IN4LHWr84FOL3gSqZeJUZqq7e7L0JLH
	 R4Czcf14cgcZYwpANur8PAX1stiikUCGtBkaO6Py5cfMerRK1jTO59X2LE9ql5lsTa
	 Hssh+YoomA1fH/PA2QH0SL6pUkVBeKfr/gDXMf8U9UHOts0itTCWybxkKzhL9jv5aW
	 jgC5PcJ76KBdZpgvY6owhLzrSazcRMe9QY2TEn5UdgMekXkT2v6VLFn0tV+HT+z0Z6
	 9p5v83tD04DrQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6D44BC53BBF; Wed, 24 Jun 2026 03:56:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 207729] Mounting EXT4 with data_err=abort does not abort
 journal on data block write failure
Date: Wed, 24 Jun 2026 03:56:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aditya.ansh182@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207729-13602-w47oY8rPJN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207729-13602@https.bugzilla.kernel.org/>
References: <bug-207729-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D207729

Aditya Prakash Srivastava (aditya.ansh182@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aditya.ansh182@gmail.com

--- Comment #5 from Aditya Prakash Srivastava (aditya.ansh182@gmail.com) ---
This has been resolved by commit ce51afb8cc5e ("ext4: abort
journal on data writeback failure if in data_err=3Dabort mode")

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
