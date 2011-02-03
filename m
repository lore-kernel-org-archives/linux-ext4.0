From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Date: Thu, 3 Feb 2011 10:28:23 +0100
Message-ID: <20110203092823.GB2570@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jaxboe@fusionio.com>, tytso@mit.edu, djwong@us.ibm.com,
	shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca,
	jack@suse.cz, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	hch@lst.de, josef@redhat.com, jmoyer@redhat.com, vgoyal@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110202225549.GA28109@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Wed, Feb 02, 2011 at 05:55:49PM -0500, Mike Snitzer wrote:
> @@ -808,9 +808,14 @@ static struct request *get_request(struc
>  	rl->count[is_sync]++;
>  	rl->starved[is_sync] = 0;
>  
> -	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> -	if (priv)
> -		rl->elvpriv++;
> +	/*
> +	 * Only initialize elevator data if REQ_SORTED is set.
> +	 */
> +	if (rw_flags & REQ_SORTED) {
> +		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> +		if (priv)
> +			rl->elvpriv++;
> +	}

This isn't enough.  Now the allocated requests would have REQ_SORTED
set before going into elevator.  You probably want to filter out
REQ_SORTED to elv_may_queue() too.

Also, it would be great if you update the comment on top of
get_request() to explain what @rw_flags does.

Thank you.

-- 
tejun
