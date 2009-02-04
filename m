From: Jimmy Rentz <jedynamic@bellsouth.net>
Subject: Re: ext4 - error with root drive mount
Date: Wed, 4 Feb 2009 09:34:20 -0500
Message-ID: <20090204093420.44cac139@amd64linuxmsi.rentzhouse.lan>
References: <20090203191531.0dfe27a1@amd64linuxmsi.rentzhouse.lan>
	<20090204062400.GZ14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jimmy Rentz <jedynamic@bellsouth.net>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:37376 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZBDOj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2009 09:39:26 -0500
In-Reply-To: <20090204062400.GZ14762@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Feb 2009 01:24:00 -0500
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Feb 03, 2009 at 07:15:31PM -0500, Jimmy Rentz wrote:
> > 	I am unable to mount my ext4 root drive. 
> > 
> > 	I get this error:
> > 	EXT4-fs: ext4_check_descriptors: Block bitmap for group 2688
> > 	not in group (block 4205711663)!<3>EXT4-fs: group
> > descriptors corrupted!
> > 
> > 	I had a similar error some time ago, but I thought it was
> > power related.  I fixed the problem by running a fcsk.  
> 
> You'll need to fix it using fsck again.  I assume the back up
> superblocks will have the correct value.
> 
> It would be interesting to see if there are any other errors picked up
> by e2fsck.
I reran fsck and that fixed the problem. 

Here is a sample of the errors:
Free blocks count wrong for group #1 (14705, counted=19112).
Fix? no

Free blocks count wrong for group #2 (12753, counted=11404).
Fix? no

Free blocks count wrong for group #3 (20531, counted=17213).
Fix? no
...
Free blocks count wrong for group #11160 (7673, counted=3577).

Then some errors about inode and directory counts wrong.

I also forgot that I have a log of the fsck errors when I
had this problem before.

> 
> > 	Any tips to debug this?
> 
> Can you reliably replicate this problem?  I've not seen any similar
> reports of problems like this.
> 
> 						- Ted

I am not sure how to reproduce this problem.  It seems random
enough.  The system is a mythtv box so it happens to
poweron/poweroff on a regular basis to record.    
