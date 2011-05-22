From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: EXT4 partition changes every time it's mounted. (How to stop this?)
Date: Sun, 22 May 2011 07:47:49 -0400
Message-ID: <A129F9FD-E914-408C-8997-FD145AA2A697@mit.edu>
References: <476510.14310.qm@web125206.mail.ne1.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Lee Davis <l.davis37@ymail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:57022 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032Ab1EVLrw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 07:47:52 -0400
In-Reply-To: <476510.14310.qm@web125206.mail.ne1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On May 21, 2011, at 3:45 PM, Lee Davis wrote:

> I'm setting up a Linux system with full disk encryption. I've written a script (to run on every boot) which will verify that neither the MBR or /boot partition (ext4) has been modified.
> 
> Problem is that every time I boot up the system, my /boot partition hashes differently.
> 
> I'm guessing there is something behind the scenes which is changed/updated each time the filesystem is mounted? If so, can it be disabled?

Yes, there is a last mounted time in the superblock.   If you mount the file system read-only, then not only will that field not be changed, but you can guarantee that nothing else will change...

-- Ted

