Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794887492;
	b=tbOp2DC7V6jHq++DwxoEhWjQIyBYsjUIADWYmsG8BFw915bipRaHUwr6r+tixTYNNDhZ
	 lQ/QJAXm58TkDgN6C4DVleXY8I4DhmVASrGDk0ob7twHaGeI+Ru7Cx0A36xqxGHq9VnWi
	 hdsLnj2tLWUyS9Zm8vYeoy5g+DWmFzt28H8oZzcnlqqeupK4KeeEgv6c/QltJN7j8PPa6
	 eVm++xi31ieD1ww1xJY3kyhlxSu8VwMOsc1gKSCJukANg0BONut5ttcWb3U5bfhrz2Wsp
	 fvCW50urO/s48VUgKldzlOmOecT0kIqmSOB0pTHEX8SmkW9/EYODH0zwVvv4lJRfE8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794887492;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2mOtm4DwSmoBJhnoupqmif+QbfKTnFIwpHZjvgUCm8Q=;
	b=tLZCsCswkmmk7J+oUuaAneccRtkAl4JuaTUd5i0pz+wzEz3GNt2gQWP67ARnJPg77Xor
	 IodxabOhqv0sO5DPiZmA2uSzizw3LSmvtEStlOWnSKFYHgyQ2R+XR8J8ze3qVhOJtRngR
	 4DKRUKW3t9usYQLkBKvnJpGxcpVwjy9DYJk6mpXzzLAayZXBkiPeOm9jThTYE2WGoXmcP
	 4Z+Hp3wHR330ppSIUd6eREGFCCHiZfy7/sbFVWhMSTmeypZSu3UE9OKoQarQkGZdpMmlc
	 yeizNsP1Q0BvYPphy3xjL27QpCxFRyJcSZNWW6hKsUpdrDzG9dBW3cu2Lc8hL9/f9Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H7Wn4AMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B55606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 03:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H7Wn4AMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6A71F000C4;
	Tue, 17 Nov 2026 03:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794887492;
	bh=2mOtm4DwSmoBJhnoupqmif+QbfKTnFIwpHZjvgUCm8Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H7Wn4AMfJitKm0tjm/et8JNj4pvAQ6PAxReibWv/HBHvDPXMNcIe/aieVdgJlB0Zt
	 9hGdrWzdzirr8r9yllHySWzwa9Ohdj4OsDn9ms3pYu1nhKQ3wXd0XLDEQidUVZviGH
	 DOw8YGAavKYI96RcKvI9CekY+ALLOefj58EBoeOqtPNfcRk468MaCovHTEcwX0PSpF
	 dRDnuMv5cUCI4b+RtTBL2cn3t9bZyGmHcEA0A6+c0jRFJf3hIOQtv+ZdFshLswIn5q
	 1Dw9n82A7z98+lQhlvyqISTEqGECkCBVKqIjm1jx12mtaj6gv1H068Hlpyqk4MDX3F
	 Vws2L4BbzycOA==
Message-ID: <sashiko-outbox-218163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: reserve inode write access before unlinking
 entry
Reply-To: sashiko-reviews@lists.linux.dev
To: Alan <3164729207@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
 <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
 <otvuclstcoaysrnywzdttapxbxg7hq3p7lp3iexy7u5cuj6plx@waqfsi2dg2p4>
 <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 03:51:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] ext4: single-word name in Signed-off-by trailer of commit
  message
--

commit 5832893d419ac26f89a042ffd66a0050e8ae1910
Author: Alan <3164729207@qq.com>

> ext4: reserve inode write access before unlinking entry
>
> __ext4_unlink() removes the directory entry before decrementing the target
> inode's link count. It then dirties the parent inode. If the parent
> inode-table block cannot be read, parent inode dirtying fails after the
> entry has been removed, and unlink returns without dropping the target
> inode's link count. With errors=3Dcontinue, this read error need not abort
> the journal transaction, so the directory update can be committed without
> the corresponding link-count update.
>
> Reserve the inode locations and journal write access for the parent and
> target inodes before removing the directory entry. This makes inode-table
> read and access errors fail before the namespace is changed. Keep the
> existing namespace and link-count update order, and release the inode
> location references on every exit path. Fast-commit replay can skip the
> parent update when the directory entry does not match the target inode, so
> reserve only the target inode in that case.
>
> The original source-derived injection at the journal write-access boundary
> is not evidence for a committed inconsistency: an error after the journal
> has already aborted cannot establish a committed transaction. The relevant
> failure is an actual inode-table READ EIO before journal write access.
>
> Tested on Linux 7.4-rc3 (torvalds/linux commit
> aebb7274476403040d582c61478df8f4a7bf9cd3) with QEMU blkdebug and
> errors=3Dcontinue. On the unpatched kernel, the READ EIO leaves the direc=
tory
> entry removed with Links: 1 after normal unmount; the JBD2 trace shows no
> journal abort and records the transaction commit, and e2fsck -fn reports
> an unattached inode. With this patch, the same error is returned before t=
he
> directory entry is removed; the file remains present with Links: 1 and
> e2fsck -fn passes. No-fault controls pass on both kernels. Also built
> fs/ext4/namei.o with W=3D1.
>
> Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
> Link: https://lore.kernel.org/linux-ext4/tencent_D60E766CE07D3A1847B81DE9=
BC37B4466908@qq.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

[Severity: High]
The Signed-off-by trailer and Author header use a single-word name ("Alan"),
whereas Documentation/process/submitting-patches.rst requires a full real
name for the Developer's Certificate of Origin.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_58D8BEFB603=
08A7011D26F6F7E8C941C2A09@qq.com?part=3D1
