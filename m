From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] FIEMAP on ext3
Date: Wed, 16 Apr 2008 14:29:21 -0500
Message-ID: <48065391.10603@redhat.com>
References: <20080416191030.GE15668@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbYDPT3Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2008 15:29:24 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3GJTNBT032425
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 15:29:24 -0400
In-Reply-To: <20080416191030.GE15668@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Josef Bacik wrote:
> Hello,
> 
> Obviously ext3 doesn't have extents, however it would still be usefull to use it
> on sparse files in order to find data/holes within a file.  What I'm thinking is
> treat contigous allocated blocks as an extent, and contiguous non-allocated
> blocks as extents.  So for example, with Eric's fiemap test program, on a normal
> non-sparse file you would only see one large extent for the entire file.  In the
> case of a file that has data, hole and then data you would see 3 extents, two
> for the two spans of data and one for the span of holes.
> FIEMAP_FLAG_NUM_EXTENTS would in that case return 3.  Does this sound like an
> acceptable thing to do?  If not, are there any other suggestions on how to do
> fiemap in ext3?  Thanks much,

Yes, regardless of whether the fs itself manages blocks as "extents" you
would just return contiguous ranges of blocks, allocated or unallocated,
in the structures...

FWIW I think currently the definition says FLAG_NUM_EXTENTS only returns
data extents not holes, so in your case above it'd be "2" (this bugs me
a little)  :)

The current FIEMAP definition has enough other bells and whistles
(flags), ext3 won't support most of them but that's ok; you won't have
to mark blocks delalloc or unwritten or offline or ....

I was playing with using getblock to do this a bit more efficiently; I
owe Josef my hacky patch for that, which I was playing with on ext4... I
did run into the situation where at least today, getblock will return
you a nice length of blocks for contiguous data, but for holes IIRC I
had to go one block at a time (basically falling back to FIBMAP-like
operation)

-Eric
