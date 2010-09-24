From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 07/11] vfs: Make acl_permission_check() work for richacls
Date: Sat, 25 Sep 2010 00:25:51 +0530
Message-ID: <m3y6ar9djc.fsf@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285332494-12756-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100924115049.47b1217b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55969 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab0IXS4F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2010 14:56:05 -0400
In-Reply-To: <20100924115049.47b1217b@tlielax.poochiereds.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Sep 2010 11:50:49 -0400, Jeff Layton <jlayton@redhat.com> wrote:
> On Fri, 24 Sep 2010 18:18:10 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > From: Andreas Gruenbacher <agruen@suse.de>
> > 
> > Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/namei.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 855b360..b0b8a71 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -174,6 +174,12 @@ static int acl_permission_check(struct inode *inode, int mask,
> >  {
> >  	umode_t			mode = inode->i_mode;
> >  
> > +	if (IS_RICHACL(inode)) {
> > +		int error = check_acl(inode, mask);
> > +		if (error != -EAGAIN)
> > +			return error;
> > +	}
> > +
> >  	if (current_fsuid() == inode->i_uid)
> >  		mode >>= 6;
> >  	else {
> 
> This may just be my own ignorance of ACL semantics and unfamiliarity
> with the ACL code in general. It seems a bit unusual though...
> 
> Just to be clear...this patch implies that with richacls you can deny
> or grant access to the owner of the file even if the mode bits say
> otherwise. With POSIX acls, this seems to be the other way around.
> 
> Hmm....guess I should read the spec...
> 

To be POSIX compatible we need to ensure that additional file access
control mechanisms may only further restrict the access permissions defined
by the file permission bits. So with rich acl, similar to POSIX ACL,
we use file mask as an upper bound of the acess permission
allowed. Unlike POSIX ACL where the 'owner' and 'other' ACL entry access
mask is kept in sync with mode bits, rich acl include a file mask even
for 'owner' and 'everyone' entries. 

The patch that gives more details about the permission check algo can be
found at 

http://git.kernel.org/?p=linux/kernel/git/agruen/linux-2.6-richacl.git;a=commitdiff;h=442c675aeac85cfc893a2ec600f7fb3da3951177;hp=02456437cf280838a50ef00d7b4df2e7179fe6b2

-aneesh
