From: Ted Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in print_daily_error_info
Date: Tue, 14 Sep 2010 15:46:41 -0400
Message-ID: <20100914194641.GB3730@thunk.org>
References: <20100914125102.GA5318@swordfish.minsk.epam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60339 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab0INTqt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Sep 2010 15:46:49 -0400
Content-Disposition: inline
In-Reply-To: <20100914125102.GA5318@swordfish.minsk.epam.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 14, 2010 at 03:51:02PM +0300, Sergey Senozhatsky wrote:
> Hello,
>       
> This patch fixes NULL pointer dereference in print_daily_error_info, when   
> called
> on unmounted fs (EXT4_SB(sb) returns NULL). Deleting error reporting timer  
> in
> ext4_put_super fixes oops.

Good catch!  Thanks for the patch.  I will include this into ext4
tree, and I will probably push it separately to Linus so that it gets
into 2.6.36, since this is a regresssion.

You didn't add a Signed-off-by: line, which is needed for Developer's
Certification of Origin (see section 1, subsection 16 of
Documentation/SubmittingPatches in the Linux source tree).  Can you
send confirmation that it's OK for me to add a Signed-off-by line for
you?  Thanks!!

> By the way, isn't print_daily_error_info racy? Is it safe to call           
> print_daily_error_info
> (by timer event (softirq)) when we'are remounting fs, etc.?

It should be fine.  Remounting doesn't actually change out the struct
superblock.  There is a chance that the information might not be fully
complete if an error is printed exactly as the same time as
print_daily_error_info() is run, but I'm not sure it's worth trying to
protect against that race, since the worst that this will mean is a
confusing report in the /var/log/messages file, and the ext4 error
message will be printed right next to it, which will have all of the
information the system administrator will need.

						- Ted
						
