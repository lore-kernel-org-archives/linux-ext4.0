Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840947D94F
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812210; cv=none; b=foG+kbytqHJJM/+rl9Lt51sdCDIKBA9FCI9vDJQ3o9CaRfmUpBJrG8/X293GCKVPJM1MOz2duTQlvUmGMXT+kdgvYCsDUt0AIZpwmibVN2sRl6ZOMfhDKPNISSjAB0V0nSMoYv/t2C3i6wDnPucqPpZfVwmZYSEpjrPTbgSyqRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812210; c=relaxed/simple;
	bh=BwucinpU7mBh/wRbSAQ6vmio6eMNcZ0tNfSOUDLBbAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ng0CELFzEAniOBCor4E+uhNwLqOzEOPf8/YZm7icszeylLPekKGSNEmejCf/FWk6qVmM2/bVPL+6F+NBKnBc7DgC3SgylSGvatv07c+V32x9OK9rd4uZi2TXPi28mKH91Ty9lGb4euXng+llKLmCWttFEJmgHf646AdtnqssWjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=MWTGC1Rr; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="MWTGC1Rr"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND94V3017987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812148; bh=ofnCWmvqyceT3elKksKFNwOwXSgYaOmRUabOuLHdoLk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=MWTGC1RrCV4p/bozpVRJrTU9gMtmYhyumrQPt4v1B37bqMJFd0j5I56LrnrmZoMWC
	 ICa6NJlZBE0frCbeitZxqBnJfVCKW7vqaj1fvfP3K/yqlM9Kx+g7LnP7s+xb5pHvDY
	 JQU4FIvq0JvQzrQ9KG17S5p2natDlUl4QIAUjLdHSQ3ssksu+sCQsM5uWmXkGET1Rg
	 9sM8+Cj7f6rP+u0JLRA66r7qTO5VdWgf5N/HiKqGyt+zr/pvmvw3iQehpQuuIC8Njm
	 8OIS8l1pKp8LUGgDHJR4GvPV5NTKs3blHlsN18Bytz0hoi2k9dM12UWZ29TEQSWHYc
	 Rg3rbx9dTirWA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E88A22E3F27; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Jia Zhu <zhujia.zj@bytedance.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] ext4: avoid tail walks for cached large-folio writes
Date: Thu, 23 Jul 2026 09:08:55 -0400
Message-ID: <178481171724.796182.1013390309077521614.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609035202.90669-1-zhujia.zj@bytedance.com>
References: <20260609035202.90669-1-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 09 Jun 2026 11:52:00 +0800, Jia Zhu wrote:
> This series addresses a buffered-write regression we found during our
> v6.12 -> v6.18 LTS upgrade testing on ext4.
> 
> The regression is in the remaining buffer_head path.  A small overwrite
> of an already cached, uptodate large folio still walks every buffer_head
> attached to the folio in both write_begin and write_end.  With order-0
> folios this was bounded by the page size.  After ext4 enabled large
> folios for regular files, the same loops became proportional to the
> folio size.
> 
> [...]

Applied, thanks!

[1/2] fs/buffer: avoid tail commit walk for uptodate folios
      commit: f10b9cc1eb20637351f4e33372bfb464f89de59b
[2/2] ext4: avoid tail write_begin walk for uptodate folios
      commit: d09811183db2891776dbf0c0f1094540e29938f6

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
