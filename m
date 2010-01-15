From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Fri, 15 Jan 2010 14:17:31 -0600
Message-ID: <4B50CD5B.9050804@redhat.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu> <4B50C78D.2000807@redhat.com> <20100115201521.GE7256@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab0AOURh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jan 2010 15:17:37 -0500
In-Reply-To: <20100115201521.GE7256@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Fri, Jan 15, 2010 at 01:52:45PM -0600, Eric Sandeen wrote:
>> At least as far as that last bit goes, simply having the extents
>> feature is not sufficient; we allow both formats of files to exist
>> on a filesystem with the extents feature turned on.
> 
> ... and I guess someone could be appending to a legacy file when the
> system crashes.  I suppose we can at least exempt extent files from
> ordered mode handling.
> 
>> As to the general idea I'll have to give it more thought. :)
> 
> Yeah, and we need to do a lot of performance and functional testing.
> Jiaying has done a lot of testing of this in the past couple of
> months, but more testing, especially power fail testing, is definitely
> a good thing.  I also want to do power fail testing for journal
> checksums and async commits so we can turn that feature on by default,
> since with those features enabled, it almost doubles fs_mark
> performance.  (Async commit is now badly named, what it does is
> reduces the number of write barriers needed from two per commit to
> just one.  But we do need to test it some more...)

At one point google was planning to devise a power-fail test
harness.  Any news on that?

> This was more of a statement of intentions than a "we'll turn this on
> by default in 2.3.34".  I figure we'll merge first, and then change
> the default later, and still later we'll simplify the code paths by
> removing the old code path.
> 
> Speaking of which, something more to think about --- does anybody
> still care about nobh mode?  It was necessary to preserve lowmem for
> 32-bit kernels with lots of memory, and it was mainly useful for
> database workloads.  But with 64-bit kernels, it's not clear the
> tradeoffs of not caching the block number are really worth it any
> more.  What would people think about potentially dropping the nobh
> option and write paths from ext4?

I have no special love for it personally, and I don't run into
fedora users or red hat customers using it, as far as I know.

-Eric

