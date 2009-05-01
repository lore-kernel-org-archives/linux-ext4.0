From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ext4: Use separate super_operations structure for
	no_journal filesystems
Date: Fri, 1 May 2009 03:04:22 -0400
Message-ID: <20090501070422.GB2107@infradead.org>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu> <1241152637-11986-2-git-send-email-tytso@mit.edu> <1241152637-11986-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZEAHEW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 03:04:22 -0400
Content-Disposition: inline
In-Reply-To: <1241152637-11986-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 12:37:17AM -0400, Theodore Ts'o wrote:
> By using a separate super_operations structure for filesystems that
> have and don't have journals, we can simply ext4_write_super() ---
> which is only needed when no journal is present --- and ext4_freeze(),
> ext4_unfreeze(), and ext4_sync_fs(), which are only needed when the
> journal is present.

FYI: I will make ->sync_fs mandatory pretty soon.  At that point
->write_super will only be left for d_dirt-induced periodic writeback.
(Still have to figure out what to do about file_fsync, but that won't
affect ext4)

