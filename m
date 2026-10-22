Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639077;
	b=jHGePk2uLi0sU1/DaYSc86/scEqNK0x5PsBDB1M/Yw49l/7YzIDYmBChB5UqRmC2axrV
	 iKPznbsurA2ehodJJVbYW975Jd+iJ/BTdBAV9it+Di8JZxdys0SY8HqFnBTcjBbLK3IWL
	 2t/a7IlNR0urOT3nSjq+mMuwobda8fRwKxntk9Z8I/gZCh9IF4aozfwKugkYE7AM6Bk0J
	 nUoR/qeE8fI7ZTaGSYJ6ip+DsVEuIJZTNOC+/7xUblbh55Za2S375ooB8Qb94y24faaGw
	 ww101T3mVkMxjK93Xk3of+y1ydeOYlnlYFRLY6MXcnAJ44iW42dN2vi7q6MoWhPVf1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639077;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZiYFRn2rHT1XmpTx5g5IheWbVndYdrDEgc1wqd5CAl0=;
	b=bN1fEflTSse7I8o4aEQfn090wTdZ1lJ8kHGdqBtFgMnaMz3EvAie3H677n/QxELGs8QL
	 ME28hBKBuzjGS4I1IRIHvciZarW6LR3KRpMFA4Ijq9TR+Gn3ItbMe7zPevuYLIyrcWe4Y
	 ruu9PrBWZNvA6PDD3x3syzie7rGjxYeRctXAeIssmg5D+PEVcvxHLiWfCkWSHolvaNSOj
	 UNyo8iOm+MDGKp/U3ohAayjVvEgqGWOQwsJbRPWdkfGBtDU9hTNxpD24bSDzSvq0NUdh0
	 nBvTzc2a/8eWS2BwuhUBGJI6D/gy03UuYS+Kr29Y+p9ob9gExJulenQ1gwjDjlPHbxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TyGGW9lw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A3D60A2622;
	Thu, 22 Oct 2026 03:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TyGGW9lw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C8F1F000C4;
	Thu, 22 Oct 2026 03:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639076;
	bh=ZiYFRn2rHT1XmpTx5g5IheWbVndYdrDEgc1wqd5CAl0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TyGGW9lwHa8f2esgWKZO764k6O/Ug7IgnkLLifxRohZz25CbPl7MEo6dE+hXZ0UA0
	 BKwtqb5oQ4jBFl7whAZiAbNLnYkIWmHISd6RpB6iSi9A6f4ClgWQ+4F910GfkE2ky5
	 RxP+XyuL+WosEV+g1asZ6H5X2VDGhkbT0IFNXXz8ndU1t/7MeHuWXXb/LFS/7EJFuf
	 fZl0s/CzEaq85a23jx/VqYPuRCkoRi/j/Y64+pmQCZVw/Y2OkOTM3zEuLP7tuKeY3C
	 p6ZS2WDtFaoruT8jD3JEX77k0rHNUXbMPjTM95r5Iv/uZ8RZCjgrsr1VEEa1ZnuMKJ
	 pU9SkMHcz9CJA==
Message-ID: <sashiko-outbox-180930@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 29/41] signal: report the sender's UUID or GUID
 uid in si_uid_r
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <59988b6ac15fa727c7f5d14d5342ceba4d6e595f.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <59988b6ac15fa727c7f5d14d5342ceba4d6e595f.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:55 +0000
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
- [High] signal: broken userns UID mapping in send_signal_locked() and call=
ers
- [Medium] bpf: missing siginfo_set_kernel_uid() call in bpf_send_signal_co=
mmon()
--

commit 3fc8400fa91445ed3a591553195996d33af32cb3
Author: Jan Koester <jan.koester@tuxist.de>

signal: report the sender's UUID or GUID uid in si_uid_r

This commit adds si_uid_r (__kernel_uid_r_t) at offset 96 in siginfo_t and
compat_siginfo_t, along with ssi_uid_r in signalfd_siginfo, to report the
sender's UUID or GUID UID for signals and waitid(). It introduces
siginfo_set_uid() and siginfo_set_kernel_uid() to populate and translate
si_uid and si_uid_r across signal generation, delivery, and wait paths.

> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index f19816832f055..928e67e283b60 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -6,6 +6,7 @@
>  #include <linux/list.h>
>  #include <linux/signal_types.h>
>  #include <linux/string.h>
> +#include <linux/uidgid.h>
> =20
>  struct task_struct;
> =20
> @@ -23,6 +24,27 @@ static inline void clear_siginfo(kernel_siginfo_t *inf=
o)
>  	memset(info, 0, sizeof(*info));
>  }
> =20
> +struct user_namespace;
> +
> +/*
> + * Sets si_uid and si_uid_r to @uid as seen from @ns (the receiver's user
> + * namespace), the overflow id if it has no mapping there.
> + */
> +static inline void siginfo_set_uid(kernel_siginfo_t *info,
> +				   struct user_namespace *ns, kuid_t uid)
> +{
> +	info->si_uid =3D from_kuid_munged(ns, uid);
> +	from_kuid_r_munged(ns, uid, &info->si_uid_r);
> +}
> +
> +/* si_uid and si_uid_r of a signal from the kernel: 0 */
> +static inline void siginfo_set_kernel_uid(kernel_siginfo_t *info)
> +{
> +	info->si_uid =3D 0;
> +	memset(&info->si_uid_r, 0, sizeof(info->si_uid_r));
> +	info->si_uid_r.type =3D UID_R_LEGACY;
> +}

[Severity: Medium]
Should bpf_send_signal_common() in kernel/trace/bpf_trace.c also call
siginfo_set_kernel_uid(&info) when sending a signal to a specific task?

When a BPF program invokes bpf_send_signal_task() with a non-NULL task,
bpf_send_signal_common() takes the else branch and initializes info manuall=
y:

kernel/trace/bpf_trace.c:bpf_send_signal_common() {
	if (!task) {
		task =3D current;
		siginfo =3D SEND_SIG_PRIV;
	} else {
		clear_siginfo(&info);
		info.si_signo =3D sig;
		info.si_errno =3D 0;
		info.si_code =3D SI_KERNEL;
		info.si_pid =3D 0;
		info.si_uid =3D 0;
		info.si_value.sival_ptr =3D (void __user __force *)(unsigned long)value;
		siginfo =3D &info;
	}
}

Because info.si_uid =3D 0 is set directly after clear_siginfo(&info),
info.si_uid_r remains UID_R_NONE instead of UID_R_LEGACY with uid 0, whereas
calling bpf_send_signal() or bpf_send_signal_thread() (where task is NULL)
uses SEND_SIG_PRIV and sets info.si_uid_r via siginfo_set_kernel_uid().

[ ... ]

> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index d1dd36a651b0d..f0a319ed97515 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -802,8 +802,8 @@ static void __do_notify(struct mqueue_inode_info *inf=
o)
>  			/* map current pid/uid into info->owner's namespaces */
>  			sig_i.si_pid =3D task_tgid_nr_ns(current,
>  						ns_of_pid(info->notify_owner));
> -			sig_i.si_uid =3D from_kuid_munged(info->notify_user_ns,
> -						current_uid());
> +			siginfo_set_uid(&sig_i, info->notify_user_ns,
> +					current_uid());
>  			/*
>  			 * We can't use kill_pid_info(), this signal should
>  			 * bypass check_kill_permission(). It is from kernel

[ ... ]

> diff --git a/kernel/signal.c b/kernel/signal.c
> index d31ebcb6ed4db..af0793d04b640 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c

[ ... ]

> @@ -1229,6 +1228,13 @@ int send_signal_locked(int sig, struct kernel_sigi=
nfo *info,
>  			info =3D &rewritten;
>  			uid =3D make_kuid(current_user_ns(), info->si_uid);
>  			rewritten.si_uid =3D from_kuid_munged(t_user_ns, uid);
> +			if (rewritten.si_uid_r.type !=3D UID_R_NONE) {
> +				kuid_t uid_r =3D make_kuid_r(current_user_ns(),
> +							   &rewritten.si_uid_r);
> +
> +				from_kuid_r_munged(t_user_ns, uid_r,
> +						   &rewritten.si_uid_r);
> +			}
>  		}
>  		rcu_read_unlock();
>  #endif

[Severity: High]
Can this cross-user-namespace translation in send_signal_locked() corrupt
both si_uid and si_uid_r in several signal delivery paths?

First, in send_signal_locked(), rewritten.si_uid is still derived from the
32-bit info->si_uid via make_kuid(current_user_ns(), info->si_uid) rather
than from uid_r. When a process with a UUID or GUID UID in init_user_ns
signals a task in a child user namespace t_user_ns (via
prepare_kill_siginfo() in tkill(), tgkill(), or pidfd_send_signal() with
info =3D=3D NULL, or via rt_sigqueueinfo()), info->si_uid has already been =
munged
to overflowuid (65534). make_kuid(&init_user_ns, 65534) then fabricates the
legacy host UID KUIDT_INIT(65534). If t_user_ns maps legacy host UID 65534 =
to
a valid container UID, rewritten.si_uid is set to that container UID instead
of overflowuid, while rewritten.si_uid_r is munged to overflowuid.

Second, prepare_kill_siginfo() in kernel/signal.c pre-maps current_uid() in=
to
current_user_ns() before send_signal_locked() knows the target's user
namespace:

kernel/signal.c:prepare_kill_siginfo() {
	clear_siginfo(info);
	info->si_signo =3D sig;
	info->si_errno =3D 0;
	info->si_code =3D (type =3D=3D PIDTYPE_PID) ? SI_TKILL : SI_USER;
	info->si_pid =3D task_tgid_vnr(current);
	siginfo_set_uid(info, current_user_ns(), current_uid());
}

If a task with a UUID or GUID UID enters a child user namespace via
unshare(CLONE_NEWUSER) or setns() and calls tkill(), tgkill(), or
pidfd_send_signal() (with info =3D=3D NULL) targeting a task in init_user_n=
s,
siginfo_set_uid() in prepare_kill_siginfo() immediately munges info->si_uid=
_r
to UID_R_LEGACY / overflowuid because current_user_ns() !=3D &init_user_ns.
When send_signal_locked() subsequently translates from current_user_ns() to
t_user_ns (&init_user_ns), the original UUID or GUID has already been lost.

Third, both do_notify_parent_cldstop() in kernel/signal.c and __do_notify()
in ipc/mqueue.c already translate the sender's kuid_t into the receiver's
user namespace via siginfo_set_uid(), but then pass the resulting siginfo to
send_signal_locked():

kernel/signal.c:do_notify_parent_cldstop()
  -> siginfo_set_uid(&info, task_cred_xxx(parent, user_ns), task_uid(tsk))
  -> send_signal_locked(SIGCHLD, &info, parent, PIDTYPE_TGID)

ipc/mqueue.c:__do_notify()
  -> siginfo_set_uid(&sig_i, info->notify_user_ns, current_uid())
  -> do_send_sig_info(info->notify.sigev_signo, &sig_i, task, PIDTYPE_TGID)
    -> send_signal_locked(sig, info, p, type)

When current_user_ns() !=3D t_user_ns, send_signal_locked() translates si_u=
id
and si_uid_r a second time assuming they were formatted in current_user_ns(=
).
For example, if a child or mqueue sender with a UUID or GUID UID is in a
child user namespace and the parent or notify_owner is in init_user_ns,
siginfo_set_uid() writes the UUID or GUID into si_uid_r, and
send_signal_locked() then calls make_kuid_r(current_user_ns(), ...), which
fails in kid_r_to_128() and returns INVALID_UID, overwriting the valid UUID
or GUID with overflowuid.

[ ... ]

=E5=AE=8C=E7=BE=8E=EF=BC=81 Let's double check everything before finalizing=
. Everything adheres strictly to the guidelines.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D29
