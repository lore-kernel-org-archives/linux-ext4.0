Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9E52914
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2024 01:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721870094; cv=none; b=gGNE/FPAnH69ur4sre+9E2ChtXo9GTiAEg6mIi385cG/+jLJcRMCLfYABjZIl9xsGpnKYuSNDHmmSBtE+rwaYGXHgEN/r9BuY1oeeiQThs127leHqoojq2U25ca8ZRF7aVSpzy9b13U11JiqOyHw/B+1f1O98bWuFx5tHk/vOvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721870094; c=relaxed/simple;
	bh=XLr8Llao3ME0c4oNloYPj6BCjUYdpecW5KsMscxPBvU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l/GPadDMTsE6xA9bIXJiyj5MF4ZH8WRhN9VqF3NNCa17REPa4cqaiCm/Nm/rR/RjfkAm4Tghyg4iGJMGr+6GmJhuNfA+R600ijHng2fRbCzVMxaYFbM14ca9BRnnKzzojDevSS8SisZZiSdqKdRzT8EW86MCXiXBX2acfig7/3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcaElEIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcaElEIr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1239C4AF0E
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2024 01:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721870093;
	bh=XLr8Llao3ME0c4oNloYPj6BCjUYdpecW5KsMscxPBvU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gcaElEIrHfeRjlgotnisL09RgMBPJfoAEz+nbJhNmUqE7y65YspFQ8ryJZwpuUmRp
	 XwYkYNIsMCsokDsBTdE/l9gKPDhlXSqjquH/2dXdI80T2zXG9l0ci9gSZcMHvoDj4a
	 ZADnvnH22ZgjG7Us1RbL7JJoAFzrQHiEVZsglAYZZGO+wsgXE2vzYV4UTwSf8BZ7Tq
	 ZKd8fKoPe+mvRRq16MHCbdfew+sZZ4fdaH8jFXtILR7CwUkrOHv1eIxm93nCheSWD9
	 Kbj01JLg/0UpJqciaYOxb81Ekv2AMfNY38HA5mgv1zqIiR55sXjLwlbYQJtImPkXEi
	 SfJXSzKblXabA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D4E88C53B73; Thu, 25 Jul 2024 01:14:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 219072] After updating to kernel 6.10.0, one of my Western
 Digital HDD stopped working
Date: Thu, 25 Jul 2024 01:14:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: xcreativ@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219072-13602-BABGBZiWWk@https.bugzilla.kernel.org/>
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

--- Comment #8 from xcreativ@gmail.com ---
Thank you very much. Today I downloaded 6.10.1. And the problem is fixed. A=
ll
disks work and folders and files open without problems or freezes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
