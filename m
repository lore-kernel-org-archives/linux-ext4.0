From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Rare xfsqa test failure
Date: Wed, 19 Aug 2009 11:51:25 -0500
Message-ID: <4A8C2D8D.8080402@redhat.com>
References: <E1MdNJu-0006uc-GX@closure.thunk.org> <20090818170705.GI5931@webber.adilger.int> <20090818214218.GK28560@mit.edu> <4A8C1A04.1090501@redhat.com> <20090819164014.GA17665@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49573 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752790AbZHSQyF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 12:54:05 -0400
In-Reply-To: <20090819164014.GA17665@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Wed, Aug 19, 2009 at 10:28:04AM -0500, Eric Sandeen wrote:
>> If so, that calls ltp's fsstress, which does not call fallocate nor
>> posix_fallocate.  It only does preallocation on xfs via the old
>> xfs-specific ioctl (though I suppose we should add it...)
> 
> Which in modern kernels is implemented in common code and gets routed to
> ->falllocate.

Oh right....

I was thinking it didn't try any xfs ioctls on non-xfs filesystems but I
guess that's not the case.

-Eric
