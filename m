From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: 3.10.10: quota problems
Date: Tue, 15 Oct 2013 18:55:50 -0300
Message-ID: <21085.47590.362775.313582@fisica.ufpr.br>
References: <21080.35061.164482.975014@fisica.ufpr.br>
	<20131015155334.GG12428@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:40263 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759799Ab3JOVzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 17:55:53 -0400
In-Reply-To: <20131015155334.GG12428@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara (jack@suse.cz) wrote on 15 October 2013 17:53:
 >On Fri 11-10-13 20:25:41, Carlos Carvalho wrote:
 >> There are two problems. First, on a new filesystem with
 >> tune2fs -Q usrquota and grpquota was working fine until a power
 >> failure switched the machine off. On reboot all files seem normal
 >> but quota -v showed no limits neither usage...
 >> 
 >> I ran fsck and it said the fs was clean. Then I ran fsck -f and
 >> 
 >> Pass 5: Checking group summary information
 >> [QUOTA WARNING] Usage inconsistent for ID 577:actual (12847804416, 308767) != expected (12868194304, 308543)
 >> [QUOTA WARNING] Usage inconsistent for ID 541:actual (186360393728, 11089) != expected (186340204544, 11085)
 >> 
 >> ... etc until
 >> 
 >> Update quota info for quota type 0<y>? yes
 >> 
 >> then some more of
 >> 
 >> [QUOTA WARNING] Usage inconsistent for ID 500:actual (192918523904, 20725) != expected (192897576960, 20671)
 >> 
 >> until
 >> 
 >> Update quota info for quota type 1<y>? yes
 >> 
 >> /dev/md3: ***** FILE SYSTEM WAS MODIFIED *****
 >> 
 >> After remounting and running quota on usage for some users were back
 >> but not limits. For other users even usage is lost.
 >> 
 >> This is with 3.10.10, e2fsprogs 1.42.8 (Debian) and mount options
 >> rw,nosuid,nodev,commit=30,stripe=768,data=ordered,inode_readahead_blks=64
 >> 
 >> This was the first unclean shutdown of this machine after more than 6
 >> months of usage. The new quota method looks fragile... Is there
 >> something I can do get limits and usage back?
 >  No idea here, sorry. I will try to reproduce the problem and see what I
 >can find. I'd just note that userspace support of hidden quotas in
 >e2fsprogs is still experimental and Ted pointed out a few problems in it.

I know. They work fine under normal operations but the broke in this
case, so I'm reporting it.

 >Among others I think limits are not properly transferred from old to new
 >quota file during fsck...

Not the case here. I started with a just-made empty filesystem. Limits
are enforced, everything works fine except when a crash happens.

 >But it still doesn't explain why the limits got lost after the
 >crash.

Not only limits, usage was also lost.

 >Didn't quotacheck create visible quota files after the crash or
 >something like that?

There's no quotachek with the new implementation. Everything should be
done by fsck.

So there are two problems here: one is that both usage and limits info
is rather fragile; they didn't survive the first power loss. The
second problem is that fsck should have recovered usage numbers, even
if it has to crawl the whole fs like quotacheck...

 >> --------------------------------------------------
 >> 
 >> The second problem is on an old filesystem with the old quota system,
 >> also with kernel 3.10.10 but another machine. Compilation is different
 >> because this one is 32bit, the other is 64bit. mount options are
 >> 
 >> defaults,strictatime,nobarrier,nosuid,nodev,commit=30,inode_readahead_blks=64,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv1
 >> 
 >> The problem here is that after removing lots of users in a row
 >> repquota -v shows many entries of removed users in numerical form, like
 >> 
 >> #42       --      32       0       0              1     0     0       
 >  OK, so we still think there is one file with 32KB allocated to the user.
 >Strange. Isn't it possible there is still some (unlinked) directory
 >existing which is pwd of some process or something like that?

No. I modified the boot script right after the filesystem is mounted
to do:

repquota -v /home > /root/quotas-before
quotacheck # takes 20min :-(
repquota -v /home > /root/quotas-after

Here are the real wrong entries in quota-before, that don't exist in
quota-after:

#1121     --       0       0       0              1     0     0       
#531      --   16496       0       0             60     0     0       
#557      --       0       0       0              1     0     0       
#685      --       4       0       0              2     0     0       

It happens after removal of about 50 users.

Note also that these #uid entries are not the only problem;
repquota-{before,after} show MANY other differences in usage of inodes
and disk. Here are a few of
them:

                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
-root      -- 22691376       0       0         248709     0     0       
+root      -- 22691088       0       0         248632     0     0       
-user1     -- 1260088 1300000 1370000           2789     0     0       
-user2     -- 2026108 2400000 2410000          10944     0     0       
-user3     -- 135165684 750000000 750000000         115438     0     0       
-user4     -- 12010356 36000000 36000000          77662     0     0       
+user1     -- 1260084 1300000 1370000           2783     0     0       
+user2     -- 2026104 2400000 2410000          10943     0     0       
+user3     -- 135164656 750000000 750000000         115427     0     0       

These differences are after an uptime of about 35 days. This shows
that quota accounting seems to miss stuff. Fortunately the relative
error is small.

 >Because accounting problems in number of used inodes are rather
 >unlikely (that code is really straightforward).

Strange but it's not new; I've already buggered you around 2006
because kernels of that time had this problem. It was with reiserfs
then, now it's with ext4. The problem disappeared but is back now.
