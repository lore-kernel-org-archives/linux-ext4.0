Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FF94F5DE4;
	Tue, 13 Oct 2026 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892778; cv=none; b=lpYb1gmOIVgEHOGYS/FgqP5lEIZ/X1YElGVeqzY5J7lnmBSxCqO41UM90fPK8QnDKWulR1+NEXlJBu5dSg5BcBw8vhxpdPk82wC+brD/V3QKpoCtCVmtT7zNIetRF0WSO/lbT1wZeSI6+5oU4SvbWzSKR7ITJPHVz7pBN9IYnD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892778; c=relaxed/simple;
	bh=r+P/0aiUZ5OEP58sad2Jx3bVFCiid6ZmpblfL3eIotg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETSEsTi9p0r1c8/0I1JxSRYztBv3NTIwmMQy0FkTYnJS0YbcU3uAqyoFCzvqBB7Cpb/fP65xXp3N0vGojr9Ks6U84l1CpjmRvg73huobsB6g8uVYC4BLZ/wIJbYt+/OBFRy4vEPxuhNQVZTcdVCvHAKz8fyvtxsr1zPfaz4UcIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A69B227A88; Tue, 13 Oct 2026 13:59:27 +0200 (CEST)
Date: Tue, 13 Oct 2026 13:59:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Taotao Chen <chentaotao@didiglobal.com>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
Message-ID: <20261013115926.GA2944@lst.de>
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

I wonder if we can add a test to xfstests using say the mincore command
in xfs_io to check if the pages actually get dropped after a trivial
RWF_DONTCACHE write to verify this behavior?

