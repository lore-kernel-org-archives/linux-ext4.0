From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Re: What to do when the journal checksum is incorrect
Date: Tue, 03 Jun 2008 15:52:13 +0530
Message-ID: <1212488533.3272.23.camel@alpha.linsyssoft.com>
References: <E1K02Jh-0002wf-2e@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:56574 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYFCK3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 06:29:14 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m53ABJwi019073
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 10:11:19 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K1V00401TGW4000@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Tue, 03 Jun 2008 18:10:10 +0800 (SGT)
In-reply-to: <E1K02Jh-0002wf-2e@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On Sat, 2008-05-24 at 18:34 -0400, Theodore Ts'o wrote: 
> I've been taking a much closer look at the ext4's journal checksum code
> as I integrated it into e2fsck, and I'm finding that what it's doing
> doesn't make a whole lot of sense.
> 
> Suppose the journal has five commits, with transaction ID's 2, 3, 4, 5,
> and 6.  And suppose the CRC in the commit block delineating the end of
> transaction #4 is bad.  At the moment, due to a bug in the code, it
> stops processing at transaction #4, meaning that transactions #2, #3,
> and #4 are replayed into the filesystem --- even though transaction #4
> failed the CRC checksum.  
I went through the code and also re-ran the e2fsprogs tests which we had
sent upstream for journal checksum. And found that if the transaction is
bad it is marked as info->end_transaction which indicates a bad
transaction and is not replayed.

if (chksum_err) {
     info->end_transaction = next_commit_ID;

The end_transaction is set to transaction ID which is found to be
corrupt. So #4 will be set in end_transaction and in PASS_REPLAY the
last transaction to be replayed will be #3 due to this:
----------------------------------------------------------------
if (tid_geq(next_commit_ID, info->end_transaction))
                                break;
-----------------------------------------------------------------

     if (!JFS_HAS_COMPAT_FEATURE(journal,
                                 JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)){
           printk(KERN_ERR "JBD: Transaction %u found to be corrupt.\n",
                next_commit_ID);
   brelse(bh);                                 
   break;
     }
} 
> Worse yet, no indication of any problems is
> sent back to the ext4 filesystem code.
This definitely is not present and needs to be incorporated. 

Thanks,
Girish

