From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 1/5] vfs: Add additional owner identifier
Date: Thu, 11 Mar 2010 13:51:35 -0500
Message-ID: <20100311185135.GA27145@fieldses.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org> <20100311120152.GA4706@infradead.org> <87hbonj942.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:45866 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994Ab0CKSuS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 13:50:18 -0500
Content-Disposition: inline
In-Reply-To: <87hbonj942.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 11, 2010 at 04:11:57PM +0300, Dmitry Monakhov wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Thu, Mar 04, 2010 at 09:34:33PM +0300, Dmitry Monakhov wrote:
> >> This patch add project inode identifier. Project ID may be used as
> >> auxiliary owner specifier in addition to standard uid/gid.
> >
> > There's really no reason to make this a config option.
> Project id feature is not likely to be widely used (i hope only 
> at the beginning). Personally this is not bad to avoid config option.
> At least we will have many new users for free. But I predict
> many angry voices against enabling this feature by default.

How would those "angry voices" notice this feature?

--b.

> Look, we even have CONFIG_BLOCK option at the time when this option
> is enabled in 99.99% of systems.
> 
> Let's ask Jan an Al:
> Will they accept genetic projectid support without appropriate config option?
> >  And xattrs
> > are a rather bad interfaces to this, so even if a filesystem has to
> > resort to implement the project ID this way, this should be hidden
> > inside the filesystem.
> Only one question "Why not?".
> I've tried to count pro and contra options.
> *PRO*
>  1) xattr interface already available, we don't have to invent a new one
>  2) xattrs are supported by most of backup tools and other fs-related
>     tools.
>  3) xattr interface is rather simple and flexible. Filesystem is free
>     to store it's projectid whenever it likes to, xattr is just an
>     manipulation interface.
> *CONTRA*
>  1) XATTR_CREATE/XATTR_REPLACE is useless for project id since
>     inode is belongs to default project (id == 0)
> 
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
