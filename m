From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't set i_flags in EXT4_IOC_SETFLAGS.
Date: Thu, 7 Jun 2012 19:05:52 -0400
Message-ID: <20120607230552.GL19839@thunk.org>
References: <1338779898-3146-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48411 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377Ab2FGXFz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2012 19:05:55 -0400
Content-Disposition: inline
In-Reply-To: <1338779898-3146-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 04, 2012 at 11:18:18AM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> 7990696 uses the ext4_{set,clear}_inode_flags() functions to change
> the i_flags automatically but fails to remove the error setting of
> i_flags. So we still have the problem of trashing  state flags. So
> remove it.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Good catch!  Sorry that I missed it.  I've taken this patch, thanks.

     	     	   	  	      - Ted
