Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639054;
	b=R/wuZhU8D37lfhx/rNVEQ+OUyFVZVrCpdBWL7zP1FbNWAU7E8xIGpHDhyGbZNcaOYXOp
	 T+j+/ebrOdAIlta5Y/8G7KshmCW4xKIQzkL8tZyR037hEeJgNYlf1feaIHP1gN1HKUAlp
	 bnPrWOwwjZ0KkYbr1sdiZSCgjo1G1wTOaXLGvRPVH4PdzNb1WsKAvu3OTa/EzH9p++MIQ
	 3HE2+qQlCBvwO4bXx42GBMYJb8iL2vgR5OeLafMCmlf846nhcdmt3bejtNMNfsGQlI+ir
	 vpK2eV3Ug+DWuxAWuwAJMpcn0kT42JePjz9tT7ArYbZxXtuX03Tq5s1kkntJ5SH0utQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639054;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7r++vDdpmrvdXMT2BhNrwPNHVMbVue220LeEs6hg0Z4=;
	b=G+gHUbrjvqRV79JzKK+DAaIqB+iQfhkv+WRgmnbD7HMmXzbb3nFBLkaoiVsikwvynK/R
	 xCny7iumaoRNWR7qe9Ar0ZjnxwShnCzf1JlEer9PRTnnOH281m2931SJ089srBH+TW3FJ
	 CUKl9frEXuIXqmfNMuxef0IC1hp5haR4cSkTcyZktGJH6Dk4Hp4nsYTuaLlnEoGzaOvAK
	 TchaUk2pWslmhM+P4BkPydDaccg22E2ABBA5C0zcHO6vSDga8oFj/BuwBAeW8PtSWsp7S
	 sPDKJUUFOv1vODJ2/ELhomFxwoh5HeoLO2KGBxtv4EQ0Gx3J3SMWHRbcdkTZJ41D1JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bJ5MoRC7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9C060A3806;
	Thu, 22 Oct 2026 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bJ5MoRC7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570811F000CC;
	Thu, 22 Oct 2026 03:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639053;
	bh=7r++vDdpmrvdXMT2BhNrwPNHVMbVue220LeEs6hg0Z4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bJ5MoRC7P0yRxhLXUsvVZOAUwOnVss61Q5DH6Lpn+oSVbGxJjT/QjRR0qmAVQ0qrT
	 9I6ZaboLknac6C5dgG4tPZ1BzxuR7/klTvKr2uPG6JmaGuBqaxQMA2LX7+sGbGf/aU
	 nimFOkHMDNopv0qoIximfyS49ttOV+3vfikv0WPYtFLAE46dEsffA/mjol7u+7ZuFk
	 HZZF/6JCcjWRGQ5FuUBvenEwPtATv6h+fRjpFiRGaROzQWX/oIfI/ZLWcITcr/inL1
	 op5/fYY0PdFzKDqrFkxkbV5hiduA9OlVA4J/5AlO/2rk+kIsnmSVbyPtSoKH/oDvI7
	 IKuXddK+bPiJg==
Message-ID: <sashiko-outbox-180910@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 09/41] uidgid: let kuid_t and kgid_t hold a UUID
 or a GUID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <740f7687fd823a127ff6c312240eadbd8b3ec209.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <740f7687fd823a127ff6c312240eadbd8b3ec209.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] fs: VFSUIDT_INIT_RAW() initializes .type instead of .legacy
- [High] quota: qid_has_mapping() returns false for UUID/GUIDs in init_user=
_ns
- [High] uidgid: 20-byte kuid_t and kgid_t cause torn reads and writes on i=
node ids
- [High] uidgid: __kid_cmp() ordering breaks fib_rule_match() for UUID/GUID=
 sockets
- [High] audit: broken audit_field union aliasing in audit_krule_to_data()
- [Medium] uidgid: __kid_hash() mismatches __kid_cmp() when !CONFIG_MULTIUS=
ER
- [Low] uidgid: 20-byte kuid_t and kgid_t break READ_ONCE()/WRITE_ONCE() in=
 tun.c
--

commit 36d10e56f75840b8f3657151d3427526a39d77ae
Author: Jan Koester <jan.koester@tuxist.de>

uidgid: let kuid_t and kgid_t hold a UUID or a GUID

This commit turns kuid_t, kgid_t, vfsuid_t, and vfsgid_t into 20-byte tagged
unions capable of holding a classic 32-bit ID, an RFC 9562 UUID, or a
Microsoft GUID. It also updates ID comparison, hashing, user namespace
mapping, and mount idmapping helpers to handle non-legacy IDs.

> diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
> index cb61fbdb52e90..c36e74a37138c 100644
> --- a/fs/mnt_idmapping.c
> +++ b/fs/mnt_idmapping.c
> @@ -87,6 +87,10 @@ vfsuid_t make_vfsuid(struct mnt_idmap *idmap,
>  		return VFSUIDT_INIT(kuid);
>  	if (idmap =3D=3D &invalid_mnt_idmap)
>  		return INVALID_VFSUID;
> +	/* idmappings map classic ids only; UUIDs and GUIDs pass unchanged */
> +	if (!uid_is_legacy(kuid))
> +		return kuid_has_mapping(fs_userns, kuid) ?
> +		       VFSUIDT_INIT(kuid) : INVALID_VFSUID;
>  	if (initial_idmapping(fs_userns))
>  		uid =3D __kuid_val(kuid);
>  	else

[Severity: High]
When make_vfsuid() and make_vfsgid() in fs/mnt_idmapping.c map a classic ID=
 on
an idmapped mount, they return via VFSUIDT_INIT_RAW() and VFSGIDT_INIT_RAW(=
):

fs/mnt_idmapping.c:
    #define VFSUIDT_INIT_RAW(val) (vfsuid_t){ val }
    #define VFSGIDT_INIT_RAW(val) (vfsgid_t){ val }
    ...
    return VFSUIDT_INIT_RAW(map_id_down(&idmap->uid_map, uid));

Now that vfsuid_t and vfsgid_t in include/linux/mnt_idmapping.h have u32 ty=
pe
as their first struct member, doesn't this positional initializer assign the
mapped 32-bit UID or GID to .type while zero-initializing .legacy and .uuid?

When VFS callers on an idmapped mount map an inode's classic ID through
i_uid_into_vfsuid() or i_gid_into_vfsgid() (such as acl_permission_check(),
inode_owner_or_capable(), may_follow_link(), chown_ok(), and
generic_fillattr()):

- Mapped ID 1 sets .type =3D KID_UUID with an all-zero UUID, and mapped ID 2
  sets .type =3D KID_GUID with an all-zero GUID, allowing a caller with an
  all-zero UUID or GUID credential to match files owned by mapped UID 1 or 2
  in vfsuid_eq_kuid().

- Other non-zero mapped IDs set .type to an unknown tag with .legacy =3D 0,=
 so
  vfsuid_is_legacy() returns false and __vfsuid_val() returns (uid_t)-1.

- When map_id_down() returns (uid_t)-1 for an unmapped ID,
  VFSUIDT_INIT_RAW((uid_t)-1) sets .type =3D (u32)-1, causing vfsuid_valid(=
) and
  vfsgid_valid() in include/linux/mnt_idmapping.h:

    static inline bool vfsuid_valid(vfsuid_t uid)
    {
    	return !vfsuid_is_legacy(uid) || __vfsuid_val(uid) !=3D (uid_t)-1;
    }

  to see !vfsuid_is_legacy(uid) as true and treat unmapped IDs as valid.

Should VFSUIDT_INIT_RAW() and VFSGIDT_INIT_RAW() initialize
.type =3D KID_LEGACY and .legacy =3D (val) like KUIDT_INIT() and KGIDT_INIT=
()?

[ ... ]

> diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
> index 182c682458cb6..e1adb50d5dac5 100644
> --- a/include/linux/uidgid.h
> +++ b/include/linux/uidgid.h

[ ... ]

> @@ -64,64 +69,115 @@ static inline gid_t __kgid_val(kgid_t gid)
>  #define INVALID_UID KUIDT_INIT(-1)
>  #define INVALID_GID KGIDT_INIT(-1)
> =20
> +/*
> + * Ids are ordered by kind first (legacy ids before UUIDs before GUIDs),
> + * then by value: numerically for legacy ids, bytewise for the others.
> + * That keeps sorted id arrays and range checks between legacy ids
> + * working: a UUID is never inside a range of legacy ids.
> + */
> +static inline int __kid_cmp(u32 ltype, u32 llegacy, const u8 *lb,
> +			    u32 rtype, u32 rlegacy, const u8 *rb)
> +{
> +	if (!IS_ENABLED(CONFIG_MULTIUSER))
> +		return 0;
> +	if (ltype !=3D rtype)
> +		return ltype < rtype ? -1 : 1;
> +	if (ltype =3D=3D KID_LEGACY)
> +		return llegacy =3D=3D rlegacy ? 0 : llegacy < rlegacy ? -1 : 1;
> +	return __builtin_memcmp(lb, rb, UUID_SIZE);
> +}

[Severity: High]
How does this ordering interact with fib_rule_match() in net/core/fib_rules=
.c
when a socket is owned by a KID_UUID or KID_GUID user?

In net/core/fib_rules.c, FIB rules without an explicit FRA_UID_RANGE attrib=
ute
(including the default local, main, and default table rules added by
fib_default_rule_add() and rules created in fib_nl2rule()) initialize
rule->uid_range to fib_kuid_range_unset:

net/core/fib_rules.c:
    static const struct fib_kuid_range fib_kuid_range_unset =3D {
    	KUIDT_INIT(0),
    	KUIDT_INIT(~0),
    };

When policy routing is active and fib_rules_lookup() calls fib_rule_match(),
it checks fl->flowi_uid (populated from sk_uid(sk) in paths such as
build_sk_flow_key() in net/ipv4/route.c and ip6_route_output_flags() in
net/ipv6/route.c) unconditionally against rule->uid_range without checking
uid_range_set(&rule->uid_range):

net/core/fib_rules.c:fib_rule_match()
    if (uid_lt(fl->flowi_uid, rule->uid_range.start) ||
        uid_gt(fl->flowi_uid, rule->uid_range.end))
    	goto out;

Because __kid_cmp() orders KID_UUID and KID_GUID after all KID_LEGACY value=
s,
uid_gt(fl->flowi_uid, fib_kuid_range_unset.end) will evaluate to true for a=
ny
UUID or GUID socket, rejecting all unset-UID rules (including the default
rules) and failing route lookups with -ESRCH (-ENETUNREACH).

[ ... ]

> +/* A hash of an id, for hash tables keyed by kuid_t or kgid_t */
> +static inline u32 __kid_hash(u32 type, u32 legacy, const u8 *b)
> +{
> +	u32 w[4];
> +
> +	if (type =3D=3D KID_LEGACY)
> +		return legacy;
> +	__builtin_memcpy(w, b, sizeof(w));
> +	return w[0] ^ w[1] ^ w[2] ^ w[3] ^ type;
> +}
> +
> +static inline u32 kuid_hash(kuid_t uid)
> +{
> +	return __kid_hash(uid.type, __kuid_val(uid), uid.uuid.b);
> +}

[Severity: Medium]
When CONFIG_MULTIUSER is disabled, __kid_cmp() returns 0 unconditionally so
uid_eq() treats all kuid_t values as equal regardless of .type, whereas
__kid_hash() still hashes the UUID/GUID bytes when type !=3D KID_LEGACY.

On a !CONFIG_MULTIUSER kernel, if an inode with a KID_UUID or KID_GUID owner
(e.g. from a mounted ext4 uid_r filesystem or via chown_r() / fchown_r() in
fs/open.c) and S_ISUID set is executed via execve(), bprm_fill_uid() in
fs/exec.c sets bprm->cred->euid to that UUID or GUID. When inc_ucount() ->
alloc_ucounts() -> find_ucounts() in kernel/ucount.c (or uidhashentry() in
kernel/user.c, or later fs/ecryptfs/messaging.c) hashes that kuid_t with
kuid_hash(), won't it land in a non-zero bucket, miss init_ucounts (hashed =
at
GLOBAL_ROOT_UID), and allocate duplicate ucounts structures even though
uid_eq(init_ucounts.uid, uid) is true?

