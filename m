From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
	only file
Date: Wed, 16 Apr 2014 10:29:43 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404161028210.5916@localhost.localdomain>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
	<1397580076-19826-2-git-send-email-lczerner@redhat.com>
	<20140415220220.GR15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140415220220.GR15995@dastard>
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

On Wed, 16 Apr 2014, Dave Chinner wrote:

> Date: Wed, 16 Apr 2014 08:02:20 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
>     only file
> 
> On Tue, Apr 15, 2014 at 06:41:15PM +0200, Lukas Czerner wrote:
> > Currently punch hole and collapse range fallocate operation are not
> > allowed on append only file. This should be case for zero range as well.
> > Fix it by allowing only pure fallocate (possibly with keep size set).
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > v2: Change the condition to be future proof as suggested by hch
> > 
> >  fs/open.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/open.c b/fs/open.c
> > index 631aea81..fe48b2f 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -254,11 +254,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  		return -EBADF;
> >  
> >  	/*
> > -	 * It's not possible to punch hole or perform collapse range
> > -	 * on append only file
> > +	 * We can only allow pure fallocate on append only files
> >  	 */
> > -	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> > -	    && IS_APPEND(inode))
> > +	if (mode & ~FALLOC_FL_KEEP_SIZE && IS_APPEND(inode))
> 
> 	if ((mode & ~FALLOC_FL_KEEP_SIZE) && IS_APPEND(inode))
> 
> gcc normally complains when you mix & and && in the same logic
> statement without () to separate the logic. I agree with gcc here,
> because the () indicate the intent of the logic and make it easy to
> determine that the & and && haven't been mixed up or fat-fingered...

Yeah, I was thinking about this and then left it to operator
precedence. But having () in there is fine as well.

-Lukas

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
