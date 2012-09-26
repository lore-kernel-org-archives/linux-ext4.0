From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Only call update_backups if necessary in online
 resize.
Date: Wed, 26 Sep 2012 09:57:53 -0400
Message-ID: <20120926135753.GH11468@thunk.org>
References: <1348498817-3598-1-git-send-email-tm@tao.ma>
 <20120926033935.GD11468@thunk.org>
 <50627BA5.60106@tao.ma>
 <20120926040349.GG11468@thunk.org>
 <CAOoaTqUvBbJnKRcxe6RTL8fw1Q76B7Dtqqa3T37X2qgOk4ugTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Kevin Liao <kevinliao@qnap.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52469 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab2IZN56 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 09:57:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOoaTqUvBbJnKRcxe6RTL8fw1Q76B7Dtqqa3T37X2qgOk4ugTQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 26, 2012 at 01:26:14PM +0800, Kevin Liao wrote:
> 
> Is this patch should be merged with your previous patches about meta_bg
> online resize on 9/14?
> 
> [PATCH 2/9] avoid duplicate writes of the backup bg descriptor blocks
> [PATCH 5/9] add online resizing support for meta_bg and 64-bit file systems

It would be, except that those patches are now in the "master" branch
of the ext4 git tree, which is an implicit promise on my part not to
rebase or change the commit.  This allows people to build git trees
based on the "master" branch.  Commits between "master" and "dev" are
still subject to change, although I am pretty happen with them at that
point, so it will general be only to fix bugs in the patches, or to
adjust the commit descrpition, etc.

						- Ted
