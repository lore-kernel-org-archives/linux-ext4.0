Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA8148C3E3;
	Fri, 18 Sep 2026 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.59.206.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789714512; cv=none; b=NAaYf8qMSlnsml16RcOeZgWJTDk2mNvOFREowuAVcLhOpQkZ8HGxqsX3TTdcRknPI4XXj3u9yZovxD3DleLLPWWmFLOB2Ft8x0xzhed4HbPfy2i+IZ3O1E1HkN/1d5x9rI4xo8DoIFqq9IS/Eo/S1ZV86lbuDvf3nT2r9nGa56c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789714512; c=relaxed/simple;
	bh=Y9s+V8hIMLVqSdacHfFD88ou9qrojjmYU6uQCjwgbFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nROi+QCijOhrtHQOrFRjXBli6Vn2v3NzT5TwmGpnUXPIavvx+6O4L9zsWPEHr2sXkfJHwoGYztZjVxTkbRK2xMWVxUEJACq5Ey+JdXSERxb6bfI/qL6SapkWMRYPlNvw9HmqWIUoUxXNp51B01hJmqypANmZlfuj3FKrmu8eK2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=KdXxenMf; arc=none smtp.client-ip=194.59.206.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="KdXxenMf"
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4hmNfZ2qqhz4RCj;
	Fri, 18 Sep 2026 08:55:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1789714502;
	bh=Y9s+V8hIMLVqSdacHfFD88ou9qrojjmYU6uQCjwgbFk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KdXxenMf6Uv0mqlMvf06S7gzLdPoS8tHtOiET/D+FovlrL1jUGVO7dqTp4nKcjKM/
	 gqFbYIz0CDnYpDKD1OJE1hqAErHI6+asb9OeWLaaVKmNFkYREe3yjrHyMJkOFAubg8
	 N/YFs9EWEyenHxCwgDnMPB006RYjfJ4DxZcgZsE25DM0pE9MAMSVsMLN5dX5PlvKlS
	 J/bFZwQyUvT2cfdsyels36Yi3ENMgQsk+nFRyA6UHFETc/MjJveiIIa4/7yf081SE6
	 DTWhrFoCXea1vEfRbTTlhKZnzeZnLpsLpV7bU60743Qiu4769TxjiGc/0+NJsUJhLT
	 0l3hKTCxz5hDg==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4hmNd61CT3z7wv7;
	Fri, 18 Sep 2026 08:53:46 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hmNd46N9yz8scr;
	Fri, 18 Sep 2026 08:53:44 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id A4C195F995;
	Fri, 18 Sep 2026 08:53:39 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <12e93e0d-0fb8-4ac8-9be2-3d9b5f7c6d4e@leemhuis.info>
Date: Fri, 18 Sep 2026 08:53:38 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
To: Christian Brauner <brauner@kernel.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Srikanth Aithal <Srikanth.Aithal@amd.com>,
 Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
 <apiMiLlwujmqyYLP@user>
 <c3be2678-72e6-4122-94de-ae95e980578b@linux.alibaba.com>
 <20260904-unkraut-preis-pendel-a57f694a54c5@brauner>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <20260904-unkraut-preis-pendel-a57f694a54c5@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178971442017.268043.15968006172941830620@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: A4C195F995
X-NC-CID: 3cTDfuCUa7jz5N+rD9oSjy+lGqqoxOGdMhEhVhaaIqK9CZ/Cn2k=

On 9/4/26 12:35, Christian Brauner wrote:
> On Thu, Sep 03, 2026 at 09:42:27AM +0800, Joseph Qi wrote:
>> On 9/3/26 4:52 AM, Yalagada Pavan Kumar wrote:
>>> On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
>>>> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
>>>> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
>>>> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
>>>> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
>>>> directly") made them point b_data at the kmalloced frozen data rather
>>>> than a folio.  Submitting such a buffer during journal commit oopses:
>>>>
>>>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>>> [...]
>>> I was working on a fix for this syzbot report [1] and didn't realize that you were
>>> already working on it. I noticed your patch on the mailing list, so i won't
>>> send a duplicate patch.
>>>  
>>>> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
>>>
>>> Could you please add the Reported-by: and Closes: tags from the syzbot report
>>> to your patch? This will help syzbot associate the patch with the reported
>>> issue and track the fix.
>>>
>>> [1]: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f
>>>
>> Could you please address the above when apply the patch? Or should I
>> resend the patch with them?
> 
> I'll do it. Thanks!
Christian, just wondering, did this fix maybe fall through the cracks?
This got on my radar because there were a few other reports about this
regression since then -- and I can't see this or some other fix like
this in -next.

At the same time it feels a lot like I'm missing something -- or like
some deeper problem with all of this turned up meanwhile, which required
more changes that people are still working on. If it's something like
that and everything is on track, feel free to just ignore this message.

Ciao, Thorsten
