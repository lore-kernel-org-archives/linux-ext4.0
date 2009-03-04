From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Wed, 4 Mar 2009 04:11:26 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903040406570.26543@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr> <49ADBB03.9070303@redhat.com> <alpine.LSU.2.00.0903040125410.12894@fbirervta.pbzchgretzou.qr> <20090304024904.GK32284@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	kzak@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58558 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZCDDLa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 22:11:30 -0500
In-Reply-To: <20090304024904.GK32284@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wednesday 2009-03-04 03:49, Theodore Tso wrote:
>On Wed, Mar 04, 2009 at 01:36:44AM +0100, Jan Engelhardt wrote:
>> >> 
>> >> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
>> >> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
>> >> would mean the default for -i is 16384. 
>> >
>> >Which part of a 16384-data-bytes-to-inode-count ratio do you find
>> >unreasonable?  Do you find it unreasonably high, or unreasonably low?
>> 
>> I think it's a bit too high, causing the amount of usable inodes
>> to be a bit too low.
>
>So out of curiosity, what are you storing on the filesystem such that
>you're worried about running out of inodes?  The assumption was that
>on most filesystems the average file size would indeed be bigger than
>4k these days, although obviously things will vary depending on what
>you plan to store.  Even if you're using maildir stores, or squid
>caches, it seemed like 16k was a good default.

The source and module_prepare'd obj dirs for the trees
2.6.{17.14,18.8,19.7,20.21,21.7,22.19,23.17,24.7,25.20,26.8,27.8,28}.

Filesystem    Type    1K-blocks      Used Available Use% Mounted on
/dev/loop0     xfs      4184064   3676644    507420  88% /lo/kernel

Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
/dev/loop0     xfs   2343280  313466 2029814   14% /lo/kernel
