Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778EC345CAA;
	Sun,  9 Aug 2026 05:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786254339; cv=none; b=uU5io3WfK3959ekJ1Lp56nP8AUILT2e4z9D1olQ+dGVlYo+dGU6I3pCaC4DI0xKit1aILgIXVpp9tn/DVKv1nvMQMI/n4PM1ZhCxFXh5RoIrtS2yUijbpGrQ3H3wabrWcwSQ/ue3dHK3A7g0FjXJ/GVvx8xs04fz6WYpHmEqpcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786254339; c=relaxed/simple;
	bh=7RMFFNYT4Qt8JhSON2vW8u1uNwhLqTIWLy3cXedCmLU=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=rAPvFL+rvzpYpnSvvNKR6G7JSxGwm0gAPGIQ/SAO9XLPf32rYtPPOt6mbFLRUNdDmKcyOBc+2kiADePw2UP85746qIMmHQ6jiFonFJ1wRJw0UlQjanTkGdTb3ci5wNFbscBbutZvrLHHXCDQNz2XJMrp9ut9jCWAw0EpCY0HwjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=YDp0dvf+; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="YDp0dvf+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786254325; bh=eI63H6+vyv/AYPMEyjQuuho9STUT5+sLSdIlKSsoDOk=;
	h=From:To:Cc:Subject:Date;
	b=YDp0dvf+IIkzBke/uqxh6RxDme04W7DRbbEsp/Ex/GHogGcKTJmdz0pMLhylSdJDx
	 WcLM/nupLTj2E8+mxctWoxZzhL9rBLQ7BNXjXXhYiZH/7DINItXHABPQz3ilzS9mY4
	 9YUXi2DDRx/q9sFnZnfh+RfL+okGfFhjY3oyl75E=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4824:bd7c:c5a2:f149:1f65])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id B4F87A15; Sun, 09 Aug 2026 13:45:15 +0800
X-QQ-mid: xmsmtpt1786254315tfg67yd44
Message-ID: <tencent_3E210B6E71105F311354D53C158A3A9E1E08@qq.com>
X-QQ-XMAILINFO: M4IaOLvRTdegXe1aim0mGDwJwB5pFgJ2tZLZsznm6JrjkKSuMw0mOgQJVDh5za
	 yzfLBavgZrcbyeJ6Nk0cQPdbadJxEv7Lj6nqmN3DD1aXlv2A/v6y0e6lwNGP5GyU9bFvG76LxSFE
	 6Xn4v5JDa4NRe06JiT4XbOrRZsJsJdisSBAvxq7JG/wLzvjUecabcC6S7AMW6/pasder8YYfqY7E
	 eIHrHgGdwqMUj38q1cyD7dEwinGjOu8wz2UyvbqfsdHRvidsSuMqww/56jHuwuQfQMi8lhX/r1k9
	 pkgW92ESps6yfsD1z+EhJ+c4Z5ijIez9ShaGf/0Pl8hmS3xN3htWt341vQj9gE4zPtr7h0cJkoPy
	 kNHSHcOlqAm/nLpJzhvQwNRvKISru9M65ikr6E/0YTM12RXccbUJ3G7YcVeDk1dBwCV27lOc/Fzx
	 XSHR23bEdXIr9ThQMb6nABesRLbhweLpeZNa14aAeVL1juQUw1tU2atJM6iY56LuUvVnszgEIDm8
	 PuwIXe9T0BdpxAozGCNvIRV0kEWDencIIvksyNTY7pIvL+r/EGwSFHTf+4Kwjim0TKyvADEXkljf
	 4GmyCkVmQ4dwrTu4A998ch4W909ZuXO5pbCRq96AgPgFKlg82b+QZ7EWWNCRkzIi1DWEE6L1nmxh
	 Mo0oPslzutWNoeQHpsu1+UuLHRIUYb+SfGsobU3swkmFlSRIQEdFtqTlglbnBmMgGsK7C6Muw/Tf
	 dJAm9v2h+0nw2qNP+l3onqCYB4/ToOtD57SxxB4eiV/SlQidH2ILrMovgwN4TtXjEhuEPWt/UCow
	 Cw9UDvVkBa/USSb0XN973ViysehlCGt7F1exb3NslHgfQJUnJw0mtmUC0qSHnAiJxP9FS7gmkot7
	 LYL5rJaC/eIY9ukKJ1PyJWJvV9UKN9zl4y2T/8EwfWuvmlyOtA4bmlRtVWtpRGbt0UnzrD3SKZxv
	 lZ/TUKrkiidg/vfNWhNnoeDNLWym1oIa3/lOQTkuBRGwKIBWU3z8P6VAV/yVgblo5ZyRgsn7sG/v
	 M+YhZguJqTAcvLhrLRvi1pik4/NxMSaKoGTPoAcIARso1oDLWhf2g6vuHaBUGTC/3s46DdAi/FZZ
	 hXY0b9
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Guanghui Yang <3497809730@qq.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [RFC] ext4: orphan tracking after a failed truncate
Date: Sun,  9 Aug 2026 13:45:09 +0800
X-OQ-MSGID: <20260809054509.67718-1-3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I am looking for clarification about the intended orphan handling when a
truncate fails after its journal transaction has been restarted.

I reproduced the following using the official kernel.org Linux v6.14
source:

- a large truncate naturally triggers jbd2_handle_restart()
- after the restart, a block-layer fault makes ext4_read_bh() return -EIO
- ext4_ext_truncate() and the truncate syscall return -EIO
- the restarted transaction is committed on disk
- before journal replay, e2fsck -fn reports that the orphan file contains
  no orphan entries
- the inode has i_size 0 but still has allocated blocks beyond EOF
- mount-time journal recovery completes, but the inconsistency remains

In ext4_truncate(), an error from ext4_ext_truncate() jumps to out_stop.
For an inode with a nonzero link count, that path calls
ext4_orphan_del(handle, inode) regardless of the error.  In this run, the
committed post-restart transaction contains the orphan-file block, and the
pre-recovery check reports that the orphan file is clean.

The comment above ext4_truncate() says that an incomplete truncate can be
restarted from ext4_orphan_cleanup() after a crash.  Should the on-disk
orphan entry therefore be retained when block removal fails after the
entry has been added?

There is a second part to the recovery contract that I am unsure about.
The EIO marks the filesystem with EXT4_ERROR_FS, and
ext4_orphan_cleanup() skips orphan recovery in that state.  Is an e2fsck
repair the intended outcome for this class of error, or should ext4 keep
enough orphan state for mount-time recovery to finish the truncate?

 OpenAI Codex (GPT-5)
assisted with reviewing the failure path, preparing the test procedure,
and drafting this RFC.  I reviewed the analysis and ran the reproduction.

Assisted-by: Codex:gpt-5

