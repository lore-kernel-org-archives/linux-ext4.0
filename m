From: Ted Ts'o <tytso@mit.edu>
Subject: Re: question about i_dtime being used as an orphan list pointer
Date: Wed, 25 Aug 2010 18:48:30 -0400
Message-ID: <20100825224830.GK4453@thunk.org>
References: <AANLkTi=3hK1RLRJ+2Kt0ju=HEr-LdkO9eX_YxLfp0wea@mail.gmail.com>
 <20100825203914.GF4453@thunk.org>
 <AANLkTi=6tfTpDLqiYpvkOwcWZsWRqru9bHOeOdP=ghf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vitali Lovich <vlovich@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39900 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0HYWsc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Aug 2010 18:48:32 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=6tfTpDLqiYpvkOwcWZsWRqru9bHOeOdP=ghf0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 02:25:37PM -0700, Vitali Lovich wrote:
> > For a long-term fix, it probably would make sense to patch ext3/ext4
> > so that when we delete a file, and the current time is less than
> > number of inodes, that we set dtime to 0xffffffff.
>
> Is the i_dtime actually used at all?  Could we just patch it to always
> set that as the i_dtime always?  I grepped the source, & no one is
> actually using the i_dtime field.

It's not used by the kernel, but it is used occasionally by people who
are trouble shooting file systems, and want to know when a particular
inode was deleted.  So a local hack to always set i_dtime to ~0 would
not be horrible.  But something which sets i_dtime to the system time,
unless this would cause confusion with an orphaned inode linked list,
in which case ~0 is used instead, is probably a cleaner fix.

   	      	    	 	     	      	- Ted
