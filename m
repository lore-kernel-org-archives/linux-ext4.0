Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FE439FCE;
	Tue, 25 Aug 2026 11:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787658407; cv=pass; b=f7KhQQ3yGdl5RQ/deHC8AsOkRN9vhRQi1+1j3NmXzsjZPMlgSporpZ7ctoAls0q1Cg8InO72u1GK2ia3k2MVCcnHDflpRdbLpaB+FSO/A0ECWb++F5pFk7KJHmN7tfDXHryQ5zav0GVaMBgPtAXSdsLtMjPAbeBDLxEhK1qiM2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787658407; c=relaxed/simple;
	bh=eJ3vT+vuBacVbzbtOLsevIF1KPhD+sfeVOgHHNnGeGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GtSMZ8MkQzLLee9CHf2T4VR7NThoWoVRM0aZaI+6EIlsORBkIHrID2smLoEf6aus5M+enAyDO8b6wk+9jTcpdtQbCDl2kJ5/HF36XNa0AZna/mjRpfi4OKAmkFputDjyJfAMRH9fGFXXiQpDqb1tquAsIGIlSft+86T5BQhMnX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=TsPEcB/8; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=UwQPWAjD; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="TsPEcB/8";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="UwQPWAjD"
ARC-Seal: i=1; a=rsa-sha256; t=1787658391; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=M45uAjbDemq0PJFHc4HZR1G5Yibs/vnYTpXm+nGnu/xKLHKsvzF4SXzUukIXKS0E7g
    QY1klPT7B+1ehS3qBW9qW5TyOCobQ2PX73S7z2XDSOVb948wSsqhOgQISw579YDDsTiI
    bZhLN1pCYrE58XAx016yBet8s1769Y1MMYLvTTjb4+7PJlkvJICx8Ufx1xEDsU2/WRWm
    FaBCzKXjPdDFQWU9DCD1sjSgllgNKd5b33uXrOARgj0OrKpyJ9n1GGKiSyPUUU4j+mfk
    r3Sq0LkKhJmqo1Ye6/f3leP0pNKOCCStP8lZ4OMR+wdueaLq+flzVNc8Hvacd4DgwBoj
    4KCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1787658391;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=iP6jtxwbjBDjbuYkNn10IjbK3A++kSGtLuw0xlnBAiA=;
    b=sR/Q1ogS7Dknhd0JcSFxpcew0SExKNGhRWd1p39N+1Z1TizMmV6U5r8i8rjNRoXqBw
    cZSVGJJE0uSGu6kFaMrmyaTLw2+RtjJSGTsEXf1ArWRBfs+pwUpU+LftIDnGaDRg5+SS
    zrkMLuuMxhq6MoiY7SAMlLuRVNRnKBIKCPK2J/dAK/wIUq4U2p/gEc5a3OSKS5vLDzqV
    5PqCqKLSn3uhx9BQxy1B57irkEXSJy1MBLyoDD3midS0DH/xRp/yYbHmFRwVeatdLzSi
    /Syzz5eUJjRY1OBaKKWxEcQ8vDT1Go2qs6oUYDlucPHcg38Y6zQzPqfSj8DkJTuZVvlb
    pnYQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1787658391;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=iP6jtxwbjBDjbuYkNn10IjbK3A++kSGtLuw0xlnBAiA=;
    b=TsPEcB/8NAGp804tDVsc4fLoNOuiIsEK0gCWKL4ygN9rPZytBGLWVaFsBJQNqQziOp
    EGYDk9qgjYALKFdv6bovxOHQfoSjLfrKNmMaE1WTgcX+0+1zazagC2srpuW9pTKv1TOX
    u6+g55hPtGAuNuQzI2VaLhvrnaqoIe+NpcKQ96gogl8A4wRb1IP1mZwC8j5GUpKsqCGA
    kWJncAuKGMQlu5s+AfbNVXOcZ4qyLWL9P70GiNSG4ZhdRL7knbEr1ERn5Lx9Rlk1SFA/
    EJa/qDiWAEeuEnqMIdGSmx3RXWP324i4sXr7QBjP8WZKlzNfpyzQ4LS3mpZYe+IhXtlW
    czyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1787658391;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=iP6jtxwbjBDjbuYkNn10IjbK3A++kSGtLuw0xlnBAiA=;
    b=UwQPWAjD5CGSeoJ018ZwemewVcL8E4qyA/qulOa+5bgV4rNach3+Lr4dFeWDyLtuRq
    8FI1o4rYbxN/0nSdZ0CA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tTUsMrZpkO3Mw3lZ/t54cFxeEQ7s8YjX10Q=="
Received: from [IPV6:2a00:6020:4a38:6810::76e]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id K171b727PBkSkGk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 25 Aug 2026 13:46:28 +0200 (CEST)
Message-ID: <d23aaeb2-1ed4-4b83-befb-996c569da27f@hartkopp.net>
Date: Tue, 25 Aug 2026 13:46:21 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] can: isotp: publish tx.state with
 smp_store_release()
To: Jinjie Ruan <ruanjinjie@huawei.com>, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, bcrl@kvack.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, yi.zhang@huawei.com, pmladek@suse.com,
 rostedt@goodmis.org, andriy.shevchenko@linux.intel.com,
 linux@rasmusvillemoes.dk, senozhatsky@chromium.org,
 akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, mkl@pengutronix.de,
 kuniyu@google.com, willemb@google.com, jhs@mojatatu.com, jiri@resnulli.us,
 kees@kernel.org, cyphar@cyphar.com, tglx@kernel.org, liuhangbin@gmail.com,
 sdf@fomichev.me, nb@tipi-net.de, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-12-ruanjinjie@huawei.com>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20260825095422.3166067-12-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 25.08.26 11:54, Jinjie Ruan wrote:
> The writer already pairs with the smp_load_acquire() readers
> in isotp_tx_timeout()/isotp_tx_gen_done(); convert
> the smp_wmb() + WRITE_ONCE() into a release store.
> 
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>   net/can/isotp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 155530aedce2..11b653ba7c10 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -1156,8 +1156,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	my_gen = isotp_inc_tx_gen(READ_ONCE(so->tx_gen));
>   	isotp_set_tx_result(so, my_gen, ECOMM); /* prevent stale slot matching */
>   	WRITE_ONCE(so->tx_gen, my_gen);
> -	smp_wmb(); /* see smp_load_acquire() in isotp_tx_[timeout|gen_done] */
> -	WRITE_ONCE(so->tx.state, ISOTP_SENDING);
> +	/* Pairs with smp_load_acquire() in isotp_tx_[timeout|gen_done] */
> +	smp_store_release(&so->tx.state, ISOTP_SENDING);
>   	WRITE_ONCE(so->cfecho, 0);
>   	spin_unlock_bh(&so->rx_lock);
>   

Hi Jinjie,

thank you for the patch, but I think this breaks the barrier logic.
The original smp_wmb() ensures that so->tx_gen is visible before both 
subsequent writes (so->tx.state and so->cfecho).

By converting only the first write into smp_store_release(), the 
WRITE_ONCE(so->cfecho, 0) is no longer protected. The compiler or CPU 
could reorder and execute the cfecho write before the release store of 
so->tx.state, introducing a race condition with the concurrent readers.

Best regards,
Oliver

