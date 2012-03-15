From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Status of META_BG?
Date: Thu, 15 Mar 2012 13:55:36 -0400
Message-ID: <4F622D18.3020805@ubuntu.com>
References: <4F620EDA.8030701@ubuntu.com> <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:22887 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161122Ab2CORzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 13:55:38 -0400
In-Reply-To: <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/15/2012 12:25 PM, Andreas Dilger wrote:
> In the case of very large filesystems (256TB or more, assuming 4kB
> block size) the group descriptor blocks will grow to fill an entire
> block group, and in the case of group 0 and group 1 they would start
> overlapping, which would not work.

To get an fs that large, you have to enable 64bit support, which also 
means you can pass the limit of 32k blocks per group.  Doing that should 
allow for a much more reasonable number of groups ( which is a good 
thing several reasons ), and would also solve this problem wouldn't it?

> META_BG addresses both of these issues by distributing the group
> descriptor blocks into the filesystem for each "meta group" (= the
> number of groups whose descriptors fit into a single block).

So it puts one GD block at the start of every several block groups? 
Wouldn't that drastically slow down opening/mounting the fs since the 
disk has to seek to every block group?

Perhaps if it were coupled with flex_bg so that flex_factor GD blocks 
would be clustered that would mitigate that somewhat, but iirc the 
default flex factor is only 16 so that might need bumped up for such 
large disks.

> The number of backups is reduced (0 - 3 backups), and the blocks do
> not need to be contiguous anymore.

You know, I've been wondering why the group descriptors are backed up in 
the first place.  If the backups are only ever written at mkfs time, and 
can be reconstructed with mke2fs -S, then what purpose do they serve?

