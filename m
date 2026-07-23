Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE2341F7F2
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812167; cv=none; b=GaWdyMcMcQvuqADtMcg9q474OVL7oE0Ekn8jXwkeCaij3y3jbqYy2OHzahGDUkzWeOk8JtHSICaTg7m6ImEtla5+wN7fpd5LO+WF3wYYvIOjmXT3aujgLZ/fkmlg5COD84A97aLWRtisTLMOhSBmmRbVtXTrJjasa/W14ktjs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812167; c=relaxed/simple;
	bh=WiV/TPKq1oBk90cjEo2dwwqlNc0vVT/Cr1WsSLZV5vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2EEuTDOAerVKMGLUHg+dhPWxys3hBcGWYmDi3cbKXMhP4vEdZt8M05q6pzDmuD0tIX+tXurwEWSQ/KabSRLdxVJT4ISpLOGxCWJeDMTL0GpokgI+0f+zBbmJknUB15exz+pUEQxwh2lYJ3Ed/DazyXmBHtt3XWGjNmzEnMngCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=VC6qv0un; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="VC6qv0un"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND8xs1017842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812143; bh=hUqjAO+yyYfRN/qvSyuFrFuZlztXbFcwXVTUfv5qGEA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=VC6qv0unvKFQxWVz9U5GK6hlfvfJEs0ShsmIyD36KsztNU0DnVGeSrPaiInmHEw1F
	 eqXRPA2k2W1JdnwXv21OEdBbTsAS63BVQNgTdbUB8gYT5PWYycZUak+FtDrJQS6+iy
	 hwCujg8ZMEtMjTfTfepAD0IgvT9e4zqM8QE7WxURcBhRg5G9USVmiUprEtOYvmGr9U
	 bxY3zHblk6yPL/SkMT2nVZvEe2nOO3VzWnlj9MWrbDR3afQRqRZC2C5sZy3Xg1klaO
	 o+rH5et8XrNRP4oEGftmowec2zUtMfezcfuimLMieOKikQq4h51NN8Y3K3DWWylxD3
	 f4YAEZi++L63w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id AD7272E3F16; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Tao Ma <boyu.mt@taobao.com>,
        syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] ext4: use fsdata to track inline data write state and fix race
Date: Thu, 23 Jul 2026 09:08:38 -0400
Message-ID: <178481171744.796182.4771772432914384249.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703045414.1768-1-aditya.ansh182@gmail.com>
References: <20260703045414.1768-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 03 Jul 2026 04:54:12 +0000, Aditya Srivastava wrote:
> Instead of checking the live inode state (ext4_has_inline_data(inode)
> and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
> write_end handlers, use the fsdata parameter of the address space
> operations to explicitly pass down the state in which write_begin
> prepared the write.
> 
> A concurrent thread (such as ext4_page_mkwrite()) can convert the
> inline data to an extent between write_begin and write_end. If this
> happens, the write_end handlers would previously miss the inline
> write_end path and fall through to extent-based write_end logic.
> However, since block buffers were never allocated in write_begin,
> this resulted in NULL pointer dereferences or data loss because
> folio_buffers(folio) was NULL.
> 
> [...]

Applied, thanks!

[1/2] ext4: use fsdata to track inline data write state and fix race
      commit: 7edbb323bab2b2a609016014caafdb651c898249
[2/2] ext4: cleanup unused CONVERT_INLINE_DATA flag
      commit: f6065852d2137734bcb26c9f94e5daf526179aa9

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
