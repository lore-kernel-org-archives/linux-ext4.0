Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QN7ctFjO"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDD4D68;
	Thu, 23 Nov 2023 07:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cRle48OR1Y4Ci2rvLicUXi7ASMQFImZUpVWaM1PJQvs=; b=QN7ctFjO66TmuLZvp3G8RWZFQU
	qRnmpa5lMMs8m5gMB8Ss8NILQr+G1nIj6NN0zwuqCCBJg7t6XDzUQi1jG3hsiWzC1xtGBlG2NSgqn
	cHA2bjB6AFDxsgPgSbb9ZmUD1mGzNVFvBcJf4Rsx+tErP6PW+UHVlHf2zbCk73xAlDvOFT6asf9a2
	2yLPAXBS9BHLKB5hVgovqm5DMKfQFUFfwet+GKisM3O/+ug+Vb4zWhoWH4r6JV3nWqlpR45xI537g
	G5qmHk1HjIB+G2CgF3mllf67Y5u2VDJeyanlQgbtHshV+MB2Ws3HtkMoFg0kIP8NDh3jkLjanFFnU
	uYNX8jpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6Bkm-005BbM-17;
	Thu, 23 Nov 2023 15:36:32 +0000
Date: Thu, 23 Nov 2023 07:36:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
	ritesh.list@gmail.com, hch@infradead.org, djwong@kernel.org,
	yi.zhang@huawei.com, chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [RFC PATCH 11/18] iomap: add a fs private parameter to
 iomap_ioend
Message-ID: <ZV9xgAXbJMCJqWvt@infradead.org>
References: <20231123125121.4064694-1-yi.zhang@huaweicloud.com>
 <20231123125121.4064694-12-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231123125121.4064694-12-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 23, 2023 at 08:51:13PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Add a private parameter to iomap_ioend structure, letting filesystems
> can pass something they needed from .prepare_ioend() to IO end.

On it's own this looks fine.  Note that I have a series that I probably
should send out ASAP:

   http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/iomap-map-multiple-blocks

that makes each ioend only have the embdeed bio, and bi_private in that
is unused, so you could just use that if we go down that route.

