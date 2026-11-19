Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099688;
	b=H9mAzkIXP+Gu1LUlxtu8mewqaIYpMBh5kRW2QanSraviJSLaWSCWRPTqhhBU4+kp1jJq
	 P/UDSmxdc8gCNz4LZ3suOhFC+OouEY1YHKHnPaISGIDDbW+vlY98EIoJcPCnDC8FBanR/
	 Uly1loQTI+d8zx+3P75b/zxU+b4st8bYkAV8pnOAw9WswCCmj6PNqyZGSNki8uDzYPuP2
	 cRUCOdbPfTkN7Bnh3sQ+BPTUQZpYlZ9F9RkAzCxegHdbPC0oTgIZtPrVOm/ASyluQHnzY
	 0SadsYbgKGSGL42ayhA5gSp3rfBvZrcEgAdh5QkIa+YtX4Hw0iBnV4bDg62FQ7KH1hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099688;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=kurHUUmqX29/+jZpVsObmOB+w8+nkhXBuCbwBPy8NWc=;
	b=ja9lIghKosox6PDERsvK9zADx5W/nUE3ojrnMlZaodN3q6Hq6YJubQEKn5E+Nr5TBsFy
	 f/56998+GbvQnauxm9wz2kF73ABrKG9Z/zpmAobcYtyHHq4X0dX8omOxIKNxhMDTXBbu/
	 7+X+kITvo+sOG4vK68A9u65j+VcVSWXtzuyd7ZVk+yWtJe9EwEBck73MMla9wHnO+Idil
	 WTcB2M/pXRvPZ+XyuA8IA30KNHsPXsoxaECrQ0AxQhiemQsgT1GCV3un2KAOqaM77ICOX
	 hMtH5lCPrUk37nyo0gers5U7qmmdhhWZsxcBjX5PdGjGT6fF0OisG90fMWw7LU66CxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=owgtPBaM;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539060A6F6F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3539060A6F6F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=owgtPBaM
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfW0018211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=kurHUUmqX29/+jZpVsObmOB+w8+nkhXBuCbwBPy8NWc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=owgtPBaM6FtlAsZlyXIzLZzvr32hOzcWPJmjQ3JgMj+zSOmN9jdoCsyQkflXz+yH2
	 RLWTp1T/ti+gztJRepVjKNdKyIyNkD8q9fajrzLhYp3BsiVSVfEfWob/5Lrq1nHOqX
	 MkN2zCow2YJyEmq8H7T6eVk2gvJ8CuHEtrRlVkb8PPYn+uR2nYoEZTarmrV9gqz3if
	 VHU8BFRDlIjXt9y9Ee2y6e1BR02wzU4HJNLu162wkKNbBvQxvuiPL+jrlPd8JiAxm1
	 HwfDboqpZglm+4I0nso6pYzqY5ZTeShcoPIjYb3sKRqNpdAFIKfVhsrfhicYJ3l0Ci
	 dBtV5wMU68B9w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 6251C2E0196; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: set awu_max_opt to awu_max
Date: Thu, 19 Nov 2026 09:47:19 -0500
Message-ID: <179509948669.1938961.9058443174730907558.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910100829.2532894-1-p.raghav@samsung.com>
References: <20260910100829.2532894-1-p.raghav@samsung.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 10 Sep 2026 12:08:29 +0200, Pankaj Raghav wrote:
> commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
> added atomic write max optimal to statx. As XFS can support large atomic
> writes through SW, max_opt exposes the value that will be HW accelerated
> atomics.
> 
> As ext4 does not support SW atomics, set awu_max_opt to awu_max.
> 
> [...]

Applied, thanks!

[1/1] ext4: set awu_max_opt to awu_max
      commit: 291cccad437eafafab0357c5a3a990f995c96e67

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
