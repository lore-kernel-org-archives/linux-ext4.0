Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C0A3F88BB
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 12:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181575; cv=none; b=HR526xxa7YvnRLIEm2gHcCsWN32aLkdSyEl8h6PT72JY7GTHM6aery/HbE90svpFFXD5ZLTCKSc/ylAz4Cc8BO7WTL1CU6Jz902Lph8ixCY9kevnil65MknFw9MIDD/FVv25lk6vYw9I+9/Dd7d0XyknH7zl2I3jA6+sP5PHvjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181575; c=relaxed/simple;
	bh=J1LOK5xEkslxjECOUepgYvKYygph2WJpGFhOLd+DXqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIBlVY8HAhHOa0a+fH3P9vQF95eQ7tYcA8QyBeoIOPP9xe6nGNh8HYY4D5WejOKfU8Rzcqxogd4lIeXlGC4VjGNQYGpfu1H660gbyXpZDaCyA3AgnZ+7GUTT+T/r4E2wGc1SNSt6Kdtcnz5vxSUgaB9WsvWKXBqfXKh8IgRiMj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=X8c1avCP; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="X8c1avCP"
Received: from trampoline.thunk.org (pool-173-48-113-189.bstnma.fios.verizon.net [173.48.113.189])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65BCZTMM008241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 08:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781181339; bh=1af3V7mq+xCVl62o6oZObWkjIbBuyc92g8CHfmlc7Fo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=X8c1avCPPczGcL6PdZX7NbmBmnahlPD5YDbt9dUrV2HspWlZJZYHbQR+kfcrPy7Kj
	 5Q5IHVMLNgoIZEfMR4mEHhP6nnSLNCipIPCg8RmVt/zrP7pE/7LA6keCcHGIdXi13E
	 RC/lp0y8W9pgW51P83l6E7hHIf03e7QESaH7CqpYUgM1GTwR7NS++Mw+wpTp/6Zw9a
	 yfrcFz8DdYOtPTlqINb8uSaindwC5p+h2PjTVsqPN19UDkjZ9HfmiTHicGOZ+Qa3br
	 8rUkN1NQXhH3PuD0uMlXx8DqRY6OA4MWTs5Etn63rQOKDFSdhJBXpREQIXp5GIyUi6
	 6/CcytNngRgsw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0B73E2E00CF; Thu, 11 Jun 2026 08:35:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org,
        syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Thu, 11 Jun 2026 08:35:17 -0400
Message-ID: <178118128409.522716.1341590641766651492.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608065227.3018-1-aditya.ansh182@gmail.com>
References: <20260608065227.3018-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 08 Jun 2026 06:52:27 +0000, Aditya Prakash Srivastava wrote:
> When the data=journal mount option is used, the ext4_journalled_write_end()
> function incorrectly calls ext4_write_inline_data_end() without checking
> if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.
> 
> If a previous attempt to convert the inline data to an extent failed (e.g.
> due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
> the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
> call to ext4_write_begin() will not prepare the inline data xattr for
> writing, but ext4_journalled_write_end() will incorrectly attempt to write
> to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
> ext4_write_inline_data() since i_inline_size was not expanded.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix kernel BUG in ext4_write_inline_data_end
      commit: ad09aa45965d3fafaf9963bc78109b73c0f9ac8d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
