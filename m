From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 10:06:54 +1000
Message-ID: <20070502000654.GK77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35221 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946093AbXEBAHQ (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Tue, 1 May 2007 20:07:16 -0400
Content-Disposition: inline
In-Reply-To: <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 01, 2007 at 07:37:20PM +0100, Anton Altaparmakov wrote:
> On 1 May 2007, at 05:22, David Chinner wrote:
> >On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
> >>  The FIBMAP ioctl is for privileged users
> >>  only, and I wonder if FIEMAP should be the same, or at least  
> >>disallow
> >>  mapping files that the user can't access especially with  
> >>FLAG_SYNC and/or
> >>  FLAG_HSM_READ.
> >
> >I see little reason for restricting FI[BE]MAP to privileged users -
> >anyone should be able to determine if files they have permission to
> >access are fragmented.
> 
> Allowing anyone to run FI[BE]MAP creates potential for DOS-ing the  
> machine.  Perhaps for non-privileged users FIEMAP has to be read- 
> only?  As soon as any of the FLAG_* flags come into play you make it  
> privileged.  For example fancy any user being able to fill up your  
> file system by calling FIEMAP with FLAG_HSM_READ on all files  
> recursively?

By that reasoning, users should not be allowed to recall any files
without root privileges. HSMs don't work that way, though - any user
is allowed to recall any files they have permission to access either
by manual command or by trying to read the file daata.

If that runs the filesytem out of space, then the HSM either hasn't
been configured properly or it's failed to manage the space
correctly. Either way, that's not the fault of the user for
recalling their own files.

Hence allowing FIEMAP to be executed by the user does not open up
any DOS conditions that don't already exist in normal HSM-managed
filesystem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
