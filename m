From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in
 ext4_setattr()
Date: Wed, 18 May 2011 09:05:22 -0500
Message-ID: <4DD3D222.4050900@redhat.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com> <4DD33AA9.9060104@redhat.com> <20110518061356.GY19446@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jiaying Zhang <jiayingz@google.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab1EROFb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 10:05:31 -0400
In-Reply-To: <20110518061356.GY19446@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/18/11 1:13 AM, Dave Chinner wrote:

> It's entirely up to the filesystem how it treats blocks beyond EOF
> during truncation. XFS frees them on truncate down, because it is
> much safer to just truncate away everything beyond the new EOF than
> to leave written extents beyond EOF as potential landmines.
> 
> Indeed, that's why calling vmtruncate() as a bad fix. If you have:
> 
> 
> 	       NUUUUUUUUUUWWWWWWWWWOUUUUUUUUU
>        ....----+----------+--------+--------+
>                A	  B        C        D
> 
> Where	A = new EOF (N)
> 	A->B = unwritten (U)
> 	B->C = written (W)
> 	C = old EOF (O)
> 	C->D = unwritten (U)
> 
> Then just calling vmtruncate() will leave the blocks in the range
> B->C as written blocks. Hence then doing an extending truncate back
> out to D will expose stale data rather than zeros in the range
> B->C....

Hm, running recent xfstests which includes fsx-with-fallocate should probably
eventually catch that then.

-Eric
 
> Cheers,
> 
> Dave.

