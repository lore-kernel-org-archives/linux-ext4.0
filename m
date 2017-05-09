From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Clear lockdep subtype for quota files on quota off
Date: Tue, 9 May 2017 14:09:43 +0200
Message-ID: <20170509120943.GC21467@quack2.suse.cz>
References: <20170505085327.27103-1-jack@suse.cz>
 <0A0D0EE6-38A2-4701-87EF-E8D63CA136C0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751210AbdEIMJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 May 2017 08:09:46 -0400
Content-Disposition: inline
In-Reply-To: <0A0D0EE6-38A2-4701-87EF-E8D63CA136C0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 05-05-17 14:20:38, Andreas Dilger wrote:
> On May 5, 2017, at 2:53 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > Quota files have special ranking of i_data_sem lock. We inform lockdep
> > about it when turning on quotas however when turning quotas off, we
> > don't clear the lockdep subclass from i_data_sem lock and thus when the
> > inode gets later reused for a normal file or directory, lockdep gets
> > confused and complains about possible deadlocks. Fix the problem by
> > resetting lockdep subclass of i_data_sem on quota off.
> > 
> > Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Fixes: daf647d2dd58cec59570d7698a45b98e580f2076
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks I'll add these tags.

> The change to skip clearing the NOATIME/IMMUTABLE inode flags and times
> on every mount/unmount when the journaled quota feature is enabled is
> good, since it avoids needless overhead, but isn't really described in
> the commit comment.  This isn't directly related to the lockdep, but
> rather improving 957153fce8d2 "ext4: Set flags on quota files directly"
> AFAICS.

I don't think I'm changing anything in that code actually. Previously, we
didn't call ext4_quota_off() at all when quota files were stored in system
inodes, now we do call it but just skip NOATIME/IMMUTABLE flag handling. So
what you write below is not related to this patch.

> It might be worthwhile to add a line to this commit like:
> 
>  Don't clear NOATIME/IMMUTABLE flags when journaled quota is enabled.
> 
> It also looks like ext4_quota_on() could use a similar check, to avoid
> setting the NOATIME/IMMUTABLE flags on every mount if they are already
> set.

I don't think it is worth it. Firstly, In don't think people care about
quotaon() performance that much, secondly those flags are expected to be
clear, thirdly, that function is called only for legacy quota files.

> I guess it isn't harmful to clear IMMUTABLE in the case of non-journaled
> quotas, to maximize compatibility with older quota utilities, so long as
> we don't incur this needless overhead for the newer journaled quota case.

We manipulate inode flags only for legacy quota files. For quota files that
are hidden system inodes, there's no point so we avoid that.

> There is a separate issue of what to do if the filesystem wasn't unmounted
> cleanly and IMMUTABLE is still set?  If the userspace quotacheck always
> clears IMMUTABLE when it is run, then there isn't much benefit in setting
> the IMMUTABLE flag in the first place.  Is there some other way that the
> userspace quota utilities know whether it is safe to update the quota files?

Userspace quotacheck does remove IMMUTABLE flag if it sees it. But it
checks using quotactl() calls whether quota isn't turned on on that
filesystem before doing that. Generally quota-tools take care and check
using quotactl() whether quota isn't turned on before going and modifying
quota files directly. However there are some Perl modules out there
modifying quota files which are not as careful...

> One possibility would be to use a similar open(O_EXCL) hack as we use
> with block devices to avoid userspace trying to modify the quota file while
> the kernel is using it?

Well, that would be possible and possibly more reliable than IMMUTABLE
flag. However since the problem is there only for legacy quota files, I
don't think it's worth the de fact API change. Hidden quota files solve all
these problems (and couple others) nicely...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
