From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 8/8] Revert "ext4: fix wrong gfp type under transaction"
Date: Fri, 27 Jan 2017 01:13:18 -0500
Message-ID: <20170127061318.xd2qxashbl4dajez@thunk.org>
References: <20170117025607.frrcdbduthhutrzj@thunk.org>
 <20170117082425.GD19699@dhcp22.suse.cz>
 <20170117151817.GR19699@dhcp22.suse.cz>
 <20170117155916.dcizr65bwa6behe7@thunk.org>
 <20170117161618.GT19699@dhcp22.suse.cz>
 <20170117172925.GA2486@quack2.suse.cz>
 <20170119083956.GE30786@dhcp22.suse.cz>
 <20170119092236.GC2565@quack2.suse.cz>
 <20170119094405.GK30786@dhcp22.suse.cz>
 <20170126074455.GC8456@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
        linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>,
        ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126074455.GC8456-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 26, 2017 at 08:44:55AM +0100, Michal Hocko wrote:
> > > I'm convinced the current series is OK, only real life will tell us whether
> > > we missed something or not ;)
> > 
> > I would like to extend the changelog of "jbd2: mark the transaction
> > context with the scope GFP_NOFS context".
> > 
> > "
> > Please note that setups without journal do not suffer from potential
> > recursion problems and so they do not need the scope protection because
> > neither ->releasepage nor ->evict_inode (which are the only fs entry
> > points from the direct reclaim) can reenter a locked context which is
> > doing the allocation currently.
> > "
> 
> Could you comment on this Ted, please?

I guess....   so there still is one way this could screw us, and it's this reason for GFP_NOFS:

        - to prevent from stack overflows during the reclaim because
	          the allocation is performed from a deep context already

The writepages call stack can be pretty deep.  (Especially if we're
using ext4 in no journal mode over, say, iSCSI.)

How much stack space can get consumed by a reclaim?

						- Ted
    		 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
