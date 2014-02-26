From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/6] xfstests: fsstress punch should always have
	FALLOC_FL_KEEP_SIZE set
Date: Wed, 26 Feb 2014 14:04:10 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402261400250.2243@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-3-git-send-email-lczerner@redhat.com>
	<20140225201854.GA13647@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140225201854.GA13647@dastard>
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

On Wed, 26 Feb 2014, Dave Chinner wrote:

> Date: Wed, 26 Feb 2014 07:18:54 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 3/6] xfstests: fsstress punch should always have
>     FALLOC_FL_KEEP_SIZE set
> 
> On Tue, Feb 25, 2014 at 08:15:25PM +0100, Lukas Czerner wrote:
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  ltp/fsstress.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 4c3368f..42c8a5a 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -2555,8 +2555,8 @@ punch_f(int opno, long r)
> >  	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
> >  	off %= maxfsize;
> >  	len = (off64_t)(random() % (1024 * 1024));
> > -	mode |= FALLOC_FL_KEEP_SIZE & random();
> >  	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
> > +	mode |= FALLOC_FL_KEEP_SIZE;
> >  	if (v)
> >  		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
> >  		       procid, opno, mode,
> 
> NACK. There's nothing wrong with testing a set of parameters that
> should fail in a stress test.

How is this testing ? We do not actually test whether it fails when
it should and vice versa. Only thing that it does right now is
making punch hole testing less efficient.

We do not really test correctness of the arguments in fsstress.

-Lukas

> 
> Regardless, the patch is wrong...
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
