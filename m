From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] e2fsprogs tests: fix f_bad_disconnected_inode e2fsck
 output
Date: Fri, 23 Mar 2012 09:03:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203230903120.8421@dhcp-27-109.brq.redhat.com>
References: <1332333293-25028-1-git-send-email-lczerner@redhat.com> <1332333293-25028-2-git-send-email-lczerner@redhat.com> <20120323001849.GA5832@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2CWIEW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2012 04:04:22 -0400
In-Reply-To: <20120323001849.GA5832@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 22 Mar 2012, Ted Ts'o wrote:

> Thanks, I've applied these two patches as a single commit.  (In
> general the regression tests should always pass after each commit, so
> that git bisects work correctly.)

Right, it makes sense.

Thanks
-Lukas

> 
> 					- Ted
> 
> On Wed, Mar 21, 2012 at 01:34:53PM +0100, Lukas Czerner wrote:
> > Since we removed EOFBLOCKS_FL flag handling, we have to fix the
> > f_bad_disconnected_inode test so that e2fsck output correspond with the
> > new version of the code where we do not check for the EOFBLOCKS_FL flag
> > at all.
> > 
> > Simply remove EOFBLOCKS_FL flag warnings from expect.1 e2fsck output.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  tests/f_bad_disconnected_inode/expect.1 |    9 ---------
> >  1 files changed, 0 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
> > index d3920e3..11862f6 100644
> > --- a/tests/f_bad_disconnected_inode/expect.1
> > +++ b/tests/f_bad_disconnected_inode/expect.1
> > @@ -2,21 +2,12 @@ Pass 1: Checking inodes, blocks, and sizes
> >  Inode 1 has EXTENTS_FL flag set on filesystem without extents support.
> >  Clear? yes
> >  
> > -Inode 9 should not have EOFBLOCKS_FL set (size 0, lblk -1)
> > -Clear? yes
> > -
> > -Inode 10 should not have EOFBLOCKS_FL set (size 0, lblk -1)
> > -Clear? yes
> > -
> >  Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
> >  Clear? yes
> >  
> >  Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
> >  Clear? yes
> >  
> > -Inode 13 should not have EOFBLOCKS_FL set (size 0, lblk -1)
> > -Clear? yes
> > -
> >  Pass 2: Checking directory structure
> >  Pass 3: Checking directory connectivity
> >  /lost+found not found.  Create? yes
> > -- 
> > 1.7.4.4
> > 
> 

-- 
