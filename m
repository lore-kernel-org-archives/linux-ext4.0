From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: crypto return correct error for file_mmap when
 get_encryption_info failed.
Date: Mon, 2 Nov 2015 15:26:00 -0500
Message-ID: <20151102202600.GA6729@thunk.org>
References: <CAOjcEBL6QQYdSpVq_6mSuzyMq6XO6kJGhseF6bD3WOeYLgC6Vw@mail.gmail.com>
 <20151102003235.GT10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xu Cang <cangxumu@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37926 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbbKBU0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2015 15:26:02 -0500
Content-Disposition: inline
In-Reply-To: <20151102003235.GT10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 01, 2015 at 04:32:35PM -0800, Darrick J. Wong wrote:
> On Sun, Nov 01, 2015 at 05:01:37PM -0500, Xu Cang wrote:
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 113837e..1c0086a 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -295,7 +295,7 @@ static int ext4_file_mmap(struct file *file,
> > struct vm_area_struct *vma)
> >         if (ext4_encrypted_inode(inode)) {
> >                 int err = ext4_get_encryption_info(inode);
> >                 if (err)
> > -                       return 0;
> > +                       return -EACCES;
> 
> Shouldn't this return err here?

Yes, it should return err here.

					- Ted
