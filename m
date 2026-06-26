Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03E30D3F7
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 21:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782508167; cv=none; b=OV/spW4aQkYvQlWL6CwDhEG7saXxCH6qyype4+2dNW4pZ86O0+Bs733jaLhXgnsbSvssyZCIbnoL0FcizwsIejF+NFHnPeeDPL1kTU/sRIxxd/Pd2N3UaqNG0/Z9M8wyV40HuqSnQl7vKQN/ZtiaNOF/mek6+3eJ54KqMqVU4Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782508167; c=relaxed/simple;
	bh=rbjqMhPbnQUzuLgJ+wVJn1eah4JvwXCM1/PIJTrD6nM=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=W25aWsq/Yx9BhmNFULfxGbsjiWTwf4v0T5I1RflbiMX8Dj06WdLVMReSncorabFBDuemcxHkAUdqrqZPWkmbYSOuxTogFz4+M2LGMlXQjbb+nY6pQBOd3T0ZDdFVlpgDJN/0t0ikuxErWNQnp33pbcg5twkJa1MNBX4mZ62dF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=HSqEW2J9; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="HSqEW2J9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1782508152; x=1782767352;
	bh=rbjqMhPbnQUzuLgJ+wVJn1eah4JvwXCM1/PIJTrD6nM=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HSqEW2J9AiJ1poxr8G1WKNHcsI0RU5vpykjNor/F+s7AbjtrnAIyepOtKFi216S9l
	 oeBs67cWPh57vTsO3ORRoYCBmuj35/WX40sGolI8Dza3FUjjRAL+4INP7SepXFwGbT
	 DsPdeMMgmLUtbV/yHDpT8lrbqa4mNwrIVTLbS6zaIXv8xPMJKsqdY13clo/TT1uIHX
	 fJoGq9SyOdaa5a6L6qp/8epyr0UVhwC2ay5C/pqW2aOS326Kh9OVa5LD1gc28v0FZ2
	 iPtkOYvrHEhphpGx4Pl5OYwlJUGBqQxaPoyNNq+EjSafnFO+wyHZswFEGRKHS4dTbL
	 gLNP7PyGDVB3Q==
Date: Fri, 26 Jun 2026 21:09:09 +0000
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From: dardaoe <dardaoe@proton.me>
Subject: linux-doc@vger.kernel.org
Message-ID: <F6-Nv2DhZIxD7g0KzZFf36UXOLn6D8qTlOQQFjIuQb_GyiQtoEQCvvRzDKnpYeSrd_E9H_DQYygw1zBDzlR2KxqqGsmYjODQr2qmRdjuixw=@proton.me>
Feedback-ID: 203735097:user:proton
X-Pm-Message-ID: e1e424868765b76b3406213ebc85c625d09ec7d6
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Documentation/filesystems/ext4/group_descr.rst contains a slightly inaccura=
tedescription of the meta_bg layout.

The current text says:
=C2=A0 =C2=A0 "Note that in the meta_bg case, however, the first and last t=
wo block
=C2=A0 =C2=A0 =C2=A0groups within the larger meta group contain only group =
descriptors for
=C2=A0 =C2=A0 =C2=A0the groups inside the meta group."

However, the more precise description (in older documentation and the actua=
l
implementation) is that the superblock + group descriptor block is placed a=
t
the beginning of the **first, second, and last** block groups in a meta-blo=
ck
group.
This is confirmed by:
- The Meta Block Groups section (previously 2.2.3)
- e2fsprogs test case: tests/m_meta_bg/expect.1 (and related tests)
- Actual on-disk layout used by mke2fs and the kernel
---
Here's the proposed patch:
diff --git a/Documentation/filesystems/ext4/group_descr.rst b/Documentation=
/filesystems/ext4/group_descr.rst
index abc1234..def5678 100644
--- a/Documentation/filesystems/ext4/group_descr.rst
+++ b/Documentation/filesystems/ext4/group_descr.rst
@@ -19,8 +19,8 @@ group of the flex group.
=C2=A0If the meta_bg feature flag is set, then several block groups are
=C2=A0grouped together into a meta group. Note that in the meta_bg case,
-however, the first and last two block groups within the larger meta
-group contain only group descriptors for the groups inside the meta
-group.
+however, the superblock and a single block group descriptor block is
+placed at the beginning of the first, second, and last block groups
+in a meta-block group.
=C2=A0flex_bg and meta_bg do not appear to be mutually exclusive features.


Signed-off-by: dardaoe dardaoe@proton.me


Sent with Proton Mail secure email.
