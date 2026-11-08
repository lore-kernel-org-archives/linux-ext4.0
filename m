Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794171381;
	b=IpKHjoMifJKoPR8LxlzsnNgrj+Djuf2t5m1Y5REOxIz29TdUrS240j6oAJDAGA4VcYhi
	 f8l8m2ufms/CiyNM4YUL59OEoRAUcQ0qekZH+mNL4pL+76eQt/VY37OLvkXnlBmKcYpEt
	 VWjfgwok32G1lyM+j6BSRnHyIDgnMkpmLP5h5RuAi917QarRCjFClt/yEuaduVCVm38Wt
	 CMGWpLfFpfV5jBpcURJOXMxUwpYxOjPF9c6DYERACgZQjcKoYbEDO7zZ8QsLAEb3EJFws
	 qqu08eYuHr6p7LVU8Wc/jZ1Kvr1kWqHOQBc6o77P3ZORjjXH60kys6uDHvklHc/XB2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794171381;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ujZFKpLc0Ix28/V6FG+69l9KmNZz1vlOpwYyVTzHvv0=;
	b=mHJ9W0RZUHgn37I4WJUXVIsKIuqEc3ZFYQo5jvPQZ9nxx2koWVeMUIjOIKF9JJupOKUi
	 thEN7ayLHcOYwy0+7sVh5y5dKXomLzEqpGOI44puO8lt7yt9wRMEBdoGqgq6bw3eyISgv
	 o0sI0/y8JJLwET5UL5rN9ZbjItAvIRN9M5RH7DKyKlw4LgS2BbWa3SeRaCNij+ygmUwNX
	 r4RgdBzk9rGY5ZZOpSMm/m7+9+/w292On8CuTyQAWw4qM94Cvw++BPJ5xK8iCl6PXs9Uf
	 3GYlb1XfEnTcVboBN8zb/a4WgDucafCJW/l//8EoNqFGD+/sFnCMMI1nZJlAh9jhoew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bpx75LLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FA6606A31C
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 20:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bpx75LLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831231F0089F;
	Sun,  8 Nov 2026 20:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171380;
	bh=ujZFKpLc0Ix28/V6FG+69l9KmNZz1vlOpwYyVTzHvv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bpx75LLnHHkuFn/BdYvAqO7IILwge4aTMOT/KUXjfHjadoNL7AX9PRkAxhyc9gIRw
	 3EpK+uLFClVU79BBla9I04nNmVrsPCb09rDwVbQieTGBZfbcFPNEv3mSnDSQFDeF77
	 pCkpqyqhxVQPeAgxqIOXFuZlRu3VEeMZm4zRifesep2GSHR6BWrnn72tOhpcLhNjlX
	 Pw0fuUB5ajIoFoi7SRPU2GIEIQJKeZ0OBoXSmK+CaDkNrnjncPsyoJuiuSLKyk846w
	 ldUhw6MYcbl/koR5L0I5xtgAbiL4/Jmp8TaivwIRCHb7TVxk3bydNHugB3UlojjtnT
	 Lpm17hlKjcr0A==
Message-ID: <sashiko-outbox-204031@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix OOB write in fast-commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 20:56:20 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] ext4: missing block bitmap updates in ext4_fc_replay() [1]
--

commit 5ddbe50e098dc2628bd98eec98bb8cad8442ceb0
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

ext4: fix OOB write in fast-commit replay

This commit re-validates fast-commit record bounds and value lengths
during the replay phase to prevent out-of-bounds writes if an earlier
replay operation overwrites a later record.

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf3702..9edd26a18b92e 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2613,6 +2613,11 @@ static int ext4_fc_replay(journal_t *journal, stru=
ct buffer_head *bh,
>  			ext4_fc_set_bitmaps_and_counters(sb);
>  			break;
>  		}
> +		if (tl.fc_len > end - val ||
> +		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
> +			ret =3D -EFSCORRUPTED;
> +			break;
> +		}
> =20
>  		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
>  		state->fc_replay_num_tags--;

[Severity: Critical]
This problem wasn't introduced by this patch, but can ext4_fc_replay()
skip ext4_fc_set_bitmaps_and_counters() [1] when the last valid
EXT4_FC_TAG_TAIL record is in the final block of the fast-commit area?

Because EXT4_FC_TAG_TAIL pads its payload to the block boundary, the loop
increment advances cur to end right after state->fc_replay_num_tags is
decremented to 0.  The loop condition cur <=3D end - EXT4_FC_TAG_BASE_LEN
then exits the loop before the state->fc_replay_num_tags =3D=3D 0 check at =
the
top can run.  When that block is also journal->j_fc_last, fc_do_one_pass()
finishes without calling ext4_fc_replay() again, leaving blocks allocated
before the crash unmarked in the block bitmaps and subject to reallocation.

[1] https://sashiko.dev/#/bug/linux-07caeb0c-7490-4ef6-a809-3f819db1b121

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204345.1423=
203-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1
