From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Thu, 13 Mar 2014 00:39:36 -0700
Message-ID: <20140313073936.GA14663@infradead.org>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
 <20140313003635.GA4263@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lucas Nussbaum <lucas.nussbaum@loria.fr>,
	linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine"
	<emmanuel.jeanvoine@inria.fr>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaCMHjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2014 03:39:40 -0400
Content-Disposition: inline
In-Reply-To: <20140313003635.GA4263@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2014 at 11:36:35AM +1100, Dave Chinner wrote:
> IMO, I think that you should be looking to fix ext4 syncfs issues,
> not changing the VFS behaviour that might cause subtle and unnoticed
> problems for other filesystems. We should not be moving data
> inegrity operations without first auditing of all the filesystem
> remount operations for issues.

Requiring a sync on every remount that doesn't go read-only seems odd
to me, so removing it doesn't sound bad.  However I agree that a proper
audit of filesystems should be done, e.g.:

  patch 1:
  	move calls into the filesystems, explaining why filesystems not
	implementing ->remount_fs should be safe
  patch 2:
  	remove call from ext4, safe because of $FOO
  patch b:
	remove call from $fs, safe because of $BAR

