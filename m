From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove ac_repeats from ext4_allocation_context.
Date: Sat, 23 Jul 2011 16:20:16 -0400
Message-ID: <20110723202016.GC3469@thunk.org>
References: <1310915483-2906-1-git-send-email-tm@tao.ma>
 <1310915483-2906-3-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57988 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1GWUUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jul 2011 16:20:23 -0400
Content-Disposition: inline
In-Reply-To: <1310915483-2906-3-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 17, 2011 at 11:11:23PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> ac_repeats isn't referenced in the mballoc code. So remove it.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, added to the ext4 tree.

					- Ted
