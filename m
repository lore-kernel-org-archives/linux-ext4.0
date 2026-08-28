Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D53C76BE
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2026 05:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895935; cv=pass; b=OvHQNsNYuvH++oCpjcwjBmpfnYBg8JfWcrCVSmtfTuuhLy5cnAhJjrj5wGwK5j3xjT53jtFNTuWGJKVpSbBy9ssFjG/zLKgXmUreoPWOINIWiB+YUVSzrppshfCfy2KwPZgVhSxmAAHjtq1VUF7FwT5QwBt7th+nNyS8qJDI6mY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895935; c=relaxed/simple;
	bh=T2fF49gHVeJcSZd+NSxaC89BuaAnThHgWNNz9fV8otM=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=mNKmVJtUzA3Fu//jWc6aikG3fwztb9plefLmdwxdHNrvCW+CzIsqiNbYm3iVuuVviR5VJImSPXKeo7QJNxiHc13woRPFr0zTN0IUVKWFYmJXken4oV0/ukDA4he76K/9vNQ70rNGa6cMP1EPdQQhR5TnyXY9RGlp29lLNdFg/Cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=TgJTwuob; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="TgJTwuob"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d715f4a587so9611825ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 22:45:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787895933; cv=none;
        d=google.com; s=arc-20260327;
        b=lwYQxXrm6fq37OoosJH0y5Lx4dpFiEv42QUpeLE4Rk6F4QoiUPS2wum0msEa9b6W/Z
         HyeFeb+yEcejdKG4I7MorHWr3WVlhRUieoh1oQbDglyKLIEjAAtoosGG6rQSL8Ezoi0z
         TwALxAl7M96774Q2MyAbw+9DGv8o/XaCR0olhINX4/ttpBlt2RYC1VymDo/9UlPwbbqB
         JIOGOXnrQpyeZz24SGdwXu4lTFslSEAhHiBhepFkOuorR1LQ13zXP71awTPZTrkN3jRI
         w3dCRy8TlNiHZuc/G7fDmw9EcYZTMqOi+sNo0bQrk81uFqnR+RnpNNoIIvgX2g0FkZqr
         M0vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=MrP3fs+sBh4JTGYQXlz9sQdw6xaaN4KOuGpsYfS+xWY=;
        fh=Y5SXkr8BLT1sr79p1XrcHj374o0OE1THCA9M0luO7o8=;
        b=d4mk2iteAf6bLbtTOhu2MhM3EvpJ9F4z6WqgD0BSqRKXYCNS+aRoVrP7+Kst5FgGSO
         1s8j9bTCSLpnnyqCcHKbw3Sqcmz9cvPxkard0zgXafb19IP2DXnckbWugE9kMinUMiLO
         g9dy44L8ntUo3Dunl4sfZQeTwcRnsuImzc+WUHqrKLe1mpo21Tfog3Ydq2Kwj87MpXna
         MJEFBZurTbVZhaWNkTmGm3pV+lDzgXSOeXSbT4TtXeSt81lFSC2pAmzSdOP7fsvBbCmI
         p+1vcFlzN/w56Bqmlg0/WYZ3p+t0Y7V1RZnu73vipp1anECgVfJ/dtJwsHnSocjUjy/H
         k0Wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787895933; x=1788500733; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MrP3fs+sBh4JTGYQXlz9sQdw6xaaN4KOuGpsYfS+xWY=;
        b=TgJTwuobKCkuJdYPd23NEYVYRyDh2zDf6AUyRDFNFhjRzYhnxqxvGUyCuxNdtAxV5k
         qsbqI8nI/fRm5yPGBRuO66XcCrRlsrkAe6i5713LSidVjiSl13IjjKWARBAqRSbBIPLu
         j9MKcz0FsBUh9Vo9zdaontGSS/H2PAnMCIJA6xPmQPDJgfNisreWftVolsQ4GeC02T+H
         bpPeJGZYJJRChV1lW0ehl/psTexPnbT+0zNmFfui+9YG0Ieddol5jDkakRn119+DFOb6
         4L4DIxW2jcsMTRZgDY0gtTPozewIHi0WsW+Hx/4dmwmd9g6yuUbIaYB/SMHyW6qKjz5J
         HfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895933; x=1788500733;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MrP3fs+sBh4JTGYQXlz9sQdw6xaaN4KOuGpsYfS+xWY=;
        b=HrZ6N63dtRXhy1cSf+XPqlH3y66iCylMM8TjlyG1Bs4IX+VoNzAP5Jt/lCd87ALE6Q
         naLE7QSkvLe3BWEmrdm1pAiwlJXQ37rLHftoAtN0m1dcElwUBeQSXc9igaRkHKzZ+AiK
         2IfJJvJAHpFjyhtdiaUdMqSXlob2Yda+mpm4mopR2+/mCQuQzGPztiYwmaoVMJvhKzRt
         gpazJxyCRs3aEFYHvEfUxWJAJg1rPoejk5gHnb/PIPJzKbYeepPt7IliDvKhQhAle2d/
         clJ/vTV2nvUw+bWHWdgBe4RBOilW6WacrpOQZdzDnI7ZdWscIdZk4oTCBpCYmW9gICxi
         zoYA==
