Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749D628504D
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2026 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778588587; cv=pass; b=WHO0XWMXX+pdb+bgb/47MnpJA2q6XBuSWtYVMFWlwkKNfdkGINDuoVdNkDVpJG+L8pBA79AEuH8BRDC9oOGJxSVkH05Z1Oe9Fzo3DcYqtDvufBbAXtMqzAyYWDap0vzQpdIWlDuzuacWDJ/GiIHPONQHOFvfussCNzBhhZNZw3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778588587; c=relaxed/simple;
	bh=snpZtaiuehEpdah6YhTE1cMUtD/Ycgzgmd0f2xm4N5k=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=NZmpz+BxRrvAP/nTkolwnn/+1CwRgypUklVIL/zl9hDU5o0CZ1sevVN7qUDHiLBozQ/Vt6mpBzOekLmFz6kEXAzv2+Jv+Qtsk3n+OGKdEGT8v3VVd4tXztv5KJIHznIkPkmhcfdBe9lqy+JdnfRb6CMR7olmNxAGZUUiIAYEAWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=b3TPlRC0; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="b3TPlRC0"
ARC-Seal: i=1; a=rsa-sha256; t=1778588579; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=krVCyxV1oDyPzzZ4ixQxLhwCeRzCKhSJN7Gi5B0L6WiM4Nn/msPmU2ethZxq7k0/rh6Lfyp7ykNKAf45R63dT54huq8M7u7Gvx2SaCg6g+U2hoW5QKpTICUV1ePLm4mcxACsy9SnfsXAPolxuszaPYn1lqWiw3yQzEmRxvHLpIQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778588579; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=tftwGdSYOF+SPOXairbdqYm2g/X90ABFg53gvL5xLxo=; 
	b=ltklMV4mbUb9dwijde5eX3SckCx6tuxn/jp4aex0Kcbo2T8Or5TiJFdFrxlckLec8eDk7q5ccRJkfOPD5mV8TBXIJ85Gg3RIlKwX+E19bhkaqHb7xaNOGMOm6hqB4cloxZSVufCJ1gEFddlv402aHWKmqs1TxNQOpbLwXxsnb0Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778588579;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=tftwGdSYOF+SPOXairbdqYm2g/X90ABFg53gvL5xLxo=;
	b=b3TPlRC0L6Cr5RtYVJGozNmnqtMKKUHDp93SFyXLD/eiqT5wLTqM/dIjaSTPSAKi
	OFhfpsZlvr0KVg7xeCfi0+stCU2WrJfrXeJ3VViYwr3DXqs37VUyQMXfEyTs6hlPc4j
	BRJV7dMcpXhbDuplzervU17vpgLGEf/aMBNYtN3Y=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1778588576731782.4163117919959; Tue, 12 May 2026 05:22:56 -0700 (PDT)
Date: Tue, 12 May 2026 20:22:56 +0800
From: Li Chen <me@linux.beauty>
To: "sashiko" <sashiko@lists.linux.dev>
Cc: "tytso" <tytso@mit.edu>, "Linux ext4" <linux-ext4@vger.kernel.org>
Message-ID: <19e1c23ebca.6a3c475d372729.498530157652304808@linux.beauty>
In-Reply-To: <20260512022525.BD660C2BCF5@smtp.kernel.org>
References: <20260511084304.1559557-4-me@linux.beauty> <20260512022525.BD660C2BCF5@smtp.kernel.org>
Subject: Re: [RFC v7 3/7] ext4: fast commit: avoid waiting for FC_COMMITTING
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi sashiko,

 ---- On Tue, 12 May 2026 10:25:25 +0800   <sashiko-bot@kernel.org> wrote -=
--=20
 > Thank you for your contribution! Sashiko AI review found 1 potential iss=
ue(s) to consider:
 > - [High] Wait loops using `bit_waitqueue` test the wrong bit on 64-bit p=
latforms, causing permanent deadlocks due to ignored wakeups for files with=
 certain on-disk flags (e.g., encrypted or uncompressed files).
 > --
 >=20
 > Note: The standard inline-diff format for this LKML report has been alte=
red
 > to a free-form summary due to automated system recitation restrictions.
 >=20
 > commit 6a0b3a4122c0edab1e98d39dcec0cf8e11e66265
 > Author: Li Chen <chenl311@chinatelecom.cn>
 > ext4: fast commit: avoid waiting for FC_COMMITTING
 >=20
 > This commit removes the block on FC_COMMITTING during fast commit inode
 > tracking to avoid deadlocks. It instead requeues modified inodes via a n=
ew
 > state flag and adds wait loops in the eviction path to block while a com=
mit
 > is actively using the inode.
 >=20
 > Looking at the newly added wait loop in ext4_fc_del() and the wakeup in
 > ext4_fc_cleanup(), could the use of bit_waitqueue() and DEFINE_WAIT_BIT(=
)
 > with EXT4_STATE_FC_COMMITTING and EXT4_STATE_FC_FLUSHING_DATA cause task=
s
 > to sleep forever on 64-bit systems?
 >=20
 > On 64-bit platforms, the EXT4_INODE_BIT_FNS macro maps dynamic state fla=
gs
 > to bits 32 and above in the i_flags field. For example, the enum values =
for
 > EXT4_STATE_FC_COMMITTING (10) and EXT4_STATE_FC_FLUSHING_DATA (11) are
 > actually evaluated as bits 42 and 43 when accessed through the proper
 > ext4_test_inode_state() helpers.
 >=20
 > However, the 64-bit fallback paths for the wait queues and wake_up_bit()
 > calls in this patch act directly on i_flags using the unshifted enum
 > values 10 and 11. In the context of the raw i_flags field, bit 10
 > corresponds to EXT4_NOCOMPR_FL, and bit 11 corresponds to EXT4_ENCRYPT_F=
L.
 >=20
 > If a file has the encrypted or no-compress on-disk flags set, test_bit()=
 in
 > the kernel's wake_bit_function() will return true because the on-disk fl=
ags
 > are set, rather than checking the intended dynamic state flags. Will thi=
s
 > cause wake_bit_function() to assume the condition is still pending and
 > ignore the wakeup, leaving the task in ext4_fc_del() deadlocked in an
 > uninterruptible sleep?
 >=20
 > --=20
 > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260511084304.1=
559557-1-me@linux.beauty?part=3D3
 >=20

Thanks, good catch. This bug was already in 857d32f26181 ("ext4: rework
fast commit commit path"); this patch just moved the same wait/wake code
into ext4_fc_del().

I think it's cleaner to send a small standalone fix patch first, instead
of folding this into v8. I'll add a helper to map EXT4_STATE_* to the
real wait word/bit, and use it for both bit_waitqueue() and wake_up_bit()
so it matches ext4_test_inode_state() on 64-bit.

I'll look at the other two review mails tomorrow.

Li=E2=80=8B

