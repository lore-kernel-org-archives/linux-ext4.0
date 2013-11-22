From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bio_add_page rw mode check by merge_bvec_fn
Date: Fri, 22 Nov 2013 07:36:18 -0800
Message-ID: <20131122153618.GB15143@infradead.org>
References: <528E4A50.7040609@itwm.fraunhofer.de>
 <528E4C19.70507@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	NeilBrown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
	Kent Overstreet <kmo@daterainc.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528E4C19.70507@itwm.fraunhofer.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

While this is trivial to fix it's also fairly unexpected and easy
to get wrong for new callers.  Neil, can you explain why you
desperately need it?

