From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Date: Fri, 4 Feb 2011 16:08:46 +0100
Message-ID: <20110204150826.GJ12133@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
 <4D4AAC9A.4050407@fusionio.com>
 <20110203133820.GF2570@htj.dyndns.org>
 <20110204150456.GD32190@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jaxboe@fusionio.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"djwong@us.ibm.com" <djwong@us.ibm.com>,
	"shli@kernel.org" <shli@kernel.org>,
	"neilb@suse.de" <neilb@suse.de>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"jack@suse.cz" <jack@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kmannth@us.ibm.com" <kmannth@us.ibm.com>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>,
	"hch@lst.de" <hch@lst.de>, "josef@redhat.com" <josef@redhat.com>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110204150456.GD32190@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Fri, Feb 04, 2011 at 10:04:57AM -0500, Vivek Goyal wrote:
> > The rationale behind suggesting was that it indicates to the allocator
> > that the request may be sorted as how the request will be used is
> > communicated using @rw_flags to the allocator.  The patch is buggy
> > that the flag actually ends up on the request.  Any better idea how to
> > communicate it?
> 
> Though you did not like the V1 of patch, personally I also liked just parsing
> FLUSH or FUA flag in get_request().
> 
> Or how about intoducing a helper function blk_rq_should_init_elevator() 
> or something like that and this function will parse FLUSH, FUA flags.

I suppose it's Jens' call, but if the FLUSH/FUA testing goes inside
the alloc function, please decorate with big fat comment and mention
it in the comment for the union definition too.

Thank you.

-- 
tejun
