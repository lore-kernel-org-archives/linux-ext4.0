From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH v1 29/30] fs: track whether the i_version has been
 queried with an i_state flag
Date: Fri, 03 Mar 2017 19:43:21 -0500
Message-ID: <1488588201.11672.4.camel@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <1482339827-7882-30-git-send-email-jlayton@redhat.com>
         <87wpc5lxg6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org
To: NeilBrown <neil@brown.name>, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87wpc5lxg6.fsf@notabene.neil.brown.name>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2017-03-04 at 11:03 +1100, NeilBrown wrote:
> On Wed, Dec 21 2016, Jeff Layton wrote:
> 
> > @@ -2072,7 +2093,12 @@ inode_cmp_iversion(const struct inode *inode, const u64 old)
> >  static inline bool
> >  inode_iversion_need_inc(struct inode *inode)
> >  {
> > -	return true;
> > +	bool ret;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	ret = inode->i_state & I_VERS_BUMP;
> > +	spin_unlock(&inode->i_lock);
> > +	return ret;
> >  }
> >  
> 
> I know this code gets removed, so this isn't really important.
> By why do you take the spinlock here?  What are you racing again?
> 
> Thanks,
> NeilBrown

I think I was worried about I_VERS_BUMP being set or cleared during an
increment or query. It is quite possible that that spinlock is not
necessary.
-- 
Jeff Layton <jlayton@redhat.com>
