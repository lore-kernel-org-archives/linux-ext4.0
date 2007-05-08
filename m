From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-ext4-1
Date: Tue, 8 May 2007 12:50:48 +1000
Message-ID: <20070508025048.GC32602149@melbourne.sgi.com>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org> <1178571383.3933.8.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Dave Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42736 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967642AbXEHCvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 22:51:46 -0400
Content-Disposition: inline
In-Reply-To: <1178571383.3933.8.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 07, 2007 at 01:56:23PM -0700, Mingming Cao wrote:
> In any case, it would be useful to add a new set of testsuites for the
> new fallocate() syscall and fsstress in LTP testsuites to automatically
> the preallocation code in ext4/XFS.

I hacked an existing XFS test prog to do manual testing of the fallocate()
syscall. In the XFSQA suite we have various pre-alloc enhanced utils (e.g.
fsstress, fsx, etc) that we should probably update to be able to use both
fallocate and xfsctl so we can test both.

Here's all the programs we use that have preallocation awareness:

chook 982% grep RESVSP ltp/*.c  | awk '/^ltp/  { split($1,a,":"); print a[1] ;}' | uniq
ltp/doio.c
ltp/fsstress.c
ltp/fsx.c
ltp/growfiles.c
ltp/iogen.c
chook 983% grep RESVSP src/* | awk '/^src/ { split($1,a,":"); print a[1] ;}' | uniq
src/alloc.c
src/fstest.c
src/iopat.c
src/randholes.c
src/resvtest.c
src/unwritten_mmap.c
src/unwritten_sync.c

BTW, have you guys tested mmap writes into unwritten extents? ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
