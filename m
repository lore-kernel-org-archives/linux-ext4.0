Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6473594A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jan 2026 12:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170386; cv=none; b=fJJHPqpUnJleCrONRccgMPrh1Aq1tb7DIF7u7+6afzv/mG9rn0wV2ttI9d5LVKyx679xo13UaQq2mjU7UAFKmY5HSaNhDb4imheRtf+5ase9u1e5wru5qB7lX2RdXjcrot8MRfYbROEHzx/KcOC0mtK5tlwPAcu6DenomC8DtPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170386; c=relaxed/simple;
	bh=SxxnOKJjWtI8Xk/oXP2qSFACyT6VIQrWodc/Zsy/buA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PaNpDXis0FPdgQCOysI50Bm3jCoVA5NK+9tide8cYc3SFnQUaH5F0jDctO41Zq3RX+6BUh9EcI9dikrIgS+PEtW+OqI5l0sQCdjFMP8aY2DITPwUkjPUNk7IwdFLAMXtsGeRk7r3+vrFUIzX30/o+me5zFh6pgS8KZwNq2apUSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hu4c+1Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hu4c+1Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8645C4CEF1
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jan 2026 12:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769170385;
	bh=SxxnOKJjWtI8Xk/oXP2qSFACyT6VIQrWodc/Zsy/buA=;
	h=From:To:Subject:Date:From;
	b=hu4c+1YpEue/BozZSL7RN6QoUvGW0XSRZpQd9CPM/bIqrqr4nA9EwbFBiCV+rheq9
	 d+JcTp/B1hyldTdcsMovhk12klkd2e0En2vhcDlt26hOJ8IkdBaGFEtL1l4V9w0ejm
	 +wGPg0OhjJp1yHchuDbfz0lBH2Fp2qSmS0OuZZaJgXgzOuFljFQCewBiuv5gXuud7L
	 QVd+H3DlO2LGgNSKE/aS3G6KadqN7q1UYL9eT0Ut/p/Nbotqq/t8bm7XMzj9KZGbhb
	 KvHZ4qQU3ePE+yQ3s82CqxVphHtGM/AeZyiESJPEbMOHTXfMelPXYUl4i4ijxMcmKb
	 AH88r4Q+a75WA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id BE8B4C3279F; Fri, 23 Jan 2026 12:13:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 221007] New: Online ext4 defragmentation fails on 'inline'
 files (feature inline_data_
Date: Fri, 23 Jan 2026 12:13:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: deknuydt@esat.kuleuven.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-221007-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D221007

            Bug ID: 221007
           Summary: Online ext4 defragmentation fails on 'inline' files
                    (feature inline_data_
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: deknuydt@esat.kuleuven.be
        Regression: No

Hi,

If one has an ext4 filesystem, with enabled feature flag 'inline_data', and
there are effectively inline files, then the e4defrag tool crashes with a
segfault. Bit exotic I admit, but we really use this...

How to reproduce:

----
> cd /tmp
> dd if=3D/dev/zero of=3Dext4.ima bs=3D1M count=3D10
> mkfs.ext4 ./ext4.ima=20
> debugfs -w ./ext4.ima
debugfs 1.47.3 (8-Jul-2025)
debugfs:  feature inline_data
Filesystem features: has_journal ext_attr resize_inode dir_index orphan_file
filetype needs_recovery extent 64bit flex_bg metadata_csum_seed inline_data
sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
orphan_present
debugfs:  q
> mount ./ext4.ima /mnt
> echo 'This is a very small file' > /mnt/smallfile.txt
> lsattr /mnt/smallfile.txt
------------------N--- /mnt/smallfile.txt
> # File is indeed inline
> e4defrag -c /mnt
e4defrag 1.47.3 (8-Jul-2025)
<Fragmented files>                             now/best       size/ext

 Total/best extents                             1/0
 Average size per extent                        0 KB
 Fragmentation score                            inf
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This directory (/mnt) needs defragmentation.
 Done.
> # Obviously wrong, but not problematic
> e4defrag  /mnt
e4defrag 1.47.3 (8-Jul-2025)
ext4 defragmentation for directory(/mnt)
Segmentation fault         (core dumped) e4defrag /mnt
> # Should not happen; occurs at first encounter of an inline file, always
---

e4defrag should totally ignore inline files, as they cannot be (de)fragment=
ed.

Cheers, B.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
