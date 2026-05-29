Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED95344D99;
	Fri, 29 May 2026 08:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044229; cv=none; b=QkwqtCrRCedbqPPAXfo3S7297eGooNFi+M5mlsDHy3rSe2XVJs4VxmdZ+nX1AMunzozSYTVScpSdRNGbe0RU9wq9iZk9o3iubmiU6iuzN1133IwvuQrGlEdtMm1RsPtJAJE8QluxaUj3+g6m1cY6Rk+ICP0qnHPH5p4y+XINAk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044229; c=relaxed/simple;
	bh=TezqxLuEacBo03YBRah67EKQivItx9+EZUd9S6YufI4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GZPOMHAMroYln7gfooic+e7uVb/GcpVlcwgHMVVopBUslGXNlRCwk7HrhayE6Vnqk8Gotu+J73CUsr9yt/w6RGTAcda3kYCAIWRQpmPeHL3E0k5edB8hqc60qyUBdTu2oUDoZtjAi8RL5ZdPHFwuMQSDRQ4kpL86OdR+hIBZetQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/zblSfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/zblSfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4341D1F00893;
	Fri, 29 May 2026 08:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780044228;
	bh=BsPfU+9UVLsYxwZA0+Z5LJE2Ml8CK2QRYNvHCqUa7r0=;
	h=From:Subject:Date:To:Cc;
	b=n/zblSfJR6HPcqeU2gRKv2R9XgSsgzk6muJMc7wRZiEXi9OJfk4VNV+/WdmA0APZ/
	 biamIzZLTnDUvxGFuFQ3YniWBKvsOvptrpj2eeCj4aKMrQ/vQTfaYgrw/kkZvKVIJw
	 eFWfgFjSmak+hD0pLmBZpkKPpMXuT96WakhLXa2I0x0RYpkcNWuqT+oIJrC3t+sMGs
	 bMJIlWGPmR9dQWvTN/Fe8xcx4nUcZYJOxUueWklubcznVQTxEP6uIfBUDjcQUWalzE
	 I3cdOKVrPsE2C1YzF6G+vjh0Yn0uyKKyjOFxF1Nk6+BzuW7ogg+xzzIulC8/NSAFdd
	 ixJQXYXNbF1sw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/4] super: retire sget()
Date: Fri, 29 May 2026 10:43:39 +0200
Message-Id: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALtRGWoC/22Oyw6CMBREf4V0bUlb2iKu/A/Doo8LVBTMLaKG8
 O9S3Lo8k8mZWUgEDBDJKVsIwhxiGIcNxCEjrjNDCzT4jYlgQjMlNH2N2NPYwkS1dUdmK+2sUWT
 rPxCa8N5dl/rH8Wmv4KYkSA1rIlCLZnBdiu4mToC5ULKRlS4kANemLDgvpRcGCmmdYtarRirY4
 mToQpxG/Ox3Z56W/j2bOWVU6KIpmVAOvD/3gAPc8hFbUq/r+gWBW46f9wAAAA==
X-Change-ID: 20260526-work-sget-6bc80b96cba5
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1362; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TezqxLuEacBo03YBRah67EKQivItx9+EZUd9S6YufI4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRJBh58dcqgNP33rQZzDokJn9Y8P+RaJVX449fmb+cWd
 gh+lIoP6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIpB2MDBec2c4suRadv6Er
 y8No5sXgnqdHi3X74+91mV5KXs2jycLIcOZ2/+1Zf3bUunI4NLwvM1wcftOJb80xpZmms08vWT9
 nNwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

CIFS plus the two ext4 KUnit tests (extents-test, mballoc-test) were the
last in-tree callers, and all three convert cleanly to sget_fc(). That
lets sget() and its prototype come out, taking ~60 lines that only
existed to be kept in lockstep with sget_fc() on every publish-path
change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Move some changes into a separate series.
- Link to v1: https://patch.msgid.link/20260526-work-sget-v1-0-263f7025cedd@kernel.org

---
Christian Brauner (4):
      ext4: convert extents KUnit test to sget_fc()
      ext4: convert mballoc KUnit test to sget_fc()
      smb: client: convert cifs_smb3_do_mount() to sget_fc()
      fs: retire sget()

 fs/btrfs/super.c           |  2 +-
 fs/ext4/extents-test.c     | 22 +++++++++++---
 fs/ext4/mballoc-test.c     | 17 +++++++++--
 fs/smb/client/cifsfs.c     | 43 +++++++++++++++++-----------
 fs/smb/client/cifsfs.h     |  3 +-
 fs/smb/client/cifsproto.h  |  3 +-
 fs/smb/client/connect.c    |  5 ++--
 fs/smb/client/fs_context.c |  2 +-
 fs/super.c                 | 71 ++++------------------------------------------
 include/linux/fs.h         |  4 ---
 10 files changed, 73 insertions(+), 99 deletions(-)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260526-work-sget-6bc80b96cba5

