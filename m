From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: queue conversion after adding to inode's
 completed IO list
Date: Sat, 9 Oct 2010 19:14:51 -0400
Message-ID: <20101009231451.GE11237@thunk.org>
References: <4CAE022C.7050504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jiaying Zhang <jiayingz@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53513 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0JIXOx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 19:14:53 -0400
Content-Disposition: inline
In-Reply-To: <4CAE022C.7050504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 07, 2010 at 12:23:56PM -0500, Eric Sandeen wrote:
> On 08/06/2010 02:52 PM, Eric Sandeen wrote:
> > By queuing the io end on the unwritten workqueue before adding it
> > to our inode's list of completed IOs, I think we run the risk
> > of the work getting completed, and the IO freed, before we try
> > to add it to the inode's i_completed_io_list.
> > 
> > It should be safe to add it to the inode's list of completed
> > IOs, and -then- queue it for completion, I think.
> 
> Ping? would be good to fix this race, this has jiaying's ack too.

Added to the ext4 patch queue, thanks for the ping.

      	     	  	       	      	      - Ted
