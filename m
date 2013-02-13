From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 10:19:53 -0500
Message-ID: <20130213151953.GJ14195@fieldses.org>
References: <20130212202841.GC10267@fieldses.org>
 <20130213040003.GB2614@thunk.org>
 <20130213133131.GE14195@fieldses.org>
 <20130213151455.GB17431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:48896 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934080Ab3BMPTz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 10:19:55 -0500
Content-Disposition: inline
In-Reply-To: <20130213151455.GB17431@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 10:14:55AM -0500, Theodore Ts'o wrote:
> On Wed, Feb 13, 2013 at 08:31:31AM -0500, J. Bruce Fields wrote:
> > They're assuming they can take the high bits of the cookie for their own
> > use.
> > 
> > (In more detail: they're spreading a single directory across multiple
> > nodes, and encoding a node ID into the cookie they return, so they can
> > tell which node the cookie came from when they get it back.)
> > 
> > That works if you assume the cookie is an "offset" bounded above by some
> > measure of the directory size, hence unlikely to ever use the high
> > bits....
> 
> Right, but why wouldn't a nfs export option solave the problem for
> gluster?

No, gluster is running on ext4 directly.

> Basically, it would be nice if we did not have to degrade locally
> running userspace applications by globally turning off 64-bit telldir
> cookies just because there are some broken cluster file systems and
> nfsv3 clients out there.  And if we are only turning off 64-bit
> cookies for NFS, wouldn't it make sense to make this be a NFS export
> option, as opposed to a mount option?

Right, the problem is that from ext4's point of view gluster is just
another userspace application.

(And my worry of course is that there may be others.  Samba would be
another one to check.)

--b.
