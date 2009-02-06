From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Fri, 6 Feb 2009 13:23:07 +0100
Message-ID: <p06240523c5b1db4d5423@[10.1.5.33]>
References: <p06240517c5b14e12f7d1@[10.1.5.33]>
 <20090206062901.GM3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:51018 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbZBFMXX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 07:23:23 -0500
In-Reply-To: <20090206062901.GM3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At 23:29 -0700 05-02-2009, Andreas Dilger wrote:
>On Feb 06, 2009  04:06 +0100, J.D. Bakker wrote:
>  > On reboot the system refused to auto-fsck /dev/md0. A manual e2fsck -nv
>  > /dev/md0 reported:
>  > [...]
>  >   Error writing block 1 (Attempt to write block from filesystem resulted
>>  in short write).  Ignore error? no
>>    Error writing block 2 (Attempt to write block from filesystem resulted
>>  in short write).  Ignore error? no
>>    Error writing block 3 (Attempt to write block from filesystem resulted
>>  in short write).  Ignore error? no
>
>This is a serious problem.

Could this be caused by my using the -n option on e2fsck (see my 
reply to Eric)?

>  > As I said, is there anything I can do to recover my data, or to make 
>>  sure this doesn't happen again?
>
>I would say to run "e2fsck -fp /dev/XXX" and your data _should_ be
>there.

No dice:

   newraidfs: Note: if several inode or block bitmap blocks or part
   of the inode table require relocation, you may wish to try
   running e2fsck with the '-b 32768' option first.  The problem
   may lie only with the primary block group descriptors, and
   the backup block group descriptors may be OK.

   newraidfs: Block bitmap for group 7808 is not in group.  (block 3731742663)

   newraidfs: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
	  (i.e., without -a or -p options)

Thanks,

JDB.
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
