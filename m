Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639060;
	b=rO0/5apW9PXFwyUzG5v085ddoPwV+9SA/YDGixGfnCAddL31G+s3CxuN4f1vNq/CdCM1
	 5v3caszs/AhXAgu+3gc0SSUso9omv+BkRuqVUu1/OF65P/xLYD1lmMndj/meIW26PQSni
	 buLeHUfWfkSyLUp2t7tX4tD98qL/OmB8O0OXIiwIA6nlrNnTWVH3d/VtkT6zlF7NJ3avH
	 XjM1aMkDbqJQlNOguBJIt0+wgSYqB/OIg4mWuqNLHtUbcpMsLNypaDMvFu7VzcRI74F/s
	 UO9sE9qsYmAqokzOpkPTOaNwxGHl7tgZzCWToC+DmZEK4zrS6qCTTmPKseTk8bhZ42w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639060;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DZqNSWPFox7V1DcstQlxkC4fL0rijhsdd51wDSXSCzU=;
	b=pIhp6g9rXEx9RyabHBKETaXldDj2nBEt0WlQp8lVAb7NEFIgcRsmF+Ja/byQMWFGWx3L
	 YW5ulfrWR2TgSZcJiWX92yqBDfG63n9RS1i7IlwGR5rHk0uMXoLmhC/XinLz03B8QvWlH
	 ZFResEtAJzFFmrvZdbGNp4ha14vVjBVTxwxwLSsPInpv9g1dlqyLJPPbWgFMLKkznKFQ3
	 3JpyMunus/1UoBddf1lZV9COqUOAHLFn+evM+NEf0c/QfVXKWCn+zwee7ytfMHfT1NVgf
	 HZv1FGFyDHGPC0MsEeCrMc5JYQvUMv3Gwn20Y2X78ahroxwWt8sNI5sBAa7eQ1+u62Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfJoMNgh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6651060A4AC6;
	Thu, 22 Oct 2026 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfJoMNgh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BF01F000C8;
	Thu, 22 Oct 2026 03:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639060;
	bh=DZqNSWPFox7V1DcstQlxkC4fL0rijhsdd51wDSXSCzU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RfJoMNghV0vxNefp7fTyxo+AOwBNHf+zdTCXlWE1T7aECWkRFIsgvC3D8gOMgQjVs
	 2qqMMKdgCctv3YQKTwVQo6wryBLRLi5NsXCIiv1WF5yyIw+GUvZpkJ1h4F/eA5vZs8
	 CeJqmAB0kU1MVcZ58QBSB4tFaBsx7gFtPrMsFpoDfa+fbcS2ZM93kn7kb0sk4Mz7P/
	 RDk7mHL89Cv9ji4uJ4No7vfzHjDA1wk05fiZ8XMK3MSEom5IYfGIIALcp8fsO7LIoQ
	 Cec5xkPTii2cwneDpsEieKyohH4EwvYGjfih6QPohPbcIMTj8cENIGEwG8OxsdJUOl
	 3eCJVUKIc+JqA==
Message-ID: <sashiko-outbox-180916@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 15/41] SUNRPC: name UUID and GUID users to gssd
 as uid_r=
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <91ba959f368000c0946cb846af3cbb8c97f7e005.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <91ba959f368000c0946cb846af3cbb8c97f7e005.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] sunrpc: hang and leaked upcall in gss_encode_v1_msg() when uid=3D =
is omitted
--

commit ca819aaf8bcc6fad14f1ba4a44164f940c6b1b37
Author: Jan Koester <jan.koester@tuxist.de>

SUNRPC: name UUID and GUID users to gssd as uid_r=3D

This commit updates RPCSEC_GSS v1 text upcalls to pass non-legacy user IDs
using the uid_r=3D key and extends gss_pipe_downcall() to accept a
__kernel_uid_r payload following a sentinel uid of -1. It also rejects bina=
ry
v0 upcalls for non-legacy user IDs with -EACCES.

> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gs=
s.c
> index 8ddc65e894dab..5e9e2cf4e9cb4 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -18,6 +18,7 @@
>  #include <linux/sched.h>
>  #include <linux/pagemap.h>
>  #include <linux/sunrpc/clnt.h>
> +#include <linux/uidgid_r.h>
>  #include <linux/sunrpc/auth.h>
>  #include <linux/sunrpc/auth_gss.h>
>  #include <linux/sunrpc/gss_krb5.h>
> @@ -438,10 +439,23 @@ static int gss_encode_v1_msg(struct gss_upcall_msg =
*gss_msg,
>  	struct gss_api_mech *mech =3D gss_msg->auth->mech;
>  	char *p =3D gss_msg->databuf;
>  	size_t buflen =3D sizeof(gss_msg->databuf);
> +	char idbuf[KID_STR_LEN];
>  	int len;
> =20
> -	len =3D scnprintf(p, buflen, "mech=3D%s uid=3D%d", mech->gm_name,
> -			from_kuid_munged(userns, gss_msg->uid));
> +	/*
> +	 * A UUID or GUID user is uid_r=3D in its text form instead of uid=3D,
> +	 * which gssd versions that don't know it reject rather than taking
> +	 * an overflow uid. Where gssd can't see the user at all, there is
> +	 * neither, and the upcall fails.
> +	 */
> +	if (uid_is_legacy(gss_msg->uid))
> +		len =3D scnprintf(p, buflen, "mech=3D%s uid=3D%d", mech->gm_name,
> +				from_kuid_munged(userns, gss_msg->uid));
> +	else if (kuid_has_mapping(userns, gss_msg->uid))
> +		len =3D scnprintf(p, buflen, "mech=3D%s uid_r=3D%s", mech->gm_name,
> +				kuid_str(gss_msg->uid, idbuf));
> +	else
> +		len =3D scnprintf(p, buflen, "mech=3D%s", mech->gm_name);

[Severity: High]
When gssd reads from the v1 pipe via rpc_pipe_read() -> gss_v1_upcall() ->
gss_encode_v1_msg(), all three branches return 0 and deliver the upcall text
to userspace with msg->errno =3D=3D 0.

When rpc_pipe_read() then calls gss_pipe_destroy_msg(), gss_msg is only
unhashed from pipe->in_downcall if msg->errno < 0:

net/sunrpc/auth_gss/auth_gss.c:gss_pipe_destroy_msg() {
	...
	if (msg->errno < 0) {
		refcount_inc(&gss_msg->count);
		gss_unhash_msg(gss_msg);
		if (msg->errno =3D=3D -ETIMEDOUT)
			warn_gssd();
		gss_release_msg(gss_msg);
	}
	gss_release_msg(gss_msg);
}

Because msg->errno is 0, gss_msg stays on pipe->in_downcall waiting for a
downcall. However, gss_pipe_downcall() matches downcalls to pending upcalls=
 on
pipe->in_downcall solely by uid in gss_find_downcall():

net/sunrpc/auth_gss/auth_gss.c:gss_find_downcall() {
	struct gss_upcall_msg *pos;
	list_for_each_entry(pos, &pipe->in_downcall, list) {
		if (!uid_eq(pos->uid, uid))
			continue;
		...
}

When !kuid_has_mapping(userns, gss_msg->uid), gss_encode_v1_msg() emits only
"mech=3D%s" without uid=3D or uid_r=3D, so gssd is given no user id with wh=
ich to
construct a matching downcall (and in a non-initial user namespace,
make_kuid_r() in gss_pipe_downcall() also rejects the namespace). Likewise,=
 an
older gssd that does not recognize uid_r=3D cannot write a __kernel_uid_r
downcall that matches the non-legacy pos->uid in gss_find_downcall().

With no matching downcall possible to unhash gss_msg or set
gss_msg->msg.errno, won't callers in gss_create_upcall() sleep forever in t=
he
wait loop:

net/sunrpc/auth_gss/auth_gss.c:gss_create_upcall() {
	...
	for (;;) {
		prepare_to_wait(&gss_msg->waitqueue, &wait, TASK_KILLABLE);
		spin_lock(&pipe->lock);
		if (gss_msg->ctx !=3D NULL || gss_msg->msg.errno < 0) {
			break;
		}
		spin_unlock(&pipe->lock);
		if (fatal_signal_pending(current)) {
			err =3D -ERESTARTSYS;
			goto out_intr;
		}
		schedule();
	}
}

while leaving gss_msg (along with its references to gss_auth->kref and
sn->pipe_users) stranded on pipe->in_downcall until the pipe is closed,
causing subsequent upcalls for the same user to coalesce onto the dead
gss_msg in gss_add_msg() and hang as well?

>  	buflen -=3D len;
>  	p +=3D len;
>  	gss_msg->msg.len =3D len;

[ ... ]

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D15
