From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/12] quota: Allow each filesystem to specify which
 quota types it supports
Date: Fri, 10 Oct 2014 17:37:27 +0200
Message-ID: <20141010153727.GB8705@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
 <1412952910-7142-2-git-send-email-jack@suse.cz>
 <5437FAB1.1010005@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5437FAB1.1010005@oracle.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 10-10-14 10:26:41, Dave Kleikamp wrote:
> On 10/10/2014 09:54 AM, Jan Kara wrote:
> > diff --git a/include/linux/quota.h b/include/linux/quota.h
> > index 80d345a3524c..b52539f42e19 100644
> > --- a/include/linux/quota.h
> > +++ b/include/linux/quota.h
> > @@ -56,6 +56,11 @@ enum quota_type {
> >  	PRJQUOTA = 2,		/* element used for project quotas */
> >  };
> >  
> > +/* Masks for quota types when used as a bitmask */
> > +#define QTYPE_MASK_USER (1 << USRQUOTA)
> > +#define QTYPE_MASK_GROUP (1 << GRPQUOTA)
> > +#define QTYPE_MASK_PROJECT (1 << PRJQUOTA)
> 
> The uses of these masks use the names QTYPE_MASK_USR, QTYPE_MASK_GRP,
> and QTYPE_MASK_PRJ
  Sigh. Friday afternoon isn't a good time for sending out patch sets :(
Thanks for catching this. I'll wait if someone has other feedback before
resending the patches...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
