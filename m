From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Tue, 12 Feb 2013 22:56:36 -0800
Message-ID: <CA1BDE43-F265-48AF-9E6D-10974F0C45CB@gmail.com>
References: <20130212202841.GC10267@fieldses.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Theodore Ts'o <tytso@mit.edu>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:59388 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3BMG4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2013 01:56:39 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so408644dan.37
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2013 22:56:39 -0800 (PST)
In-Reply-To: <20130212202841.GC10267@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-02-12, at 12:28 PM, J. Bruce Fields wrote:
> 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> and previous patches solved problems with hash collisions in large
> directories by using 64- instead of 32- bit directory hashes in some
> cases.  But it caused problems for users who assume directory offsets
> are "small".  Two cases we've run across:
> 
> 	- older NFS clients: 64-bit cookies cause applications on
>           many older clients to fail.
> 	- gluster: gluster assumed that it could take the top bits of
> 	  the offset for its own use.
> 
> In both cases we could argue we're in the right: the nfs protocol
> defines cookies to be 64 bits, so clients should be prepared to handle them (remapping to smaller integers if necessary to placate 
> applications using older system interfaces).

There appears to already be support for handling this for NFSv2
clients, so it should be possible to have an NFS server mount
option to set this for all clients:

        /* NFSv2 only supports 32 bit cookies */
        if (rqstp->rq_vers > 2)
                may_flags |= NFSD_MAY_64BIT_COOKIE;

Alternately, this might be detected on a per-client basis by
whitelist or blacklist if there is some way for the server to
identify the client?

> And gluster was incorrect to assume that the "offset" was really
> an "offset" as opposed to just an opaque value.

Hmm, userspace already can't use the top bit of the cookie,
since the offset is a signed value, so gluster could continue
to use that bit for itself.  It could, in theory, also downshift
the cookie by one bit for 64-bit cookies and shift it back
before use, but I'm not sure that is kosher for all filesystems.

> But in practice things that worked fine for a long time break on a
> kernel upgrade.
> 
> So at a minimum I think we owe people a workaround, and turning off
> dir_index may not be practical for everyone.
> 
> A "no_64bit_cookies" export option would provide a workaround for NFS 
> servers with older NFS clients, but not for applications like gluster.

We added a "32bitapi" mount option to Lustre to handle the case
where it is re-exporting via NFS to 32-bit clients, which is like
your proposed "no_64bit_cookies" and "nfs.enable_ino64=0" together.

> For that reason I'd rather have a way to turn this off on a given ext4 filesystem.  Is that practical?

It wouldn't be impossible - pos2maj_hash() and pos2min_hash()
could get a per-superblock and/or kernel option to force 32-bit
hash values.

Cheers, Andreas





