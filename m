Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639073;
	b=dlWgR5YjaMPm48WcMocCfq7Mxh9SurPsbMjqLGWbkt3NPdiNyZN3pfqQbxii3ypMLVe7
	 Krj2+bbvRnazrLkGq28Dd5fpCrO9rsraYQUdsC2c+2Bw5BDsia0QyqhJCm0A+wHxT+P1a
	 vVh8rHUSXnwtKhGH42EKXMegoB6nNrvoDXAHeTdN6tLMu797WLgpvC/ouKT9yTF6JYGiE
	 LmVXa8EOp6s1merowYzJUrVFFqR7LZ4UASNll7bQlRR5lekgT8c05Ir19knawIWKCpw87
	 S3C97yKlPyawuH5Y2MH0zyW+CWe2yT4+8DJglCLkKdKQUMAfvu62iFmeD+d6OYp8ixQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639073;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5ieIJanyBEjK9GzgvCDjcdA4rdlAuffQNhskh5KUZ8s=;
	b=gzJWQJtEZs4RIBM0HsA4HO0Za4tx6VzrFqQE4KJZJIK4q4ATbVxosQD4q5rrDzm00IFi
	 EuM+nTxDdEJIS9Mtj63pH7v5EurUXVQPV2w6trh7T7EEPERw9naZ2k6LJje30p4GXZEQi
	 wuok2aYreN+bupZzjOBm6iUrVZFA0/ZSJlCGsvUg0jtaP12N7+ysorwpk37/I+UNdCmxf
	 tuJKY1MxAiNWj+STaf7PzYqYJPULHu1qONjxudDYQCF8Wlb9HkX6PRLqCt+N/2HhOa1jB
	 84NAOIEr293yn0G8SyGvvnYLDvNPpnAfY308gw5WBeGJax8un4echQ/tngFcbSsBV+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwS0hGb3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E139960A3808;
	Thu, 22 Oct 2026 03:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwS0hGb3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9030E1F000D1;
	Thu, 22 Oct 2026 03:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639072;
	bh=5ieIJanyBEjK9GzgvCDjcdA4rdlAuffQNhskh5KUZ8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mwS0hGb3uuaw9sqy9s8sRgVTJaYF1Q3jyouzqIF5hKVc+tCfDKFbHjIixj5TVr3Yo
	 j6Z1RakMEv0Zzzk4TEyVnn+G59ygh54l636s96jBui4V6tINAOqoFiQk6XrIwkQKy6
	 ia4N7LgUsGmRakIgtsKZmvFWemLLwQDVf6OGntkL0gvZc2yv9uXF7GH0okV0R7Jn+i
	 aYmkgaCrPs2tdlHDxwQsL1fyOCrL2oxDxZ91HIkqz+5E5238gEgP7KZ2azMGssJiDa
	 7iVsVbIDbyDUV2hc+L6M5Mvi2W18tY4yLP5gglj71dPQZLXPShP9f+oKnCFU1x94DT
	 O4a6lDibKkRcw==
Message-ID: <sashiko-outbox-180927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 26/41] proc: show UUID and GUID ids in status,
 accept them for loginuid
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <5e8def743ca1ecd53337d7c1ff543cab0ef9b313.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <5e8def743ca1ecd53337d7c1ff543cab0ef9b313.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:51 +0000
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
- [Medium] proc: off-by-one TMPBUFLEN in proc_loginuid_write() rejects GUID=
 with newline
- [Medium] proc: torn read of 20-byte loginuid in proc_loginuid_read()
--

commit 272e06b9ffc63c454062912295a6fc0f1ae20fab
Author: Jan Koester <jan.koester@tuxist.de>

proc: show UUID and GUID ids in status, accept them for loginuid

