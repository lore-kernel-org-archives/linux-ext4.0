From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Fri, 5 Oct 2012 00:20:59 -0400
Message-ID: <20121005042059.GC11723@thunk.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
 <20121004101106.GC4641@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53924 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab2JEH3O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 03:29:14 -0400
Content-Disposition: inline
In-Reply-To: <20121004101106.GC4641@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 04, 2012 at 12:11:06PM +0200, Jan Kara wrote:
> >  retry:
> >  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> > -		if (unlikely(!list_empty(&ei->i_completed_io_list)))
> > -			ext4_flush_completed_IO(inode);
> > -
> > +		if (unlikely(!atomic_read(&EXT4_I(inode)->i_unwritten))) {
>   This condition which seems to be inverted...

Nice catch, thanks!  I've fixed this in my tree.

     	    	   	      	      - Ted
