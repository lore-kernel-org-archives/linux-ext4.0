From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: fs corruption recovery
Date: Thu, 19 Mar 2015 22:47:17 -0700
Message-ID: <550BB465.6040601@linux.vnet.ibm.com>
References: <550A1EBF.2030902@linux.vnet.ibm.com> <3D9B0893-DA8D-41D1-8782-BC966B91D44D@dilger.ca> <20150320014708.GA3425@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jane@us.ibm.com" <jane@us.ibm.com>,
	"marcel.dufour@ca.ibm.com" <marcel.dufour@ca.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35842 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbCTFrX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Mar 2015 01:47:23 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Thu, 19 Mar 2015 23:47:23 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 6C6A43E4003F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2015 23:47:20 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2K5lApY32374920
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2015 22:47:10 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2K5lJvr014243
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2015 23:47:19 -0600
In-Reply-To: <20150320014708.GA3425@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/19/2015 06:47 PM, Theodore Ts'o wrote:
> On Wed, Mar 18, 2015 at 06:59:52PM -0600, Andreas Dilger wrote:
>> I think that running a 17TB filesystem on ext3 is a recipe for disaster.  They should use ext4 for anything larger than 16TB.
>
> It's not *possible* to have a 17TB file system with ext3.  Something
> must be very wrong there.  16TB is the maximum you can have before you
> end up overflowing a 32-bit block number.  Unless this is a PowerPC
> with a 16K block size or some such?
>
> If e2fsck is segfaulting, then I would certainly try getting the
> latest version of e2fsprogs, just in case the problem isn't just that
> it's running out of memory.  Also if recovering customer data is the
> most important thing, the first thing they should do is a make image
> copy of the file system, since it's possible that incorrect use of
> e2fsck, or an old/buggy version of e2fsck could make things work.
>
> In particular, if they are seeing errors with multply claimed inodes,
> it's likely that part of the inode table was written to the wrong
> place, and sometimes a skilled human being can get more data than
> simply using e2fsck -y and praying.  At the end of the day the
> question is how much is the customer data work and how much effort is
> the customer / IBM willing to invest in trying to get every last bit
> of data back?
>
> 						- Ted
>

Hi all,

Sorry for the delay, our email servers went down for a bit after I sent 
the email.  I will work with Marcel to find the block size, page size 
and arch.  It is my understanding they they have a contract with this 
customer to maintain this data, so there is pressure to recover it. 
Unfortunately the product mirrored the fs corruption to the back up 
device before the corruption was discovered.  I've been told that I was 
the only person they could find left that had some background with 
ext3/4, so I have an inkling that the "skilled human being" might end up 
being me, even though its been a while since I've worked with it. :-) 
Maybe I could poke into the inode table and see what I can figure out. 
We will be sure to make image backups though.  Thx a bunch for the feed 
back, we really appreciate the help!  I will keep folks updated when I 
have more info.  Thx!

Allison Henderson

