Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E119E992
	for <linux-ext4@vger.kernel.org>; Sat, 27 Jun 2026 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782550466; cv=none; b=TVKfULI61dGt5Fdqx/xjHoVGtj6T4Zm2LvQiK8o8CeClmtUw2UPqRYGrXhRIcXIO+7QVjeVUjj3ZsF60v45BU9r1Bj4D5ua7/vfRTXPQbedXbkbzB0kIb/U9aqydkJRh68oAXa5eBc/3M0eIytrzukvpCeUor2uvKE3Kc2Kmo/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782550466; c=relaxed/simple;
	bh=zhpI/bDKRYl6XwOGmLFnXXl+Bm1jsqw5L6iUIdU4/OA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qARu0tkCvpASRyuQSAbi953snjRTACRdQI8LV0piZMhHJstVqtzA/zNPcakP3m1IwEzwDj09AQ5bFJ8l1DkMWvRe8IZGu4uZ2vZy/hXoWwgRkTrln7tKByhsWgmUOu5ZndJ8pZvdh15oLGjHhHscJCQ6Mam7s8SeDcvEGTua6Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKcAcFDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKcAcFDr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A150DC2BCB7
	for <linux-ext4@vger.kernel.org>; Sat, 27 Jun 2026 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782550465;
	bh=zhpI/bDKRYl6XwOGmLFnXXl+Bm1jsqw5L6iUIdU4/OA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BKcAcFDrIRAZRtLuJrxnPTk3NNQRLtamVyTl3dkW7u/mU2LBcmNNxZ4amFJHOA7X/
	 JovpziDOOrJ+SDpHxI6zrK3UjcdTP8pu/n068AMif16ljiVizmdTWaXVlC5MHf83U2
	 ZzZAq1YQcqplbG+LV5o5a7x4dXYeuqfSMfvQREY1mJTnjF/j8m6/712ZoyuiVnjw1p
	 aQMFdYad172wDZCzfH7Dfvkm5PDF2S3XvLzs0D1AdMlzUdCvpauh/rKVugoDwc3QAp
	 iL2DARBZXbIUkdLeElGPcW68RPDOw2Ocz9OYjjxi7Z2XZQ8KkCSeTv7/O9SYkNTgbu
	 srJYawqPeXzTw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 98608C41614; Sat, 27 Jun 2026 08:54:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 207729] Mounting EXT4 with data_err=abort does not abort
 journal on data block write failure
Date: Sat, 27 Jun 2026 08:54:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-207729-13602-EyXAZul2i2@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
