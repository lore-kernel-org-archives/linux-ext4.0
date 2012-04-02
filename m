From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: backup of the last group'descriptor when it is the 1st group of a meta_bg
Date: Sun, 1 Apr 2012 23:46:06 -0600
Message-ID: <48603AD4-9120-41F1-A796-06684D605C57@dilger.ca>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com> <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca> <CAGBYx2ap2UFyvjuFr=BH1NfeeCZrQn93w0mtCtOje_TsmixnTA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <aedilger@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49630 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2DBFoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 01:44:02 -0400
Received: by dake40 with SMTP id e40so1977200dak.11
        for <linux-ext4@vger.kernel.org>; Sun, 01 Apr 2012 22:44:01 -0700 (PDT)
In-Reply-To: <CAGBYx2ap2UFyvjuFr=BH1NfeeCZrQn93w0mtCtOje_TsmixnTA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-01, at 11:04 PM, Yongqiang Yang wrote:
> On Thu, Mar 29, 2012 at 12:08 AM, Andreas Dilger <aedilger@gmail.com> wrote:
>> I would suggest to put the backup group descriptor in the last block
>> of the filesystem.  This would be in the 0th group of the metagroup.
>> If the metagroup grows to have a second group, then this block is not
>> needed anymore, and if both the primary (at the beginning of the group)
>> and the backup (at the end of the group) are corrupted, then there is
>> little chance that the data in this last group is good either...
> 
> Now we have 2 solutions, the 1st one is storing backup group
> descriptor in resize inode itself while the 2nd one is storing backup
> in the last block of the 0th block. Both need patching e2fsck because
> older e2fsck does not work.  The 1st one's patch to e2fsck is much
> more complicated, because only one group descriptor is stored in
> resize inode itself, but the e2fsck's code reading/writing group
> descriptor block. so I like the 2nd one.

This solution doesn't _require_ patching e2fsck, which is useful.
If an older e2fsck doesn't understand the backup group descriptor is
in the last block, it is no worse than today where the backup does
not exist at all.  In that case, the old e2fsck would mark this block
free, and there is a tiny chance that it would be allocated to some
file and overwritten.

However, the last block will almost never be allocated, since block
allocation is typically biased toward the beginning of the disk, so
storing a checksum in it (per Darrick's patches) would allow a new
e2fsck to use it in case of emergency, and it would mark the block
in use again (so long as it wasn't allocated to some file).

Cheers, Andreas





