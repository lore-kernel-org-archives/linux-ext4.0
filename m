Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639048;
	b=P/ruwjDhulZxAex7eusq5q0i+IreifcHYh8BZTyR5e0feBnl8/c0/XsjgLeY1KkFQfRB
	 z6R4aggzoNRwj+2U4cODwQ6g8m3yBzp2TEfSueTL3EZmrcdZfvZKoqWFMFWyX5kln0uuD
	 a4GUC8bIEXRt88/LFqCfskqG0I6Z71Ik21udfcodj4UVI6zO1tXLwIxHouD7/vwxjsQNk
	 mduS73lC8IWFiKZDUkepDfpQp7pjgU77BPrUJ+KCy2K5fQM/5FgyXsKQdV/s6trWa3QTx
	 lrMpo3bKQx708uVQKpe8O/jSsbviVD2KGk6PypHGRg2fzob3953KCWdp1KZCeLU6fmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639048;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KZCEo2wse43nUzcymGh8GiLaduay4Uai85RAqha0IK8=;
	b=uB8/XdiR2jtA9VpU2HnI2OGJic9qn3dsRfvzWRjdtT9/dJnDz/GspZE6IeScihuJ8beA
	 1+Ukd9mrUJyg0ru6DhGfhGfE1jb8DLwbkpW5yuKpAjSW+JkFqR+Q5hqJLYYuJqdn8zhfl
	 BgxIMo4ls1zI4vMgGfNJ3FjcmEqG96iPYjfUa+H0hPIshjZoVoihaphVY2yu41hNcAxcj
	 lk139KOXgjI0ElndayEr/7F/HMfsWuMGJBZC5n5XfRP8uUTuXEKmNg1drkwaN0Lzw9HF7
	 DSszYKnr9lTGVJIdEBadT1evqUCLmmChbKU2+7jhKxRpKGJGqlu1VB+9xzEjdo7M7sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AufUQTG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DE560A260A;
	Thu, 22 Oct 2026 03:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AufUQTG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734C71F000C6;
	Thu, 22 Oct 2026 03:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639048;
	bh=KZCEo2wse43nUzcymGh8GiLaduay4Uai85RAqha0IK8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AufUQTG4u3YXps8Ms1kJ3bhJtiT6QDXT7bKecZv73opVfQiAJW+/b3EEE1R25lAph
	 TCoUuw7CJGOrB/rBcYjZ2gZUWBHbLstIhC8TqbTGvDnFikgParHaUFT94AaToqbHsH
	 3wm4GqrjWdoMrUoUTNuDHjBecJgsxOki9fL0wLWa6viAhGOt/gfa5oPDdHPkpp5ICs
	 Y1wCFEOjwl/yhtkloOnCEI9Xi+rQ4RA13eIEDO2PIynibc1MELjPlWOU62kcMPySJk
	 /1Ioh4EWVFOcDvKeCt6sF9ovX5k0WY7sAV7cqDtgmiu740Fy16mXo6BxE9PWil/L70
	 zqaM6NK19gXQQ==
Message-ID: <sashiko-outbox-180905@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 04/41] net: sock: read sk_uid through a seqcount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <3ace21531501a80a31350f9a178828212fc7a224.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <3ace21531501a80a31350f9a178828212fc7a224.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:27 +0000
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
- [High] net: sock: write_seqcount_begin() called in preemptible sock_init_=
data_uid()
- [High] net: sock: raw seqcount_t under sk_callback_lock livelocks on PREE=
MPT_RT
--

commit e15d18b6d3adc57553d8944b44a103206aaa6a91
Author: Jan Koester <jan.koester@tuxist.de>

net: sock: read sk_uid through a seqcount

This commit introduces a sequence counter (sk_uid_seq) in struct sock to
protect lockless reads of sk_uid against concurrent updates in sock_graft()
and sockfs_setattr(). Writers update sk_uid via __sk_set_uid(), while reade=
rs
use sk_uid() to retry until a consistent value is read.

> diff --git a/include/net/sock.h b/include/net/sock.h
> index 60ea55dc18854..0986d946659a8 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h

[ ... ]

