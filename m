Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456740DFD4;
	Wed,  8 Apr 2026 02:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775614384; cv=pass; b=oLrPvFmWq6pga73YqzQtW3mVCLAxZsDyAYMvq8TKwQK8Q8Fik7kKVwqoCFv/nI8V5SkM9oEaQ3aotXzJsEvaefEfG3qr4ndyTwmxv6Fm6k0k+5FiLJ9N2Vk6phmyTkPOdexGCMtgGZtGjyjdXRXncMnist0JGE1JsEGnZ0dpKms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775614384; c=relaxed/simple;
	bh=eyoyXlcJTyoWlelpg/gBuIe+Uh0cOF1QNrrDhnzQwDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl2lDCKD4nrogTqAl83GFjVjMacWO9HBZP1JARz16PKxYnlY5fOuXZ13vuW12WcZwR7V5vQv7ZBv8aT09i4IBQ28iCNYzSN0FLy9TckdbFB7p5gwA/FvnY5UllITAu5z+AJjWXwW6dV47cJCD4JmwTqAL5/lwsx2/8ijWJrEXGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ImJFZvO3; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ImJFZvO3"
ARC-Seal: i=1; a=rsa-sha256; t=1775614354; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DR7jxLPDruobcn+KlW56bCuNMd9nWyonqcIfLzi2NKV+pzY/krmy7I+0CPhRQtxVi9Zhbhp9iGHsNFzoE7Ollr7WO7Z+UKbUNC8T+maxsVoEJd7xoVnNbeLwmEQLyFhmrAAMbf+e6J68tC90XS1evYP7WP4P4/bdxr/qYPGZGS8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775614354; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=eyoyXlcJTyoWlelpg/gBuIe+Uh0cOF1QNrrDhnzQwDo=; 
	b=m6Jl37K8BU3WDOmVCczdNiGVTcnMTftA2vYSJKaxbnmg/B94OSlU7yplG2e6ZwHdv28pTJqHetv/Xkgk5GBTl0CG+9cwg/9MhCiCCIn7BmWNF0ODLBeNjBIzWEJebu+HnAgMdTY5EEGP+Cex7mfF9l/86BYJ3VGqI61T9La/iIw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775614353;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=eyoyXlcJTyoWlelpg/gBuIe+Uh0cOF1QNrrDhnzQwDo=;
	b=ImJFZvO3J/22H8qAaSz1lOLgdpiL3RljdSIlJaZfJD8LsJRe07ow7jJagMdf8ISi
	x38Gv3upkkrPHIGn4t537fwchc3da3qMlEjyTsK9Aatbxpunec6UioTJXp/QcgV2c00
	oDlfFuyiZrry2zeV6JnPmNy3wrhl2l+zzSihhNBM=
Received: by mx.zohomail.com with SMTPS id 177561434908025.963734623901928;
	Tue, 7 Apr 2026 19:12:29 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Cc: Andreas Dilger <adilger@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] jbd2/ext4/ocfs2: lockless jinode dirty range
Date: Wed,  8 Apr 2026 10:12:14 +0800
Message-ID: <20260408021214.2060713-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260306085643.465275-1-me@linux.beauty>
References: <20260306085643.465275-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

Just a gentle ping on this series posted on March 6, 2026.

The current v4 has Reviewed-by tags from Jan on all four patches.
If there are no further concerns, could you please consider it for
merging?

I'm happy to resend if that would help.

Thanks,
Li
