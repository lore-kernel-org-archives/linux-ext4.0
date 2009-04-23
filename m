From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] remove whole-disk entries from cache when partitions
	are found
Date: Wed, 22 Apr 2009 22:53:58 -0400
Message-ID: <20090423025358.GB15541@mit.edu>
References: <49C7BE27.2090702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60434 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZDWCyC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 22:54:02 -0400
Content-Disposition: inline
In-Reply-To: <49C7BE27.2090702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 23, 2009 at 11:51:51AM -0500, Eric Sandeen wrote:
> We can get into a situation in blkid where whole disks remain
> in the cache, even though partitions are found.  For labels
> such as sun disklabels which may have the first partition
> beginning at sector 0, this is even somewhat likely.

Applied to the e2fsprogs source repository.

						- Ted
