From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Only call update_backups if necessary in online
 resize.
Date: Wed, 26 Sep 2012 00:03:49 -0400
Message-ID: <20120926040349.GG11468@thunk.org>
References: <1348498817-3598-1-git-send-email-tm@tao.ma>
 <20120926033935.GD11468@thunk.org>
 <50627BA5.60106@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52400 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2IZEDx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 00:03:53 -0400
Content-Disposition: inline
In-Reply-To: <50627BA5.60106@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 26, 2012 at 11:51:01AM +0800, Tao Ma wrote:
> Why?  If it isn't the same as the previous one, it will be updated. If
> it is the same, it don't need to be updated. I don't see what your mean
> here.

Oh, I see; sorry, I was just looking at the patch and not the file
with the changes in context.  I thought you were updating the backup
descriptors after modifying the last block group in the meta_bg group,
but that was my confusion.

Yes, your patch looks good and I will apply it, thanks!!

     	  	      	       	      - Ted
