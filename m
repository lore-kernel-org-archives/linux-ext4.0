Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055992;
	b=dSRS7oQ65xBuFGkfUM1JJCW5nKRGSORp1G7dXsW2EIxWR/FjSSc+nrHoJ3LsS3buGOUq
	 VNcpgaF8oto5YsonPOpTOAeQL58efRx8Un3J16rChmpnHX0P2NAuag0QlhBNAl1BLVY2d
	 EtpSfCG57vujzvmA3Dm0WJD9MJtrWUVB06QpamFq/3aXuce4/PnCnP6uP3t0VdwwAaS1N
	 tZ1JruS0q5dyi+ovvy+ceBzwow3utv4/9NH0/9Re39+R42rjh+B5SBBxsFusrzvhuyvSV
	 dmLkSZDT4hWSd5ICXAmc+2O+l9Nzuh1p2opeVz67hSVhenoTLMb0iwWbCA22e9Wl0Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055992;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ghAsB1EQ6W9HushhTZukbQU7hgwIEOGHN/35nrQIsqA=;
	b=AzlZb47cwIkuFQLuKxy6D+5l0poxsHUkjw3lB5ax95bMK1zZ49KLKx0LBwgXalebpyIH
	 h71ZBvJpQYi91d07BUNRFZc4GjSTZcJDzC9rWVib5XlvS25X64ySApT2Ke/uktATDBRI2
	 K+FWSpu0RedVa+mppAEDn5MX1nPA0ytPpzWiz1jCePVDfWxeaCJoY8vz+59pO4sCZuIEX
	 8HLG6lDHzTXsrfm3gXm+E6F4/z5z3Z8zPTtydge+D4K7lGEvrDg+lSGl7RYfUpS6CP+sT
	 VpmOHUpq0swzbqj5ccLAlcAam+t2n364136l54HyRQeJv7tSG6nfvGGk2JJr8pvRunQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=g3u3VjCd;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FCC606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 02:39:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1FCC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=g3u3VjCd
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJ2csww000439
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 21:38:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795055939; bh=ghAsB1EQ6W9HushhTZukbQU7hgwIEOGHN/35nrQIsqA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=g3u3VjCdMiZJz4n0JHeG8g3f/jKykOBr2a9lDRTEPTZL+qiUNHo0nIYlBe+93spl8
	 TNgr7qQtTM9dtfU1jtN8woOlcWL6spRjT9Z5PXsqq9KmThb+YjJwzCeuXGdFQXimmG
	 H6flsIb7JTeaODkz5G1kJGpJYXQP1ByJFz5NTR3lqMha4eE8WY+cE9XsTrhtD0inVn
	 S1F4JOo925pPcaIKpAlocXew0fVHrILeFZNsBvHFNBpMSY6ESFZqLBWSsnAp9nnDcK
	 J0wsGmpcIEsPox2HNjfPPNbgo/zvGkNLRqzSTDO4w9Dxk+BDvyZI2BMLsRQS3wlDha
	 CiZXmY90lN3wQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 900BE28441A0; Wed, 18 Nov 2026 21:38:54 -0500 (EST)
Date: Wed, 18 Nov 2026 21:38:54 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: reject impossible group free cluster counts
Message-ID: <av5hDZzzrKNxmDBy@mit.edu>
References: <20261102042428.65204-1-zhaogongyi@bytedance.com>
 <F238B62D-6BED-4D64-B099-B956B820BA44@dilger.ca>
 <2c1663e5-fac2-4346-ab2a-b35ae652373a@bytedance.com>
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
In-Reply-To: <2c1663e5-fac2-4346-ab2a-b35ae652373a@bytedance.com>

On Tue, Nov 03, 2026 at 10:58:38AM -0500, Zhao Gongyi wrote:
> 
> I will rework v2 so that only the checks needed to safely load the
> journal are done before recovery, followed by full superblock geometry
> and group descriptor validation after replay and before free-space
> accounting. I will also check which existing validation helpers can be
> safely rerun without duplicating initialization side effects.

Did you send out a rework of this patch series?  I don't see a v2
version of this patch in my inbox.

Thanks,

						- Ted
