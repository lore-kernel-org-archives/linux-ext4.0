From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 10:25:18 +0200
Message-ID: <20080520082517.GH22369@kernel.dk>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:27209 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYETIZX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 04:25:23 -0400
Content-Disposition: inline
In-Reply-To: <200805191439.36577.chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 19 2008, Chris Mason wrote:
> On Monday 19 May 2008, Chris Mason wrote:
> >
> > Here's a test workload that corrupts ext3 50% of the time on power fail
> > testing for me.  The machine in this test is my poor dell desktop (3ghz,
> > dual core, 2GB of ram), and the power controller is me walking over and
> > ripping the plug out the back.
> 
> Here's a new version that still gets about corruptions 50% of the
> time, but does it with fewer files by using longer file names (240
> chars instead of 160 chars).
> 
> I tested this one with a larger FS (40GB instead of 2GB) and larger
> log (128MB instead of 32MB).  barrier-test -s 32 -p 1500 was still
> able to get a 50% corruption rate on the larger FS.

I ran this twice, killing power after 'renames ready'. The first time it
was fine, the second time I got:

centera:~/e2fsprogs-1.40.9/e2fsck # ./e2fsck -f /dev/sdb1
e2fsck 1.40.9 (27-Apr-2008)
/dev/sdb1: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Problem in HTREE directory inode 2395569: node (281) has bad max hash
Problem in HTREE directory inode 2395569: node (849) has bad max hash
Problem in HTREE directory inode 2395569: node (1077) has bad max hash
Problem in HTREE directory inode 2395569: node (1718) has bad max hash
Problem in HTREE directory inode 2395569: node (4609) has bad max hash
Problem in HTREE directory inode 2395569: node (4864) has bad max hash
Problem in HTREE directory inode 2395569: node (5092) has bad max hash
Problem in HTREE directory inode 2395569: node (5148) has bad max hash
Problem in HTREE directory inode 2395569: node (5853) has bad max hash
Problem in HTREE directory inode 2395569: node (7588) has bad max hash
Problem in HTREE directory inode 2395569: node (8663) has bad max hash
Invalid HTREE directory inode 2395569 (/barrier-test).  Clear HTree
index<y>? yes

Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Duplicate entry
'0650419c70f3beadaa9a2c2f4999745a9c02066a0650419c70f3beadaa9a2c2f4999745a9c02066a0650419c70f3beadaa9a2c2f4999745a9c02066a0650419c70f3beadaa9a2c2f4999745a9c02066a0650419c70f3beadaa9a2c2f4999745a9c02066a0650419c70f3beadaa9a2c2f4999745a9c02066a.0'
in /barrier-test (2395569) found.  Clear? yes

and tons of 'duplicate entry' errors after that. And then

Pass 4: Checking reference counts
Inode 168 ref count is 0, should be 1.  Fix? yes

Unattached zero-length inode 255.  Clear? yes

Inode 1221 ref count is 0, should be 1.  Fix? yes

Inode 1253 ref count is 1, should be 2.  Fix? yes

Inode 2692 ref count is 0, should be 1.  Fix? yes

Inode 3465 ref count is 0, should be 1.  Fix? yes

and lots of those too. So definitely easy to trigger. Test fs was ext3
of 40gb on a 320gb maxtor drive.

-- 
Jens Axboe

