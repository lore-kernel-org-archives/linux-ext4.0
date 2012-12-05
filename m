From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix the complie warning if CONFIG_EXT4_FS_XATTR
 isn't set.
Date: Wed, 5 Dec 2012 11:18:38 -0500
Message-ID: <20121205161838.GE18885@thunk.org>
References: <1354714583-3187-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36947 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab2LEQSm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 11:18:42 -0500
Content-Disposition: inline
In-Reply-To: <1354714583-3187-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 09:36:23PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Fix the compile warning created by copy/paste.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

I've folded these fixups into the inline data patches.

Thanks!!

     	    	  	      	  	      - Ted
