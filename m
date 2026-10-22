Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639074;
	b=3c7M1DAbfBP8AN9xPpXs/YYBM9L9svERZuBvd0535tlymhWGr2Y9pfe7kf2RrfeXek9/
	 8U2mcWRmjRpGuRk1NoE8MtqI5u/vBJiq/vZocYXoNxii2ZYkcS54uEcBBgw1eVcF/zmGh
	 +dna48Y03Gwo2af0hflnGRnpIgUGSimq22tWmQYXosSDt144jEFoaDHHNUqg9QfyjiQep
	 lF5GzMSSgnHDUAZ16abOApJodsXzLBHOqoYIioRY2H11mdlwZC3bdpzpxyC3lxgGxbm+0
	 GEPZ60JbG0Wd9GW8tKNvJhLZxBMbsgwcPzdKCLUSjo1qUDZkn26crhGce4ekVnrgVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639074;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k/aE+v1ni2QF3w8lWv8hqgF7cpkH6/pjpLLb+XgT3bE=;
	b=2u5Jk6+AlvqWMdo/w4haf37RaFzMXQLc0VQhwcJnRK5yyvcS58ayD5mA+CHVqgd822tk
	 ZGH2NMrsglHEWX/iVPrZChma/ZloWNbNey9GxlpM+ePWz4JfUASvQHJKU5OuvWP0CugGg
	 jNhFGnuryc8FuwVyEhHfjFs7LGKTBKyh+Ts2agf88VMXHtmfBv3+C1xOodQ2Xgg4cOUlW
	 bvSbkKC5gXa1RdElFhRi4D8RKQNyYqwxpHuTwjoxhJFmj2ybwIU4WlhvSem/sEPjiW737
	 7wLWhSnHsRRvclHSJ79a6tQhD7pEHXNEsIN22YGvP16nGPxNNJojPVLboclg1BurJ8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Qz/m9TYY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316C560A6F64;
	Thu, 22 Oct 2026 03:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qz/m9TYY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FB71F000CA;
	Thu, 22 Oct 2026 03:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639074;
	bh=k/aE+v1ni2QF3w8lWv8hqgF7cpkH6/pjpLLb+XgT3bE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qz/m9TYYiDu6zRbJOCEIhnZEuZr9N7+2dE/KRpqOllgHRLwyctoioHhAtiyOM6clM
	 bwWia3GXjY90u394vbRWvpeFFuDRQ/CxOLWl4/23hkGkdFXCePwWeYq93YDMf3vjZh
	 cTs3m+3TNoSJlkEl2izOa8m0OJ9jwOCnVFbqxrvk4M3zB+X8mztUQo/QBB703O5db5
	 W+XYrJjgN5Bd9q1977vvhsa59Sya6PIJWsO1uXEm4UbtOlxgzOuPSjz+7YWQ/xNHR4
	 8npA6RVjBkPfok3TtimTMQrpdOVAGrLfYt1BPVLg8t4OCfuLBeuXZeFLFVsc1VqH7/
	 mTO/mR5xPfVfg==
Message-ID: <sashiko-outbox-180928@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 27/41] audit: log UUID and GUID ids in full
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <875406238f051dbc4b95221b301b311dc0b75f67.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <875406238f051dbc4b95221b301b311dc0b75f67.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] audit: xfrm_audit_helper_usrinfo() still logs UUID/GUID auid as =
4294967295
- [Medium] audit: Landlock log_domain() still logs UUID/GUID creator uid as=
 4294967295
--

commit 91e2cc101c7d60a9061395bf85632c87b9500902
Author: Jan Koester <jan.koester@tuxist.de>

audit: log UUID and GUID ids in full

This commit replaces from_kuid() and from_kgid() calls in audit record
formatting with KUID_STR() and KGID_STR() so that uuid and guid user and
group identifiers are logged in their text form rather than as -1
(4294967295).

>     audit: log UUID and GUID ids in full
>    =20
>     Audit records print ids with from_kuid(&init_user_ns, ...), which giv=
es
>     -1 for a UUID or GUID. 4294967295 is what audit uses for "unset", so a
>     UUID user's actions would be logged as if there were no login user.
>    =20
>     Print all ids in audit records with KUID_STR()/KGID_STR(): classic ids
>     come out exactly as before (signed where the format was "%d"), UUIDs =
and
>     GUIDs in their text form. The binary AUDIT_SIGNAL_INFO reply keeps its
>     32 bit field.
>    =20
>     Assisted-by: Claude:claude-opus-5-5
>    =20
>     Signed-off-by: Jan Koester <jan.koester@tuxist.de>

[Severity: Medium]
Should xfrm_audit_helper_usrinfo() in include/net/xfrm.h also be converted =
to
use KUID_STR()?

When a task running under a uuid or guid loginuid adds or deletes an ipsec
policy or state, xfrm_audit_policy_add(), xfrm_audit_policy_delete(),
xfrm_audit_state_add(), or xfrm_audit_state_delete() calls
xfrm_audit_helper_usrinfo() with task_valid set to true:

include/net/xfrm.h:xfrm_audit_helper_usrinfo() {
	const unsigned int auid =3D from_kuid(&init_user_ns, task_valid ?
					    audit_get_loginuid(current) :
					    INVALID_UID);
	const unsigned int ses =3D task_valid ? audit_get_sessionid(current) :
		AUDIT_SID_UNSET;

	audit_log_format(audit_buf, " auid=3D%u ses=3D%u", auid, ses);
	audit_log_task_context(audit_buf);
}

Because from_kuid(&init_user_ns, ...) returns (uid_t)-1 for a uuid or guid,
AUDIT_MAC_IPSEC_EVENT records will still log auid=3D4294967295 (unset) inst=
ead
of formatting task_valid ? audit_get_loginuid(current) : INVALID_UID with
KUID_STR() and %s.

[Severity: Medium]
What about Landlock domain audit logging in security/landlock/domain.c,
security/landlock/domain.h, and security/landlock/audit.c?

When a task with a uuid or guid current_uid() restricts itself via
landlock_restrict_self() -> landlock_init_hierarchy_log() ->
get_current_details(), the creator's uid is converted with from_kuid() and
stored as a 32-bit uid_t in struct landlock_details:

security/landlock/domain.h:
struct landlock_details {
	struct pid *pid;
	uid_t uid;
	char comm[TASK_COMM_LEN];
	char exe_path[];
};

security/landlock/domain.c:get_current_details() {
	...
	memcpy(details->exe_path, path_str, path_size);
	details->pid =3D get_pid(task_tgid(current));
	details->uid =3D from_kuid(&init_user_ns, current_uid());
	get_task_comm(details->comm, current);
	return details;
}

When log_domain() in security/landlock/audit.c later emits the
AUDIT_LANDLOCK_DOMAIN record, it logs hierarchy->details->uid with %u:

security/landlock/audit.c:log_domain() {
	...
	audit_log_format(
		ab,
		"domain=3D%llx status=3Dallocated mode=3Denforcing pid=3D%d uid=3D%u exe=
=3D",
		hierarchy->id, pid_nr(hierarchy->details->pid),
		hierarchy->details->uid);
	...
}

For a uuid or guid user, from_kuid(&init_user_ns, current_uid()) yields
(uid_t)-1, causing log_domain() to log uid=3D4294967295. Could struct
landlock_details store a kuid_t instead and format it with KUID_STR() and
uid=3D%s in log_domain()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D27
