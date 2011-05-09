From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use EXT4FS_DEBUG instead of EXT4_DEBUG in fsync.c
Date: Sun, 8 May 2011 21:55:06 -0400
Message-ID: <20110509015506.GD4138@thunk.org>
References: <1301326873-9551-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48563 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1EIBzJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 21:55:09 -0400
Content-Disposition: inline
In-Reply-To: <1301326873-9551-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 11:41:12PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> We have EXT4FS_DEBUG for some old debug and CONFIG_EXT4_DEBUG
> for the new mballoc debug, but there isn't any EXT4_DEBUG.
> 
> As CONFIG_EXT4_DEBUG seems to be only used in mballoc, use
> EXT4FS_DEBUG in fsync.c.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

It doesn't really matter; although I'm including this patch in the
ext4 tree for consistency's sake.  The whole point of the #ifdef's is
to disable the debugging code.  In general you don't want to enable
all of the code protected by EXT4FS_DEBUG at the same time.

						- Ted
