From: Stephan Kulow <coolo@suse.de>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Fri, 11 Sep 2009 12:38:49 +0200
Message-ID: <200909111238.50029.coolo@suse.de>
References: <200909101455.38400.coolo@suse.de> <200909102257.54889.coolo@suse.de> <20090911005503.GI6705@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:58302 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbZIKKiv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Sep 2009 06:38:51 -0400
In-Reply-To: <20090911005503.GI6705@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 11 September 2009 02:55:03 Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 10:57:54PM +0200, Stephan Kulow wrote:
> > The work flow is as such:
> > - boot into live cd, live cd thinks system is UTC, mounts sda1 (ro)
> >   at 9am, umounts cleanly, updates mount time to 11am (hardware clock)
> 
> That doesn't make any sense.  The mount time is only set if the
> filesystem is mounted read/write.  So if you only mounted the
> filesystem read/only, the mount time wouldn't be changed.  Watch:
> 
I wasn't certain if it also happens with ro, so I put the ro in ().

> 
> Now, if the Live CD is going to be repairing a filesystem, it should
> mount the root filesystem read/only, extract the time zone, fix the
> system clock, and only then mount the filesystem read/write.
> 
> Or the Live CD should fix the system clock over the network before it
> tries mounting any hard drives.  The point is, there are ways for the
> Live CD to do the right thing.  If it's not willing to do that, then
> its init scripts are buggy.  :-)
> 
It doesn't matter if the live init scripts are buggy or not, because the
real system's fsck will be the one to complain about future mounts.

Ok, perhaps it's clearer if you think about it this way:
- installing openSUSE using local time
- boot ubuntu live cd (assuming utc), mount /data (in the future), 
  umount cleanly
- reboot into openSUSE (without buggy init scripts) 
   -> UNEXPECTED INCONSISTENCY, need to repair

I think this is pretty much expected as ubuntu has little chance to figure out 
the timezone of the system using /data normally.

What you're saying is basically: screw everyone living east and using dual 
boot. fsck repairs way more serious problems without any problem, but if I 
share data between ubuntu and openSUSE I need to go into single mode 
afterwards?

At least consider this one:

--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -836,7 +836,7 @@ void check_super_block(e2fsck_t ctx)
                pctx.num = fs->super->s_wtime;
                problem = PR_0_FUTURE_SB_LAST_WRITE;
                if (fs->super->s_wtime <= (__u32) ctx->now + ctx->time_fudge)
-                       problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
+                       problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
                if (fix_problem(ctx, problem, &pctx)) {
                        fs->super->s_wtime = ctx->now;
                        ext2fs_mark_super_dirty(fs);

Greetings, Stephan
