From: Ted Ts'o <tytso@mit.edu>
Subject: Re: E2fsprogs 1.42.1 release
Date: Mon, 20 Feb 2012 14:18:20 -0500
Message-ID: <20120220191820.GB6541@thunk.org>
References: <4F3F1439.5000407@ubuntu.com>
 <4F3F1580.9020108@redhat.com>
 <20120218223131.GB8320@thunk.org>
 <B2C249E4-41BE-400F-BC11-B1F7ABDE308E@redhat.com>
 <20120220031938.GA5113@thunk.org>
 <4F4297FE.9090208@redhat.com>
 <4F4298A0.1000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <esandeen@redhat.com>,
	Phillip Susi <psusi@ubuntu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36773 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab2BTTSY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 14:18:24 -0500
Content-Disposition: inline
In-Reply-To: <4F4298A0.1000900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2012 at 01:01:52PM -0600, Eric Sandeen wrote:
> > The tarball is a little messed up:
> > 
> > [esandeen@neon e2fsprogs]$ tar xvzf e2fsprogs-1.42.1.tar.gz
> > e2fsprogs-libs-1.42.1/
> > e2fsprogs-libs-1.42.1/.gitignore
> > e2fsprogs-libs-1.42.1/.release-checklist
> > e2fsprogs-libs-1.42.1/lib/
> > 
> > why does it unpack into e2fsprogs-libs-1.42.1?
> >                                   ^^^^
> > 
> > I could work around that but it's unexpected.
> 
> Oh actually I can't work around it, it really is just the libs.

Whoops, kup screwup.  I uploaded e2fsprogs-1.42.tar.gz and
e2fsprogs-libs-1.42.tar.gz.... into the same destination file.  I just
fixed it on master.kernel.org; it should propagate over in 15 minutes
or so.

Or you can grab the files from sourceforge.  (Note that the
sourceforge tarballs are actually signed by me.  In contrast the
kernel.org tarballs are signed by the ftp.kernel.org machine key, and
the signature covers the uncompressed tar file.  That way they can use
the same signature file for the tar.gz and tar.bz2 tarball.)

    	 	   	    	       	   	   - Ted
