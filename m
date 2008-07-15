From: Josef Bacik <jbacik@redhat.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
	writers
Date: Tue, 15 Jul 2008 16:43:56 -0400
Message-ID: <20080715204356.GE30311@unused.rdu.redhat.com>
References: <487B7B9B.3020001@gmail.com> <20080715183904.GC30311@unused.rdu.redhat.com> <20080715201010.GD30311@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org,
	adilger@sun.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762977AbYGOVCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 17:02:52 -0400
Content-Disposition: inline
In-Reply-To: <20080715201010.GD30311@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 04:10:10PM -0400, Josef Bacik wrote:
> On Tue, Jul 15, 2008 at 02:39:04PM -0400, Josef Bacik wrote:
> > On Mon, Jul 14, 2008 at 12:15:23PM -0400, Ric Wheeler wrote:
> > >
> > > Here is a pointer to the older patch & some results:
> > >
> > > http://www.spinics.net/lists/linux-fsdevel/msg13121.html
> > >
> > > I will retry this on some updated kernels, but would not expect to see a 
> > > difference since the code has not been changed ;-)
> > >
> > 
> > Ok here are the numbers with the original idea I had proposed.
> > 
> > type	threads		base	patch	speedup
> > sata	1		17.9	17.3	0.97
> > sata	2		33.2	34.2	1.03
> > sata	4		58.4	63.6	1.09
> > sata	8		78.8	80.8	1.03
> > sata	16		94.4	97.6	1.16
> > 
> > ram	1		2394.4	1878.0	0.78
> > ram	2		989.6	2041.1	2.06
> > ram	4		1466.1	3201.8	2.18
> > ram	8		1858.1	3362.8	1.81
> > ram	16		3008.0	3227.7	1.07
> > 
> > I've got to find a fast disk array to test this with, but the ramdisk results
> > make me happy, though they were kind of irratic, so I think the fast disk array
> > will be a more stable measure of how well this patch does, but it definitely
> > doesn't hurt the slow case, and brings stability to the fast case.  Thanks much,
> >
> 
> Hmm talking with ric I should just leave the single thread stuff alone.  That
> removes the slight speed regression seen above.  Thanks,
>

Here are the results with the single thread stuff put back in and with 250HZ
instead of 1000HZ from before

type	threads		base	patch
sata	1		21.8	21.6
sata	2		26.2	34.6
sata	4		48.0	58.0
sata	8		70.4	75.2
sata	16		89.6	101.1

ram	1		2505.4	2422.0
ram	2		463.8	3462.3
ram	4		330.4	3653.9
ram	8		995.1	3592.4
ram	16		1335.2	3806.5

Thanks,

Josef 
