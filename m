From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 08:40:33 -0500
Message-ID: <20130213134033.GF14195@fieldses.org>
References: <20130212202841.GC10267@fieldses.org>
 <CA1BDE43-F265-48AF-9E6D-10974F0C45CB@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Theodore Ts'o <tytso@mit.edu>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:43191 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3BMNkh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 08:40:37 -0500
Content-Disposition: inline
In-Reply-To: <CA1BDE43-F265-48AF-9E6D-10974F0C45CB@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 10:56:36PM -0800, Andreas Dilger wrote:
> On 2013-02-12, at 12:28 PM, J. Bruce Fields wrote:
> > 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> > and previous patches solved problems with hash collisions in large
> > directories by using 64- instead of 32- bit directory hashes in some
> > cases.  But it caused problems for users who assume directory offsets
> > are "small".  Two cases we've run across:
> > 
> > 	- older NFS clients: 64-bit cookies cause applications on
> >           many older clients to fail.
> > 	- gluster: gluster assumed that it could take the top bits of
> > 	  the offset for its own use.
> > 
> > In both cases we could argue we're in the right: the nfs protocol
> > defines cookies to be 64 bits, so clients should be prepared to handle them (remapping to smaller integers if necessary to placate 
> > applications using older system interfaces).
> 
> There appears to already be support for handling this for NFSv2
> clients, so it should be possible to have an NFS server mount
> option to set this for all clients:
> 
>         /* NFSv2 only supports 32 bit cookies */
>         if (rqstp->rq_vers > 2)
>                 may_flags |= NFSD_MAY_64BIT_COOKIE;
> 
> Alternately, this might be detected on a per-client basis by
> whitelist or blacklist if there is some way for the server to
> identify the client?

No, there isn't.

--b.
