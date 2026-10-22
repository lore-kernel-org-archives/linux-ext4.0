Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639086;
	b=wC6ax0L/k4ZpLrzfH9/qZuGPZ5inR1Zo8rau1SqeiWCUp7eVzMpf5eIVEQP3yOUxm2WK
	 wZfmdKYAjfjkO5/8NqmWtY4yXtF4iW4NVxHjO0KuwctcmgS3fUIJ2HVgtvSSNzeO3Wub0
	 1qE73zKzHzQlEji0KX1yFc4BUxXxuDZr0OGAM0A+x995fmbOz9tebQitvKZhyXS+nloeI
	 MSdX7cgOUWvHIJs/m+4/rR75do2yUe4vqYJkAGd8VTMIybsNSA0nUd25t8gbLldMxbJjC
	 PslCtNkNqk7vDc02fLhSGUJXjaH0yzbj/tSU/5jxFeU0NIUzbXGaLppDY3sJjnIsVsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639086;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HVCrkqMFSge/nW0W1PaTatXl4WyYpNcZRZzC0fyinhc=;
	b=G7RvO13sICgzAdq5AIJS4Hxe5Mr3jdm5r/ZEomxj2Iet7hQtlvr2q4rmKkaQSlwM4Ib6
	 x0h+kV31bVR001ttswVo3yEhXNHIH4vO+6DFNxYJSJPXVrf9LcS0O5e6PCkGyb5VuGxeN
	 IMTT5DlTrbakyqz98AJTE8CfUDj3aaJ7TPGC8ZERxLZuwO8AjsxUT+6EQg7UzrbXNJHCy
	 APXXU29WJDklllYXa4prkge4czB18ohCL+qAdS3IZKS+7p01bF6PUfGPk7jr+ejQAKzRw
	 s0NuKqwg0xMFabtQRYqCz0RkaRq5eeKbM1F59EkLo/vvkJv9PBoFHOTyZKdoNnBkx/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EHRGH+RE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E98606A337;
	Thu, 22 Oct 2026 03:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EHRGH+RE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133441F000C2;
	Thu, 22 Oct 2026 03:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639085;
	bh=HVCrkqMFSge/nW0W1PaTatXl4WyYpNcZRZzC0fyinhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EHRGH+REMKJQacf1fdufFWhLvg1uXoAvoPh7M0eChOktk107WkmoBmaM6Pc2BWFWY
	 DTarmsnnPxX//xUKskd9+4LaDBdihHJh41Q9vare8vrsakAvZEuKrP8hhICOXIFY40
	 p0J2XwBoLLG6e4GJmsA0Lr0COwemGHoRGL25J/NdJw6mBPESviDpbXTd68VVkuhBqM
	 pk1ZKUa8AdZrj5cuokMWBGGKzpTKv0ViqCzcF9ILzkzcXJoncMVuGLVlDihF01rjNX
	 Ul3sl0SEs6G3OQJA93YonBazRJcB4HDrvyxOy33zAzQWL28upZdd+LDhECzLI3+DNG
	 qzoTslGLCmyow==
Message-ID: <sashiko-outbox-180937@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 36/41] selftests: add tests for UUID and GUID ids
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <fe7cdf53b4cc8e404778fb91dc5e44e48197b48a.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <fe7cdf53b4cc8e404778fb91dc5e44e48197b48a.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] selftests: uid_r: acl_v3() writes POSIX ACL xattr fields in host=
 byte order
- [Medium] selftests/uid_r: fail instead of skip on ENOSYS in signalfd and =
ipc tests
- [Low] selftests: uid_r: FIXTURE_TEARDOWN() leaves mkdtemp() directories i=
n /tmp
--

commit b236f646b555e600321fde8fdcedd3ac92eccb4e
Author: Jan Koester <jan.koester@tuxist.de>

selftests: add tests for UUID and GUID ids

This commit adds a kselftest suite for the *_r system calls and extended
kernel interfaces supporting UUID and GUID user and group identifiers. It
covers ID validation, credential switching, supplementary groups, filesystem
ownership on tmpfs, socket credentials, signalfd, SysV IPC, POSIX ACL v3
xattrs, /proc/self/status, and user namespace restrictions.

