From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 08:36:40 -0700
Message-ID: <520CF588.7090800@intel.com>
References: <520BB9EF.5020308@linux.intel.com> <20130815002436.GI6023@dastard>
	<20130815022401.GQ23412@tassilo.jf.intel.com>
	<20130815042930.GO6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130815042930.GO6023@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On 08/14/2013 09:29 PM, Dave Chinner wrote:
> On Wed, Aug 14, 2013 at 07:24:01PM -0700, Andi Kleen wrote:
>>> And FWIW, it's no secret that XFS has more per-operation overhead
>>> than ext4 through the write path when it comes to allocation, so
>>> it's no surprise that on a workload that is highly dependent on
>>> allocation overhead that ext4 is a bit faster....
>>
>> This cannot explain a worse scaling curve though?
> 
> The scaling curve is pretty much identical. The difference in
> performance will be the overhead of timestamp updates through
> the transaction subsystems of the filesystems.

I guess how you read it is in the eye of the beholder.  I see xfs being
slower than ext3 or ext4.  Nobody sits and does this in a loop in real
life (it's a microbenchbark), but I'd be willing to bet that this is a
real *component* of real-life workloads.  It's a component where I think
it's pretty clear xfs and ext4 lag behind ext3, and it _looks_ to me
like it gets worse on larger systems.

Maybe that's because of design decisions in the filesystem, or because
of the enhanced integrity guarantees that xfs/ext4 provide.

>> w-i-s is all about scaling.
> 
> Sure, but scaling *what*? It's spending all it's time in the
> filesystem through the .page_mkwrite path. It's not a page fault
> scaling test - it's a filesystem overwrite test that uses mmap.

will-it-scale tests a bunch of different scenarios.  This is just one of
at least 6 tests that we do which beat on the page fault path.  It was
the only one of those 6 that showed any kind of bottleneck being in the
fs code.

> Indeed, I bet if you replace the mmap() with a write(fd, buf, 4096)
> loop, you'd get almost identical behaviour from the filesystems.

In a quick 60-second test: xfs went from ~70M writes/sec (doing faults)
to ~18M/sec (using write()).  ext4 went down to 0.5M/sec.  I didn't take
the mmap()/munmap() out:

                lseek(fd, 0, SEEK_SET);
                for (i = 0; i < MEMSIZE; i += pgsize) {
                        write(fd, xxx, 4096);
                        //c[i] = 0;
                        (*iterations)++;
                }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
