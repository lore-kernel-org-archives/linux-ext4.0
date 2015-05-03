From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Fix growing of tiny filesystems
Date: Sun, 3 May 2015 00:00:38 -0400
Message-ID: <20150503040038.GH10014@thunk.org>
References: <1430377561-6079-1-git-send-email-jack@suse.cz>
 <55423DAA.6020305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41755 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbbECEAn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2015 00:00:43 -0400
Content-Disposition: inline
In-Reply-To: <55423DAA.6020305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 30, 2015 at 09:35:22AM -0500, Eric Sandeen wrote:
> On 4/30/15 2:06 AM, Jan Kara wrote:
> > The estimate of necessary transaction credits in ext4_flex_group_add()
> > is too pessimistic. It reserves credit for sb, resize inode, and resize
> > inode dindirect block for each group added in a flex group although they
> > are always the same block and thus it is enough to account them only
> > once. Also the number of modified GDT block is overestimated since we
> > fit EXT4_DESC_PER_BLOCK(sb) descriptors in one block.
> > 
> > Make the estimation more precise. That reduces number of requested
> > credits enough that we can grow 20 MB filesystem (which has 1 MB
> > journal, 79 reserved GDT blocks, and flex group size 16 by default).
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Jan, thank you for looking into this and sorting it out.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
