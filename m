From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] nowait aio: Introduce IOCB_FLAG_NOWAIT
Date: Wed, 1 Mar 2017 14:44:21 -0800
Message-ID: <20170301224421.GA12768@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-2-rgoldwyn@suse.de>
 <20170301153647.GA30631@infradead.org>
 <20170301155634.GA9630@infradead.org>
 <cc3fc6ee-c48d-1b51-59b7-1e322d10a561@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.com,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cc3fc6ee-c48d-1b51-59b7-1e322d10a561@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 01, 2017 at 10:57:17AM -0600, Goldwyn Rodrigues wrote:
> RWF_* ? Isn't that kernel space flags? Or did you intend to say
> IOCB_FLAG_*?

No, they are the flags for preadv2/pwritev2.

> If yes, we maintain two flag fields? aio_reserved1 (perhaps
> renamed to aio_flags2) and aio_flags?

Yes - I'd call it aio_rw_flags or similar.

> aio_reserved1 is also used to return key for the purpose of io_cancel,
> but we should be able to fetch the flags before putting the key value
> there. Still I am not comfortable using the same field for it because it
> will be overwritten when io_submit returns.

It's not - the key is a separate field.  It's just that the two are
defined using a very strange macro switching around their positions
based on the endiannes.

> Which brings me to the next question: What is the purpose of aio_key?
> Why is aio_key set to KIOCB_KEY (which is zero) every time? You are not
> differentiating the request by setting all the iocb's key to zero.

I don't know the history of this rather odd field.
