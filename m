Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204283A9D9F
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779642744; cv=none; b=KBdAvlrd4IZWoCA5lagfs96eQC7J128u1FApol7JNG7EGPb+Ra5dBvOZgmYkhX53lRJQNI6DXDarKK/QWrlejQSl+5RaQTaWbwlOuTDk/59soLO0n7BSH0fR4AE+T8VpVUiipA8LPZmlWkfN834M3kL0xSU8qljTfTp13bEIYyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779642744; c=relaxed/simple;
	bh=1CjcdtZpvj0U4dfjParmsRVoOyX04BoV5qItudSmExQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IEUwwa5g43uDshW3/yD/wRCzT5gwPKraEE+foleRW7s1xMTTlD4rFk450huijxCdaicOMA1kBxXsehgR7TtrdHBaDVuMl27TdD4ZSQnS7LZ5JqYXwBoKqJy/SQOdBB0wwKhRreo61+3ozkpWNPL4rVbFa/fZTDcoQb7jSxqygZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5tZBMv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5tZBMv+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3A84C2BCC7
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779642743;
	bh=1CjcdtZpvj0U4dfjParmsRVoOyX04BoV5qItudSmExQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t5tZBMv+Sx+e/NuFBfGIGxS0G3XxQTrTpt7qOy2a/EUHzSuIHl28I9KPEUG2DcAFW
	 ZDxBeKFdKcwRluOH6UstpFX+Pjji3tq5AmNv0dwIm6PJSjzmxyVAX8HZ8O6nedb7gB
	 H1SMDgHt4xaKD1n7hUe3tN30r3KUn8reb9iQ1WcYqfhkYliF2+9AA/G+4f7cby6IAv
	 +dhx0WlzivXfKHVqrN7KAkqYtBRZk8sIosDXqJlt4cSktlGUD4hasSQyC5B+J4NJpw
	 qUB8WIB5mEbxw5kPHDVa26E6dyYDBxZmzFESRJr6Vm9qcckpVtBhA4w/zuoZbkfZrA
	 JCmkF3Xrl4CSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AC52BC41612; Sun, 24 May 2026 17:12:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 221570] [BUG] ext4: WARNING in dquot_reclaim_space_nodirty on
 bigalloc + PUNCH_HOLE
Date: Sun, 24 May 2026 17:12:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yzjaurora@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-221570-13602-f3zHta5mIV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-221570-13602@https.bugzilla.kernel.org/>
References: <bug-221570-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D221570

--- Comment #2 from yzjaurora@gmail.com ---
Created attachment 310190
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310190&action=3Dedit
C reproducer

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
