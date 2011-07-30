From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: add a kfree() on error i add_new_gdb()
Date: Sat, 30 Jul 2011 12:59:39 -0400
Message-ID: <20110730165939.GJ7361@thunk.org>
References: <20110730082557.GB5575@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54954 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1G3Q7m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jul 2011 12:59:42 -0400
Content-Disposition: inline
In-Reply-To: <20110730082557.GB5575@shale.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 30, 2011 at 11:25:57AM +0300, Dan Carpenter wrote:
> We added some more error handling in b40971426a "ext4: add error
> checking to calls to ext4_handle_dirty_metadata()".  But we need to
> call kfree() as well to avoid a memory leak.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Added to the ext4 tree, thanks for catching this!!

      	     	  	       	   	    - Ted
