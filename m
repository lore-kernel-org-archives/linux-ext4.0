From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] improve jbd fsync batching
Date: Tue, 28 Oct 2008 17:33:10 -0400
Message-ID: <20081028213310.GC21600@unused.rdu.redhat.com>
References: <20081028201614.GA21600@unused.rdu.redhat.com> <20081028213805.GC3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081028213805.GC3184@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 28, 2008 at 03:38:05PM -0600, Andreas Dilger wrote:
> On Oct 28, 2008  16:16 -0400, Josef Bacik wrote:
> > I also have a min() check in there to make sure we don't sleep longer than
> > a jiffie in case our storage is super slow, this was requested by Andrew.
> 
> Is there a particular reason why 1 jiffie is considered the "right amount"
> of time to sleep, given this is a kernel config parameter and has nothing
> to do with the storage?  Considering a seek time in the range of ~10ms
> this would only be right for HZ=100 and the wait would otherwise be too
> short to maximize batching within a single transaction.
>

I wouldn't say "right amount", more of "traditional amount".  If you have super
slow storage this patch will not result in you waiting any longer than you did
originally, which I think is what the concern was, that we not wait a super long
time just because the disk is slow.
 
> > type	threads		with patch	without patch
> > sata	2		24.6		26.3
> > sata	4		49.2		48.1
> > sata	8		70.1		67.0
> > sata	16		104.0		94.1
> > sata	32		153.6		142.7
> 
> In the previous patch where this wasn't limited it had better performance
> even for the 2 thread case.  With the current 1-jiffie wait it likely
> isn't long enough to batch every pair of operations and every other
> operation waits an extra amount before giving up too soon.  Previous patch:
> 
> type    threads       patch     unpatched
> sata    2              34.6     26.2
> sata    4              58.0     48.0
> sata    8              75.2     70.4
> sata    16            101.1     89.6
> 
> I'd recommend changing the patch to have a maximum sleep time that has a
> fixed maximum number of milliseconds (15ms should be enough for even very
> old disks).
> 

This stat gathering process has been very unscientific :), I just ran once and
took that number.  Sometimes the patched version would come out on top,
sometimes it wouldn't.  If I were to do this the way my stat teacher taught me
I'm sure the patched/unpatched versions would come out to be relatively the same
in the 2 thread case.

> 
> That said, this would be a minor enhancement and should NOT be considered
> a reason to delay this patch's inclusion into -mm or the ext4 tree.
> 
> PS - it should really go into jbd2 also
>

Yes I will be doing a jbd2 version of this patch provided there are no issues
with this patch.  Thanks much for the comments,

Josef 
