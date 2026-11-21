Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230804;
	b=PXu9z1oh7SkyOIHzZic4J80Ko71cAIvaZS8Cav5vzhxsnHmJOMxqCvGwYG6EZ1syXNGE
	 9mYMuhPGg+ZgKW05qRgbYwr+CwQTwiYG3Tb3jaq9yenzGx57iZ9tuvaxG1bHnIR0rmEM/
	 ITT5wr4sOpiDb0Wi4h5s4OYkMDNS/Scj2DDrCgcv/0gM6R+CklLDh/x4MtWgAy41hmWDR
	 BDIDBaUHQ6m61Y6sQ7q2QZdBE0Cj5cgas/kr++f3SnnouEaCwWpFDCK4ufb/hlTuCHaZO
	 S9l5665vKzjUjtYJpRMkZR0acjOQhfw/XXWd864HgezhAKSCDKFE/t/1H8IX5+lUSmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230804;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=23Ez2iWNIY2YxpFLRgDlRKhLeqLWPzebbogdTUhxsYw=;
	b=fmOMSWMog+beK+EokteKnxVQ3E45GuLeiIFD8HdqgrKGDQjNE6PI4OfKuZavxO+dg7Po
	 kmUq7C+p0xX8F+k/gwopuTlmSEhRzGyCVcWmxgW5+PnQeAASGP97FWaoChrJ4bV36FV6E
	 rQTGNeKSyA3AKWmk+0ACMH7l5Pa3XaFcGaYPq2rAXdpdhyDoDHUlpJY4xW+T95vgvxA36
	 wzYXriCzyqFaqOcomi4R139fQazUz3lZIv9MuQ1SjfrLfqJDCA4Nt5vJdi8+097v1DNN7
	 sSY64ikWAY+VOEOz+2Ls81toyqE0jGiK2eRpeGcGoih52TlUtliR0Eg7jJ4mL6NrZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X87OoRUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5E7606A68A
	for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 03:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X87OoRUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7206F1F000C0;
	Sat, 21 Nov 2026 03:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795230803;
	bh=23Ez2iWNIY2YxpFLRgDlRKhLeqLWPzebbogdTUhxsYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X87OoRUAJV9FiOpMqQx1o3P8OAwFi4WQIb6Dvnx2PSk7lIj8ia8m74csElgQqUyfL
	 Plt4QWmmiQFPtLUb9MsMaoleMCGDjO03LBuWHrmLHdbRopAgzOyQ+PJWZoXMXGA3OA
	 q4Ck6a6u1/u8NoTI1tw4EIZM+pr14PbaGGXmmT0EFxduoR/2dr/wBXkxR+JpSBQqol
	 8kLt9awQPOrpYMNdD8/KY2A8EeaW8gsREfY2Ak/qeARD67BhNO+Nc6C/k0Ae+m5g7I
	 TUDGY6PzwjWmyiHkqFDai0cF1iyCzMQq1iZzSI69XbgIZnvFAXjNb8UK0fNj22bIIB
	 qLRBTOEcFRdMQ==
Message-ID: <sashiko-outbox-226561@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: stop fast commit replay at the end of the fast
 commit area
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VG9tw6FzIFNlbmFydA==?= <ts@perfloop.ai>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <CAEEBa3XJt0XU+5pXNQz_tjZyPEeEnY67i_QGupOnHLnXB=BVDw@mail.gmail.com>
References: <CAEEBa3XJt0XU+5pXNQz_tjZyPEeEnY67i_QGupOnHLnXB=BVDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 03:13:23 +0000
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
- [Critical] jbd2: skipped ext4_fc_set_bitmaps_and_counters() when fast
  commit area is full
--

commit c70236779e98a78f5adca06274fb30cb8d0a0f06
Author: Tom=C3=A1s Senart <ts@perfloop.ai>

jbd2: stop fast commit replay at the end of the fast commit area

This commit changes the loop bound in fc_do_one_pass() from
<=3D journal->j_fc_last to < journal->j_fc_last so fast commit recovery
stops before reading past the end of the fast commit area.

> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index cac8c2cd4a92a..a59de33a2a4a9 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -242,7 +242,7 @@ static int fc_do_one_pass(journal_t *journal,
>  	if (!journal->j_fc_replay_callback)
>  		return 0;
> =20
> -	while (next_fc_block <=3D journal->j_fc_last) {
> +	while (next_fc_block < journal->j_fc_last) {
>  		jbd2_debug(3, "Fast commit replay: next block %ld\n",
>  			  next_fc_block);
>  		err =3D jread(&bh, journal, next_fc_block);

[Severity: Critical]
When the fast commit area is full, does exiting the loop at
next_fc_block =3D=3D journal->j_fc_last skip
ext4_fc_set_bitmaps_and_counters()?

In ext4_fc_replay(), state->fc_replay_num_tags is checked for zero only
at the top of the function and before decrementing it for the current tag:

fs/ext4/fast_commit.c:ext4_fc_replay() {
    ...
	if (!sbi->s_fc_replay_state.fc_replay_num_tags) {
		ext4_debug("Replay stops\n");
		return ext4_fc_set_bitmaps_and_counters(sb);
	}
    ...
	for (cur =3D start; cur < end;
	     cur =3D cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
		ext4_fc_get_tl(&tl, cur);

		if (state->fc_replay_num_tags =3D=3D 0) {
			ret =3D ext4_fc_set_bitmaps_and_counters(sb);
			break;
		}

		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
		state->fc_replay_num_tags--;
    ...
}

Because ext4_fc_write_tail() sets the length of EXT4_FC_TAG_TAIL to cover
the rest of the block, the final tag in block journal->j_fc_last - 1
decrements state->fc_replay_num_tags from 1 to 0 and immediately finishes
the block loop, returning JBD2_FC_REPLAY_CONTINUE.

When the area is not full, fc_do_one_pass() invokes j_fc_replay_callback
on the next block, hitting !sbi->s_fc_replay_state.fc_replay_num_tags at
the start of ext4_fc_replay().  When the last usable block
(journal->j_fc_last - 1) holds the final EXT4_FC_TAG_TAIL, the while loop
in fc_do_one_pass() now terminates before calling j_fc_replay_callback
again.

During PASS_REPLAY, ext4_fc_replay_inode() clears the on-disk block
bitmaps for modified inodes via ext4_ext_clear_bb() and relies on
ext4_fc_set_bitmaps_and_counters() to mark their data and extent blocks
allocated again, so skipping it leaves live blocks marked free on disk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/CAEEBa3XJt0XU+5pXNQ=
z_tjZyPEeEnY67i_QGupOnHLnXB=3DBVDw@mail.gmail.com?part=3D1
