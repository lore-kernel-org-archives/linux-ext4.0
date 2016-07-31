From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Open bugs found by fuzzing as of 2016-07-30
Date: Sun, 31 Jul 2016 00:37:27 -0400
Message-ID: <20160731043727.GB12853@thunk.org>
References: <579CA5EB.1070707@oracle.com>
 <09df1f58-ed4c-6887-e112-bbc68d9ec1d6@gmail.com>
 <579CFF1B.40201@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nborisov <n.borisov.lkml@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <579CFF1B.40201@oracle.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 30, 2016 at 09:25:15PM +0200, Vegard Nossum wrote:
> 
> It seems that most of them are indeed tagged for stable; for the patches
> I submitted or reported for, it looks like the only one without a stable
> tag is a warning about large memory allocations -- commit
> 7bc9491645118c9461bd21099c31755ff6783593.

... and that's an oversight.  Commit 7bc949164511 ("ext4: verify
extent header depth") should have been marked for stable.  I've added
stable@vger.kernel.org to the cc.  Could you please it to the stable
kernels?  Many thanks!!

					- Ted
