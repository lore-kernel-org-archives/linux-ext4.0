Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F53A3A9D9F
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779642730; cv=none; b=UW/lPzgtzJVqzzCw+pLmxnJhT6+ueW5SB8GXlHpwK0pHXoMzJJlpRGd5DcmOzGX88ikHtp/Pj8Ul5bch3sUcy8FSx27VuGiIhPN8ZjUDpYYUxTRigCTHhGJNNNcv7VaUDUMLBT+47EQvLxByrH3vNI5XmkL7IEOafiIZI99FVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779642730; c=relaxed/simple;
	bh=pL85Nl65V8iPAinsDu8dCmmwNG8UqrtphdHwInIuiv8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZIYFx0yxTWxz7jqVqqtLCguEEtJWDH3hKC745pgPQcRl9e9x+xCYZagiAz9hos5vvhQYspv591t0OUgYYIYuC5pJ/V3wgMqFwyIVvUB200usDYhwWIduJ6jFIktYAIB/MLrpEILl1RZ9MYZTIX/tZO4Y0I8iYzwmjDwmWCauFqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiRA11zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiRA11zS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C00E6C2BCB7
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779642729;
	bh=pL85Nl65V8iPAinsDu8dCmmwNG8UqrtphdHwInIuiv8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hiRA11zSdWlas4M+sH/v6NgOt9aR2gk+avoj1S5lIVvQlLGRY26TNwKszTlhTcy6p
	 oWeIJhsv11QkrG9oR2YLXuZsDxklX/w3CkS6vs8ncXXbyezcNNiUpZ0JMVaLz7Sm0w
	 fR+QBjxDR2GlOziQBEH/U/6vHBpQUtyOOew4cbggz1qGAPtMJQAOq1R82qD2WqN749
	 fb/H/UGCr7yJo/jJBJKS4W5yYazs2rGadnjHj29XY4q/1n6MConxNhT2lzCODy3ZMj
	 cebokXWC8+b9FMx0TqmLyB3pG3ltBskkkcBFwcfAs/iXJCIs9Ao1LvT9czYM/edicC
	 eSkfvSC6ptJfA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B6446C3279F; Sun, 24 May 2026 17:12:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 221570] [BUG] ext4: WARNING in dquot_reclaim_space_nodirty on
 bigalloc + PUNCH_HOLE
Date: Sun, 24 May 2026 17:12:09 +0000
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
Message-ID: <bug-221570-13602-m18Zs6A1gJ@https.bugzilla.kernel.org/>
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

--- Comment #1 from yzjaurora@gmail.com ---
Created attachment 310189
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310189&action=3Dedit
Kernel config

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
