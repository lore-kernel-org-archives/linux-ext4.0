Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203192;
	b=0qvnxMxTvmREq2k7DMBurV2fEYpzE8SUUBdnFynNrCa24f5KLVN5PqgD+9z4Em8hcKcQ
	 e0Ohice1bae103ByVAo/MSluqZ8AMWqP6o8k6IBykM3nFWe997I092o2Q4nBNWBdDBNib
	 6aLw/VD9/ytq2A0a9znKCW2KqngD9VP2SqtD2k5wlToIhk5FgqlzmAss/7QUPGvTs0Hj5
	 e8KcNBthtuAB+N3wCqibPzLoSq2K6nS9YkBlHVRH69DmwYuZPd06PmkBjub8ZTcc3DU1E
	 zgaEks1pmzrKfBFBKMIShgKqpUXTjUc9GaIXL7ywQrdqINvh8Kxs1lzRclAHRkcWn5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203192;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=l3tVzcj26vlAGE46hF2X5BB1I3D1+2/FC/tTZkkpAbflnzvhnZgHKZe4R4vRTc0Cnyz0
	 g10pjHlzuLg76zO2tFms/mWKbbmw50c2W2A07Xb0f+7fiduwJjoEPy8oOsRbG5HhIoAeo
	 8QvvJwYj7Kbx9Sry+1TYlj7bWK6Pm4K8ZxV/o3MoZW5vL2LXX10sIetsaw7eq5z+sfWxj
	 vCsbga/DR+/VjSG2wdy3Hh3t8eKxYmKMzRYA8QGBMKC81QikkiVGO8UPDlUJSYMRKCChG
	 3LHTOAB/zMVPMqX0yjo6tCE/flMTi5LfHYFfiLxMlzvpmEhbRGxb5tExChh+EYL242Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC29606A31A;
	Wed, 28 Oct 2026 15:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EC29606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9BA9168AFE; Wed, 28 Oct 2026 16:59:48 +0100 (CET)
Date: Wed, 28 Oct 2026 16:59:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] common/rc: probe pread options with a real read
Message-ID: <20261028155948.GB20501@lst.de>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu> <20261015-dontcache-test-v1-1-6aa7583973a9@columbia.edu>
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
In-Reply-To: <20261015-dontcache-test-v1-1-6aa7583973a9@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

