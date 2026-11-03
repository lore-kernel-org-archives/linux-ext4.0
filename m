Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718096;
	b=n7hKHZIq2+w/n7eVQOsU3SRwSxfZt5XjZzFGnAghkKlq1udJlxqtfZfOTY7MuLzuHFLM
	 NBvGBTwuv/asG2CYrjJSK8zEAegp8mO7iXzyYCNjD8ADP9jDhzlq0hi/di249d168gMK9
	 n6Ug+yyOPCJPDrkH0flAOn/YYlfopbVMAWLKe6hgt6tjxbtilad2fU+atuoC8ausgGs0q
	 0CYsZyrzkvnE6eJpscStbG412VEea2HhRp9sbPu4lo+Lljfa81ChsDpYhYNHHWcJEB5ea
	 quwhJjv8f45lQeA7hhvV8dvL2dwxJ8DlfBy8js+wFAxwlQNHiS+TWBxkHNIbdkprKlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718096;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1VZl7qidssi1ktD3Tb5xCqeZKKhCHxpcCGjwzNwohWM=;
	b=Rs3QbM7UhELAhWBgemqM4SdztekW1xjrmvoHVy7yUSt6o9Q09c8QUKNRoJiJqZtDDyy2
	 CKQD49AYWKisvt4OJQ3zA70Qq95FTinzymJRbs6o7yyineiEMkowLnCG3At5ZTzhAOaNJ
	 eS4gMAPJ4VXaem5shLUPbTyYpLmBg3HgUI4gshPzPOMEA91YI8+RmnM0BgF5HJF5jnx/M
	 H6Gf0ZiL+W1K+ANTp7rozSX/17ggEzt9rfA2S8B7EJZJAQSSj0azAHif8stqR8k8qCauy
	 7EPES7pd/IbmXFc5O3DjmLuRUOH/XUiIZvAIDU0Y+H92WXTBjwuDtnjjZsymF8EaynQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lB9ymstx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494BC6071C0C;
	Tue,  3 Nov 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lB9ymstx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A97D1F00A15;
	Tue,  3 Nov 2026 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718095;
	bh=1VZl7qidssi1ktD3Tb5xCqeZKKhCHxpcCGjwzNwohWM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lB9ymstxD2jW9FJnjd7yfwgHQCygouVuaUNrPu/PoynIqBUhwdCZzT2zz6hDyMWfw
	 YcZohJmiuou7CXmFeQkBbobxsY7W3rz8baS8GVRJO0kQ8rp7jqpzXBDOF20ZwRkSnG
	 nErT+ShqWAVZWSSCrWbcFrcMc6bjV6OhjCsDbsHj6dNwDTLta4HQXunuCYdd8pGy5N
	 QM0q3S+koNafy+7N3iP/fwwlIqk3Bi1Wb1hFNC1OOvd3tT4xgM2trp03tV1cyoUKB+
	 JSxbtARnxikJyDqg4WFDJfKyHT4r+mahZr7saUIEqSOy07BNqSd/NKBk4ATzIkxAz4
	 zi3pQsJaFbcxw==
Message-ID: <sashiko-outbox-195541@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 14/16] fs/proc/vmcore: let procfs copy out reads
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
In-Reply-To: <20261102-work-procfs-core-v1-14-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-14-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:33 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D14

