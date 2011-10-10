From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch]ext4: add block plug for .writepages
Date: Mon, 10 Oct 2011 12:51:16 -0400
Message-ID: <20111010165116.GX7948@thunk.org>
References: <1317004226.29510.172.camel@sli10-conroe>
 <20110926073025.GB21079@infradead.org>
 <1317022727.29510.175.camel@sli10-conroe>
 <20110926094554.GA30827@infradead.org>
 <1317179380.22361.8.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54943 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab1JJQvZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 12:51:25 -0400
Content-Disposition: inline
In-Reply-To: <1317179380.22361.8.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 28, 2011 at 11:09:40AM +0800, Shaohua Li wrote:
> I searched a little bit, looks only ext4 need it. here is the patch.
> 
> 
> Add block plug for ext4 .writepages. Though ext4 .writepages
> already handles request merge very well, block plug is still
> helpful to reduce block lock contention.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Thanks, applied.

					- Ted
