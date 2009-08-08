From: Andreas Dilger <adilger@sun.com>
Subject: Re: Questions about mballoc's stream allocation
Date: Sat, 08 Aug 2009 01:51:33 -0600
Message-ID: <20090808075133.GW3340@webber.adilger.int>
References: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <bzzz@sun.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55224 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZHHHvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2009 03:51:47 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n787pjZk006444
	for <linux-ext4@vger.kernel.org>; Sat, 8 Aug 2009 00:51:48 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KO100400SH8YO00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sat,
 08 Aug 2009 00:51:45 -0700 (PDT)
In-reply-to: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 07, 2009  09:07 -0400, Theodore Ts'o wrote:
> I've got two questions about mballoc's stream allocation.

Sorry, I don't know the answers.  Hopefully Alex can chime in.

> First of all, in ext4_mb_regular_allocator(), I'm 99% sure this is a
> bug:
> 
> 	/* if stream allocation is enabled, use global goal */
> 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
> 	isize = i_size_read(ac->ac_inode) >> bsbits;
> 	if (size < isize)
> 		size = isize;
> 
> 	if (size < sbi->s_mb_stream_request &&
> 	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
> 		/* TBD: may be hot point */
> 		spin_lock(&sbi->s_md_lock);
> 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
> 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
> 		spin_unlock(&sbi->s_md_lock);
> 	}
> 
> Shouldn't that be ">=", not "<".  We want to use the values saved in
> sbi->s_mb_last_{group,start} only if we are doing a stream allocation,
> which would be true only if the file is *larger* than
> s_mb_stream_request, no?
> 
> 
> The second question I have is with regards to ext4_mb_use_best_found(),
> we set sbi->s_mb_last_{group,start} on any data allocation; shouldn't we
> only be setting those values only if we were doing a stream allocation
> in the first place?
> 
> Otherwise, any kind of allocation will end up moving the global goal
> block for stream allocations; even if it is a small allocation in the
> middle of some block group caused by the flag EXT4_MB_HINT_NO_PREALLOC
> being set.
> 
> Am I missing anything?
> 
>      	   	      	       		     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

