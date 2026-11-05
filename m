Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907350;
	b=GHCE7KbAh0h5eIhaHGM0OiNeIGhSeFz3E7KrNWuMer16fGeh9rQnWqtNW68VzoYQvPT/
	 sDMxCRn9VrbTfk5lcD/NdhK8YPNMy1IIbKcETwwkWgX484OvUcTqKHyf+5XwTZ6Jm/GrK
	 i51mWx2AR9EdAIEEq1DKzWfFE7szIWIipGEtyRIaLHE33zuBsHLgSZUMv7+5mGjdZogz1
	 NsG84nVQnl5O25XsuD79P0j4oml3aRGQEUciZcIDkQiPfxH2kVayyGOL6U7tb/nJwujh3
	 zTtjvMUlNAxq2zmMdPUoBKOX/m+aL1XznQcnaHOM+q8wngV7wA8+6iJXKUXi9EAKdNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907350;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AmN7iDpzjJ1PM6HacIbA4oMAV9jT2VXf3oFN7TUN1kQ=;
	b=rkPY+2A79rpLZL2cF3vHl3/4/2D0kmQ3W3WjTkdPmqUrE0p78sSCnZ5Px/Pb0DCjplax
	 FkLjH2l8TDF30yUcHhT/z3hugurChTGZIil5HZCNuvaZYwjaWvnhUQg/24TxYt26toSXp
	 18BUI3NXh01lpb0TfZGPVbof9ha6SJNRVkyLwvpul5Xr96Qo98Dc+JRRUiKfLVThNV+d9
	 BYWzIhlQ5HrdB2Nid8ezQ4f782A7QQjrEnFIUSgr/ztPOl2/YUxmVf9Ouh6THPOWeoL6r
	 EEuVvuYFh4BIqd9yFYPJmXGJ0oAbUAfRZDwuD6WFvkhdPO5xpfii7ec2BGW+k/agVeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2b0FoPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B76079C0B;
	Thu,  5 Nov 2026 19:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2b0FoPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C061F0089E;
	Thu,  5 Nov 2026 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907350;
	bh=AmN7iDpzjJ1PM6HacIbA4oMAV9jT2VXf3oFN7TUN1kQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F2b0FoPlGpVNh9mR9X4mwXarD/KuCYBVnvUmH6E7tZhJtBt5PCXx933IV6aiReouK
	 LnK4sp79dqsWsQgIRBB52e6C2scR+7O9aq42OmuiMuAhSvxgt8qaQEjRMxcJps+5xW
	 VdeI/08WnjHl5IfcKYrPNVcCkskBx+YzqyRBgsiWHP62+S9vXdFt+dSnKmNPdL54Gi
	 Fu1iRVyhor6sLsyNi3KpdJnVwZfldWCmfqPHKyXacsYeRvCGc5d0g5zBMwG5Z1zMa4
	 riwDW9+fwdB3AHVr9RxmUYb4iBKW9d+rhmsuBt5B7UD8oM7aTO9IwB8MyCJWnccLPv
	 tGGpP6SDL1kpA==
Message-ID: <sashiko-outbox-199947@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 17/23] fs/proc/vmcore: let procfs copy out
 reads
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, tytso@mit.edu, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-core-v2-17-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-17-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:48 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry. __read_vmcore() fills procfs' buffer
> through a kvec iov_iter. So a read goes through that buffer now instead
> of straight from the old memory into the reader's, which is what
> splice() did already. mmap() isn't affected. On ppc64 a machine check
> while reading the old memory used to be recovered through the exception
> table of copy_to_user(), by accident. copy_oldmem_page() copies with
> _copy_mc_to_iter() now, so a read through procfs' buffer recovers from
> it as well.
>=20
> The buffer is 128k, which keeps the entry pinned for one such piece at
> a time, and /proc/vmcore asks for PROC_ENTRY_FULL_READS so that a
> larger read is filled in pieces. kexec-tools treats a short read of it
> as fatal. A read that faults on its buffer in a later piece returns the
> pieces before it now instead of failing with -EFAULT. fadump removes
> /proc/vmcore when its memory is released and that no longer waits for a
> reader that faults on its buffer.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D17

