From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to use new "native 4k sector sized" HDD with ext4
Date: Wed, 31 Oct 2012 11:43:04 +1100
Message-ID: <20121031004304.GJ29378@dastard>
References: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
 <20121030142245.GB5972@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>, adilger@dilger.ca,
	sandeen@redhat.com, Namjae Jeon <linkinjeon@gmail.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44059 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934083Ab2JaAnI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 20:43:08 -0400
Content-Disposition: inline
In-Reply-To: <20121030142245.GB5972@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 10:22:45AM -0400, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 06:27:52PM +0530, Ashish Sangwan wrote:
> > 
> > In mkfs.xfs there is option "-s", using which, one can set the sector size.
> > What is the use case of this option?
> > 
> > Also, such option is not present for ext4. So, apart from aligining the
> >  partition on multiple of 8 sector numbers do we have to do something else
> >  for using 4k sectors?
> 
> The equivalent option for ext4 is -b (which we call the block size).
...
> > Is there any way to make sure that ext4 is indeed using 4k sectors?
> 
> You can use dumpe2fs to look at the file system parameters.  The
> confusion here is caused by the fact that xfs uses sector size where
> ext 2/3/4 follows the BSD Fast File System convention of using the
> terminology of "block size".

That's not really correct.  XFS also uses the uses filesystem blocks
just like ext2/3/4 for almost everything, data and metadata.

However, the XFS journal format has requirements for detecting torn
writes in journal recovery and hence needs to know the sector size
of the log device (i.e. the minimum guaranteed atomic IO size). The
key metadata in each AG (the AG headers) are also sector sized so
that they don't get corrupted by torn writes, either, so XFS also
needs to know the sector size of the data device if is using.

> XFS supports using the minimum sector size of 512 bytes by default
> since it means that if you are store large number of small files
> (i.e., only one or two 512 byte sectors), there is less wasted space.

That's not really correct, either. Just like ext4, XFS uses a 4k
block size by default, so the minimum allocated to file data is 4k.
The minimum FSB size that XFS supports is the sector size, but that
is not the default...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
