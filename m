From: Norbert Preining <preining@logic.at>
Subject: Re: Ext4 slow on links
Date: Thu, 21 Jun 2012 11:28:19 +0900
Message-ID: <20120621022818.GD9669@gamma.logic.tuwien.ac.at>
References: <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D993.8090307@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D91B.8020707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <esandeen@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46750 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab2FUC2X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2012 22:28:23 -0400
Content-Disposition: inline
In-Reply-To: <4FE2260B.6090602@redhat.com> <4FE1D993.8090307@redhat.com> <4FE1D91B.8020707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

thanks a lot for looking into that.

On Mi, 20 Jun 2012, Eric Sandeen wrote:
> so almost all reads, and no read merges; almost 35 megabytes read and every
> one was a small 4k IO.

Ouch, that hurts.

On Mi, 20 Jun 2012, Eric Sandeen wrote:
> Would you be willing to provide an "e2image -r" image of the filesystem?

Ok, it is running now since a few hours and I am far from finished
I guess, since there are 350+G on the fs, and the compressed image
is by now 200M.

Is it fine to do it on a running system, or do I have to boot
from USB or so?

If it is not toooo big I will tr to upload it to some place were
you can get access to.

On Mi, 20 Jun 2012, Eric Sandeen wrote:
> Oh, but Zach Brown reminds me that if we stat the entries in getdents/hash
> order, it's roughly random w.r.t. disk location.  Newer utils will sort into
> inode order, I think(?)  Might be interesting to strace the ls -l and see
> if it's doing it in inode order, or not.

Ok, is there a special option to strace, or -trace=all?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CANNOCK CHASE (n.)
In any box of After Eight Mints, there is always a large number of
empty envelopes and no more that four or five actual mints. The
cannock chase is the process by which, no matter which part of the box
often, you will always extract most of the empty sachets before
pinning down an actual mint, or 'cannock'. The cannock chase also
occurs with people who put their dead matches back in the matchbox,
and then embarrass themselves at parties trying to light cigarettes
with tree quarters of an inch of charcoal. The term is also used to
describe futile attempts to pursue unscrupulous advertising agencies
who nick your ideas to sell chocolates with.
			--- Douglas Adams, The Meaning of Liff
