From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ways to debug Filesystem code.
Date: Mon, 5 Aug 2013 09:46:34 -0400
Message-ID: <20130805134634.GB20389@thunk.org>
References: <CAGW2f1HfyW3WT-=OX3VSkMxrukSyw07G3PTfKzGZV=ANQh4qdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39582 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3HENqh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Aug 2013 09:46:37 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1HfyW3WT-=OX3VSkMxrukSyw07G3PTfKzGZV=ANQh4qdA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 02:38:53AM +0000, jon ernst wrote:
> Hi list,
> 
> Sorry for the spam. Just curious what are the ways/tools filesystem
> experts using for debugging.
> I sometimes use Ftrace, Kgtp and printk. Seldomly use virtualbox with kgdb.
> But each way has it short-comes.
> Just want to get some enlightenment about debugging skills, especially
> from you Filesystem experts.

Those are the basic tools.  Also useful to consider is compiling with
CONFIG_LOCKDEP, and with CONFIG_DEBUG_INFO or
CONFIG_DEBUG_INFO_REDUCED, and then using a tool such as addr2line[1].

[1] https://plus.google.com/117091380454742934025/posts/h8H9z4EopkS

Other tools include using xfstests run automatically from kvm and
having automated tools to parse the output of xfstests so you can see
test failures much more easily[2].

[2] https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/

And then when you get a test failure, knowing how to run the test from
xfstests by hand, with a fixed random number generator seed for better
reproducibility.   And of course, knowing how to use git bisect.

Beyond that, a huge amount of it is in experience in using the tools.
After all, there isn't that much difference the tools used by between
a master carpenter and a beginning journeyman.  They use the hammer,
screwdriver, saws, planes, etc.  The trick is in knowing how to best
use the tools.  :-)

Cheers,

					- Ted