Should __kid_hash() also return 0 when !IS_ENABLED(CONFIG_MULTIUSER)?

> +
> +static inline u32 kgid_hash(kgid_t gid)
> +{
> +	return __kid_hash(gid.type, __kgid_val(gid), gid.uuid.b);
> +}
> =20
>  #ifdef CONFIG_USER_NS
> @@ -134,13 +190,22 @@ extern gid_t from_kgid(struct user_namespace *to, k=
gid_t gid);
>  extern uid_t from_kuid_munged(struct user_namespace *to, kuid_t uid);
>  extern gid_t from_kgid_munged(struct user_namespace *to, kgid_t gid);
> =20
> +/*
> + * UUIDs and GUIDs aren't in any namespace's uid_map or gid_map: they
> + * exist in the initial user namespace only, and nobody has privilege
> + * over them through a capability in another one.
> + */
>  static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t ui=
d)
>  {
> +	if (!uid_is_legacy(uid))
> +		return ns =3D=3D &init_user_ns;
>  	return from_kuid(ns, uid) !=3D (uid_t) -1;
>  }
> =20
>  static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gi=
d)
>  {
> +	if (!gid_is_legacy(gid))
> +		return ns =3D=3D &init_user_ns;
>  	return from_kgid(ns, gid) !=3D (gid_t) -1;
>  }

