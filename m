From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 7/8] xfstests: Add fallocate zero range operation to
 fsx
Date: Mon, 3 Mar 2014 13:21:03 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403031317310.2258@localhost.localdomain>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<1393603865-26198-7-git-send-email-lczerner@redhat.com>
	<CB2787E8-CE9B-46BE-B649-4E38ABE27C2B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <CB2787E8-CE9B-46BE-B649-4E38ABE27C2B@dilger.ca>
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

On Fri, 28 Feb 2014, Andreas Dilger wrote:

> Date: Fri, 28 Feb 2014 12:08:47 -0700
> From: Andreas Dilger <adilger@dilger.ca>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 7/8] xfstests: Add fallocate zero range operation to fsx
> 
> On Feb 28, 2014, at 9:11 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > This commit adds fallocate FALLOC_FL_ZERO_RANGE support for fsx.
> 
> It looks like this patch breaks the option handling for these
> fallocate features.
> 
> >  int     fallocate_calls = 1;            /* -F flag disables */
> >  int     punch_hole_calls = 1;           /* -H flag disables */
> > +int     zero_range_calls = 1;           /* -z flag disables */
> 
> So these fallocate tests are on by default...
> 
> > +int
> > +test_fallocate(int mode)
> >  {
> >  #ifdef HAVE_LINUX_FALLOC_H
> > +	int ret = 0;
> > 	if (!lite && fallocate_calls) {
                     ^^^^^^^^^^^^^^^

Right, I forgot about this.


> > +		if (fallocate(fd, mode, 0, 1) && errno == EOPNOTSUPP) {
> > 			if(!quiet)
> > 				warn("main: filesystem does not support fallocate, disabling\n");
> > 		} else {
> > +			ret = 1;
> > 			ftruncate(fd, 0);
> > 		}
> > 	}
> > #endif
> > }
> 
> And this returns 1 or 0 depending if they are supported or not...
> 
> > +	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzLN:OP:RS:WZ"))
> > 	       != EOF)
> > 		switch (ch) {
> > 		case 'H':
> > 			punch_hole_calls = 0;
> > 			break;
> > +		case 'z':
> > +			zero_range_calls = 0;
> > +			break;
> 
> And the option parsing sets the values to zero if they are disabled,
> so far, so good...
> 
> > +	fallocate_calls = test_fallocate(0);
> > +	punch_hole_calls = test_fallocate(FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE);
> > +	zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
> 
> But here, the values set by option parsing are clobbered and the
> tests are only enabled or disabled depending on whether the kernel
> supports that feature or not.  I think you need something like:

Right, and the 'fallocate_calls' test needs to disappear from
test_fallocate().

Thanks!
-Lukas

> 
>         if (fallocate_calls)
>                 fallocate_calls = test_fallocate(0);
>         if (punch_hole_calls)
>                 punch_hole_calls = test_fallocate(FALLOC_FL_PUNCH_HOLE |
>                                                   FALLOC_FL_KEEP_SIZE);
>         if (zero_range_calls)
>                 zero_range_calls = test_fallocate(FALLOC_FL_ZERO_RANGE);
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
