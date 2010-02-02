From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/23] vfs: Add a flag to denote posix mapped richacl
Date: Tue, 02 Feb 2010 11:03:09 +0530
Message-ID: <87vdeg42y2.fsf@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100201231858.GR19418@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, adilger@sun.com, tytso@mit.edu, jlayton@redhat.com,
	nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org,
	sfrench@us.ibm.com, ffilz@us.ibm.com, linux-ext4@vger.kernel.org,
	agruen@suse.de
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20100201231858.GR19418@fieldses.org>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 1 Feb 2010 18:18:58 -0500, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> On Mon, Feb 01, 2010 at 11:04:50AM +0530, Aneesh Kumar K.V wrote:
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/richacl_posix.c      |    7 +++++++
> >  include/linux/richacl.h |   10 ++++++----
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
> > index 07db970..3cf2124 100644
> > --- a/fs/richacl_posix.c
> > +++ b/fs/richacl_posix.c
> > @@ -183,6 +183,13 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
> >  	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
> >  	acl->a_other_mask = richacl_mode_to_mask(mode);
> >  
> > +	/*
> > +	 * Mark that the acl as mapped from posix
> > +	 * This gives user space the chance to verify
> > +	 * whether the mapping was correct
> > +	 */
> 
> How would it use this information?  (And how could it be incorrect?)
> 

Incorrect in the sense of what user expected the mapping should be. 
This flag is later used by the userspace to indicate that the returned
richacl is a mapped richacl from Posix. The sysadmin should be able to
look at the flag and make sure the acl values are what he expected it
to be and the mapping code didn't map it wrongly.

NOTE: If the user belong to multiple groups, posix acl evaluation will
look at the group for which the requested access mask is allowed and
then apply the ACL_MASK values. That can be quiet confusing when we map to
richacl.

-aneesh
