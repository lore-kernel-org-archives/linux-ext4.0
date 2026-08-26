Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B68399CF0;
	Wed, 26 Aug 2026 08:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731473; cv=pass; b=LESUOGzPPkHVJisJ03yiWw0z6xB7HKexBgoUznamQMeBk6kkhgU9r0Fke8SiV0FBtjrXJoZNMfeTF3PUPnLZ7+TMfkvw1Bl39EJ6xZxe4oTzwDOpQNAacWFMO98HixhY/I8k3jdbJDEWMQSCoB7LO6RT5EKnNFUuMR1/HLlokbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731473; c=relaxed/simple;
	bh=1K93Sxi+Nu8YpEXEss+ZLBJqNNXd5/5fYQ5WylzwLcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oJzGdiMFx9uomXb9lMu3x9aej+YIllaeXXxPODIgx6YxrEEwpCAY9QQZMQq/U1F7Hzv32fFxPQG30Kao2RVJFQF0ua5TsHjrn0Ra36L6unQ81HIH/mQHjYvlkrjb5/7n7idq+k2R62K0dMkWKNT94lU1Ogc1z3QUN4mL4AE7rk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=qey9xxMF; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=cKH0DRkc; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="qey9xxMF";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="cKH0DRkc"
ARC-Seal: i=1; a=rsa-sha256; t=1787731461; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=fza5aW/LkTT+ZR4Yee/r1zq7z3v/8hnWyRf7Z2mvdxpfaw35UFCSc3aNlfQPWDmy6l
    8eX+aJedFP7bPt0wsTpcMx0IGajUOBL9vNzJz6MArJbDvxRMM/5Q8FzDPb3khFTG9SBw
    u399Nhe6uvt3wfrtxCxipkTEKk4aJo8Zt6PmTVdIP3TgPzUr54V27Y/1FR/O5xRectdy
    RdohmERzUqZ3yT7DpI0uaDg6zmRlmkS+P5igdCONnXYhrcIQqtF1U//daUOcc2VQQ0SS
    h5DyEQJRvM4Uy/X2c/gzopZvPPXUuMIEGLOD9C+p0aQZhDGBoJVSoPYNcqxRbUMS79ps
    N6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1787731461;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=MoaHxjYunFWGgumpgqoG7Dx2f70N2p1lTEGDqO83liY=;
    b=GjrF79ReFOat+GLc1v3FQk+r+zKwQUCsj7DyRi7eHxeCiG7mNerQ9TMycN5mQznUWC
    oB70eq+waoTdftF3dbtQNn5ZI/njNSz+QFRKIp9WExu6QOaq6PbPycf7CKLCEwOqrkmt
    chpbT6JvOxNEqfcwL8d0xOSnC5Xu0G6W5w85xptLA0SysquV4vINh7Bp4E+prwtEMHHo
    l65TyU2PAnJJ5FvjFW2OmhrWbM1dZBTwXtPJgN6b1m/eWJRgX87eltltosSTc1RZXfRT
    Eto3sLhu9RiAHRsPX5SGP9tpQRnE8F94TFXkfNs3h/oiBT2WAfWjjdY6N+MNKEitvfi+
    B8xg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1787731461;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=MoaHxjYunFWGgumpgqoG7Dx2f70N2p1lTEGDqO83liY=;
    b=qey9xxMF6PS4QpkNRo9GAC+EZgCPkNfEq6f/0R41cdVE2QuRMpVDUfOxuXQ4vDO1tA
    zPYyPyvgIHPOuvL6W9lWkfc94ecXk8UQPjGZwc5GEhEnodbO+mpaHOJBkDV/qRIi6U5A
    OSfG/8PgPC0+umDZ8jlzwlN5d/ONj+BGLbwejiyjmxocnfsnoNEdEX0yQuBF+NDPr//M
    ndiY1IlaF5DBc9yZPg6DGgA1mMNGs4XGfC+4nnp9r44Eh8GCam82MlqDf7pk/97qOHKB
    tLtxadFWBEdGWbtHFAm80iRmYvG+ypgmpsLh9hdFmKarpLeHIcgryPlQW1ZyK8uFje0h
    vNaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1787731461;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=MoaHxjYunFWGgumpgqoG7Dx2f70N2p1lTEGDqO83liY=;
    b=cKH0DRkcLkVr9gpkvfpXbhKDYWy93vb1/J3uFsLwDk4+z+YNTQRKJIDMRSuaQeCSsO
    BUE1aF5Bb23HwrR9acCQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tTUsMrZpkO3Mw3lZ/t54cFxeEQ7s8bDup0Q=="
Received: from [IPV6:2a00:6020:4a38:6810::989]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id K171b727Q84Goo6
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 26 Aug 2026 10:04:16 +0200 (CEST)
Message-ID: <871b0e00-1ca0-40b7-9dad-35b3b7943f4a@hartkopp.net>
Date: Wed, 26 Aug 2026 10:04:05 +0200
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
 <d23aaeb2-1ed4-4b83-befb-996c569da27f@hartkopp.net>
 <bc9a3081-a567-4e2a-8847-c60fd0e3dc89@huawei.com>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <bc9a3081-a567-4e2a-8847-c60fd0e3dc89@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 26.08.26 05:33, Jinjie Ruan wrote:
