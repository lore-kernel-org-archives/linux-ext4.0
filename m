From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
Date: Sat, 14 Jul 2012 03:45:54 -0400
Message-ID: <20120714074554.GA27610@infradead.org>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
 <1342185555-21146-2-git-send-email-lczerner@redhat.com>
 <20120713174209.GC17109@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36839
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714Ab2GNHp7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jul 2012 03:45:59 -0400
Content-Disposition: inline
In-Reply-To: <20120713174209.GC17109@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 13, 2012 at 01:42:09PM -0400, Theodore Ts'o wrote:
> Hi Lukas,
> 
> This patch set has changes to the VFS, XFS, and ext4, and there are
> cross dependencies between them.  Is there any way you can disentagle
> the dependencies between the patches so we don't need to worry about
> how these get pulled in during the merge window?
> 
> I suppose could try to get the XFS folks to sign off with my carrying
> this patch in the ext4 tree, since the bulk of the changes are
> ext4-related, but it is a bit of a complication.

There are no real XFS changes, just changing the calling conventions for
a generic function.  Adding this through another tree if properly
reviewed seems perfectly fine.
