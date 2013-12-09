From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fix del_timer() misuse for ->s_err_report
Date: Sun, 8 Dec 2013 20:56:28 -0500
Message-ID: <20131209015628.GA12883@thunk.org>
References: <20131204072926.GK10323@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131204072926.GK10323@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 04, 2013 at 07:29:26AM +0000, Al Viro wrote:
> That thing should be del_timer_sync(); consider what happens
> if ext4_put_super() call of del_timer() happens to come just as it's
> getting run on another CPU.  Since that timer reschedules itself
> to run next day, you are pretty much guaranteed that you'll end up
> with kfree'd scheduled timer, with usual fun consequences.  AFAICS,
> that's -stable fodder all way back to 2010... [the second del_timer_sync()
> is almost certainly not needed, but it doesn't hurt either]
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Nice catch.  Thanks, applied.

						- Ted
