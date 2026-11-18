Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010777;
	b=N05lHncxSX0WpkiTDS1pF4NwqpGKG9YIV6Sry5Z7BjLRPPBmMs+0bkP0SqyRXKL5ZUdf
	 8g0kROUH1L56amITw2JySdHXVFG98trejePDjaGFBKNtv8Wt2bpnkDdw/feh2plpL5cLj
	 I5dyUoS6FZ3R+oICjve50Auq7iIcHhxgq4op+Z2vzmWsqfd/2T1Gh1+ZTGzDATZG9oZuH
	 XQxyN2Mz6N42EIcX9tsw2QhSMXxFjekkxyG5+zd+zn8BsGFMVlR60BEpdW/TbRTWODdHH
	 nND4zKkzfOMmS1jQHpBrUYW77LpX75ORoD/9HpkJIL7hI3YoxX297PD2ftHiiqXneWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010777;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zDdHU1Mp/qEVnnzvJCrNaX1Z+NluRq2vfZr6YiBJ/FM=;
	b=ExBI/YqBFPspQJ3O0U5DekSm65/hZxxgIKffLy0DHLK7TBvAK6GMwob5nCIKM+rUjRlS
	 cbEzxB4lu4ZqePv22ebFG2rFpRJ1zKMhL7d01y/R5rCL0SP36wliKkw8kQ2TY0QESKDZa
	 Fpt9Ye2t028GAwPkHRNS2EHwUPe8wYtL3uXDeE8CLUp0/ISev5eKAgriRDyCwhHR9mxUd
	 H7NrbmwHno/1ZV6DKuC71vxhJZFAjwxM3kRKdARAdiuAHJmZBrp+MjZ4luWImElLFRHRA
	 c08K34HobeoZZ1jYh+X+v5ejsSXxYuL0btnehGn2JJx0TsCLrEqHR1pyi2DJxGxdelg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RPBTyxN5;
	arc=none smtp.remote-ip=95.215.58.37
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15537606A320
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2026 14:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15537606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RPBTyxN5
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zDdHU1Mp/qEVnnzvJCrNaX1Z+NluRq2vfZr6YiBJ/FM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795010774; v=1; x=1795615574;
 b=RPBTyxN5I9/5DUMxX7kWUlulbiqTWvooAOtDgIkV/VcY49qaagrx36PoX9i6Lp75iX5gn2i5
 uQtfcMuZGpTuIX+ABE4H20KE3sk4P+NtpTrchLdHEHV2jOXfMalZsT0xgzNP4p0Z/WI0HchJ4Tf
 ZUF9ikc8YjrjAQ7WXctKJwVk=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aa0702a36d5e3080;
	Wed, 18 Nov 2026 14:06:13 +0000
X-Mizu-Trace-ID: aa0702a36d5e3080
X-Migadu-Flow: FLOW_OUT
Date: Wed, 18 Nov 2026 14:06:06 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Zhang Yi <yi.zhang@huaweicloud.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, guolingxing <guolingxing@tju.edu.cn>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
Message-ID: <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
 <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>

On Wed, Nov 18, 2026 Zhang Yi wrote:
> Could you provide a reproducer? My guess is that high concurrency causes
> the blocks freed by my current process to be taken by I/O issued by
> other processes

That fits our runs. I'll send you the script off-list.

- Jose
