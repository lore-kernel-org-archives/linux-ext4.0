From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] improve jbd fsync batching
Date: Tue, 28 Oct 2008 15:38:05 -0600
Message-ID: <20081028213805.GC3184@webber.adilger.int>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20081028201614.GA21600@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 28, 2008  16:16 -0400, Josef Bacik wrote:
> I also have a min() check in there to make sure we don't sleep longer than
> a jiffie in case our storage is super slow, this was requested by Andrew.

Is there a particular reason why 1 jiffie is considered the "right amount"
of time to sleep, given this is a kernel config parameter and has nothing
to do with the storage?  Considering a seek time in the range of ~10ms
this would only be right for HZ=100 and the wait would otherwise be too
short to maximize batching within a single transaction.

> type	threads		with patch	without patch
> sata	2		24.6		26.3
> sata	4		49.2		48.1
> sata	8		70.1		67.0
> sata	16		104.0		94.1
> sata	32		153.6		142.7

In the previous patch where this wasn't limited it had better performance
even for the 2 thread case.  With the current 1-jiffie wait it likely
isn't long enough to batch every pair of operations and every other
operation waits an extra amount before giving up too soon.  Previous patch:

type    threads       patch     unpatched
sata    2              34.6     26.2
sata    4              58.0     48.0
sata    8              75.2     70.4
sata    16            101.1     89.6

I'd recommend changing the patch to have a maximum sleep time that has a
fixed maximum number of milliseconds (15ms should be enough for even very
old disks).


That said, this would be a minor enhancement and should NOT be considered
a reason to delay this patch's inclusion into -mm or the ext4 tree.

PS - it should really go into jbd2 also

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