This commit adds Uid_r, Gid_r, and Groups_r lines to /proc/<pid>/status to
display user and group ids in text form via kuid_str_munged() and
kgid_str_munged(). It also updates /proc/<pid>/loginuid to accept and
display text-formatted uuid and guid ids alongside classic numeric uids.

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6a39de424f62a..ec3147e7ab05e 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1290,20 +1290,26 @@ static const struct file_operations proc_oom_scor=
e_adj_operations =3D {
>  };
> =20
>  #ifdef CONFIG_AUDIT
> -#define TMPBUFLEN 11
> +#define TMPBUFLEN KID_STR_LEN
>  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
>  				  size_t count, loff_t *ppos)
>  {
>  	struct inode * inode =3D file_inode(file);
>  	struct task_struct *task =3D get_proc_task(inode);
> +	struct user_namespace *ns =3D file->f_cred->user_ns;
>  	ssize_t length;
>  	char tmpbuf[TMPBUFLEN];
> +	kuid_t loginuid;
> =20
>  	if (!task)
>  		return -ESRCH;
> -	length =3D scnprintf(tmpbuf, TMPBUFLEN, "%u",
> -			   from_kuid(file->f_cred->user_ns,
> -				     audit_get_loginuid(task)));
> +	loginuid =3D audit_get_loginuid(task);
> +	/* a UUID or GUID loginuid as text, if @ns can see it */
> +	if (!uid_is_legacy(loginuid) && kuid_has_mapping(ns, loginuid))
> +		length =3D strlen(kuid_str(loginuid, tmpbuf));
> +	else
> +		length =3D scnprintf(tmpbuf, TMPBUFLEN, "%u",
> +				   from_kuid(ns, loginuid));

[Severity: Medium]
Can proc_loginuid_read() observe a torn 20-byte kuid_t when reading
task->loginuid concurrently with proc_loginuid_write() ->
audit_set_loginuid()?

In kernel/audit.c:audit_set_loginuid():

	current->sessionid =3D sessionid;
	current->loginuid =3D loginuid;

Updating current->loginuid is an unsynchronized 20-byte struct store, and
audit_get_loginuid(task) in proc_loginuid_read() copies task->loginuid from
a potentially running target task without a lock or seqcount retry loop.

When transitioning between a legacy id (such as INVALID_UID) and a uuid or
guid id, a concurrent reader of /proc/<pid>/loginuid could see the new
.type before all 16 bytes of .uuid/.guid are written (or after .legacy is
overwritten when unsetting), causing kuid_str() to format a corrupted uuid
or guid string. Conversely, seeing the old KID_LEGACY .type with the first
4 bytes of the new .uuid/.guid already stored would cause from_kuid() to
return a bogus numeric uid to userspace.

Would a seqcount or lock around task->loginuid be needed here to prevent
torn reads?

>  	put_task_struct(task);
>  	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
>  }
> @@ -1312,7 +1318,7 @@ static ssize_t proc_loginuid_write(struct file * fi=
le, const char __user * buf,
>  				   size_t count, loff_t *ppos)
>  {
>  	struct inode * inode =3D file_inode(file);
> -	uid_t loginuid;
> +	char tmpbuf[TMPBUFLEN];
>  	kuid_t kloginuid;
>  	int rv;
> =20
> @@ -1332,16 +1338,20 @@ static ssize_t proc_loginuid_write(struct file * =
file, const char __user * buf,
>  		return -EINVAL;
>  	}
> =20
> -	rv =3D kstrtou32_from_user(buf, count, 10, &loginuid);
> -	if (rv < 0)
> -		return rv;
> +	/* a decimal uid, a UUID or a GUID in braces */
> +	if (count >=3D sizeof(tmpbuf))
> +		return -EINVAL;
> +	if (copy_from_user(tmpbuf, buf, count))
> +		return -EFAULT;
> +	tmpbuf[count] =3D '\0';
> =20
> -	/* is userspace tring to explicitly UNSET the loginuid? */
> -	if (loginuid =3D=3D AUDIT_UID_UNSET) {
> -		kloginuid =3D INVALID_UID;
> -	} else {
> -		kloginuid =3D make_kuid(file->f_cred->user_ns, loginuid);
> -		if (!uid_valid(kloginuid))
> +	kloginuid =3D make_kuid_str(file->f_cred->user_ns, tmpbuf);

[Severity: Medium]
Does this size check in proc_loginuid_write() reject a guid in braces when
written with a trailing newline?

In include/linux/uidgid.h, KID_STR_LEN is 39, which is the exact size of a
38-character guid in braces ("{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}") plus
the terminating nul byte.

Meanwhile, make_kuid_str() -> kid_r_from_str() in kernel/uidgid_r.c is
designed to accept an optional trailing newline before checking the length
against KID_STR_LEN:

	if (len && str[len - 1] =3D=3D '\n')
		len--;
	if (!len || len >=3D sizeof(buf))
		return -EINVAL;

Because TMPBUFLEN is defined as KID_STR_LEN (39), writing a 38-byte guid in
braces followed by '\n' passes count =3D=3D 39 to proc_loginuid_write(), wh=
ich
hits count >=3D sizeof(tmpbuf) and returns -EINVAL before reaching
make_kuid_str().

Should tmpbuf in proc_loginuid_write() (or TMPBUFLEN) be sized to
KID_STR_LEN + 1 so that a guid in braces with a trailing newline is
accepted just like decimal uids and uuids with a trailing newline?

> +	if (!uid_valid(kloginuid)) {
> +		u32 loginuid;
> +
> +		/* is userspace tring to explicitly UNSET the loginuid? */
> +		if (kstrtou32(tmpbuf, 10, &loginuid) ||
> +		    loginuid !=3D AUDIT_UID_UNSET)
>  			return -EINVAL;
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D26
