Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794925433;
	b=mIwXfot/xFYnX6+tsFMrYOJk4KvPKcxMRoUCGFqH+G1MT868iXsGg8OxwrSEjJfl7jKA
	 QsXiR+0VqdIpd4oHiwM7ElwbtqaIUQyQ5uVfoStJnpPnuY/a37iV8EqCkvEiv9rUGHOFW
	 t9tFe3QTNHQ7yE5IVvVdvTZH+P0CX1rSuNkaoYyq0+akoWYRdXyWH8LcBEDvmJDxg2wRT
	 8TlR+9XWYr/5VlrRjVhijgJVzbcO+JaiLZmB3xxablt7FoKd61TCOCuv5+107Gt4pNS3H
	 WlzFaZEiqKi+HRxBCTQsGZ6SnGqlQqZzzsA74Pt7gpgS0Xuy9e3Qcb8rXzkKc8XFlgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925433;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+guh6iE7xYHMDxDlAuP+z2BJ/SuqIHLRli0tfKpcKSA=;
	b=nJy2prXRHgc2eknF8muSxLESjnARNrzmLmdVzBN9jaxJaYa1auDb9H7arZtrUxRW7Xti
	 ozkGj8LGmDDTwCtZv9+CgbCxu3UnoC2aBKMja3x/KTMjgImil9UdKLFG9WNEIlvOQ+bHn
	 24bA14bhfckogZ8vcedFnKQQuBJjSZz4QYkRm59/Ozx+oT/1WJPCUSLJO9mtUguWnDvi3
	 +nHobkiW6qs29jIQoNNxifS6hlxikZfC+cjZpv6dS2uwj6rrSCoXM1DQijbkeJTQWIO3v
	 T/2r/bJBhO8w4uErC7uEdZgJMXvbyt9qKAkybGghhMH+MDDlmeTsJHt9KKhxUjFrBmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n8EjsBSG;
	arc=none smtp.remote-ip=95.215.58.4
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FB8606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 14:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00FB8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n8EjsBSG
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vVEQh/xrnvg3iNH7ktwVr6B+e0axcBBg8VcjYROWAzs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794925431; v=1; x=1795530231;
 b=n8EjsBSG+Ee9ykzmSLTJnG/Cibj9X7WjI++nFAR8yngKRKtOUu4zPtZ9VUsIDASylbFGOavJ
 rijtRk+aSB2JzY4FQj48ufPfHyh8k3PlppMcvn+eIEh11MHpRQok1gVO0kWoiHyxS/RN/ZWSTaq
 EkFxlUv8TIAqaNTBxkwL46XM=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 08b26d05a708a200;
	Tue, 17 Nov 2026 14:23:50 +0000
X-Mizu-Trace-ID: 08b26d05a708a200
X-Migadu-Flow: FLOW_OUT
Date: Tue, 17 Nov 2026 14:23:46 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Zhang Yi <yi.zhang@huaweicloud.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, guolingxing <guolingxing@tju.edu.cn>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
Message-ID: <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
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
In-Reply-To: <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>

On Tue, Nov 17, 2026 Zhang Yi wrote:
> I think the solution should be based on Ojaswin's counting approach in
> [1] or the PENDING_CONVERSION solution we discussed, and then, after
> extent splitting fails, try to flush the journal and retry.

Thanks for the quick POC. Our agents ran it on [1] rebased on
23c62304dde2 with the report's reproducer, in two separate setups (QEMU
without KVM). None of 72 files lost data in either, against 42 and 53 of
72 with [1] alone.

They found two gaps:

- The new branch in ext4_ext_handle_unwritten_extents() skips both
  ext4_update_inode_fsync_trans() calls, so fdatasync() and O_DSYNC can
  return before the commit. On a full filesystem mounted with
  commit=3600, a shutdown test lost the write in all 13 buffered
  fdatasync() and O_DSYNC cases that reach the zeroout. They pass with
  [1] alone and with that call added.

- Direct writes into preallocated files can still get ENOSPC with the
  POC, on a few percent of files in both setups, with no data lost.

The POC tries the zeroout before the commit and retry. Should it be the
other way around? And will you take guolingxing's patch ([2] in my
report) as well?

- Jose
