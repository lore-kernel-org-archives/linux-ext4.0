From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4 df free space reporting not reliable?
Date: Sun, 13 Jun 2010 06:27:02 -0400
Message-ID: <69DFE925-D32D-4CAA-B734-545DE0515FCE@mit.edu>
References: <20100613093807.GA31407@basil.fritz.box>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:65089 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0FMK1I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jun 2010 06:27:08 -0400
In-Reply-To: <20100613093807.GA31407@basil.fritz.box>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jun 13, 2010, at 5:38 AM, Andi Kleen wrote:

> Hi,
> 
> I have a ext4 file system on 2.6.34 that shows 0 blocks available
> in "df" (it's nearly full but never got a ENOSPC). 
> 
> But when I delete a couple of files it still shows 0 blocks.
> And I can actually create small files without problem, so clearly
> there is at least some space available.
> 
> So is df reporting not accurate?

Are you creating the files as root?  Sounds like the standard reserved
blocks behavior that's been around since ext3, ext2, BSD's ufs, etc...

- Ted

