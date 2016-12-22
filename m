From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/9 v2] scope GFP_NOFS api
Date: Thu, 22 Dec 2016 10:38:28 +0100
Message-ID: <20161222093828.GF6048@dhcp22.suse.cz>
References: <20161215140715.12732-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
        Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>,
        David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
        ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161215140715.12732-1-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Are there any objections to the approach and can we have this merged to
the mm tree?

Dave has expressed the patch2 should be dropped for now. I will do that
in a next submission but I do not want to resubmit until there is a
consensus on this.

What do other than xfs/ext4 developers think about this API. Can we find
a way to use it?
-- 
Michal Hocko
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
