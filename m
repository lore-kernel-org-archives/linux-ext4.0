From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for flush
  requests
Date: Thu, 3 Feb 2011 14:24:42 +0100
Message-ID: <4D4AAC9A.4050407@fusionio.com>
References: <20110201185225.GT14211@htj.dyndns.org> <1296600373-6906-1-git-send-email-snitzer@redhat.com> <20110202225549.GA28109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <tj@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
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
	"jmoyer@redhat.com" <jmoyer@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110202225549.GA28109@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-02-02 23:55, Mike Snitzer wrote:
> Set REQ_SORTED, in the @rw_flags passed to the request allocator, for
> any request that may be put on IO scheduler.  Skip elevator data
> initialization during request allocation if REQ_SORTED is not set.
> 
> REQ_SORTED is not set for flush requests because they are never put on
> the IO scheduler.

That looks very wrong. REQ_SORTED gets set _when_ the request is sorted
into the IO scheduler. This is gross misuse, a bad hack.

-- 
Jens Axboe
