From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext2: No longer export ext2_fs.h to user space
Date: Fri, 23 Mar 2012 17:55:34 +0000
Message-ID: <20120323175534.GI6589@ZenIV.linux.org.uk>
References: <20120322183135.GC4028@thunk.org>
 <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
 <20120323131331.GA29631@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2CWRzj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Mar 2012 13:55:39 -0400
Content-Disposition: inline
In-Reply-To: <20120323131331.GA29631@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 23, 2012 at 09:13:31AM -0400, Ted Ts'o wrote:
> On Fri, Mar 23, 2012 at 10:27:36AM +0100, Thierry Reding wrote:
> > Since the on-disk format has been stable for quite some time, users
> > should either use the headers provided by libext2fs or keep a private
> > copy of this header. For the full discussion, see this thread:
> > 
> > 	https://lkml.org/lkml/2012/3/21/516
> > 
> > While at it, this commit removes all __KERNEL__ guards, which are now
> > unnecessary.
> > 
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Ted Ts'o <tytso@mit.edu>
> > Cc: Artem Bityutskiy <dedekind1@gmail.com>
> > Cc: Andreas Dilger <aedilger@gmail.com>
> > Cc: linux-ext4@vger.kernel.org
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Thanks!!
> 
> Al, do you want to take this in the VFS tree, or do you want me to
> carry this in the ext4 tree?  Or Jan could carry it in the ext2 tree.
> I don't really have strong feelings about who picks it up.  I will if
> no one else wants to...

Applied.  I'll probably add a followup moving most of that stuff to
fs/ext2/ext2.h on top of that commit...
