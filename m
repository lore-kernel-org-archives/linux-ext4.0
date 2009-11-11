From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] Fix fsync on ext3 and ext4 (v2)
Date: Wed, 11 Nov 2009 15:17:11 +0100
Message-ID: <20091111141711.GB21511@duck.suse.cz>
References: <1256647729-29834-1-git-send-email-jack@suse.cz> <20091105130250.GC17008@atrey.karlin.mff.cuni.cz> <20091105163510.GA5897@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbZKKORJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2009 09:17:09 -0500
Content-Disposition: inline
In-Reply-To: <20091105163510.GA5897@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-11-09 22:05:10, Aneesh Kumar K.V wrote:
> On Thu, Nov 05, 2009 at 02:02:50PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> > >   this is a second try for a patchset which makes ext3 and ext4 properly force
> > > a transaction commit when needed. We now do not rely on buffer dirty bits
> > > (which does not work as pdflush can just clear them without forcing a
> > > transaction commit) but rather keep transaction ids that need to be committed
> > > for each inode.
> > >   Since last version, I've implemented Aneesh's and Curt's comments and also
> > > fixed a missing initialization of the fields. I've tested that now the patch
> > > works correctly for uninitialized extents as well as for standard writes.  If
> > > noone objects, would you merge the ext4 part Ted? I'll take care of the ext3
> > > patch.
> >   Aneesh, Ted, is the second version of the patchset fine with you?
> 
> The patches looks good.
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
  Thanks for the review! I've merged the ext3 patch and will push it to
Linus soon. Ted, will you take care of ext4 changes? Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