X-Forwarded-Encrypted: i=1; AHgh+RqUVnFJMT+hkho0DEG+Zb45WQYHjZULSpCh7WU+gkdeh0Cv3P1mnZiMEkrRLHsLYtVTrSHaGUwGmxMo@vger.kernel.org
X-Gm-Message-State: AFuF++nI10sCuWsJ986WzCfn+c3gHHQRcyXjQi6O2jzIGWPdR9W0pNMD
	7S+JlggVwRj5qSIVk7IdsXAuw/khcrzpd1/7oNn+57l0mN/KP4qvqTHgDBU66UYOF1BZfVG8yNq
	bAorUNWUdEauToh7Eww88cMmhJisdnNTQudC8mUKR
X-Gm-Gg: AR+sD118SZhoWIsvaPrTvOkYxGlpPw0Da8D+6JE0f/Iydra+VK44fJHmL3j/Hx2rzt+
	nAFAYlRtimqOF/JqAWer4uWcXyD+/7Z2yDN4XUnQIimCFKAONRi6xLpPZ32EWmpN1iKJhoctAlC
	Q7R4n5tuGbxF4pbSwDhuGW01QzrJ9+QnLoSS26fVEcPWsi26ChXF7rfN3DUUsiYMB8kpBjajjaG
	c5R/83WJR+dAXVSO+hmi5MgN8jL//S/Ro1hqXn8IDDqhvRSoam/iSM/KGsphC4G3V4fNBFc+A0n
	yWmDzXYfjaYQeES+KiHDe1lYq94J0wIpsi77jot0RaI5E9yOQGVvzjzRxqv3d25AHUC8J2yjlu5
	F5paMkCX4aedsdJgyTGx2+noCSHZDLsP8
X-Received: by 2002:a17:903:15cf:b0:2cf:ccc2:6088 with SMTP id
 d9443c01a7336-2d74dc21be0mr93296435ad.4.1787895932178; Thu, 27 Aug 2026
 22:45:32 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:45:30 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:45:30 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:45:30 -0700
X-Gm-Features: AcwNN1XQaQsSGB_JtPRDptCarl0A2Bdri9F5yBjxTPzlaSSBJSLu85_ntTJbXo4
Message-ID: <CA+0ovCiKb8axo+R-RsqzGbUsrVE0AcLbHqy=+-c9oSMCAqL1fA@mail.gmail.com>
Subject: [BUG] WARNING in ext4_journalled_invalidate_folio
To: "Theodore Ts'o" <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>
Cc: falemi@asu.edu, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/172-warning-in-ext4-journalled-invalidate-folio/

  __ext4_journalled_invalidate_folio(folio, offset, length) < 0
  WARNING: fs/ext4/inode.c:3432 at
ext4_journalled_invalidate_folio+0x4a/0x50 fs/ext4/inode.c:3432,
CPU#0: syz.3.369/14887
  RIP: 0010:ext4_journalled_invalidate_folio+0x4a/0x50 fs/ext4/inode.c:3432
  Call Trace:
   ext4_journalled_invalidate_folio+0x4a/0x50 fs/ext4/inode.c:3432
   folio_invalidate mm/truncate.c:140 [inline]
   truncate_inode_partial_folio+0x33e/0x8d0 mm/truncate.c:249
   truncate_inode_pages_range+0x5de/0xdf0 mm/truncate.c:416
   ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
   ext4_journalled_write_end+0x8f2/0xc70 fs/ext4/inode.c:1608
   generic_perform_write+0x611/0x8d0 mm/filemap.c:4346
   ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
   ext4_file_write_iter+0x298/0x1bf0
   vfs_write+0x6f3/0xda0 fs/read_write.c:688

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