[Severity: High]
kuid_has_mapping() and kgid_has_mapping() (along with vfsuid_has_mapping() =
and
vfsgid_has_mapping() in include/linux/mnt_idmapping.h) are updated here
because from_kuid() and from_kgid() in kernel/user_namespace.c now return
(uid_t)-1 and (gid_t)-1 for UUID and GUID IDs even in init_user_ns.

However, qid_has_mapping() in include/linux/quota.h still checks:

include/linux/quota.h:
    static inline bool qid_has_mapping(struct user_namespace *ns, struct kq=
id qid)
    {
    	return from_kqid(ns, qid) !=3D (qid_t) -1;
    }

Because from_kqid() in fs/quota/kqid.c delegates to from_kuid() and
from_kgid(), qid_has_mapping(&init_user_ns, qid) now returns false for all
UUID and GUID kqid values.

Although the follow-up commit "fs: keep UUID and GUID owners off filesystems
that can't store them" restricts UUID and GUID owners to SB_I_UID_R
filesystems, tmpfs with CONFIG_TMPFS_QUOTA (enabled in "shmem, ramfs: allow
UUID and GUID owners") and ext4 (enabled in "ext4: add the uid_r feature for
UUID and GUID owners") both support VFS quotas and call dquot_initialize() =
and
dquot_transfer(). Furthermore, while "quota: don't account UUID and GUID
owners" adds a !qid_is_legacy(qid) check returning ERR_PTR(-ESRCH) in dqget=
()
in fs/quota/dquot.c, it places that check after:

fs/quota/dquot.c:dqget()
    if (!qid_has_mapping(sb->s_user_ns, qid))
    	return ERR_PTR(-EINVAL);

without updating qid_has_mapping(). Doesn't this make the !qid_is_legacy(qi=
d)
check unreachable and cause dqget() to return -EINVAL instead of -ESRCH,
breaking file creation (__ext4_new_inode(), shmem_get_inode()) and ownership
changes (ext4_setattr(), shmem_setattr()) for UUID and GUID owners whenever
quotas are active?

> diff --git a/include/linux/uidgid_types.h b/include/linux/uidgid_types.h
> index b35ac4955a334..0f595d075b4a2 100644
> --- a/include/linux/uidgid_types.h
> +++ b/include/linux/uidgid_types.h
> @@ -3,13 +3,41 @@
>  #define _LINUX_UIDGID_TYPES_H
> =20
>  #include <linux/types.h>
> +#include <linux/uuid_types.h>
> =20
> +/*
> + * Kinds of kuid_t and kgid_t. KID_LEGACY is 0, so zeroed memory still
> + * holds GLOBAL_ROOT_UID and GLOBAL_ROOT_GID as it did when the ids were
> + * plain numbers. Userspace has its own numbering (UID_R_* in
> + * <uapi/linux/uidgid_r.h>), in which zero is "no id".
> + */
> +enum kid_type {
> +	KID_LEGACY =3D 0,		/* classic 32 bit id in .legacy */
> +	KID_UUID,		/* RFC 9562 UUID in .uuid */
> +	KID_GUID,		/* Microsoft GUID in .guid */
> +};
> +
> +/*
> + * Only the member .type selects is meaningful; the bytes of .uuid past
> + * .legacy are undefined for a KID_LEGACY id. Copy the whole struct and
> + * use the helpers of <linux/uidgid.h> to look at it.
> + */
>  typedef struct {
> -	uid_t val;
> +	u32 type;
> +	union {
> +		uid_t legacy;
> +		uuid_t uuid;
> +		guid_t guid;
> +	};
>  } kuid_t;

[Severity: High]
Placing u32 type at offset 0 and uid_t legacy at offset 4 of kuid_t and kgi=
d_t
changes the layout of the anonymous union in struct audit_field in
include/linux/audit.h:

include/linux/audit.h:
    struct audit_field {
    	u32				type;
    	union {
    		u32			val;
    		kuid_t			uid;
    		kgid_t			gid;
    		struct {
    			char		*lsm_str;
    			void		*lsm_rule;
    		};
    	};
    	u32				op;
    };

