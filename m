From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 08:31:31 -0500
Message-ID: <20130213133131.GE14195@fieldses.org>
References: <20130212202841.GC10267@fieldses.org>
 <20130213040003.GB2614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:32892 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab3BMNbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 08:31:34 -0500
Content-Disposition: inline
In-Reply-To: <20130213040003.GB2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 11:00:03PM -0500, Theodore Ts'o wrote:
> On Tue, Feb 12, 2013 at 03:28:41PM -0500, J. Bruce Fields wrote:
> > 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> > and previous patches solved problems with hash collisions in large
> > directories by using 64- instead of 32- bit directory hashes in some
> > cases.  But it caused problems for users who assume directory offsets
> > are "small".  Two cases we've run across:
> > 
> > 	- older NFS clients: 64-bit cookies cause applications on many
> > 	  older clients to fail.
> 
> Is there a list of clients (and version numbers) which are having
> problems?

I've seen complaints about Solaris, AIX, and HP-UX clients.  I don't
have version numbers.  It's possible that this is a problem with their
latest versions, so I probably shouldn't have said "older" above.

> > A "no_64bit_cookies" export option would provide a workaround for NFS 
> > servers with older NFS clients, but not for applications like gluster.
> 
> Why isn't it sufficient for gluster?  Are they doing something
> horrible such as assuming that telldir() cookies accessed from
> userspace are identical to NFS cookies?  Or is it some other horrible
> abstraction violation?

They're assuming they can take the high bits of the cookie for their own
use.

(In more detail: they're spreading a single directory across multiple
nodes, and encoding a node ID into the cookie they return, so they can
tell which node the cookie came from when they get it back.)

That works if you assume the cookie is an "offset" bounded above by some
measure of the directory size, hence unlikely to ever use the high
bits....

--b.
