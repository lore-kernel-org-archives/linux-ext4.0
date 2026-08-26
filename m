Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919A92F6577;
	Wed, 26 Aug 2026 03:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787715202; cv=none; b=OxNkYmtRKJnkcxrK/sf9HEChYB4f/VMTUs5nv+HbtIcsRAx/vK7ZoVKPBKV128NKFq6qA5CSHoUYO0Qe5jq7xJm2au31479YHUtTkvuE7yvo3iR+XiQvDWRIxBsccbqe4Ollu7y9t0vdnPtMwp1lhqme67pNZjpXTdfA8eD9ehE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787715202; c=relaxed/simple;
	bh=k04VxeuqmKHRw01aSZ5Ko2c//yuRZs33EBX9KXGKLIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h0eEdhdBIJJzlOQavX6h7qrs5G/KhGkivSpKOMGBtdXKxh8IH3cdxgAVW9FSdEbsXJrNNUkCTmm3l+Qr8MKUelaM+CDXEriJZubohuxudWnJy/leoGpS+3RxfuhrIpUPdDfD8oFWaqJQB7076tXelYFMkaSJ0SHQLhkaMC0OQes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6G+x+Kts; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6G+x+Kts"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8aqZqDkznQ0wdG8yLp1nP/iwo/O0lbMvmv5Vz2oLzCQ=;
	b=6G+x+Ktscb6tbQNtT73i+vwYSFFIno4cZBJLhuPDOw7hAezUV0n+Iq/sVgFjm9j4LBh048buZ
	95poXpIgo7e/ybRpDL4rsCwIuqkIle6d3jkohcZ2p5+j3k2eio5Ei9lMKOyBms+aeySH212rdNR
	cBN/suKfRGaylbzFmlefqYA=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hV91r3gY1z1cyPY;
	Wed, 26 Aug 2026 11:22:24 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 52BEA40572;
	Wed, 26 Aug 2026 11:33:09 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 26 Aug 2026 11:33:06 +0800
Message-ID: <bc9a3081-a567-4e2a-8847-c60fd0e3dc89@huawei.com>
Date: Wed, 26 Aug 2026 11:33:05 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] can: isotp: publish tx.state with
 smp_store_release()
To: Oliver Hartkopp <socketcan@hartkopp.net>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <bcrl@kvack.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <mkl@pengutronix.de>,
	<kuniyu@google.com>, <willemb@google.com>, <jhs@mojatatu.com>,
	<jiri@resnulli.us>, <kees@kernel.org>, <cyphar@cyphar.com>,
	<tglx@kernel.org>, <liuhangbin@gmail.com>, <sdf@fomichev.me>,
	<nb@tipi-net.de>, <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-12-ruanjinjie@huawei.com>
 <d23aaeb2-1ed4-4b83-befb-996c569da27f@hartkopp.net>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <d23aaeb2-1ed4-4b83-befb-996c569da27f@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)



在 2026/8/25 19:46, Oliver Hartkopp 写道:
> 
> 
> On 25.08.26 11:54, Jinjie Ruan wrote:
>> The writer already pairs with the smp_load_acquire() readers
>> in isotp_tx_timeout()/isotp_tx_gen_done(); convert
>> the smp_wmb() + WRITE_ONCE() into a release store.
>>
>> Assisted-by: DeepSeek:DeepSeek-V3
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>   net/can/isotp.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>> index 155530aedce2..11b653ba7c10 100644
>> --- a/net/can/isotp.c
>> +++ b/net/can/isotp.c
>> @@ -1156,8 +1156,8 @@ static int isotp_sendmsg(struct socket *sock,
>> struct msghdr *msg, size_t size)
>>       my_gen = isotp_inc_tx_gen(READ_ONCE(so->tx_gen));
>>       isotp_set_tx_result(so, my_gen, ECOMM); /* prevent stale slot
>> matching */
>>       WRITE_ONCE(so->tx_gen, my_gen);
>> -    smp_wmb(); /* see smp_load_acquire() in isotp_tx_[timeout|
>> gen_done] */
>> -    WRITE_ONCE(so->tx.state, ISOTP_SENDING);
>> +    /* Pairs with smp_load_acquire() in isotp_tx_[timeout|gen_done] */
>> +    smp_store_release(&so->tx.state, ISOTP_SENDING);
>>       WRITE_ONCE(so->cfecho, 0);
>>       spin_unlock_bh(&so->rx_lock);
>>   
> 
> Hi Jinjie,
> 

Hi Oliver,

> thank you for the patch, but I think this breaks the barrier logic.
> The original smp_wmb() ensures that so->tx_gen is visible before both
> subsequent writes (so->tx.state and so->cfecho).

Right!

> 
> By converting only the first write into smp_store_release(), the
> WRITE_ONCE(so->cfecho, 0) is no longer protected. The compiler or CPU
> could reorder and execute the cfecho write before the release store of

Indeed, that's true.

> so->tx.state, introducing a race condition with the concurrent readers.

My rough understanding is as follows:

All lock-free readers fall into two disjoint sets:

- `isotp_tx_timeout()` and `isotp_tx_gen_done()`: read only `tx.state`
(acquire) and `tx_gen`

- `isotp_txfr_timer_handler()` the timer path of `isotp_send_cframe()`,
and the post-claim path of `isotp_sendmsg()` touch `cfecho` but never
`tx_gen`.

So no lock-free reader observes both `tx_gen` and `cfecho`.

`isotp_rcv_echo()` is the only function reading both, and it runs under
`so->rx_lock`, which serializes it with the claim.

So the ordering the `smp_wmb()` provided on top of the new release store
`tx_gen` before `cfecho` — is unobservable to every reader.

Moreover, `tx.state` and `cfecho` were never ordered against each other
by the original barrier: both followed the `smp_wmb()`, so the `(state,
cfecho)` visibility seen by the lock-free timer readers is bit-for-bit
identical before and after this change.

So the release store preserves the one ordering that matters: a reader
observing `ISOTP_SENDING` sees the new `tx_gen`.

Best regards,
Jinjie

> 
> Best regards,
> Oliver
> 
> 