In kernel/auditfilter.c, audit_data_to_entry() populates f->uid =3D make_ku=
id()
or f->gid =3D make_kgid() for UID and GID filter fields (AUDIT_LOGINUID,
AUDIT_UID, AUDIT_EUID, AUDIT_SUID, AUDIT_FSUID, AUDIT_OBJ_UID, AUDIT_GID,
AUDIT_EGID, AUDIT_SGID, AUDIT_FSGID, AUDIT_OBJ_GID), which now writes
KID_LEGACY (0) at offset 0 and the numeric ID at offset 4.

When audit_krule_to_data() in kernel/auditfilter.c serializes rules back to
userspace for AUDIT_LIST_RULES:

kernel/auditfilter.c:audit_krule_to_data()
    default:
    	data->values[i] =3D f->val;
    }

none of those UID or GID fields have explicit cases in the switch statement,
so they all read f->val at offset 0 (f->uid.type =3D=3D 0). Won't this cause
AUDIT_LIST_RULES to report 0 (root) for every UID and GID filter rule?

> =20
>  typedef struct {
> -	gid_t val;
> +	u32 type;
> +	union {
> +		gid_t legacy;
> +		uuid_t uuid;
> +		guid_t guid;
> +	};
>  } kgid_t;

[Severity: High]
With kuid_t and kgid_t growing from 4 bytes to 20 bytes, reads and writes of
inode->i_uid and inode->i_gid are no longer single-word atomic and compile
into multi-instruction memory copies.

In the VFS, writers update inode->i_uid and inode->i_gid in place via
notify_change() -> setattr_copy() -> i_uid_update() / i_gid_update() in
include/linux/fs.h (holding only inode->i_rwsem), and via lookup_fast() ->
pid_revalidate() -> pid_update_inode() -> task_dump_owner() in fs/proc/base=
.c
(under rcu_read_lock() with no inode lock held):

include/linux/fs.h:
    static inline void i_uid_update(struct mnt_idmap *idmap,
    				const struct iattr *attr,
    				struct inode *inode)
    {
    	if (attr->ia_valid & ATTR_UID)
    		inode->i_uid =3D from_vfsuid(idmap, i_user_ns(inode),
    					   attr->ia_vfsuid);
    }

Meanwhile, lockless readers in acl_permission_check(), may_follow_link(),
may_create_in_sticky(), inode_owner_or_capable(), and generic_fillattr() co=
py
inode->i_uid and inode->i_gid by value through i_uid_into_vfsuid() and
i_gid_into_vfsgid() without holding inode->i_rwsem or any seqlock:

include/linux/fs.h:
    static inline vfsuid_t i_uid_into_vfsuid(struct mnt_idmap *idmap,
    					 const struct inode *inode)
    {
    	return make_vfsuid(idmap, i_user_ns(inode), inode->i_uid);
    }

Can a concurrent reader racing with chown() / chown_r() or procfs task
revalidation observe a torn 20-byte ID=E2=80=94for example, .type =3D=3D KI=
D_LEGACY paired
with the first 4 bytes of a UUID/GUID in .legacy (which can match
GLOBAL_ROOT_UID or another local UID), or .type =3D=3D KID_UUID / KID_GUID =
paired
with stale union bytes=E2=80=94or can concurrent pid_revalidate() calls lea=
ve a
/proc/<pid> inode's ownership permanently torn?

[Severity: Low]
Also, growing kuid_t and kgid_t to 20 bytes causes READ_ONCE() and
WRITE_ONCE() on kuid_t and kgid_t to fail compiletime_assert_rwonce_type() =
in
include/asm-generic/rwonce.h.

Unlike sk->sk_uid (which is converted to a seqcount in the later commit
"net: sock: read sk_uid through a seqcount"), drivers/net/tun.c still uses
READ_ONCE() and WRITE_ONCE() on tun->owner and tun->group in tun_fill_info()
and __tun_chr_ioctl():

drivers/net/tun.c:tun_fill_info()
    kuid_t owner =3D READ_ONCE(tun->owner);
    kgid_t group =3D READ_ONCE(tun->group);

drivers/net/tun.c:__tun_chr_ioctl()
    WRITE_ONCE(tun->owner, owner);
    ...
    WRITE_ONCE(tun->group, group);

Won't this break the build when CONFIG_TUN is enabled?

[ ... ]

> --=20
> 2.51.2

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D9
