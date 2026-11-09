Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192871;
	b=gMFptDSkJbx6RpXOOue6XdgXO3I4w70kxlw/593KNzv1U2sZjimtDCTl3WgW+g4zqBYx
	 mu3yv4jleF1o3/6BOKlRA7L+y5wvmmDSHAWsFZ2+YIwv7fJghKZdQ/k9UzYATH+M+7ffZ
	 9GSmqioQ2M20cfv1E1iWIxQv5WY3LPe/7p+HwyG3Gwiptkp2RnQ86Q995xjl00Sd60JHY
	 PonnEVOx3ghWBiHy94TK7PTCvuS+E8AMOquLABHt+MkgDvoel2WtCQmSjW318ziyaKQwc
	 6cEnMg24RiIGZU7SmjQ+iCmjCITN2hBE47CJicnlDU7n0CJ2htgYIKu3p301kSunjRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192871;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=eoxX5hhnrVdnCsiEYxw4rUS1B0+rsEN339m2Nai3htg=;
	b=GrQwYUXruNK1YxCjdQIMFkh2Rn2Ed2q9Ne1DEvODJrGJkzgmoyH+DkS4vJ3FyJiYVKW9
	 asZjGOz5HFSDI8za5o94L10mguudxzWm2zgtfQu8dqeIaFj8w7MRVS3/gThS8dr+T9Lcn
	 XUyR2cumBRtt/xEn5DIgfSASm+d1c6rGCtA4xN4TZPdTH5CHCjBJHqrpILMVp+y6yeO0V
	 EXsbSOZvLmamEjee6GZyf1QzbTe8ZQfAJ+BEr5LfEm6oUsuoxQjswyfR48x/iqm68lW7/
	 zABy9x0EqMSziVXhleoF4R7xsfqMcgc9yBDygtoJ5twRfuo/9lfXuB46fdkYM2wxMbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tN54d4fE;
	arc=none smtp.remote-ip=91.218.175.5
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D886A606A326
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 02:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D886A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tN54d4fE
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8GZA7yXccoOl25ncF5WoFStP/OWge7+wGkdg+7Q22+4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192869; v=1; x=1794797669;
 b=tN54d4fELbTw1iziAe++lO07fZ5SAh4ue1naK2/9LPEFWsB9OLEZ7IIGwvMwJvNf7ENjDX9l
 QF+x5znsrYZqBLXzHYLOEerlPhB46/CjWVcI55sfgyCGnVuArQb6b6zkWJJxnh0Q7RS+EamCd8D
 JxPzlZh1L1SF3JmB2gcgkYPc=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 197dc3b85a73d5c0;
	Mon, 09 Nov 2026 02:54:28 +0000
X-Mizu-Trace-ID: 197dc3b85a73d5c0
X-Migadu-Flow: FLOW_OUT
Message-ID: <e483fc86-9a7e-49a5-873c-b5fb32d01848@linux.dev>
Date: Mon, 9 Nov 2026 10:54:14 +0800
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
Subject: Re: [RFC 2/6] mm/filemap: refuse dmabuf iterators in the generic
 read/write copy paths
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-3-mengmeng.zhao@linux.dev>
 <20261106104205.GB5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104205.GB5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 18:42, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 02:58:43PM +0800, Mengmeng Zhao wrote:
>> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>>
>> The generic copy helpers cannot touch device memory.
> 
> Which generic copy helpers?  This doesn't seem to touch copy_file_range
> at all.
> 
Sorry for the inaccuracy, it refers to the buffered io patch in 
generic_file_read_iter() and __generic_file_write_uter().
>> Refuse a
>> dmabuf iterator in generic_perform_write() and the filemap_read()
>> fallback while keeping any direct-I/O progress, and report a busy
>> folio from generic_file_direct_write() as -EAGAIN instead of asking
>> for the buffered fallback such an iterator cannot take.
> 
> I suspect the fallback code in the callers might be a better stop
> for this.
> 

Ok, I will put it in the callers side.

