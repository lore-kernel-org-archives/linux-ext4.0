From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: trigger the lazy inode table initialization after
 resize
Date: Mon, 14 Jan 2013 09:33:17 -0500
Message-ID: <20130114143317.GE12052@thunk.org>
References: <20130113133706.GA30477@thunk.org>
 <1358084571-3042-1-git-send-email-tytso@mit.edu>
 <20130114130415.GB3906@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	esandeen@redhat.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43285 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab3ANOdU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 09:33:20 -0500
Content-Disposition: inline
In-Reply-To: <20130114130415.GB3906@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 11:04:15AM -0200, Carlos Maiolino wrote:
> > @@ -388,6 +392,11 @@ group_add_out:
> >  		if (err == 0)
> >  			err = err2;
> >  		mnt_drop_write_file(filp);
> > +		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&
> 
> Maybe a n00b question Ted, but can o_group here be bigger than ->s_groups_count
> in any chance? 

o_group can never be smaller than s_groups_count (since we don't
support online shrink).  o_group can be larger than s_groups_count if
ext4_resize_fs() has added one or more block groups to the file system
--- which is when we might need to kick off the lazy init thread.

Cheers,

						- Ted
