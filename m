Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99494E3764
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812177; cv=none; b=J0JL/vqVdykTM/gRpmpVEedICXYLu5Ltih5tApvfTcnuojq1xjgXOwJ6KKz0XOIfFmdpQseL5u+5BYx0hIyRKvZx0QPNQAdL4K2iENchMZPFhDUsm7Gvx/+8sTXsCBhc8KiqIS3Td4TcjwuNmI0fIaTm6mBRgim7J3vunrSrkQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812177; c=relaxed/simple;
	bh=QjfKpdPTWo1fNeVP6eAMy/XntjlsQM0nHZQDcqrjKfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCaaGX211BtJuYuAqRlKNXYBFXLrz7Rn3/ULMTEjxrB4maWoy8gkdxcn52JCFIaDxiL/a3looPNPL/58FLLAZQ07XSyqulyA6ZNUOhQgGDDHKbS95Qx9EiqAHDHNwdaoeg1XMeu0ouCeaVXZvbkIwK3bnSdQn6/7FhIU92KbHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Kcd/zm6A; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Kcd/zm6A"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND936u017924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812145; bh=hp0I6uxCzgN1cOwl1fjxjqOfPOm+bVEDaYGvhvKkUcc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Kcd/zm6AWqT+dAWHGc+Hn4XLcw+qhzwiqHtOvBddTyStyMbtsK2+zF/X+0r0SSvvT
	 VCMbRE4E9hPhQwc4tHD4AOcsdizXoY4FACuZMuKjQq/udVNHeL8DrB/so+/HFnYviO
	 uJAx8dHX4AU/Z90fL4POaZCVMjmBuXJVmrAY7uk1gDN6hjsWi/CaK964UJzXGJ+eMx
	 8casSL/Ylkz9sXKwcvwjVCkS9jlioiepF1kXJ1oaamadtHj5smpFm2ydVPdv00VP+I
	 OAxflMFbNHYpKwmZRYcW8pI/srZ+jMhuAXtPiwedT+4Bvd3geZh/+Lc7Tg1BsPQqhx
	 UhgP+a+Qc1GTQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id CC4102E3F1F; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Remove ext4_end_buffer_io_sync()
Date: Thu, 23 Jul 2026 09:08:47 -0400
Message-ID: <178481171727.796182.12833678958266118249.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260615182527.2208479-1-willy@infradead.org>
References: <20260615182527.2208479-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 15 Jun 2026 19:25:25 +0100, Matthew Wilcox (Oracle) wrote:
> There's no need for a custom end_io routine here.  We lose some
> tracing of I/O completions, but we gain better error handling.
> Well, consistent error handling anyway.

Applied, thanks!

[1/1] ext4: Remove ext4_end_buffer_io_sync()
      commit: 7f0485dd30175d7934d101ce73efa999ad2d107d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
