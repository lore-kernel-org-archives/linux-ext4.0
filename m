From: Jan Kara <jack@suse.cz>
Subject: Re: [linux-next][EXT4][Oops]kernel panics when running fsfuzzer
Date: Mon, 25 Sep 2017 11:14:49 +0200
Message-ID: <20170925091449.GB5741@quack2.suse.cz>
References: <1505741461.6990.11.camel@abdul.in.ibm.com>
 <87lgl9lvhj.fsf@concordia.ellerman.id.au>
 <1506075381.17232.18.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        chandan <chandan@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506075381.17232.18.camel@abdul.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 22-09-17 15:46:21, Abdul Haleem wrote:
> On Wed, 2017-09-20 at 16:44 +1000, Michael Ellerman wrote:
> > Is it reproducible?
> 
> No, bug is not seen once for 3 re-run from yesterday.
> 
> Hope to hit it again in the future CI runs.

I was also looking into this but I couldn't figure out what has happened.
>From the crash it seems that jh->b_bh->b_private was NULL although it
should point back to 'jh'. But that just doesn't seem possible so maybe it
is something different. If you ever happen to hit it again, please save
the fuzzed image so that it can be used for reproduction. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
