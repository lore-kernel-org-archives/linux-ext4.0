From: Andreas Dilger <adilger@sun.com>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Fri, 06 Feb 2009 14:44:57 -0700
Message-ID: <20090206214457.GT3209@webber.adilger.int>
References: <p06240517c5b14e12f7d1@[10.1.5.33]>
 <20090206062901.GM3209@webber.adilger.int> <p06240523c5b1db4d5423@[10.1.5.33]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48338 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZBFVpO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Feb 2009 16:45:14 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n16LjAAa004240
	for <linux-ext4@vger.kernel.org>; Fri, 6 Feb 2009 13:45:10 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KEN00E00YYLRA00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 06 Feb 2009 13:45:10 -0800 (PST)
In-reply-to: <p06240523c5b1db4d5423@[10.1.5.33]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 06, 2009  13:23 +0100, J.D. Bakker wrote:
> At 23:29 -0700 05-02-2009, Andreas Dilger wrote:
>> On Feb 06, 2009  04:06 +0100, J.D. Bakker wrote:
>>  > On reboot the system refused to auto-fsck /dev/md0. A manual e2fsck -nv
>>  > /dev/md0 reported:
>>  > [...]
>>  >   Error writing block 1 (Attempt to write block from filesystem resulted
>>>  in short write).  Ignore error? no
>>>    Error writing block 2 (Attempt to write block from filesystem resulted
>>>  in short write).  Ignore error? no
>>>    Error writing block 3 (Attempt to write block from filesystem resulted
>>>  in short write).  Ignore error? no
>>
>> This is a serious problem.
>
> Could this be caused by my using the -n option on e2fsck (see my reply to 
> Eric)?

Then it is a bug in e2fsck.  e2fsck shouldn't even TRY to write to the
filesystem without asking the user first, and "-n" means the answer is
always no so it should never do this.

>>  > As I said, is there anything I can do to recover my data, or to make 
>> 
>>>  sure this doesn't happen again?
>>
>> I would say to run "e2fsck -fp /dev/XXX" and your data _should_ be
>> there.
>
> No dice:
>
>   newraidfs: Note: if several inode or block bitmap blocks or part
>   of the inode table require relocation, you may wish to try
>   running e2fsck with the '-b 32768' option first.  The problem
>   may lie only with the primary block group descriptors, and
>   the backup block group descriptors may be OK.
>
>   newraidfs: Block bitmap for group 7808 is not in group.  (block 3731742663)
>
>   newraidfs: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> 	  (i.e., without -a or -p options)

Then you should run it with "-f" and maybe "-b32768" (if it doesn't
do this on its own).  If you want to avoid hitting "y" 27000 times,
you should also add "-y".

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

