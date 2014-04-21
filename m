From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] generic: fix check for zero range support in generic/009
Date: Mon, 21 Apr 2014 16:36:55 -0400
Message-ID: <20140421203655.GA960@wallace>
References: <20140419190524.GA2116@wallace>
 <20140420005645.GB15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Eric Whitney <enwlinux@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20140420005645.GB15995@dastard>
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

* Dave Chinner <david@fromorbit.com>:
> On Sat, Apr 19, 2014 at 03:05:24PM -0400, Eric Whitney wrote:
> > Generic/001 fails when run on a file system that does not support byte range
> > zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
> > on a pre-3.15 extent-mapped file system.  The code in the test intended
> > to prevent this contains an apparent typo that results in a check for
> > fallocate() rather than zero range support.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  tests/generic/009 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/generic/009 b/tests/generic/009
> > index b7b0b3f..65abe3c 100644
> > --- a/tests/generic/009
> > +++ b/tests/generic/009
> > @@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
> >  
> >  # real QA test starts here
> >  _supported_os Linux
> > -_require_xfs_io_falloc "fzero"
> > +_require_xfs_io_command "fzero"
> 
> There should be a helper in common/rc for this. i.e.
> _require_xfs_io_fzero. There's helpers for everything else. Can you
> add the helper and wire the tests up to it properly?
> 

Sure.  For naming consistency with the other related helper functions, it
looks like we'd want to call this _require_xfs_io_falloc_zero().  I'm happy
to change this if I'm mistaken.  Patches on the way.

Thanks,
Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
