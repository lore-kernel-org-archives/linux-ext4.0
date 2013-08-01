From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Date: Thu, 1 Aug 2013 10:23:41 +1000
Message-ID: <20130801002341.GI7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
	<20130731220154.GA11378@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>,
	adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130731220154.GA11378@thunk.org>
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

On Wed, Jul 31, 2013 at 06:01:54PM -0400, Theodore Ts'o wrote:
> Have you considered what happens if you have a 10 megabyte file, of
> which the first 5 megs are mmap'ed into a userspace process.
> 
> Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
> at offset 1024k from the beginning of the file.
> 
> Does the right thing happen to the mmap'ed region in memory?

Implementation detail. like a hole punch, it needs to invalidate the
range that it is operating over so mmap()d regions are refaulted
after the operation is done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
