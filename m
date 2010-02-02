From: "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 08/23] vfs: Add a flag to denote posix mapped richacl
Date: Tue, 2 Feb 2010 10:18:16 -0500
Message-ID: <20100202151816.GB4293__19907.3243457407$1265134875$gmane$org@fieldses.org>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1265002505-8387-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100201231858.GR19418@fieldses.org> <87vdeg42y2.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, jlayton@redhat.com,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:40959 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0BBPSY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 10:18:24 -0500
Content-Disposition: inline
In-Reply-To: <87vdeg42y2.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 02, 2010 at 11:03:09AM +0530, Aneesh Kumar K. V wrote:
> On Mon, 1 Feb 2010 18:18:58 -0500, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> > On Mon, Feb 01, 2010 at 11:04:50AM +0530, Aneesh Kumar K.V wrote:
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > ---
> > >  fs/richacl_posix.c      |    7 +++++++
> > >  include/linux/richacl.h |   10 ++++++----
> > >  2 files changed, 13 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
> > > index 07db970..3cf2124 100644
> > > --- a/fs/richacl_posix.c
> > > +++ b/fs/richacl_posix.c
> > > @@ -183,6 +183,13 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
> > >  	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
> > >  	acl->a_other_mask = richacl_mode_to_mask(mode);
> > >  
> > > +	/*
> > > +	 * Mark that the acl as mapped from posix
> > > +	 * This gives user space the chance to verify
> > > +	 * whether the mapping was correct
> > > +	 */
> > 
> > How would it use this information?  (And how could it be incorrect?)
> > 
> 
> Incorrect in the sense of what user expected the mapping should be. 
> This flag is later used by the userspace to indicate that the returned
> richacl is a mapped richacl from Posix. The sysadmin should be able to
> look at the flag and make sure the acl values are what he expected it
> to be and the mapping code didn't map it wrongly.

It's not going to map wrongly--if it does, there's a bug, and we should
just fix the bug.

It's not reasonable to expect sysadmins to manually check mapped ACL's
to look for bugs in our mapping algorithm.

--b.

> NOTE: If the user belong to multiple groups, posix acl evaluation will
> look at the group for which the requested access mask is allowed and
> then apply the ACL_MASK values. That can be quiet confusing when we map to
> richacl.
> 
> -aneesh
> 