> 
> 
> 在 2026/8/25 19:46, Oliver Hartkopp 写道:
>>
>>
>> On 25.08.26 11:54, Jinjie Ruan wrote:
>>> The writer already pairs with the smp_load_acquire() readers
>>> in isotp_tx_timeout()/isotp_tx_gen_done(); convert
>>> the smp_wmb() + WRITE_ONCE() into a release store.
>>>
>>> Assisted-by: DeepSeek:DeepSeek-V3
>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>> ---
>>>    net/can/isotp.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>>> index 155530aedce2..11b653ba7c10 100644
>>> --- a/net/can/isotp.c
>>> +++ b/net/can/isotp.c
>>> @@ -1156,8 +1156,8 @@ static int isotp_sendmsg(struct socket *sock,
>>> struct msghdr *msg, size_t size)
>>>        my_gen = isotp_inc_tx_gen(READ_ONCE(so->tx_gen));
>>>        isotp_set_tx_result(so, my_gen, ECOMM); /* prevent stale slot
>>> matching */
>>>        WRITE_ONCE(so->tx_gen, my_gen);
>>> -    smp_wmb(); /* see smp_load_acquire() in isotp_tx_[timeout|
>>> gen_done] */
>>> -    WRITE_ONCE(so->tx.state, ISOTP_SENDING);
>>> +    /* Pairs with smp_load_acquire() in isotp_tx_[timeout|gen_done] */
>>> +    smp_store_release(&so->tx.state, ISOTP_SENDING);
>>>        WRITE_ONCE(so->cfecho, 0);
>>>        spin_unlock_bh(&so->rx_lock);
>>>    
>>
>> Hi Jinjie,
>>
> 
> Hi Oliver,
> 
>> thank you for the patch, but I think this breaks the barrier logic.
>> The original smp_wmb() ensures that so->tx_gen is visible before both
>> subsequent writes (so->tx.state and so->cfecho).
> 
> Right!
> 
>>
>> By converting only the first write into smp_store_release(), the
>> WRITE_ONCE(so->cfecho, 0) is no longer protected. The compiler or CPU
>> could reorder and execute the cfecho write before the release store of
> 
> Indeed, that's true.
> 
>> so->tx.state, introducing a race condition with the concurrent readers.
> 
> My rough understanding is as follows:
> 
> All lock-free readers fall into two disjoint sets:
> 
> - `isotp_tx_timeout()` and `isotp_tx_gen_done()`: read only `tx.state`
> (acquire) and `tx_gen`
> 
> - `isotp_txfr_timer_handler()` the timer path of `isotp_send_cframe()`,
> and the post-claim path of `isotp_sendmsg()` touch `cfecho` but never
> `tx_gen`.
> 
> So no lock-free reader observes both `tx_gen` and `cfecho`.
> 
> `isotp_rcv_echo()` is the only function reading both, and it runs under
> `so->rx_lock`, which serializes it with the claim.
> 
> So the ordering the `smp_wmb()` provided on top of the new release store
> `tx_gen` before `cfecho` — is unobservable to every reader.
> 
> Moreover, `tx.state` and `cfecho` were never ordered against each other
> by the original barrier: both followed the `smp_wmb()`, so the `(state,
> cfecho)` visibility seen by the lock-free timer readers is bit-for-bit
> identical before and after this change.
> 
> So the release store preserves the one ordering that matters: a reader
> observing `ISOTP_SENDING` sees the new `tx_gen`.
> 
> Best regards,
> Jinjie

Thanks for your explanation, but this assumption is too narrow and 
misses how so->cfecho interacts with the rest of the ISO-TP state 
machine, especially under concurrent TX and RX traffic.

Even if isotp_tx_timeout() and isotp_tx_gen_done() don't read cfecho, 
other functions do. For example, cfecho is heavily involved in the RX 
path—such as in isotp_rcv_cf()—where incoming Consecutive Frames are 
validated against the current transmission state.

By converting the code to smp_store_release(), you only guarantee that 
the write to so->tx_gen happens before so->tx.state. However, you 
completely lose the ordering guarantee for WRITE_ONCE(so->cfecho, 0). 
The compiler or CPU is now free to reorder and execute the cfecho clear 
before the smp_store_release().

If a concurrent CAN frame arrives and triggers the RX path exactly at 
this microsecond, it could see an updated, cleared cfecho value while 
tx.state is still in its old state, or vice versa. This breaks the 
atomicity of the state transition in isotp_sendmsg().

The original smp_wmb() acts as a clear fence: it ensures that both 
subsequent writes (tx.state and cfecho) become visible to all concurrent 
readers strictly after the new tx_gen generation is visible.
We cannot weaken this guarantee. It makes the lockless design extremely 
fragile and prone to hard-to-debug race conditions.

Therefore:

Nacked-by: Oliver Hartkopp socketcan@hartkopp.net

Best regards,
Oliver

