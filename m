From: <Martin_Zielinski@McAfee.com>
Subject: RE: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Date: Tue, 26 Apr 2011 04:07:11 -0500
Message-ID: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D08501@EMEADALEXMB1.corp.nai.org>
References: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
 <20110425231454.GB9486@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dalsmrelay2.nai.com ([205.227.136.216]:34003 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1DZJT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 05:19:29 -0400
In-Reply-To: <20110425231454.GB9486@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted!
Thank you a lot!
We observed this bug on ~10 out of 40 machines after an uptime from about 3 weeks. All run under comparable conditions.
I will have a closer look on the debugfs output to verify if the situation can  happen within this short time range. Additionally we installed a crash kernel and I changed the BUG into a panic(). 
So I will be able to look at the journal structure if this happens again.

My testing system, which runs under small load, would need several years to reach this point. 
But after two weeks of staring on journaling and filesystem code (that I never saw before), this is the only explanation I could find.
If I can verify that this is the root cause (or not the root cause), I will post this with information about the user-land part that is responsible.

Cheers,
Martin

-----Original Message-----
From: Ted Ts'o [mailto:tytso@mit.edu] 
Sent: Dienstag, 26. April 2011 01:15
To: Zielinski, Martin
Cc: linux-ext4@vger.kernel.org
Subject: Re: 2.6.32 ext3 assertion j_running_transaction != NULL fails in commit.c

On Thu, Apr 21, 2011 at 09:17:57AM -0500, Martin_Zielinski@McAfee.com wrote:
> 
> I posted this BUG already on the ext3-users list without response.
> After making some new observations I hope, that someone here can
> tell me these make sense. Kernel output of the BUG is at the end of
> the mail.

Hi Martin,

Thanks for your observations.  I don't necessarily always follow mail
sent to ext3-users, but fortunately I saw this note sent to the LKML
list.  

> Here's some debug output that I put into the code:
> kernel: (fs/ext3/fsync.c, 77): ext3_sync_file: ext3_sync_file datasync=1 d_tid=27807 tid=27846
> kernel: (fs/jbd/journal.c, 467): log_start_commit: log start commit called with commit request=27845, tid=27807 running transaction=ffff8800266913c0 27846
> 
> So the "really-commited" transaction id was advancing while this
> datasync_tid stayed the same and journal.c - log_start_commit() was
> called without waking the commit process.
> 
> I wondered what happens if the current journal tid is overflowing
> (32bit unsigned integer). By forcing the tid in get_transaction to
> jump close to UINT_MAX, I could reproduce the BUG.

A simple overflow shouldn't cause the problem, because of how
tid_geq() is coded.  However, if there have been 2**31 commits since
the fdatasync file has been opened, it's possible to trigger this.
That's a **lot** of commits, so I'm not sure I'm completely happy with
this theory.  Nevertheless, I believe this set of patches (one for
ext4, and one for ext3), should prevent the crash from happening.

      	      	  	 		    	  - Ted