> diff --git a/tools/testing/selftests/uid_r/uid_r_test.c b/tools/testing/s=
elftests/uid_r/uid_r_test.c
> new file mode 100644
> index 0000000000000..88397bf3dae7e
> --- /dev/null
> +++ b/tools/testing/selftests/uid_r/uid_r_test.c
> @@ -0,0 +1,535 @@
[ ... ]
> +/* a private tmpfs at a fresh directory, for file tests */
> +static void private_tmpfs(struct __test_metadata *_metadata, char *dir)
> +{
> +	strcpy(dir, "/tmp/uid_r.XXXXXX");
> +	ASSERT_EQ(0, unshare(CLONE_NEWNS));
> +	ASSERT_EQ(0, mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL));
> +	ASSERT_NE(NULL, mkdtemp(dir));
> +	ASSERT_EQ(0, mount("tmpfs", dir, "tmpfs", 0, "mode=3D1777"));
> +}
[ ... ]
> +FIXTURE(uid_r) {
> +	char dir[64];
> +};
> +
> +FIXTURE_SETUP(uid_r)
> +{
> +	id_r id;
> +
> +	if (geteuid() !=3D 0)
> +		SKIP(return, "needs root");
> +	if (sys(__NR_getuid_r, (long)&id, 0, 0, 0, 0) =3D=3D -ENOSYS)
> +		SKIP(return, "no *_r system calls");
> +	self->dir[0] =3D 0;
> +}
> +
> +FIXTURE_TEARDOWN(uid_r)
> +{
> +}

[Severity: Low]
Does FIXTURE_TEARDOWN(uid_r) leak the temporary /tmp/uid_r.XXXXXX mountpoint
directories created by private_tmpfs()?

In tools/testing/selftests/uid_r/uid_r_test.c, private_tmpfs() calls
unshare(CLONE_NEWNS) and makes mount propagation private, then calls
mkdtemp(dir) on the underlying /tmp filesystem before mounting tmpfs onto
dir.

When chown_r_statx, create_as_uuid_fsuid, posix_acl_v3, and user_namespace
call private_tmpfs(_metadata, self->dir), the private tmpfs mount is cleaned
up when the test child process exits, but because FIXTURE_TEARDOWN(uid_r) is
empty, the underlying self->dir directory in /tmp is never unmounted and
removed with rmdir(self->dir) when self->dir[0] is non-empty.

