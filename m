From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sat, 27 Oct 2012 13:55:34 -0400
Message-ID: <20121027175534.GA7783@thunk.org>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508AF3FA.4020506@redhat.com>
 <87wqydx957.fsf@spindle.srvr.nix>
 <20121026205618.GC8614@thunk.org>
 <87objpx84k.fsf@spindle.srvr.nix>
 <20121026211542.GE8614@thunk.org>
 <87haphx76u.fsf@spindle.srvr.nix>
 <20121027002258.GB31030@thunk.org>
 <873910xevu.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <873910xevu.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 27, 2012 at 01:45:25PM +0100, Nix wrote:
> Ah! it's turned on by journal_async_commit. OK, that alone argues
> against use of journal_async_commit, tested or not, and I'd not have
> turned it on if I'd noticed that.
> 
> (So, the combinations I'll be trying for effect on this bug are:
> 
>  journal_async_commit (as now)
>  journal_checksum
>  none

Can you also check and see whether the presence or absence of
"nobarrier" makes a difference?

Thanks,

						- Ted
