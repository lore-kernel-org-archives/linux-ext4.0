From: Ted Ts'o <tytso@mit.edu>
Subject: Re: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Date: Mon, 25 Apr 2011 19:14:54 -0400
Message-ID: <20110425231454.GB9486@thunk.org>
References: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Martin_Zielinski@McAfee.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44084 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab1DYXO5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 19:14:57 -0400
Content-Disposition: inline
In-Reply-To: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
