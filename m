From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v2 2/2] block: share request flush fields with  elevator_private
Date: Fri, 11 Feb 2011 11:08:44 +0100
Message-ID: <4D550AAC.1090708@fusionio.com>
References: <20110201185225.GT14211@htj.dyndns.org> <1296600373-6906-2-git-send-email-snitzer@redhat.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:55576 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1BKKHg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Feb 2011 05:07:36 -0500
In-Reply-To: <1296600373-6906-2-git-send-email-snitzer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-01 23:46, Mike Snitzer wrote:
> Flush requests are never put on the IO scheduler.  Convert request
> structure's elevator_private* into an array and have the flush fields
> share a union with it.
> 
> Reclaim the space lost in 'struct request' by moving 'completion_data'
> back in the union with 'rb_node'.

Thanks Mike, I've merged this one and v5 1/2 as well.

-- 
Jens Axboe

