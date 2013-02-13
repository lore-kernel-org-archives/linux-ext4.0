From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 10:14:55 -0500
Message-ID: <20130213151455.GB17431@thunk.org>
References: <20130212202841.GC10267@fieldses.org>
 <20130213040003.GB2614@thunk.org>
 <20130213133131.GE14195@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48121 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab3BMPPB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 10:15:01 -0500
Content-Disposition: inline
In-Reply-To: <20130213133131.GE14195@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 08:31:31AM -0500, J. Bruce Fields wrote:
> They're assuming they can take the high bits of the cookie for their own
> use.
> 
> (In more detail: they're spreading a single directory across multiple
> nodes, and encoding a node ID into the cookie they return, so they can
> tell which node the cookie came from when they get it back.)
> 
> That works if you assume the cookie is an "offset" bounded above by some
> measure of the directory size, hence unlikely to ever use the high
> bits....

Right, but why wouldn't a nfs export option solave the problem for
gluster?

Basically, it would be nice if we did not have to degrade locally
running userspace applications by globally turning off 64-bit telldir
cookies just because there are some broken cluster file systems and
nfsv3 clients out there.  And if we are only turning off 64-bit
cookies for NFS, wouldn't it make sense to make this be a NFS export
option, as opposed to a mount option?

Regards,

					- Ted
