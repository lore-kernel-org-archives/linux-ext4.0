From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 17:18:01 -0500
Message-ID: <20130213221800.GS14195@fieldses.org>
References: <20130212202841.GC10267@fieldses.org>
 <511AAC89.3060409@itwm.fraunhofer.de>
 <20130212210054.GF10267@fieldses.org>
 <511B4C18.8030300@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Theodore Ts'o <tytso@mit.edu>, gluster-devel@nongnu.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:53603 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3BMWSF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 17:18:05 -0500
Content-Disposition: inline
In-Reply-To: <511B4C18.8030300@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 09:17:28AM +0100, Bernd Schubert wrote:
> On 02/12/2013 10:00 PM, J. Bruce Fields wrote:
> >On Tue, Feb 12, 2013 at 09:56:41PM +0100, Bernd Schubert wrote:
> >>On 02/12/2013 09:28 PM, J. Bruce Fields wrote:
> >>>06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> >>>and previous patches solved problems with hash collisions in large
> >>>directories by using 64- instead of 32- bit directory hashes in some
> >>>cases.  But it caused problems for users who assume directory offsets
> >>>are "small".  Two cases we've run across:
> >>>
> >>>	- older NFS clients: 64-bit cookies cause applications on many
> >>>	  older clients to fail.
> >>>	- gluster: gluster assumed that it could take the top bits of
> >>>	  the offset for its own use.
> >>>
> >>>In both cases we could argue we're in the right: the nfs protocol
> >>>defines cookies to be 64 bits, so clients should be prepared to handle
> >>>them (remapping to smaller integers if necessary to placate applications
> >>>using older system interfaces).  And gluster was incorrect to assume
> >>>that the "offset" was really an "offset" as opposed to just an opaque
> >>>value.
> >>>
> >>>But in practice things that worked fine for a long time break on a
> >>>kernel upgrade.
> >>>
> >>>So at a minimum I think we owe people a workaround, and turning off
> >>>dir_index may not be practical for everyone.
> >>>
> >>>A "no_64bit_cookies" export option would provide a workaround for NFS
> >>>servers with older NFS clients, but not for applications like gluster.
> >>>
> >>>For that reason I'd rather have a way to turn this off on a given ext4
> >>>filesystem.  Is that practical?
> >>
> >>I think Ted needs to answer if he would accept another mount option. But
> >>before we are going this way, what is gluster doing if there are hash
> >>collions?
> >
> >They probably just haven't tested NFS with large enough directories.
> 
> Is it only related to NFS or generic readdir over gluster?
> 
> >The birthday paradox says you'd need about 2^16 entries to have a 50-50
> >chance of hitting the problem.
> 
> We are frequently running into it with 50000 files per directory.
> 
> >
> >I don't know enough about ext4 directory performance.  But unfortunately
> >I suspect there's a range of directory sizes that are too small to have
> >a significant chance of having directory collisions, but still large
> >enough to need dir_index?
> 
> Here is a link to the initial benchmark:
> http://search.luky.org/linux-kernel.2001/msg00117.html

Hm, so I still don't have a good feeling for when dir_index is likely to
start winning.

For comparison, assuming the probability of seeing a failure due to hash
collisions in an n-entry directory is the probability of a collision
among n numbers chosen uniformly at random from 2^31, that's about:

	 0.0002% for n=  100
	 0.006 % for n=  500
	 0.02  % for n= 1000
	 0.6   % for n= 5000
	 2     % for n=10000

So if we could tell anyone with directories smaller than 10,000 entries:
"hey, you don't need dir_index anyway, just turn it off"--good, the only
people still forced to deal with 64-bit cookies will be the ones that
have probably already found that ext4 isn't reliable for their purposes.

If there are people with only a few hundred entries who still need
dir_index--well, we may be making them unhappy as we're making them
suffer to fix a bug that they've never actually seen.

--b.
