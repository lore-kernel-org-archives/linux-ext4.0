From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsck: Always fix last mount/write/check time with -p
Date: Mon, 12 Oct 2009 16:41:12 -0700
Message-ID: <27CA8102-754B-4588-97B5-FC6881BBD134@sun.com>
References: <E1MxMjT-0003XH-Mn@zelda.netsplit.com> <4AD34EDB.3050201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48439 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZJLXlw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 19:41:52 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n9CNfDAi028510
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 16:41:13 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KRF00L00DIYEV00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 12 Oct 2009 16:41:13 -0700 (PDT)
In-reply-to: <4AD34EDB.3050201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12-Oct-09, at 08:44, Eric Sandeen wrote:
> Scott James Remnant wrote:
>> After much debugging, we've come to the conclusion that the problems
>> with a last mount, write and check time in the future by up to 24
>> hours are not caused by buggy init scripts.  In fact, in every  
>> report,
>> the "now" time was always correct and it was the last mount/write/ 
>> check
>> time that was wrong.
>> Investigation has led us to the following common scenarios:
>> - Overwriting a system that previously had Windows installed, and
>>   thus a localtime ticking hardware clock.  The installer may not
>>   even be aware that the hardware clock is in localtime, and the
>>   user fails to notice that the clock is wrong while they are
>>   installing.
>
> This has recently started showing up on Fedora as well, and I agree  
> that the 24h "grace period" seems like the best approach.  Ted, if  
> you bless this I'd like to pull it into Fedora too.  I might even go  
> so far as to say a times outside 24h don't necessarily warrant a  
> full fs check either, but I'm not hung up on that.  :)
>
> Minor nitpick, a
>
> #define 24H_IN_SECONDS 86400
>
> might be nicer than having the sorta-magic number sprinkled around  
> (though I see that was just inherited from the current code)

I hit this same problem recently, just due to the h/w clock being in  
local
time (windows machine) instead of UTC...

