From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Ext2-devel] [PATCH] 2/6 Detect overflows in loop counters
Date: Tue, 12 Sep 2006 15:28:08 -0400
Message-ID: <20060912192808.GB21500@thunk.org>
References: <44E3855D.5040303@redhat.com> <20060830061825.GB8046@thunk.org> <44F5D66D.8030500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:63404 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1030277AbWILT2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Sep 2006 15:28:15 -0400
To: Eric Sandeen <esandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <44F5D66D.8030500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 30, 2006 at 01:18:21PM -0500, Eric Sandeen wrote:
> new patchset & series is at
> 
> http://people.redhat.com/esandeen/ext3/e2fsprogs-1.39-16T/e2fsprogs-hg-20060830-16T-patches.tar.gz

I've applied your patches (with a few minor changes in the
ChangeLogs), and committed them into Mercurial.

Regards,

						- Ted

