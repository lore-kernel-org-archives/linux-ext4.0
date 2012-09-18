From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 13:20:15 -0500
Message-ID: <5058BB5F.5050506@sandeen.net>
References: <nsxa9wojdcd.fsf@closure.thunk.org> <20120918064039.GS11511@dastard> <50588898.6050802@sgi.com> <20120918181556.GC28689@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mark Tinguely <tinguely@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42108 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab2IRSUR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 14:20:17 -0400
In-Reply-To: <20120918181556.GC28689@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/18/12 1:15 PM, Theodore Ts'o wrote:
> On Tue, Sep 18, 2012 at 09:43:36AM -0500, Mark Tinguely wrote:
>> xfstest 285 and 286 (I believe these tests were only in the OSS
>> version and not in the kernel.org developers version of xfstests).
> 
> Hi Mark,
> 
> Could you clarify what the relationship is between the OSS xfstests
> tree and the one on kernel.org?  Is the OSS tree always ahead of the
> kernel.org tree (i.e., are the commits in the OSS tree a superset of
> the ones in the kernel.org tree)?
> 
> I had been under the impression that commits flowed from the
> kernel.org tree to the OSS tree, but it sounds like I was misinformed
> on that point?

That was more or less correct at one point, but we recently decided to
ditch the kernel.org repos and let sgi manage a single repo on oss.sgi.com
going forward, just to simplify things.

We just reached that agreement and haven't really communicated it yet
I guess.

So going forward, stick with the one on oss.sgi.com.

Thanks,
-Eric

> Thanks,
> 
> 						- Ted
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

