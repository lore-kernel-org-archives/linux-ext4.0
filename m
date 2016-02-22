From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Mon, 22 Feb 2016 00:56:04 -0800
Message-ID: <20160222085604.GA30903@infradead.org>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
 <20160218220232.GA4262@dastard>
 <20160219131829.GA30166@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbcBVI4I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Feb 2016 03:56:08 -0500
Content-Disposition: inline
In-Reply-To: <20160219131829.GA30166@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Jan,

this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
