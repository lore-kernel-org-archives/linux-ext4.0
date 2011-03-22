From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: critical info format fix in
 __ext4_grp_locked_error
Date: Mon, 21 Mar 2011 20:47:39 -0400
Message-ID: <20110322004739.GJ4135@thunk.org>
References: <1300442283-31421-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
	Tao Ma <boyu.mt@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35117 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab1CVAro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 20:47:44 -0400
Content-Disposition: inline
In-Reply-To: <1300442283-31421-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied to the ext4 patch queue.

On Fri, Mar 18, 2011 at 05:58:03PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> When we do performence-testing on ext4 filesystem, we observe a warning like this:
> 
> "[ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy:718: group 259825901 blocks in bitmap, 26057 in gd"
> 
> indeed, it should be
> 
> "group 2598, 25901 blocks in bitmap, 26057 in gd"

Note that the next two paragraphs don't really belong in a commit
description.  It's best if you put this kind of stuff after the
signed-off-by lines, with a "---" separating the commit description, like this:

Signed off by: Ty Coon <tycoon@gmail.com>
---
Stuff that explains the context of the patch

diff --git ....

> This bug is found on upstream 2.6.36 kernel. We ran a 2.6.36 kernel
> on the online system with 8 Ext4 file systems. 2 of them are mounted
> with delayed allocation feature. This warning is only observed on
> delayed allocation enabled Ext4 file systems.
> 
> This issue is not easy to reproduce, on two servers with 2.6.36
> kenrel + ext4, after running 110+ days, the error starts to appear
> on kernel log. When check the error log, we found the info format
> should be fixed, that's how this patch comes.

Can you send more information about what sort of workloads your
servers are under, and any other information about how to reproduce
it?

						- Ted
