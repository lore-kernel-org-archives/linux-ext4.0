From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup [NEW Version]
Date: Fri, 18 Jul 2008 10:15:18 -0500
Message-ID: <20080718101518.0722e9e4@gara>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<20080717154604.3fb8e084@ichigo>
	<87r69ro263.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56149 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbYGRPOa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 11:14:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6IFERnE027580
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 11:14:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IFE8uf075096
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 09:14:09 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6IFE82n019548
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 09:14:08 -0600
In-Reply-To: <87r69ro263.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 18 Jul 2008 13:35:32 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> "Jose R. Santos" <jrs@us.ibm.com> writes:
> 
> > Hi folks,
> >
> > I'm posting a new version of the 64-bit mke2fs patch since it was broken
> > in many ways (many thanks to Goswin for having a look and pointing them
> > out).  This one can actually handle large fs as runs until its time to
> > allocate table (where it barfs due bitmap issues).  To make 64bit fs, I
> > use the following command.
> >
> > mke2fs -T ext4dev -O64bit /dev/my_large_disk
> 
> Just like ext2/3 default to a 4k blocksize if it exceeds 2^32 1k
> blocks shouldn't ext4 default to 64bit if it exceeds 2^32 4k blocks?

Eventually, when the feature is stable enough, we can change the
default in mke2fs.conf to include this feature for the ext4 fs_type.
The problem of setting it only if the fs exceeds 2^32 blocks is that
you will not be able to resize an fs from 32 to 64bit due to the block
group descriptor size change.  Once the feature is stable, it should
set as default regardless of the storage size.
 
> > Comments welcome 
> >
> > -JRS
> 
> MfG
>         Goswin


-JRS
