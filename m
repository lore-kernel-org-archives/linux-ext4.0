From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Rare xfsqa test failure
Date: Wed, 19 Aug 2009 12:40:15 -0400
Message-ID: <20090819164014.GA17665@infradead.org>
References: <E1MdNJu-0006uc-GX@closure.thunk.org> <20090818170705.GI5931@webber.adilger.int> <20090818214218.GK28560@mit.edu> <4A8C1A04.1090501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZHSQk1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 12:40:27 -0400
Content-Disposition: inline
In-Reply-To: <4A8C1A04.1090501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 10:28:04AM -0500, Eric Sandeen wrote:
> If so, that calls ltp's fsstress, which does not call fallocate nor
> posix_fallocate.  It only does preallocation on xfs via the old
> xfs-specific ioctl (though I suppose we should add it...)

Which in modern kernels is implemented in common code and gets routed to
->falllocate.

