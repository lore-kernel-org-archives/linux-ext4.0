Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795341181;
	b=sVVxQD0AcZIXg8hE14prl/YGDbD4c4QC7IcdxjR2iQmAs8kzFJ/UN+2I7uE9qkTPqp1t
	 dlz1hetrtHOXOVNtYVnzruIaiZqPPAkHnZZ29EI88ro3XfYB80iROdSsK9QF0MlstMunN
	 5B0wrdJsPRvaVflr8rrD25tSKwKzOxKIn5gxBg/g2SbsujL+k1M5o6YUSmhHgLGEZ+lFT
	 lPZkY7bCISLs78P9NPGLqNORzkDCc9Sz8nOWwfpscMMmdwFF3Cvz+T0H2fMd3jBrptiIO
	 GshQDhzIXE9Pz5JkGENeZBq9DPemuzfWGJtkgQiFoQdFfktm9slEi2NYsofKN6XSHug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795341181;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3RDF1WM4SEV/H+sFh+drzidOtNsr4tZRsgJfOGTBjEA=;
	b=D3mEf0guG0uCyFsGx7pW4VsNd79UTVs5yWOLc6d0h/wMEyV2So/k5h/EMfeGAkKZAnjo
	 HTlSHhIZoAhj9oR8hjPBMxTdAtzlnyeVGSdFM2p6+tw6nX3MppuWW3Rp3+svDTzMNu6Jz
	 m/AznmOsXlbhMfVtcjAidKH+OQJLin+lc5QedQXHSDZU1+nmfg6rOVof9oj60eXfLZ0+1
	 7MncmTo6QBDvTYnabchXDa3hT6QWEPRJO/rAjTei1NrX21oASxBcR3od1K1+nREYcMCpe
	 BUZR26/jcoZD/O9XUpyET9uhnHQboy1uVZsdjxRnGVRDtjs39JtGiAZUPvNXwEHMX1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oulL52Ae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2645B606A320
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oulL52Ae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92061F000CA;
	Sun, 22 Nov 2026 09:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795341181;
	bh=3RDF1WM4SEV/H+sFh+drzidOtNsr4tZRsgJfOGTBjEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oulL52AeepTJ/xvB9o2yy4gjmo0Je/JBN7TuUI6c+n2fPuU2yvfgitQmwxqnaXICQ
	 STB+CtLUZcOegV/BQjPTOGvyHGysHZYBBPSgOvDpIFPwbdIa6yXOXCPrtiYojKXafa
	 ISp48CZd5s4QfsQChWzx7ADq9zEdZ4UxvC6EABcWcexPDyJ0zJASmlZRaG6Yp8z4pN
	 aqjz1pC3eGpVkcSh82g0xO7kIH6zc/U6Cy8Aj++ZuJu/T0gzSH5XZSTWXkFkjQqsff
	 dR25wFh/Cf7tVuXinT3CrjXsugaEBCyuWcy7Sms2aFcaau5GLYULBvrppVmrkGIL3B
	 7coINRMUmoowg==
Message-ID: <sashiko-outbox-227865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261122093732.136895-1-arzuagapozosergio@gmail.com>
References: <20261122084939.129223-1-arzuagapozosergio@gmail.com>
 <20261122093732.136895-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 09:53:00 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] selftests/ext4: duplicate skips and false pass in main() on
  shared-block errors
- [Medium] selftests/ext4: prepare_shared_file() stores large_name in
  inode body not block
--

commit acc0f729809bd687fef099d47921332f19729aeb
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit refines ext4 xattr journal credit estimation by accounting for =
an
existing ea_inode reference only when the target attribute currently points=
 to
