Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795083194;
	b=OxtEmWv/KjgtiYkxEvtQPMpYXQTDrj7FKZpDv9P+YT4/tm6X0Rb5yiLwLBGaC1PKc1l8
	 KuZQV4cRsRvrHp4FMNogqsdk5NgkWpc0dBhjvB8Cw/rziYYIcGW9BMP8YtFVE05DcfiKs
	 2T7nnZNoX+sfmaCVnXy0aIzEr6gbJjk4qK3uYOP9+M0ja+37iXhOzteU5thZMsOLwnpv4
	 sL28AV/JmdLaU1RRWHqxSclujR5i5iyerlgmlQOdhLdaTt8Jvvt1S0RdYMAwnlvA+vy6v
	 SEGX+Rp7X+tgLDMIbtO/3OADwgSpcuiZcJnmCO7OeNZe+F7h213WANY/UsI9SrF308Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083194;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=Lj7nj9dgk6Ip9wghXk7APeg6mGUcIS69ChDbTKYekEE=;
	b=r00QulWjbg++6WhTYzDsvbDoZVT9QxXtK9ON95YnGRlF+z73widGCpwiVFt3K/f3gSxF
	 OWvKVx+jmm3wp8gkPhVh9//irOksjbxhJ4aOBEC7hDVOmyhEFQMyMqTYTABMbFwASJCyo
	 Iz9R/uXlCdsdNvhjzu4HMlqS3Nofmt0E2xVD9KkuwS3Dh3u7GoMsRt2CzR2bWjw22/Kba
	 oOFhhBmlGD4Foodsrw7hH+F6sZm12qFx3qXMfdl0jfs06tkImCEu/3ZD2Zzzr7XxqpwA8
	 uNCAWl6ckRSw89AKBmUnoJOlZKs/vyDn/0oeRbbBwMm7OAPiE7X/YEs72GTC+pcuZ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8Zhsfl9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD447606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 10:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8Zhsfl9
Received: by smtp.kernel.org (Postfix) with ESMTPS id 674F31F000C6
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795083194;
	bh=Lj7nj9dgk6Ip9wghXk7APeg6mGUcIS69ChDbTKYekEE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Y8Zhsfl9BH8wOXolG1mimhVUjGjpM/WSsgcPuPpApXzsJlGF6N3HKyOMVscGruc52
	 NS9hUr2Oh6Puwjk1ackD5On2TiDDwEKLxE3AvZUx+UvtlHPTDtfZGJYqtznv2RhhkD
	 1XI0gzjVmmq8Lkxm0ikgaVSe7r5SHM+5M7ZOHoqaCzssuEil8RBovV2zF+Bh9Ne5Zy
	 4Ft6y/EvUxN/t+H4SnsuzMrHqRHeKGn8nLPpolYZi4S06aCgRWZMYsf/YjS1bLKVJg
	 9+lGLyb3mCrp/RRyCLdlZQDxZWhJQYttmQbWvrkOyovb239lvOfLqrFVxUhir3MLoN
	 j+er7pWrG3Hiw==
Received: by aws-us-west-2-korg-bugzilla-alma10-1.codeaurora.org (Postfix, from userid 48)
	id 642E8240040E; Thu, 19 Nov 2026 10:13:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 222294] [REGRESSION] 6.1.191+: NULL deref in
 ext4_mb_load_buddy_gfp() after a3a7d360252c ("ext4: fix e4b bitmap
 inconsistency reports")
Date: Thu, 19 Nov 2026 10:13:14 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-222294-13602-FHONC5Cxuq@https.bugzilla.kernel.org/>
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

--- Comment #2 from Dawid Partyka (internet.jejkowice@gmail.com) ---
Created attachment 311520
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D311520&action=3Dedit
log

--=20
You are receiving this mail because:
You are watching the assignee of the bug.=
