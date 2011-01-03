From: Josef Bacik <josef@redhat.com>
Subject: Re: Hole Punching V3
Date: Mon, 3 Jan 2011 16:57:21 -0500
Message-ID: <20110103215720.GA8392@localhost.localdomain>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1ACV6P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 16:58:15 -0500
Content-Disposition: inline
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 17, 2010 at 08:46:14PM -0500, Josef Bacik wrote:
> This is version 3 of the hole punching series I've been posting.  Not much has
> changed, the history is below
> 
> V2->V3
> -FALLOC_FL_PUNCH_HOLE must also have FALLOC_FL_KEEP_SIZE in order to work
> -formatting fixes
> 
> V1->V2
> -Hole punching doesn't change file size
> -Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to
> 
> I've updated my local copies of the xfsprogs patches I have to test this to use
> KEEP_SIZE and PUNCH_HOLE together, I'll post them after it looks like these
> patches are good to go, including the manpage update.  The xfstest I wrote ran
> fine both on xfs and btrfs (failing on btrfs obviously).  Thanks,
> 

I'd like to try and get this into the next merge window, it seems everybody is
happy with it so far, any other comments?  Provided everybody is ok with it, how
would you like me to send it to you Linus?  Would you prefer a pull request or
will you just pull the patches off the mailinglist?  Thanks,

Josef
