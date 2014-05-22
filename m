From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Thu, 22 May 2014 10:38:57 -0400
Message-ID: <20140522143857.GA23056@thunk.org>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
 <20140521141203.GB1501@thunk.org>
 <20140521150619.GA5459@rei.suse.cz>
 <20140521185824.GB8868@thunk.org>
 <20140521212003.GA7493@rei.suse.cz>
 <20140522024527.GA22059@thunk.org>
 <20140522104505.GA10150@rei.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luk???? Czerner <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: chrubis@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55661 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaEVOjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 10:39:12 -0400
Content-Disposition: inline
In-Reply-To: <20140522104505.GA10150@rei.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 22, 2014 at 12:45:05PM +0200, chrubis@suse.cz wrote:
> Right, sorting out right testcases is not easy task. But given that the
> runtime is not that long we can do rough selection and end up with
> something that runs in about 10 or 20 minutes and covers all possibly
> relevant testcases.

Something to keep in mind is that for at least some file system
developers, such as myself, we end up running certain tests multiple
times, so we can get test coverage for different file system mount
options, block sizes, file system features, etc.  Currently, I have
ten or so different configurations for my full test run.

So if the bulk of the 20 minutes are tests for which there is
duplicate coverage with xfstests, or which is stuff that is only
testing behaviour implemented in the VFS, that's actually 3-4 extra
hours of testing as far as I'm concerned.  Hence, the longer and the
longer the tests take, the less often I will run them --- and the
effect is not linear.

So failing to eliminate tests which are not relevant is not cost-free.
In some cases, the costs of winnowing out non-relevant tests may not
be worth the effort.  If it's only an extra 5 seconds, I probably
wouldn't care.  Although if you multiply the time saved by the number
of file system developers, and the number of full test runs that they
likely will be running during the development cycle, spending a few
minutes to disable a non-relevant test starts becoming net-positive.

> To be frank the reputation is one thing I would really like to fix.
> Nothing is more frustrating than spending years fixing code and still
> being ignored because of the past you haven't been even involved in.

Well, to the extent that many years ago, I was employed by one of the
companies had a well-meaning, but ultimately counterproductive
contribution to LTP, by putting relatively junior test engineers that
didn't understand the kernel code all that deeply, and was given the
mandate to increase the code coverage percentages as the only figure
of merit, I was actually somewhat involved, if only indirectly.

Unfortunately, I wasn't able to effect change by advocating strongly
enough for a more productive approach (which would have required
putting in far more senior, and thus more expensive and harder to
allocate engineering talent), although I did help eventually help by
arguing that ceasing support for what I considered to be a deeply
dysfunctional effort as the best thing that particular company could
have done at that point.  :-(

So I really have to commend Xiaoguang Wang for having done a large
amount of analysis when submitting the report about the LTP test
failure.  That's significantly different from my previous experience
interacting with previous people working on the LTP project, and it's
precisely that sort of work and analysis which I'm sure will help turn
around LTP's reputation.

Cheers,

						- Ted
