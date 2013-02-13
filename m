From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Tue, 12 Feb 2013 23:00:03 -0500
Message-ID: <20130213040003.GB2614@thunk.org>
References: <20130212202841.GC10267@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	gluster-devel@nongnu.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48048 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502Ab3BMEAM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Feb 2013 23:00:12 -0500
Content-Disposition: inline
In-Reply-To: <20130212202841.GC10267@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 03:28:41PM -0500, J. Bruce Fields wrote:
> 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> and previous patches solved problems with hash collisions in large
> directories by using 64- instead of 32- bit directory hashes in some
> cases.  But it caused problems for users who assume directory offsets
> are "small".  Two cases we've run across:
> 
> 	- older NFS clients: 64-bit cookies cause applications on many
> 	  older clients to fail.

Is there a list of clients (and version numbers) which are having
problems?

> A "no_64bit_cookies" export option would provide a workaround for NFS 
> servers with older NFS clients, but not for applications like gluster.

Why isn't it sufficient for gluster?  Are they doing something
horrible such as assuming that telldir() cookies accessed from
userspace are identical to NFS cookies?  Or is it some other horrible
abstraction violation?

						- Ted
