From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] ext4: turn on i_version updates by default
Date: Mon, 14 May 2012 11:23:34 -0400
Message-ID: <20120514152334.GB29902@fieldses.org>
References: <20120514140618.GA29902@fieldses.org>
 <9124E59E-2479-4C32-A528-3237B48DEC01@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9124E59E-2479-4C32-A528-3237B48DEC01-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 14, 2012 at 09:02:12AM -0600, Andreas Dilger wrote:
> On 2012-05-14, at 8:06, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> > knfsd needs i_version updates on, as will userspace nfs servers and
> > probably others.
> > 
> > The only effects are that inode->i_version is bumped (under the i_lock)
> > in more places, and that ->dirty_inode(I_DIRTY_DATASYNC) may be called
> > more frequently than once per jiffy on write (see file_update_time).
> > However the latter appears to be mostly a no-op in that case.
> 
> I thought this can have noticeable performance impact, since ext4_mark_inode_dirty() is quite heavyweight?

There's no reason it should be, should it, if we already just dirtied
the inode a moment ago?

> This is one of the reasons that the i_version update is conditional.
> If someone is exporting a filesystem from userspace the should be able
> to turn this on as a mount option, and knfsd could do it from inside
> the kernel. Why add overhead when it is not needed?

Any user of the change attribute also wants it to function correctly
while they're away.

And if it at all possible I'd rather have it be something that Just
Works rather than something that requires extra configuration.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
