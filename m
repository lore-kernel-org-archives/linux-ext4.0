From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] Add inititable/noinititable mount options for ext4
Date: Mon, 27 Sep 2010 14:35:52 -0400
Message-ID: <20100927183552.GB3168@thunk.org>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
 <1284641251-24531-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52963 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186Ab0I0Sfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 14:35:54 -0400
Content-Disposition: inline
In-Reply-To: <1284641251-24531-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 16, 2010 at 02:47:27PM +0200, Lukas Czerner wrote:
> Add new mount flag EXT4_MOUNT_INIT_INODE_TABLE and add new pair of mount
> options (inititable/noinititable). When mounted with inititable file
> system should try to initialize uninitialized inode tables, otherwise it
> should prevent initializing inode tables. For now, default is noinittable.
> 
> One can also specify inititable=n where n is a number that will be used
> as the wait multiplier (see "Add inode table initialization code into
> Ext4" patch for more info). Bigger number means slower inode table
> initialization thus less impact on performance, but longer
> inititalization (default is 10).

Note: this patch doesn't compile on its own, since it uses s_li_wait
before it is defined (in the next patch).

This is a problem if someone tries to do a "git bisect" and lands
between these two patches.

I'll probably fix this just by merging these two patches together...

     	      	       	       	       - Ted
