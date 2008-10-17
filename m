From: Theodore Tso <tytso@mit.edu>
Subject: Re: undelete still opened file
Date: Fri, 17 Oct 2008 09:24:43 -0400
Message-ID: <20081017132443.GA8755@mit.edu>
References: <20081017120852.1f04dc36.taeuber@bbaw.de> <ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com> <20081017143311.52d50a23.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org
To: Lars =?iso-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34863 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753567AbYJQNYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 09:24:48 -0400
Content-Disposition: inline
In-Reply-To: <20081017143311.52d50a23.taeuber@bbaw.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 02:33:11PM +0200, Lars T=E4uber wrote:
> Is the space of the file on the underlying block device already
> marked as free? Or does this happen after all processes have closed
> all file descriptors pointing to the file?

No, the space on the file is not yet marked as free.  *However* for
ext3 and ext4, the inode has been placed on the orphaned inode list,
so that if the system crashes, part of the journal recovery process
will at that point free the blocks.

> I really want to undo the deletion. (get a link/name connected to
> the root inode of the file again) Is there a way to do this?

Not currently using ext3/ext4, no.  There would have to be an entirely
new system call or other userspace interface for something like this.

    	   	   	 	   	     	 - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