[ ... ]
> +TEST_F(uid_r, signalfd_uid_r)
> +{
> +	id_r u =3D uuid(11), s0 =3D legacy(0), got;
> +	struct signalfd_siginfo ssi;
> +	sigset_t mask;
> +	int sfd;
> +
> +	sigemptyset(&mask);
> +	sigaddset(&mask, SIGUSR1);
> +	ASSERT_EQ(0, sigprocmask(SIG_BLOCK, &mask, NULL));
> +	sfd =3D signalfd(-1, &mask, 0);
> +	ASSERT_LE(0, sfd);
[ ... ]
> +TEST_F(uid_r, ipc_stat_r)
> +{
> +	id_r u =3D uuid(12), g =3D guid(13);
> +	struct ipc_perm_r_t pr;
> +	struct shmid_ds ds;
> +	int id;
> +
> +	memset(&pr, 0, sizeof(pr));
> +	pr.mode =3D 0640;
> +	pr.uid =3D u;
> +	pr.gid =3D g;
> +
> +	id =3D shmget(IPC_PRIVATE, 4096, IPC_CREAT | 0600);
> +	ASSERT_LE(0, id);

[Severity: Medium]
Should signalfd_uid_r and ipc_stat_r skip instead of failing when the kernel
is built without CONFIG_SIGNALFD or CONFIG_SYSVIPC?

In tools/testing/selftests/uid_r/uid_r_test.c, if CONFIG_SIGNALFD=3Dn or
CONFIG_SYSVIPC=3Dn, signalfd() in signalfd_uid_r and shmget() in ipc_stat_r
return -1 with errno set to ENOSYS, and ASSERT_LE() fails the tests outright
rather than calling SKIP().

Also, tools/testing/selftests/uid_r/config lists:

  CONFIG_TMPFS=3Dy
  CONFIG_TMPFS_POSIX_ACL=3Dy
  CONFIG_SYSVIPC=3Dy
  CONFIG_SIGNALFD=3Dy

Should tools/testing/selftests/uid_r/config also include CONFIG_USER_NS=3Dy=
 so
that the user_namespace test is not skipped on kernels built using the
selftest config fragment?

[ ... ]
> +/* user::rw- user:<u>:r-- group::--- mask::r-- other::--- in version 3 */
> +static size_t acl_v3(unsigned char *buf, const id_r *u)
> +{
> +	static const unsigned short ent[5][2] =3D {
> +		{ 0x01, 6 }, { 0x02, 4 }, { 0x04, 0 }, { 0x10, 4 }, { 0x20, 0 } };
> +	unsigned char *e =3D buf + 4;
> +	unsigned int ver =3D 3;
> +
> +	memcpy(buf, &ver, 4);
> +	for (int i =3D 0; i < 5; i++, e +=3D 24) {
> +		unsigned int type =3D 0;
> +
> +		memset(e, 0, 24);
> +		memcpy(e, &ent[i][0], 2);
> +		memcpy(e + 2, &ent[i][1], 2);
> +		if (ent[i][0] =3D=3D 0x02) {
> +			type =3D u->type;
> +			memcpy(e + 8, u->uuid, 16);
> +		}
> +		memcpy(e + 4, &type, 4);
> +	}
> +	return 4 + 5 * 24;
> +}
> +
> +TEST_F(uid_r, posix_acl_v3)
> +{
> +	unsigned char buf[256], got[256];
> +	id_r u =3D uuid(20), s0 =3D legacy(0);
> +	char path[96];
> +	size_t len;
> +	int fd;
> +
> +	private_tmpfs(_metadata, self->dir);
> +	snprintf(path, sizeof(path), "%s/acl", self->dir);
> +	fd =3D open(path, O_CREAT | O_WRONLY, 0600);
> +	ASSERT_LE(0, fd);
> +	close(fd);
> +	len =3D acl_v3(buf, &u);
> +	if (setxattr(path, "system.posix_acl_access", buf, len, 0) &&
> +	    errno =3D=3D EOPNOTSUPP)
> +		SKIP(return, "tmpfs without POSIX ACLs");
> +	ASSERT_EQ(len, getxattr(path, "system.posix_acl_access", got, sizeof(go=
t)));
> +	EXPECT_EQ(3, got[0]);

[Severity: Medium]
Won't acl_v3() and posix_acl_v3 fail or falsely skip on big-endian
architectures because the POSIX ACL xattr fields are serialized in host byte
order instead of little-endian?

In include/uapi/linux/posix_acl_xattr.h, struct posix_acl_xattr_header
defines a_version as __le32, and struct posix_acl_xattr_entry_r defines
e_tag and e_perm as __le16 and e_type as __le32. In fs/posix_acl.c,
posix_acl_fix_xattr_common() checks header->a_version against
cpu_to_le32(POSIX_ACL_XATTR_VERSION_R) and returns -EOPNOTSUPP on a
mismatch, while posix_acl_from_xattr_r() converts e_tag, e_perm, and e_type
using le16_to_cpu() and le32_to_cpu().

In tools/testing/selftests/uid_r/uid_r_test.c, acl_v3() copies host-endian
unsigned int ver, unsigned short ent[i][0] and ent[i][1], and unsigned int
type directly into buf with memcpy(). On big-endian systems, setxattr() in
posix_acl_v3 sees a byte-swapped a_version and fails with EOPNOTSUPP, which
posix_acl_v3 then treats as "tmpfs without POSIX ACLs" and skips even when
CONFIG_TMPFS_POSIX_ACL=3Dy is enabled.

In addition, if setxattr() fails with an errno other than EOPNOTSUPP,
posix_acl_v3 does not assert that setxattr() succeeded before calling
getxattr().

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D36
