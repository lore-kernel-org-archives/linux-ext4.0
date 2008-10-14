From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: sreadahead hooks
Date: Tue, 14 Oct 2008 16:49:51 -0500
Message-ID: <48F513FF.8020306@redhat.com>
References: <20081014101735.04107779@infradead.org> <20081014151329.GA17926@infradead.org> <48F4BFF6.8060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Arjan van de Ven <arjan@infradead.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35012 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYJNVt4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Oct 2008 17:49:56 -0400
In-Reply-To: <48F4BFF6.8060404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Tue, Oct 14, 2008 at 10:17:35AM -0400, Arjan van de Ven wrote:
>>> >From 3d7a0ca0ee8a755251251bd9ddca0866c25acdc2 Mon Sep 17 00:00:00 2001
>>> From: Arjan van de Ven <arjan@linux.intel.com>
>>> Date: Tue, 14 Oct 2008 10:12:08 -0400
>>> Subject: [PATCH] ext3: sreadahead hooks
>>>
>>> The sreadahead program, used to make the OS boot faster, needs to know in
>>> the approximate order in files are used during the boot process. This patch
>>> adds the ext3 hook for this functionality, basically it stores "jiffies"
>>> into the inode at allocation time, and exposes it via an EXT3 ioctl (yes I
>>> know but ioctl seems fitting for this).
>> Even if it's an ioctl there's absolutely no point in making this
>> fileystem specific.  Also the name is rather dumb and non-descriptive.
> 
> I have to agree, both the ioctl name and the new field are not very
> descriptive - created_when sounds an awful lot like ctime but it's not.
> 
> and INODE_JIFFIES really doesn't mean anything at all w/o extra context.
>  But I'm trying to think of some nice names.  :)
> 
> What about making a new struct inode field and doing this update in
> new_inode(), and making it a generic ioctl.  Are we ready to go that far?

Or, as I thought about/mentioned to hch, and I guess he and Arjan
already discussed... :)  why not just use tracing infrastructure to get
this info, rather than adding new members to every inode on the system?

-Eric
