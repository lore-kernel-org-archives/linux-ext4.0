Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795398721;
	b=HJB92oLePVmZ9PYljXkKC6WTxKEWQ+FUYyC50xPIwzBR3DOQzGP98JVXXHAjmrrP6tYq
	 xq+UnfYv8IcLdxiQPwRpeMKgoGt+AUCgu4cUJ35TwviXVF9egDm3DFwaLRLCbJMf0x6OR
	 hJ4MiEALMWRC8wSF73akO20P/nNUSmsQQoVry3Hcx5LxNWOll7GCBT7DgavQvzzNPtbkM
	 klzqqmt7YFpBuNeJ6RnnRthfQbiBDFG8na2lIOtINA4SWtjZYJ1RsvZEiSH21lR3xBzit
	 2DWZP5MfJ26m3kPrgdYj97BGhZwpOoFYge7qV7/g1bI1Uo+Fvp+597fqk3bjf3M1nVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795398721;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YVtyufYB92pslMYc1cNPbAx48nCwMK6/elZbLI4VZ4c=;
	b=3b1dFJyrDGRLC+tu9NawC41161E2gl1wvLFUvbdwDsMPek1ZIAp7l3vAv/XBIwW0vP5+
	 IC/p+ADmsc5xXwI0A3veOQ3ibQyQj7h1ISlmURoPa8ftpoCXtkE+QBqmVCUUNPXYx6/UQ
	 Zv8F07Dji17nYwEvLokrOQkFl9dCwdhSAgXfk5/psrYHwC0wrPe2BusocFAQIBInyyTZM
	 XJrHyG4MazHsaV5dunYU8S7Ml4P+SG72ZUhq5br8/Zhk/cjPsofSOj6E49YcRK2JFDKGm
	 22CuIkTiNYMPnxRuPAapJWLGeymEBiazM6R92zeyM42v00UF7UxXEBPSyIcNIiZp8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XJO+XIkm;
	arc=none smtp.remote-ip=91.218.175.42
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2AC606A32D
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 01:52:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D2AC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XJO+XIkm
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e+QHWbBPMWAeiyatS48Y4WE7Tii5hCDimKpeiM65Zg8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795398718; v=1; x=1796003518;
 b=XJO+XIkm3rkM9nMrQaJ88DBU/SbDNDS8sX/2dIaj3cwmRrKirwqyb+I0+uhLyek6+NMpIzpi
 feptrx/ngiR7GStYVclrJX2X302KeSUwM1np0LDwreiaO4CnEGlTK2BETzp5dn6xGe4YcTGokd9
 xsy7UnLpMsmmUcjbVs0s4weY=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1054823f21723493;
	Mon, 23 Nov 2026 01:51:57 +0000
X-Mizu-Trace-ID: 1054823f21723493
X-Migadu-Flow: FLOW_OUT
Message-ID: <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
Date: Mon, 23 Nov 2026 09:51:41 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj1072538@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, asml.silence@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>, Sumit Semwal <sumit.semwal@linaro.org>,
 christian.koenig@amd.com, Philipp Stanner <phasta@kernel.org>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>,
 Mengmeng Zhao <zhaomengmeng@kylinos.cn>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261120154153.GC28611@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261120154153.GC28611@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/20/26 23:41, Christoph Hellwig wrote:
> On Fri, Nov 13, 2026 at 03:06:13PM +0800, Mengmeng Zhao wrote:
>> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>>
>> This series adds dma-buf read/write support for ext4. The dma-buf direct
>> I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
>> but currently it only supports raw block devices. To better serve the
>> GPU-NVMe direct access through normal filesystems, prior work for XFS has
>> been discussed at [1]. We are also interested in this field and working on
>> it [2].
> 
> Can you an Anuj please work together and merge this into a single
> series covering both XFS and ext4?
> 

Hi Christoph, sure, I'm glad to work with Anuj on this.

Hi Anuj, I'd be happy to help pull our patches together into a single
unified series and send it out for review, if you're okay with that—and
would appreciate your review once it's posted as well. Please let me know how
you'd like to coordinate, or if you have any updates in progress on your
side before I put the series together.