one and bounding the estimate against the JBD2 transaction buffer limit, al=
ong
with adding an ext4 selftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..313e817671ac3
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c
> @@ -0,0 +1,244 @@
[ ... ]
> +#define LARGE_VALUE_SIZE 65296
> +#define FILLER_VALUE_SIZE 32
> +#define TEST_COUNT 10
> +
> +static const char large_name[] =3D "user.ext4-credit-large";
> +static const char small_name[] =3D "user.ext4-credit-small";
> +static const char target_name[] =3D "user.ext4-credit-target";
> +static const char filler_name[] =3D "user.ext4-credit-filler";
[ ... ]
> +static void report_setup_error(const char *what, unsigned int skip_count)
> +{
> +	int saved_errno =3D errno;
> +	unsigned int i;
> +
> +	ksft_test_result_error("setup %s: %s\n", what,
> +			       strerror(saved_errno));
> +	for (i =3D 0; i < skip_count; i++)
> +		ksft_test_result_skip("setup failed\n");
> +}
> +
> +static bool prepare_shared_file(const char *path, const char *large_valu=
e,
> +				const char *filler, char target_value)
> +{
> +	return create_file(path) =3D=3D 0 &&
> +	       set_xattr(path, target_name, &target_value, sizeof(target_value),
> +			 XATTR_CREATE) &&
> +	       set_xattr(path, filler_name, filler, FILLER_VALUE_SIZE,
> +			 XATTR_CREATE) &&
> +	       set_xattr(path, large_name, large_value, LARGE_VALUE_SIZE,
> +			 XATTR_CREATE);
> +}

[Severity: Medium]
Does prepare_shared_file() place large_name into the inode body instead of
the shared external xattr block?

On a 256-byte inode with i_extra_isize =3D 32, 88 bytes are available for x=
attr
entries and values in the inode body.  target_name uses 40 bytes, leaving 48
bytes free.  Because filler_name with FILLER_VALUE_SIZE =3D 32 needs 68 byt=
es,
ext4_xattr_ibody_set() returns -ENOSPC and spills filler_name to the extern=
al
xattr block without consuming the remaining 48 bytes in the inode body.  Wh=
en
large_name is added next, its value is stored in an ea_inode (i.in_inode =
=3D 1),
so its entry needs only 36 bytes in the xattr table and fits into the inode
body.  As a result, the shared external xattr block only contains filler_na=
me
with e_value_inum =3D=3D 0, and the test never exercises the block_bh e_val=
ue_inum
credit loop in __ext4_xattr_set_credits() or ea_inode refcount updates duri=
ng
block cloning.

[ ... ]

> +	if (prepare_shared_block(shared_a, shared_b, value, readback)) {
> +		shared_ready =3D true;
> +		ksft_test_result_pass("shared external xattr block fixture\n");
> +	} else {
> +		report_setup_error("prepare shared xattr block", 2);
> +	}
> +
> +	if (shared_ready) {
> +		memset(target_new, 0x22, sizeof(target_new));
> +		shared_replaced =3D set_xattr(shared_a, target_name, target_new,
> +					    sizeof(target_new), XATTR_REPLACE);
> +		result(shared_replaced,
> +		       "replace inode-body xattr with shared external block present");
> +
> +		result(xattr_matches(shared_a, target_name, readback,
> +				     shared_replaced ? target_new : &target_old,
> +				     shared_replaced ? sizeof(target_new) :
> +				     sizeof(target_old)) &&
> +		       xattr_matches(shared_b, target_name, readback,
> +				     &target_old, sizeof(target_old)) &&
> +		       xattr_matches(shared_b, large_name, readback, value,
> +				     LARGE_VALUE_SIZE),
> +		       "xattr block clone preserves both files' values");
> +	} else {
> +		ksft_test_result_skip("shared-block replacement needs its fixture\n");
> +		ksft_test_result_skip("shared-block readback needs its fixture\n");
> +	}

[Severity: Medium]
When prepare_shared_block() fails, does calling report_setup_error(..., 2)
and then entering the !shared_ready branch emit four skip results instead of
two?

That produces 12 TAP results for a 10-test plan and inflates
ksft_cnt.ksft_xskip, which can make ksft_finished() compute
ksft_pass + ksft_xskip =3D=3D ksft_plan and exit with 0 even when earlier t=
ests
failed or errored.

Also, in the shared_ready branch, falling back to &target_old when
shared_replaced is false causes "xattr block clone preserves both files'
values" to report a pass when the replacement failed and no block clone took
place.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122093732.1368=
95-1-arzuagapozosergio@gmail.com?part=3D1
