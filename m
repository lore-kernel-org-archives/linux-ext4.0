From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Date: Thu, 3 Feb 2011 14:38:20 +0100
Message-ID: <20110203133820.GF2570@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
 <4D4AAC9A.4050407@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
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
To: Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57696 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab1BCNi0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 08:38:26 -0500
Content-Disposition: inline
In-Reply-To: <4D4AAC9A.4050407@fusionio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey, Jens.

On Thu, Feb 03, 2011 at 02:24:42PM +0100, Jens Axboe wrote:
> On 2011-02-02 23:55, Mike Snitzer wrote:
> > REQ_SORTED is not set for flush requests because they are never put on
> > the IO scheduler.
> 
> That looks very wrong. REQ_SORTED gets set _when_ the request is sorted
> into the IO scheduler. This is gross misuse, a bad hack.

The rationale behind suggesting was that it indicates to the allocator
that the request may be sorted as how the request will be used is
communicated using @rw_flags to the allocator.  The patch is buggy
that the flag actually ends up on the request.  Any better idea how to
communicate it?

Thanks.

-- 
tejun
