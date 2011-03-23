From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Fix a BUG in mb_mark_used during trim.
Date: Wed, 23 Mar 2011 15:47:19 -0400
Message-ID: <20110323194719.GB2548@thunk.org>
References: <alpine.LFD.2.00.1103031117210.8737@dhcp-27-109.brq.redhat.com>
 <1299160774-2337-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47085 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab1CWTra (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Mar 2011 15:47:30 -0400
Content-Disposition: inline
In-Reply-To: <1299160774-2337-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, added to the ext4 patch queue.  My apologies for the delay.

	      	     	  	- Ted

On Thu, Mar 03, 2011 at 09:59:34PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In a bs=4096 volume, if we call FITRIM with the following parameter as
> fstrim_range(start = 102400, len = 134144000, minlen = 10240),
> we will trigger a BUG_ON.
> BUG_ON(start + len > (e4b->bd_sb->s_blocksize << 3));
> 
