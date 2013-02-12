From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: regressions due to 64-bit ext4 directory cookies
Date: Tue, 12 Feb 2013 15:28:41 -0500
Message-ID: <20130212202841.GC10267@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Theodore Ts'o <tytso@mit.edu>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:40023 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3BLU2o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Feb 2013 15:28:44 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
and previous patches solved problems with hash collisions in large
directories by using 64- instead of 32- bit directory hashes in some
cases.  But it caused problems for users who assume directory offsets
are "small".  Two cases we've run across:

	- older NFS clients: 64-bit cookies cause applications on many
	  older clients to fail.
	- gluster: gluster assumed that it could take the top bits of
	  the offset for its own use.

In both cases we could argue we're in the right: the nfs protocol
defines cookies to be 64 bits, so clients should be prepared to handle
them (remapping to smaller integers if necessary to placate applications
using older system interfaces).  And gluster was incorrect to assume
that the "offset" was really an "offset" as opposed to just an opaque
value.

But in practice things that worked fine for a long time break on a
kernel upgrade.

So at a minimum I think we owe people a workaround, and turning off
dir_index may not be practical for everyone.

A "no_64bit_cookies" export option would provide a workaround for NFS 
servers with older NFS clients, but not for applications like gluster.

For that reason I'd rather have a way to turn this off on a given ext4 
filesystem.  Is that practical?

--b.
