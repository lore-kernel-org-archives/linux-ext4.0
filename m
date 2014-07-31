From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: save goal group and offset in struct
 ext4_allocation_context.ac_g_ex
Date: Thu, 31 Jul 2014 11:32:55 -0400
Message-ID: <20140731153255.GE1566@thunk.org>
References: <1406108861-2581-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20140729135819.GA2256@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, lczerner@redhat.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38544 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaGaPdB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 11:33:01 -0400
Content-Disposition: inline
In-Reply-To: <20140729135819.GA2256@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2014 at 09:58:19AM -0400, Theodore Ts'o wrote:
> On Wed, Jul 23, 2014 at 05:47:41PM +0800, Xiaoguang Wang wrote:
> > In ext4_mb_normalize_request(), if ac_g_ex.fe_logical is adjacent to the closest logical
> > allocated block to the left or (ac_g_ex.fe_logical+len) adjacent to the closest logical
> > allocated block to the right, we'll attach EXT4_MB_HINT_TRY_GOAL flag taking the physical
> > block (ext4_allocation_request.lleft+1) or (ext4_allocation_request.pright-len) as a goal,
> > and put this information in ext4_allocation_context.ac_f_ex.
> > 
> > But look at the ext4_mb_find_by_goal(), indeed it use ac_g_ex to look up, so this is wrong,
> > we should save goal group and offset in struct ext4_allocation_context.ac_g_ex.
> > 
> > Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> 
> Nice catch!
> 
> Thanks, applied.

I've had to drop this patch, as it is causing xfstests failures for
generic/074.

I'm not sure why, and right now I don't have time to investigate.  If
someone who has time and experience wading into fs/ext4/mballoc.c, it
would be great if someone could take a closer look.

      	       	  	  	       - Ted
