From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5 bigalloc] e2fsprogs: add tool e2wreck to corrupt fs
 for e2fsck testing
Date: Fri, 18 Nov 2011 22:31:44 -0500
Message-ID: <20111119033144.GD4130@thunk.org>
References: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
 <1321613730-10600-2-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52534 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1KSDbs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Nov 2011 22:31:48 -0500
Content-Disposition: inline
In-Reply-To: <1321613730-10600-2-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 18, 2011 at 06:55:26PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> We need a tool to wreck filesystem to test e2fsck
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

I don't understand why you need this tool.  Debugfs is a more general
tool that will do pretty much everything your proposed e2wreck tool
will do.

The one exception to this is low-level extent tree modifications ---
that functionality is there in the tst_extent program, which is a
debugging program I used when developing the extent support for
e2fsck.  Go to the lib/ext2fs directory, and run "make tst_extents".
It's been on my todo list to get a more cleaner support for low-level
extent manipulation to debugfs, but I haven't gotten around to it,
since tst_extents is a serviceable enough, if hacky, substitute.

      		       		   	      	     - Ted
