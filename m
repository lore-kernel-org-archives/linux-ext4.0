From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Date: Tue, 22 Apr 2014 19:14:43 +1000
Message-ID: <20140422091443.GG15995@dastard>
References: <20140421204023.GB960@wallace>
	<20140422062816.GB31337@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Eric Whitney <enwlinux@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20140422062816.GB31337@infradead.org>
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

On Mon, Apr 21, 2014 at 11:28:16PM -0700, Christoph Hellwig wrote:
> > +# check that xfs_io, kernel, and filesystem all support fallocate with zero
> > +# range
> > +_require_xfs_io_falloc_zero()
> > +{
> > +	_require_xfs_io_command "fzero"
> > +}
> 
> I'd rather remove all the wrappers around _require_xfs_io_command, they
> don't actually add any value.

I don't really care either way, as long as all the checks are done
consistently. Send a patch to change them all... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
