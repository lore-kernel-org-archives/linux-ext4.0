From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Avoid infinite loop in ext2fs_find_block_device()
Date: Sat, 19 Nov 2011 23:18:23 -0500
Message-ID: <20111120041823.GI4130@thunk.org>
References: <4EB23889.1010807@whamcloud.com>
 <4EB2A983.6070203@redhat.com>
 <121461D1-4A28-4B65-960D-7549D2782FFA@mit.edu>
 <4EB3DF9E.7010601@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Niu <niu@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60111 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab1KTES2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Nov 2011 23:18:28 -0500
Content-Disposition: inline
In-Reply-To: <4EB3DF9E.7010601@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 04, 2011 at 08:50:38PM +0800, Niu wrote:
> From 81bfd58b3980f940c23f87f891365a289df776ec Mon Sep 17 00:00:00 2001
> From: Niu Yawei <niu@whamcloud.com>
> Date: Wed, 2 Nov 2011 04:31:11 +0800
> Subject: [PATCH] e2fsprogs: maximum nested link count
> 
> Define EXT2FS_MAX_NESTED_LINKS as 8, and check the link count
> not exceeding it in ext2fs_find_block_device() and follow_link().
> 
> Signed-off-by: Niu Yawei <niu@whamcloud.com>

Thanks, applied.

						- Ted
