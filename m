From: Niels de Vos <ndevos@redhat.com>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 14:31:33 +0100
Message-ID: <20130213133133.GB23233@ndevos-laptop.usersys.redhat.com>
References: <20130212202841.GC10267@fieldses.org>
 <511AAC89.3060409@itwm.fraunhofer.de>
 <20130212210054.GF10267@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	sandeen@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	gluster-devel@nongnu.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115Ab3BMNbn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 08:31:43 -0500
Content-Disposition: inline
In-Reply-To: <20130212210054.GF10267@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 04:00:54PM -0500, J. Bruce Fields wrote:
> On Tue, Feb 12, 2013 at 09:56:41PM +0100, Bernd Schubert wrote:
> > On 02/12/2013 09:28 PM, J. Bruce Fields wrote:
> > > 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> > > and previous patches solved problems with hash collisions in large
> > > directories by using 64- instead of 32- bit directory hashes in some
> > > cases.  But it caused problems for users who assume directory offsets
> > > are "small".  Two cases we've run across:
> > > 
> > > 	- older NFS clients: 64-bit cookies cause applications on many
> > > 	  older clients to fail.
> > > 	- gluster: gluster assumed that it could take the top bits of
> > > 	  the offset for its own use.
> > > 
> > > In both cases we could argue we're in the right: the nfs protocol
> > > defines cookies to be 64 bits, so clients should be prepared to handle
> > > them (remapping to smaller integers if necessary to placate applications
> > > using older system interfaces).  And gluster was incorrect to assume
> > > that the "offset" was really an "offset" as opposed to just an opaque
> > > value.
> > > 
> > > But in practice things that worked fine for a long time break on a
> > > kernel upgrade.
> > > 
> > > So at a minimum I think we owe people a workaround, and turning off
> > > dir_index may not be practical for everyone.
> > > 
> > > A "no_64bit_cookies" export option would provide a workaround for NFS 
> > > servers with older NFS clients, but not for applications like gluster.
> > > 
> > > For that reason I'd rather have a way to turn this off on a given ext4 
> > > filesystem.  Is that practical?
> > 
> > I think Ted needs to answer if he would accept another mount option. But
> > before we are going this way, what is gluster doing if there are hash
> > collions?
> 
> They probably just haven't tested NFS with large enough directories.
> The birthday paradox says you'd need about 2^16 entries to have a 50-50
> chance of hitting the problem.

The Gluster NFS-server gets into an infinite loop:
- https://bugzilla.redhat.com/show_bug.cgi?id=838784

The general advise (even before this Bug) is that XFS should be used, 
which is not affected with this problem (yet?).

Cheers,
Niels
