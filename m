From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Date: Wed, 31 Jul 2013 20:46:45 -0400
Message-ID: <20130801004645.GC11378@thunk.org>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
	<20130731220154.GA11378@thunk.org> <20130801002341.GI7118@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <linkinjeon@gmail.com>, elder@kernel.org,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130801002341.GI7118@dastard>
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

On Thu, Aug 01, 2013 at 10:23:41AM +1000, Dave Chinner wrote:
> On Wed, Jul 31, 2013 at 06:01:54PM -0400, Theodore Ts'o wrote:
> > Have you considered what happens if you have a 10 megabyte file, of
> > which the first 5 megs are mmap'ed into a userspace process.
> > 
> > Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
> > at offset 1024k from the beginning of the file.
> > 
> > Does the right thing happen to the mmap'ed region in memory?
> 
> Implementation detail. like a hole punch, it needs to invalidate the
> range that it is operating over so mmap()d regions are refaulted
> after the operation is done.

It's not just the range that it's operating on, but also the region
beyond the range that's been collapsed out.  That's because the page
that had formerly located at offset 3072k would now be located at
2048k.  And you had better make sure that any dirty pages located
beyond that are written out to disk before you do the invalidate and
collapse.  As a result, there's going to be potential races that don't
exist with truncate and punch.

A quick eyeball of the patch didn't seem to show any code that handled
this, which is why I asked the question.

      	    				- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
