From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] FIEMAP on ext3
Date: Wed, 16 Apr 2008 21:40:24 -0600
Message-ID: <20080417034024.GF3473@webber.adilger.int>
References: <20080416191030.GE15668@unused.rdu.redhat.com>
 <48065391.10603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60484 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYDQDk2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2008 23:40:28 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3H3eR2H028250
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 20:40:27 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZG00A01A01I700@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 16 Apr 2008 20:40:27 -0700 (PDT)
In-reply-to: <48065391.10603@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 16, 2008  14:29 -0500, Eric Sandeen wrote:
> Josef Bacik wrote:
> > Obviously ext3 doesn't have extents, however it would still be usefull to use it
> > on sparse files in order to find data/holes within a file.  What I'm thinking is
> > treat contigous allocated blocks as an extent, and contiguous non-allocated
> > blocks as extents.  So for example, with Eric's fiemap test program, on a normal
> > non-sparse file you would only see one large extent for the entire file.  In the
> > case of a file that has data, hole and then data you would see 3 extents, two
> > for the two spans of data and one for the span of holes.
> > FIEMAP_FLAG_NUM_EXTENTS would in that case return 3.  Does this sound like an
> > acceptable thing to do?  If not, are there any other suggestions on how to do
> > fiemap in ext3?  Thanks much,

Well, this is already somewhat possible with "filefrag" though if you
want an API to do FIEMAP from applications (easier to program) I'd suggest
just having the fallback in glibc doing a loop of bmap ioctls.

Note that the updated filefrag tool we have for FIEMAP also allows a much
more useful output even for block-mapped files with the "-e" option.

> Yes, regardless of whether the fs itself manages blocks as "extents" you
> would just return contiguous ranges of blocks, allocated or unallocated,
> in the structures...
> 
> FWIW I think currently the definition says FLAG_NUM_EXTENTS only returns
> data extents not holes, so in your case above it'd be "2" (this bugs me
> a little)  :)

Well, if you really think that is important, feel free to complain now
rather than later.  We haven't landed the patch into Lustre yet, and I
agree it is inconsistent that we return 3 extents when we do a full scan
but 2 when we do NUM_EXTENTS...

> The current FIEMAP definition has enough other bells and whistles
> (flags), ext3 won't support most of them but that's ok; you won't have
> to mark blocks delalloc or unwritten or offline or ....

Right, for simple filesystem most of the flags can be ignored.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

