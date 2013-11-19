From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 23:09:29 +1100
Message-ID: <20131119120929.GO11434@dastard>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
 <20131119104508.GA4630@gmail.com>
 <20131119110147.GA3323@infradead.org>
 <20131119111947.GA4782@gmail.com>
 <20131119111826.GA20485@infradead.org>
 <20131119115122.GC4782@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131119115122.GC4782@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 19, 2013 at 07:51:22PM +0800, Zheng Liu wrote:
> On Tue, Nov 19, 2013 at 03:18:26AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 19, 2013 at 07:19:47PM +0800, Zheng Liu wrote:
> > > Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
> > > it can pass the test.  But another question is why xfs fails when we do
> > > some append dio writes with doing buffered read.
> > 
> > Can you provide a test case for that issue?
> 
> Simple.  Reader just need to open this file without O_DIRECT flag.  I
> paste the full code snippet below.  Please take care of this line:
> 	readfd = open(argv[1], /*O_DIRECT|*/O_RDONLY, S_IRWXU);
> 
> The result of this program on my own sand box looks like below:
>         encounter an error: offset 0
....
> 		if (ret >= 0) {
> 			for (j = 0; j < ret; j++) {
> 				if (rbuf[i] != 'a') {
> 					fprintf(stderr, "encounter an error: offset %ld\n",
> 						i);
> 					goto err;

Should be checking rbuf[j], perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
