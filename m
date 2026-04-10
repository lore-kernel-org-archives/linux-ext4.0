Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC13DE45B
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834485; cv=none; b=hD5RrMDqSj0FanAeu1nJduoBFQ+F09sKTGwH1T2JFHV2dZWEUOjisutiYSwLSMZ5sJOKykYM5dFNe409XynH1AmXaLRxgNXZLaLrUj84Aj6maeuofY0qxpuUfF6Vxy9qRxCNLae3u0qB45uz4GSc+VCa10Xuros0Xwq5YS/ELPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834485; c=relaxed/simple;
	bh=xAad6Rg9r8tmoI6uN0DcOLlJLGeuxcOoVZYRaLJb4Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJNZQ2RsqIAV3sz7YnjlqTIL65CP4+QG+djuy7pZBDS5KKm2CtfNR6OtRJkk/oTr1pmMizDT4WmgZhe5geAYKaVmwfnoM7pyGQqr+mfDW01BqWXeSP3b3Mk4mcchmRHTT1DfDQ1/qxSy40akb2N4fhPA+lD7exmA4LBm6ZMzklY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=YZKOcskx; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="YZKOcskx"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIoTA015851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834333; bh=SYz4wWr52RDGSWvxm+GF80z9xD6xeY1lNx3crsmuOHM=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=YZKOcskxG+RNFUL/f6U98aLr+DXzkdIZQj3OI7aC6mVofalIa8rZgSwIgZaGN1MJP
	 QjE1jEbuppKUTUqS9rssyDA+BcPMQ4nFI/G4hI8uHCjGlOAUHCo+vQnyWtawNsxpqk
	 DKTKSllqNvdiCDTfYg5r+Qg7W2bHr3xqfYOWIukdEm63we1dgqTMzEHe3rKt94cPO+
	 l1eGGW/gc87BVVbrIu96v5EHtCYr0kihnQAP8nAWzIxKvYeTp6Hi0y8/JPADjbasl2
	 zhSUF1cA5aXQiEj6rS+XWgdjVOzwbifkZATG6ZRs4z0/H5MKCbyWwNZYOoQ3KxX3sQ
	 El014pUsHpuTg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 10D792E00E2; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, skoyama.kernel@gmail.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, bhupesh@igalia.com,
        Sohei Koyama <skoyama@ddn.com>, Andreas Dilger <adilger@dilger.ca>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
Date: Fri, 10 Apr 2026 11:18:41 -0400
Message-ID: <177583430881.2758959.6209162016867491519.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260406074830.8480-1-skoyama@ddn.com>
References: <20260406074830.8480-1-skoyama@ddn.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 06 Apr 2026 16:48:30 +0900, skoyama.kernel@gmail.com wrote:
> The commit c8e008b60492 ("ext4: ignore xattrs past end")
> introduced a refcount leak in when block_csum is false.
> 
> ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
> get iloc.bh, but never releases it with brelse().
> 
> 
> [...]

Applied, thanks!

[1/1] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
      commit: 77d059519382bd66283e6a4e83ee186e87e7708f

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
