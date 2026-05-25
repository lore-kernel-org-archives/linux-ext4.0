Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3B21F30A4
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 01:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779673312; cv=none; b=MkWcG6ELP+/cyIg5V8i4w/Hon7KTnJi1z0WEnJK1TrxKrrINS11Ri8uCMkHPSUQAH9sULcKQH0xJoNYDAYDxTppfUd5ai5UBFUofyGDBM/+S3In+e1vgbI8B2MF4sUCRgK4RAI1deepWMXhU9U1MWOI23j8SMyy1G9/Zzs6ej2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779673312; c=relaxed/simple;
	bh=mAw9qBzqNZKGiDotieiEjMdRq5Dn887cbvudrLw3XnU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JL5oBrHMuYQZ0bstRHkJeaWXdjqJeJwR02os5ZvIywIyD539NrITfLnuu27cebpM94izq13Ui3BnQw+j9QY4knuvU64J1d98h8a/MLblx9VDq/dTala2x+ENcYeDRp8u3beS4DHZyse+zonhk8an6+xMmnXDGzGKJSsHdhOuHy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2jsDprq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2jsDprq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7228AC2BCB4
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 01:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779673312;
	bh=mAw9qBzqNZKGiDotieiEjMdRq5Dn887cbvudrLw3XnU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t2jsDprqrzmibnz4JD2uIcRp1fWOdoLE3V1P5fhM5OWrQePSAgLTZa2RvmFxirddo
	 9d6YoLXh6FTticVG9A5eLvH9BG21PhLFsNTA5GrDvyqkb7v5rjjhRpk9YLTiDyg7a4
	 TZTdPKhFrIQWqsLy58wGrjMn4eGgN21GwfM/OmncsmrjaHajzhQBt85mVCYMpCNPNO
	 +55IInOTskmx9BhlGuU5WhonX3yTOeYRD8w0a0yMbax/vxOIwZDZzcczm2+dTtEs8H
	 QzWwWJdnrAxFa4NU5BSCgrDpHzbU7iJTE2eQF6Nif/Vj6S66X/dnQQha40I1lCN9ni
	 /sI3APmmCDA7w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 59D72C41612; Mon, 25 May 2026 01:41:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 221570] [BUG] ext4: WARNING in dquot_reclaim_space_nodirty on
 bigalloc + PUNCH_HOLE
Date: Mon, 25 May 2026 01:41:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-221570-13602-NevNGt71FK@https.bugzilla.kernel.org/>
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

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #3 from Theodore Tso (tytso@mit.edu) ---
When reporting these sorts of syzkaller bugs, please include the file system
image that was mounted in the VM.

The official upstream syzkaller has a way where you can download it from th=
eir
web interface.  The problem with people running forked copies of syzkallers=
 are
(a) often this is a duplicate of a bug already reported by the upstrea/offi=
cial
syzkaller, and (b) without the web interface, looking at these bugs are much
more difficult.

Also note that if the file system image is corrupted (which is often the ca=
se
with Syzkaller), addressing these issues are a best efforts basis by the ex=
t4
developers.   Some company is going to fund an engineer to work on this on
official work time.  Volunteers who have time on weekends or late at night
can't be expected to work these sorts of issues on anything other than a "b=
est
efforts" basis.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
