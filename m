Received: from smtp.cs.unc.edu (smtp.cs.unc.edu [152.2.131.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09CA4A0F1E;
	Wed,  2 Sep 2026 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.2.131.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365297; cv=none; b=auI+ZyTGhgHt+gAgHWoNnhmFKYwhnNwcihv3WWfSC3/6Vxb5UCW9Ob7i8wVqCKARLjg48kuBvZrqGPLmttUcicg9viUmKnCiMFew0AxYI4rF2ZP3Z1AbBQ9EGX8A16O5rinw7SfWEkvxZYy2ZT7f4Htdo+wOUIyf4OFZAdyCiNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365297; c=relaxed/simple;
	bh=9zKVMsOP+m990/PLnODgBfhdpHmHoj1oAaig8acR38w=;
	h=MIME-Version:Content-Type:Subject:Cc:To:Date:Message-Id:From; b=gz3WoVmEQVhh3QVCT7tRZ/Sn4tU1nrhyLA8To54X5z2TYV3scrXhB/9iJbKBSWqUsgEP3LCZQiLkMDvWi5B4nXdEdzrErCZTb4ZILwSty9puvYdqEj8AL2Q3/JCbnZbZT8Pz6H0DAz/GkHNk6feQKv7pCqp7LWfM6TOquTFP6xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; spf=pass smtp.mailfrom=cs.unc.edu; arc=none smtp.client-ip=152.2.131.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu [152.2.130.143])
	by smtp.cs.unc.edu (8.18.2/8.18.2/Debian-1) with ESMTP id 682G3vrs906793;
	Wed, 2 Sep 2026 12:03:57 -0400
Received: by cobra01.cs.unc.edu (Postfix, from userid 439884)
	id A55AA600BB; Wed, 02 Sep 2026 12:03:52 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1804289383-1788365032=:4131923"
Subject: Possible regression: ext4 lsetxattr returns ENOSPC on malformed image since v7.3-rc1
Cc: <linux-kernel@vger.kernel.org>
To: <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
User-Agent: mail (GNU Mailutils 3.20)
Date: Wed,  2 Sep 2026 12:03:52 -0400
Message-Id: <20260902160352.A55AA600BB@cobra01.cs.unc.edu>
From: Hengyu Liang <hengyul@cs.unc.edu>

--1804289383-1788365032=:4131923
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-ID: <20260902120352.4131923@cobra01.cs.unc.edu>

Hi,

We found a stable ext4 behavior change: with the same malformed ext4 image,
a large lsetxattr() succeeds through v7.2, but returns ENOSPC on v7.3-rc1.

The minimized syzlang reproducer is attached as repro.prog.

The relevant operations are:

syz_mount_image$ext4(..., "./file2", ..., 0x42f, <embedded image>)

open("./file2",
     O_APPEND|O_EXCL|O_NONBLOCK|O_SYNC|O_TRUNC, 0)

lsetxattr$trusted_overlay_upper("./file1",
                                "trusted.overlay.upper",
                                <65079-byte value>, 65079, 0)

Observed results:

v6.18 through v7.2:

    syz_mount_image: success
    open:            success
    lsetxattr:       success

v7.3-rc1:

    syz_mount_image: success
    open:            success
    lsetxattr:       -1, errno=ENOSPC (28)

The behavior is stable across repeated runs.

The embedded filesystem is malformed. Running e2fsck -fn reports multiple
inode, directory-entry, and symlink inconsistencies, so it is not obvious
whether the old success result or the new ENOSPC result should be considered
correct.

One detail appears potentially relevant.

The filesystem has:

s_last_orphan = 15

and inode 15 is the root-level /file1 used by the lsetxattr() operation.
It is an inline-data inode with:

i_extra_isize = 32

while the mount options request:

debug_want_extra_isize=104

During mount-time orphan cleanup, /file1 can therefore be processed through:

ext4_orphan_cleanup()
  -> ext4_process_orphan()
  -> ext4_truncate()
  -> ext4_inline_data_truncate()
  -> ext4_mark_inode_dirty()

The v7.2 to v7.3-rc1 range contains:

7461c60b9c6a
ext4: skip extra isize expansion during mount to prevent deadlock

This commit skips extra-isize expansion while the superblock is not active,
and its commit message specifically mentions the
ext4_process_orphan() -> ext4_truncate() -> ext4_mark_inode_dirty()
path.

This seems like a plausible source of the behavior change, since it could
leave the inode in a different state before the later lsetxattr() call.
However, I have not established that this commit is the direct or only
cause.

Neither behavior is obviously correct to me: the older kernels allow the
operation to succeed on a malformed filesystem, while v7.3-rc1 returns
ENOSPC rather than a corruption-related error. Therefore, I am not sure what
the expected behavior should be, but this seems to indicate a potential bug
in how ext4 handles this malformed state.

The reproducer can be run with syz-execprog, for example:

syz-execprog -os=linux -arch=amd64 \
    -executor=syz-executor \
    -sandbox=none -procs=1 -threaded=0 -repeat=1 \
    repro.prog

Thanks,
Hengyu

--1804289383-1788365032=:4131923
Content-Type: text/plain; charset=UTF-8; name="repro.prog"
Content-Disposition: attachment; filename="repro.prog"
Content-Transfer-Encoding: base64
Content-ID: <20260902120352.4131923.1@cobra01.cs.unc.edu>

c3l6X21vdW50X2ltYWdlJGV4dDQoJigweDdmMDAwMDAwMDA0MCk9J2V4dDRceDAwJywgJigweDdm
MDAwMDAwMDFjMCk9Jy4vZmlsZTJceDAwJywgMHg0MDQsICYoMHg3ZjAwMDAwMDAyODApPXtbe0Bu
b2dycGlkfSwge0BqcWZtdF92ZnN2MH0sIHtAZGVidWdfd2FudF9leHRyYV9pc2l6ZT17J2RlYnVn
X3dhbnRfZXh0cmFfaXNpemUnLCAweDNkLCAweDY4fX0sIHtAZGVidWd9LCB7QG5vbWJjYWNoZX0s
IHtAcXVvdGF9LCB7QG5vbGF6eXRpbWV9XX0sIDB4MywgMHg0MmYsICYoMHg3ZjAwMDAwMDA5NDAp
PSIkZUp6czI4OXJIRlVjQVBEdnpDYXQvV1ZpcVQrYVZvMVdNZmdqYWRKYWUvQ2lLSGhRRVBSUWp6
RkpTK3kya1NhQ0xVR2pTRDFLd2J0NEZQd0xQT2xGMUpQZ1ZlOVNLSkpMcTZlVjJaMUpkamU3YVpK
dXN0WDlmR0NTOTJiZTh0NTNaOTd1ZS9OMkF1aFp3OW1mSkdKL1JQd2VFUU8xYkdPQjRkcS9XOHVM
VTM4dkwwNGxVYW04OVZkU0xYZHplWEdxS0ZxOGJsK1I2WXRJUDB2aVNJdDY1eTlmT1Q5WkxzOWN5
dk5qQ3hmZUg1dS9mT1c1MlF1VDUyYk96VnljT0gzNjVJbnhGMDVOUE4rUk9MTzRiZzU5TkhmMDhH
dnZYSHRqNnN5MWQzLytOaW5pYjRxalE0YlhPL2hrcGRMaDZycnJRRjA2NmV0aVE5aVVVcTJiUm4r
MS93OUVLVlpQM2tDOCttbFhHd2RzcTBxbFVubWcvZUdsQ3ZBL2xrUzNXd0IwUi9GRm44MS9pMjJI
aGg1M2hSc3YxU1pBV2R5MzhxMTJwQy9TdkV4LzAveTJrNFlqNHN6U1AxOWxXMnpQZlFnQWdBYmZa
K09mWjF1Ti85S292eTkwYjc2R01oZ1I5MFhFd1lnNEZSR0hJdUwraUdyWkJ5UGlvVTNXMzd4SXNu
YjhrMTdmVW1BYmxJMy9Yc3pYdGhySGY4WG9Md1pMZWU1QU5mNys1T3hzZWVaNC9wNk1SUC91TEQr
K1RoMC92UExiRisyTzFZLy9zaTJydnhnTDV1MjQzcmU3OFRYVGt3dVRkeEp6dlJ1ZlJBejF0WW8v
V1ZrSlNDTGljRVFNYmJHTzJhZS9PZHJ1Mk8zalgwY0gxcGtxWDBjOFZUdi9TOUVVZnlGWmYzMXk3
SjRvenh3Zks2Nkt0WDc1OWVxYjdlcS9vL2c3SUR2L2UxdGUveXZ4RHliMTY3WHptNi9qNmgrZnQ1
M1RiUFg2MzVXODNiRHZ3OG1GaFV2akVidVMxMnVOcnQ4LzBWUnVZclY4RnYvSXNkYjkvMkNzdmhO
SElpSzdpQitPaUVjaTR0Rzg3WTlGeE9NUmNXeWQrSDk2K1luM3RoNy85c3Jpbjk3VStWOU43SXJt
UGEwVHBmTS9mdGRRNmVCbTRzL08vOGxxYWlUZnM1SFB2NDIwYTJ0WE13QUFBUHozcEJHeFA1SjBk
Q1dkcHFPanRkL3dINHE5YVhsdWZ1R1pzM01mWEp5dVBTTXdHUDFwY2Fkcm9PNSs2SGcrclMveUUw
MzVFL2w5NHk5TGU2cjUwYW01OG5TM2c0Y2V0NjlOLzgvOFdlcDI2NEJ0NTNrdDZGMzZQL1F1L1I5
NmwvNFB2YXRGLzkvVGpYWUFPNi9WOS8vSFhXZ0hzUE9hK3I5bFArZ2g1di9RdS9SLzZGMzZQL1Nr
K1QxeCs0ZmtKU1RXSkNLOUs1b2hzVTJKYm44eUFRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB
QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB
QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB
QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB
QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB
QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFkTWEvQVFBQS8v
OVFPT2JWIikKb3BlbigmKDB4N2YwMDAwMDAwMDAwKT0nLi9maWxlMlx4MDAnLCAweDEwMWU4MCwg
MHgwKQpsc2V0eGF0dHIkdHJ1c3RlZF9vdmVybGF5X3VwcGVyKCYoMHg3ZjAwMDAwMDAxMDApPScu
L2ZpbGUxXHgwMCcsICYoMHg3ZjAwMDAwMDAwYzApLCAmKDB4N2YwMDAwMDAwMDQwKT1BTlk9W10s
IDB4ZmUzNywgMHgwKQo=
--1804289383-1788365032=:4131923--
