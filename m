From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: fsck performance.
Date: Thu, 24 Feb 2011 16:26:16 -0800
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D6161@wdscexbe08.sc.wdc.com>
References: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu> <20110223205309.GA16661@bitwizard.nl> <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca> <20110224072945.GE16661@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam2.wdc.com ([129.253.55.43]:17094 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab1BYAhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 19:37:17 -0500
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 

> -----Original Message-----
> From: linux-ext4-owner@vger.kernel.org 
> [mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of Rogier Wolff
> Sent: Wednesday, February 23, 2011 11:30 PM
> To: Andreas Dilger
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: fsck performance.
> 
> On Wed, Feb 23, 2011 at 03:24:18PM -0700, Andreas Dilger wrote:
> 
...
> 
> Second: e2fsck is too fragile as it is. It should be able to handle
> big filesystems on little systems. I have a puny little 2GHz Athlon
> system that currently has 3T of disk storage and 1G RAM. Embedded
> Linux systems can be running those amounts of storage with only 64
> or 128 Mb of RAM. 

I have to second this comment.  One of our NAS has 256 MBytes of RAM
(and they wanted 64) with a 3TB disk, 2.996TB of which is an EXT4 file
system.  With our 2.6.32.11 kernel and e2fsprogs version  1.41.3-1,
all I get is a segfault when I run fsck.ext4.