>> ---
>> debian/rules              |    6 ------
>> e2fsck/e2fsck.conf.5.in   |   14 --------------
>> e2fsck/e2fsck.conf.ubuntu |    2 --
>> e2fsck/e2fsck.h           |    1 -
>> e2fsck/problem.c          |    4 ++--
>> e2fsck/super.c            |   39 ++++++++++++++ 
>> +------------------------
>> e2fsck/unix.c             |    2 +-
>> 7 files changed, 18 insertions(+), 50 deletions(-)
>> delete mode 100644 e2fsck/e2fsck.conf.ubuntu
>> diff --git a/debian/rules b/debian/rules
>> index f62e86f..f658bd1 100755
>> --- a/debian/rules
>> +++ b/debian/rules
>> @@ -445,12 +445,6 @@ endif
>> 	$(INSTALL) -p -m 0644 debugfs/debug_cmds.ct \
>> 		${debdir}/ss-dev/usr/share/doc/libss${SS_SOVERSION}/examples
>> -	if test -f /etc/lsb-release && \
>> -		grep -q DISTRIB_ID=Ubuntu /etc/lsb-release; then \
>> -	$(INSTALL) -p -m 0644 e2fsck/e2fsck.conf.ubuntu \
>> -		${debdir}/e2fsprogs/etc/e2fsck.conf; \
>> -	fi
>> -
>> 	dh_installinfo -pcomerr-dev ${stdbuilddir}/lib/et/com_err.info
>> 	dh_installinfo -pe2fslibs-dev ${stdbuilddir}/doc/libext2fs.info
>> diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
>> index 6638a39..daa4e9f 100644
>> --- a/e2fsck/e2fsck.conf.5.in
>> +++ b/e2fsck/e2fsck.conf.5.in
>> @@ -87,20 +87,6 @@ interrupts e2fsck using ^C, and the filesystem  
>> is not explicitly flagged
>> as containing errors, e2fsck will exit with an exit status of 0  
>> instead
>> of 32.  This setting defaults to false.
>> .TP
>> -.I buggy_init_scripts
>> -Some buggy distributions (such as Ubuntu) have init scripts and/or
>> -installers which fail to correctly set the system clock before  
>> running
>> -e2fsck and/or formatting the filesystem initially.  Normally this
>> -happens because the hardware clock is ticking localtime, instead  
>> of the
>> -more proper and less error-prone UTC time.  So while the kernel is
>> -booting, the system time (which in Linux systems always ticks in UTC
>> -time) is set from the hardware clock, but since the hardware clock  
>> is
>> -ticking localtime, the system time is incorrect.  Unfortunately,  
>> some
>> -buggy distributions do not correct this before running e2fsck.  If  
>> this
>> -option is set to a boolean value of true, we attempt to work  
>> around this
>> -situation by allowing the superblock last write time, last mount  
>> time,
>> -and last check time to be in the future by up to 24 hours.
>> -.TP
>> .I clear_test_fs_flag
>> This boolean relation controls whether or not  .BR e2fsck (8)
>> diff --git a/e2fsck/e2fsck.conf.ubuntu b/e2fsck/e2fsck.conf.ubuntu
>> deleted file mode 100644
>> index 49d6d19..0000000
>> --- a/e2fsck/e2fsck.conf.ubuntu
>> +++ /dev/null
>> @@ -1,2 +0,0 @@
>> -[options]
>> -	buggy_init_scripts = 1
>> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
>> index ff73444..a5a811f 100644
>> --- a/e2fsck/e2fsck.h
>> +++ b/e2fsck/e2fsck.h
>> @@ -339,7 +339,6 @@ struct e2fsck_struct {
>>  	/* misc fields */
>> 	time_t now;
>> -	time_t time_fudge;	/* For working around buggy init scripts */
>> 	int ext_attr_ver;
>> 	profile_t	profile;
>> 	int blocks_per_page;
>> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
>> index 540ac91..7e3cafb 100644
>> --- a/e2fsck/problem.c
>> +++ b/e2fsck/problem.c
>> @@ -388,13 +388,13 @@ static struct e2fsck_problem problem_table[]  
>> = {
>> 	/* Last mount time is in the future (fudged) */
>> 	{ PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
>> 	  N_("@S last mount time is in the future.\n\t(by less than a day, "
>> -	     "probably due to buggy init scripts)  "),
>> +	     "probably due to bad system clock last boot)  "),
>> 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
>>  	/* Last write time is in the future (fudged) */
>> 	{ PR_0_FUTURE_SB_LAST_WRITE_FUDGED,
>> 	  N_("@S last write time is in the future.\n\t(by less than a day, "
>> -	     "probably due to buggy init scripts).  "),
>> +	     "probably due to bad system clock last boot).  "),
>> 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
>>  	/* Block group checksum (latch question) is invalid. */
>> diff --git a/e2fsck/super.c b/e2fsck/super.c
>> index 097c87a..3fa0441 100644
>> --- a/e2fsck/super.c
>> +++ b/e2fsck/super.c
>> @@ -465,7 +465,6 @@ void check_super_block(e2fsck_t ctx)
>> 	int	inodes_per_block;
>> 	int	ipg_max;
>> 	int	inode_size;
>> -	int	buggy_init_scripts;
>> 	dgrp_t	i;
>> 	blk_t	should_be;
>> 	struct problem_context	pctx;
>> @@ -801,34 +800,26 @@ void check_super_block(e2fsck_t ctx)
>> 	}
>>  	/*
>> -	 * Some buggy distributions (such as Ubuntu) have init scripts
>> -	 * and/or installers which fail to correctly set the system
>> -	 * clock before running e2fsck and/or formatting the
>> -	 * filesystem initially.  Normally this happens because the
>> -	 * hardware clock is ticking localtime, instead of the more
>> -	 * proper and less error-prone UTC time.  So while the kernel
>> -	 * is booting, the system time (which in Linux systems always
>> -	 * ticks in UTC time) is set from the hardware clock, but
>> -	 * since the hardware clock is ticking localtime, the system
>> -	 * time is incorrect.  Unfortunately, some buggy distributions
>> -	 * do not correct this before running e2fsck.  If this option
>> -	 * is set to a boolean value of true, we attempt to work
>> -	 * around this situation by allowing the superblock last write
>> -	 * time, last mount time, and last check time to be in the
>> -	 * future by up to 24 hours.
>> -	 */
>> -	profile_get_boolean(ctx->profile, "options", "buggy_init_scripts",
>> -			    0, 0, &buggy_init_scripts);
>> -	ctx->time_fudge = buggy_init_scripts ? 86400 : 0;
>> -
>> -	/*
>> 	 * Check to see if the superblock last mount time or last
>> 	 * write time is in the future.
>> +	 *
>> +	 * Unfortunately it's remarkably easy for users to get
>> +	 * themselves into a problem where they've mounted the
>> +	 * filesystem at least once before the hardware clock has
>> +	 * been corrected by NTP (especially when overwriting or
>> +	 * dual booting with Windows).  Sadly these are the very
>> +	 * users who have no idea what to do when presented with a
>> +	 * root shell and invited to fix their filesystem.
>> +	 *
>> +	 * Work around this situation by always allowing the
>> +	 * superblock last write time, last mount time, and last
>> +	 * check time to be in the future by up to 24 hours (when
>> +	 * fsck called with -a/-p).
>> 	 */
>> 	if (fs->super->s_mtime > (__u32) ctx->now) {
>> 		pctx.num = fs->super->s_mtime;
>> 		problem = PR_0_FUTURE_SB_LAST_MOUNT;
>> -		if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
>> +		if (fs->super->s_mtime <= (__u32) ctx->now + 86400)
>> 			problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
>> 		if (fix_problem(ctx, problem, &pctx)) {
>> 			fs->super->s_mtime = ctx->now;
>> @@ -838,7 +829,7 @@ void check_super_block(e2fsck_t ctx)
>> 	if (fs->super->s_wtime > (__u32) ctx->now) {
>> 		pctx.num = fs->super->s_wtime;
>> 		problem = PR_0_FUTURE_SB_LAST_WRITE;
>> -		if (fs->super->s_wtime <= (__u32) ctx->now + ctx->time_fudge)
>> +		if (fs->super->s_wtime <= (__u32) ctx->now + 86400)
>> 			problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
>> 		if (fix_problem(ctx, problem, &pctx)) {
>> 			fs->super->s_wtime = ctx->now;
>> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
>> index e629602..fe7093b 100644
>> --- a/e2fsck/unix.c
>> +++ b/e2fsck/unix.c
>> @@ -304,7 +304,7 @@ static void check_if_skip(e2fsck_t ctx)
>>  	lastcheck = fs->super->s_lastcheck;
>> 	if (lastcheck > ctx->now)
>> -		lastcheck -= ctx->time_fudge;
>> +		lastcheck -= 86400; /* see comment in super.c */
>> 	if ((fs->super->s_state & EXT2_ERROR_FS) ||
>> 	    !ext2fs_test_valid(fs))
>> 		reason = _(" contains a file system with errors");
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

