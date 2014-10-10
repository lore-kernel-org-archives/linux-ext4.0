From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race between write and fcntl(F_SETFL)
Date: Fri, 10 Oct 2014 11:39:34 +0200
Message-ID: <20141010093934.GA25693@quack.suse.cz>
References: <1412853287-10496-1-git-send-email-dmonakhov@openvz.org>
 <948E780F-14EB-4E38-9BAC-A5410F339441@dilger.ca>
 <878uko4b75.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	sasha.levin@oracle.com, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaJJJjh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2014 05:39:37 -0400
Content-Disposition: inline
In-Reply-To: <878uko4b75.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 10-10-14 11:48:30, Dmitry Monakhov wrote:
> Andreas Dilger <adilger@dilger.ca> writes:
> 
> > On Oct 9, 2014, at 5:14 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> >> O_DIRECT flags can be toggeled via fcntl(F_SETFL).
> >> But this value checked twice inside ext4_file_write_iter() and __generic_file_write()
> >> which result in BUG_ON (see typical stack trace below)
> >> In order to fix this we have to use our own copy of __generic_file_write
> >> and pass o_direct status explicitly.
> >
> > This seems like a generic problem that would be better served by fixing
> > the core code instead of making a private copy of such a large function
> > for ext4.  I expect other filesystems might have similar issues if the
> > O_DIRECT state is changed in the middle of IO?
> >
> > One option is to flush pending IO on the file if the O_DIRECT flag is
> > changed in setfl(). This is a bit heavyweight but I can't imagine any
> > sane app that is changing the O_DIRECT state on a file repeatedly.
> Agree. In fact there are a lot of other issues there fcntl(F_SETFL)
> works incorrectly. For example it does not works on stack-fs
> (ecrypt,unionfs) if you try to add O_APPEND flags it will be directly
> assigned to virtual file (not lower one). For that reason OpenVZ introduced
> f_op->set_flags in order to support our stackfs (vefs)
> This is reasonable solution in general so I'll prepare patches for mainstream
> But this require reasonable time for negotiations with vfs people.
  Agreed. ->set_flags callback looks reasonable.

> At the same time currently all versions are affected since 69c499d1/2012-11-29
> So we need quick and simple fix for stable releases.
> From first glance the best fix is to simply deny toggle O_DIRECT on files.
> and f_op->check_flags(new_flags) looks like reasonable candidate, *but*
> this interface is 100% useless because it has no access to file_pointer
> so we do not know current ->f_flags :)
  [I've CCed linux-fsdevel since it may indeed affect other filesystems]
  I don't think you want to just deny toggling O_DIRECT. That's certainly
going to break some application (however stupid it may be). Also flushing
the IO as Andreas suggests doesn't seem easy because to solve the problem
with changing flags in general, you would have to wait for both reads and
writes, buffered & direct for the struct file and that's not easily doable.
What currently seems as the best solution to me is to store f_flags in the
iocb and then use that for decisions... However it still seems a bit
fragile since people modifying the would would have to have in mind they
have to use iocb->f_flags instead of iocb->ki_filp->f_flags

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