> @@ -509,6 +511,7 @@ struct sock {
>  	u32			sk_priority;
>  	u32			sk_mark;
>  	kuid_t			sk_uid;
> +	seqcount_t		sk_uid_seq;
>  	u16			sk_protocol;
>  	u16			sk_type;
>  	struct dst_entry __rcu	*sk_dst_cache;
> @@ -2109,11 +2112,23 @@ static inline int sk_rx_queue_get(const struct so=
ck *sk)
>  	return -1;
>  }
> =20
> +/*
> + * sk_uid is too big for WRITE_ONCE(): writers hold sk_callback_lock (or=
 own
> + * the socket alone, before it is published) and bump sk_uid_seq around =
the
> + * store, so sk_uid() can read it without a lock.
> + */
> +static inline void __sk_set_uid(struct sock *sk, kuid_t uid)
> +{
> +	write_seqcount_begin(&sk->sk_uid_seq);
> +	sk->sk_uid =3D uid;
> +	write_seqcount_end(&sk->sk_uid_seq);
> +}
> +
>  static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>  {
>  	WRITE_ONCE(sk->sk_socket, sock);
>  	if (sock) {
> -		WRITE_ONCE(sk->sk_uid, SOCK_INODE(sock)->i_uid);
> +		__sk_set_uid(sk, SOCK_INODE(sock)->i_uid);
>  		WRITE_ONCE(sk->sk_ino, SOCK_INODE(sock)->i_ino);
>  	} else {
>  		/* Note: sk_uid is unchanged. */
> @@ -2161,8 +2176,15 @@ static inline u64 sock_i_ino(const struct sock *sk)
> =20
>  static inline kuid_t sk_uid(const struct sock *sk)
>  {
> -	/* Paired with WRITE_ONCE() in sockfs_setattr() */
> -	return READ_ONCE(sk->sk_uid);
> +	unsigned int seq;
> +	kuid_t uid;
> +
> +	/* Paired with __sk_set_uid() */
> +	do {
> +		seq =3D read_seqcount_begin(&sk->sk_uid_seq);
> +		uid =3D sk->sk_uid;
> +	} while (read_seqcount_retry(&sk->sk_uid_seq, seq));
> +	return uid;
>  }

[Severity: High]
Could using a raw seqcount_t for sk_uid_seq cause preemption warnings and a
reader livelock on preempt-rt kernels?

Runtime writers such as sockfs_setattr(), sock_graft(), and
mptcp_sock_graft() serialize updates to sk->sk_uid with
write_lock_bh(&sk->sk_callback_lock) before calling __sk_set_uid() (directly
or via sk_set_socket()). On preempt-rt kernels, write_lock_bh() on an
rwlock_t does not disable preemption:

include/linux/rwlock_rt.h:write_lock_bh() {
	local_bh_disable();
	rt_write_lock(rwlock);
}

Because sk_uid_seq is a raw seqcount_t rather than a seqcount_rwlock_t
associated with sk_callback_lock, write_seqcount_begin(&sk->sk_uid_seq) does
not disable preemption and triggers lockdep_assert_preemption_disabled() in
__seqprop_assert():

include/linux/seqlock.h:__seqprop_assert() {
	lockdep_assert_preemption_disabled();
}

In addition, if a higher-priority task preempts the writer between
write_seqcount_begin() and write_seqcount_end() while sk_uid_seq.sequence is
odd and calls sk_uid(), read_seqcount_begin(&sk->sk_uid_seq) will spin
indefinitely in __read_seqcount_begin():

include/linux/seqlock.h:__read_seqcount_begin() {
	while (unlikely((__seq =3D seqprop_sequence(s)) & 1))
		cpu_relax();
}

With a raw seqcount_t, the reader has no associated rwlock_t to block on and
priority-boost the preempted writer. Should sk_uid_seq be a
seqcount_rwlock_t initialized with sk_callback_lock, or should preemption be
disabled around the write section?

> diff --git a/net/core/sock.c b/net/core/sock.c
> index e8551df8330ff..300bc75ce13e6 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c

[ ... ]

> @@ -3773,7 +3776,7 @@ void sock_init_data_uid(struct socket *sock, struct=
 sock *sk, kuid_t uid)
>  	} else {
>  		RCU_INIT_POINTER(sk->sk_wq, NULL);
>  	}
> -	sk->sk_uid	=3D	uid;
> +	__sk_set_uid(sk, uid);
> =20
>  	sk->sk_state_change	=3D	sock_def_wakeup;
>  	sk->sk_data_ready	=3D	sock_def_readable;

[Severity: High]
What happens when sock_init_data_uid() calls sk_set_socket() and
__sk_set_uid() in preemptible process context with softirqs enabled?

During socket creation (for example, inet_create() -> sock_init_data() ->
sock_init_data_uid()), sock_init_data_uid() runs in normal process context
with preemption and bottom halves enabled and no locks held. Calling
__sk_set_uid() (both via sk_set_socket() when sock is non-null and directly
in sock_init_data_uid()) invokes write_seqcount_begin(&sk->sk_uid_seq) on a
raw seqcount_t while preemption is enabled, which immediately triggers the
warning in lockdep_assert_preemption_disabled().

Furthermore, write_seqcount_begin(&sk->sk_uid_seq) records a lockdep write
acquisition on the sk_uid_seq class with softirqs enabled. When sk_uid() is
later called from softirq context (such as during tcp_v4_rcv() ->
tcp_v4_syn_recv_sock() -> sk_clone(), or during routing and reuseport
lookups), read_seqcount_begin(&sk->sk_uid_seq) records a softirq read on the
same class in mark_usage() in kernel/locking/lockdep.c, triggering an
inconsistent lock state warning (softirq-on-w to in-softirq-r).

Since the socket is not yet published in sock_init_data_uid(), should
sk->sk_uid be initialized with a plain assignment when the socket is still
unshared, only using __sk_set_uid() under write_lock_bh(&sk->sk_callback_lo=
ck)?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D4
