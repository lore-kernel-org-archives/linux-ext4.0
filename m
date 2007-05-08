From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: 2.6.21-ext4-1
Date: Tue, 08 May 2007 15:05:56 -0700
Message-ID: <1178661957.4135.66.camel@dyn9047017103.beaverton.ibm.com>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
	 <1178571383.3933.8.camel@dyn9047017103.beaverton.ibm.com>
	 <20070508025048.GC32602149@melbourne.sgi.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:42450 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXEHWGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2007 18:06:05 -0400
In-Reply-To: <20070508025048.GC32602149@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-08 at 12:50 +1000, David Chinner wrote:
> On Mon, May 07, 2007 at 01:56:23PM -0700, Mingming Cao wrote:
> > In any case, it would be useful to add a new set of testsuites for the
> > new fallocate() syscall and fsstress in LTP testsuites to automatically
> > the preallocation code in ext4/XFS.
> 
> I hacked an existing XFS test prog to do manual testing of the fallocate()
> syscall. In the XFSQA suite we have various pre-alloc enhanced utils (e.g.
> fsstress, fsx, etc) that we should probably update to be able to use both
> fallocate and xfsctl so we can test both.
> 
> Here's all the programs we use that have preallocation awareness:
> 
> chook 982% grep RESVSP ltp/*.c  | awk '/^ltp/  { split($1,a,":"); print a[1] ;}' | uniq
> ltp/doio.c
> ltp/fsstress.c
> ltp/fsx.c
> ltp/growfiles.c
> ltp/iogen.c
> chook 983% grep RESVSP src/* | awk '/^src/ { split($1,a,":"); print a[1] ;}' | uniq
> src/alloc.c
> src/fstest.c
> src/iopat.c
> src/randholes.c
> src/resvtest.c
> src/unwritten_mmap.c
> src/unwritten_sync.c
> 
Thanks for sharing the info. I think Amit used a fsx version with
preallocation awareness test, but I don't know if we have other ltp
tests that aware preallocation. I would very appreciate if you could
share your preallocation test with us.

> BTW, have you guys tested mmap writes into unwritten extents? ;)
> 
I am not sure, Amit, have you done some mmap write test into
uninitialized extents?

Sorry, I still not quite clear what's the mapped problem you are worry
about. Could you explain to me a bit more? thanks!

Mingming


> Cheers,
> 
> Dave.
