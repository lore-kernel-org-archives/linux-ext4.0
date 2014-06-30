From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] misc: copy extended attributes in populate_fs
Date: Mon, 30 Jun 2014 12:13:04 -0700
Message-ID: <20140630191304.GA15118@birch.djwong.org>
References: <1403902937-2781-1-git-send-email-ross.burton@intel.com>
 <1403902937-2781-2-git-send-email-ross.burton@intel.com>
 <20140630184346.GF9743@birch.djwong.org>
 <CAJTo0LZL4JMsza7XWkTjT0rPXvbhiYwbgXXJj9AWdohP6TiK7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
	tytso <tytso@mit.edu>, Robert Yang <liezhi.yang@windriver.com>
To: "Burton, Ross" <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaF3TNM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2014 15:13:12 -0400
Content-Disposition: inline
In-Reply-To: <CAJTo0LZL4JMsza7XWkTjT0rPXvbhiYwbgXXJj9AWdohP6TiK7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 30, 2014 at 07:59:03PM +0100, Burton, Ross wrote:
> On 30 June 2014 19:43, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >> +     retval = ext2fs_xattrs_open(fs, ino, &handle);
> >
> > If the FS does not have at least one of the inline_data or ext_attr features
> > turned on, the ext2fs_xattrs_open call returns EXT2_ET_MISSING_EA_FEATURE,
> > which aborts the whole operation.  Is that ok?
> 
> Good point.
> 
> I'm currently dithering over whether this should silently do nothing,
> or warn per file, or have an already-warned boolean to avoid spamming
> the user.
> 
> >> +     if (retval) {
> >> +             com_err(__func__, errno, "while opening inode %u", ino);
> >
> > retval, not errno.
> 
> Literally just squashing some commits for these error paths which went wrong.
> 
> >> +             return errno;
> >> +     }
> >> +
> >> +     list = malloc(size);
> >
> > What happens if malloc fails?
> 
> You're doomed?
> 
> What's e2fsprog's policy on OOM - I see some instances of checked
> malloc() that exit() promptly, others that simply return 0 and hope
> for the best, and some that use fputs() and gettext() - but if we're
> OOM then that's even more likely to fail.
> 
> I'll follow the official line, but what that line is isn't clear from
> a sample of malloc() calls in the source.

if (!list) com_err(__func__, ENOMEM, "while _______");

as a starting point.  Better to print a nice error and exit than to simply
crash on the null pointer dereference.

I suppose you could also do the retval = ext2fs_get_mem(size, &list);
construction as well.

--D

> 
> >> +     size = llistxattr(filename, list, size);
> >
> > What if this second call should fail for some reason?  Shouldn't we stop?
> 
> Yes, also fixed locally.
> 
> >> +
> >> +     for (i = 0; i < size; i += strlen(&list[i]) + 1) {
> >> +             const char *name = &list[i];
> >> +             char *value;
> >> +
> >> +             value_size = getxattr(filename, name, NULL, 0);
> >
> > What if getxattr returns -1?
> 
> Should bail, will fix.
> 
> >> +             value = malloc(value_size);
> >> +             value_size = getxattr(filename, name, value, value_size);
> >
> > Same complaints about not checking malloc/getxattr return values.
> 
> Agreed.
> 
> >> +     retval = ext2fs_xattrs_close(&handle);
> >> +     if (retval)
> >> +             com_err(__func__, errno, "while closing inode %u", ino);
> >
> > retval, not errno.
> 
> [sags head in shame]
> 
> Next time I'm patching at 10pm I'll remember to review the patch the
> next morning before sending...
> 
> Ross
