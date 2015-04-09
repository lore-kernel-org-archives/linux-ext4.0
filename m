From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: WARNING: CPU: 10 PID: 23340 at fs/block_dev.c
Date: Thu, 9 Apr 2015 16:27:36 -0400
Message-ID: <20150409202736.GA13705@thunk.org>
References: <55268959.6040507@oracle.com>
 <20150409151736.GA31268@thunk.org>
 <55269891.3050709@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55269891.3050709@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 09, 2015 at 11:19:45AM -0400, Sasha Levin wrote:
> 
> Nope, I just got new servers to play with and decided to try xfstests.
> 
> I can try bisection if it doesn't sound familiar, but since it's metal
> servers it'll take a while.

It's in the "dangerous" group, which may very well mean that it's
known to cause systems to crash.  In general I tend to run either
"check -g quick" as a smoke test, or "check -g auto" with a variety of
different ext4 configurations.  The former takes about 30 minuts, and
the latter (given my current list of test configs) takes a bit under
24 hours.

I tried manually running generic/019, and even though I have
CONFIG_FAIL_MAKE_REQUEST defined, /sys/kernel/debug/fail_make_request
isn't present, and so the test complains that I haven't compiled it
into my kernel --- even though /proc/config.gz confirms that it is
enabled.

Is there anything special I have to do to get generic/019 to run?

Thanks,

					- Ted

P.S.  I have provided for ext4 developers are preconfigured kvm test
image that makes it very easy to do tests without needing to use bare
metal; let me know if you're interested in getting a quick start to
our setup.
