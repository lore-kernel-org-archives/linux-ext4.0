From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Wed, 25 Aug 2010 18:55:49 -0600
Message-ID: <6B0D8B5D-C576-4DC2-B390-9D1EB8B6A5BA@dilger.ca>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com> <20100824131735.GD3713@quack.suse.cz> <20100825090551.DEB3.61FB500B@jp.fujitsu.com> <20100825230442.GH2738@quack.suse.cz> <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca> <20100826003657.GN4453@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:14959 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0HZAzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 20:55:52 -0400
In-Reply-To: <20100826003657.GN4453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-25, at 18:36, Ted Ts'o wrote:
> On Wed, Aug 25, 2010 at 05:39:11PM -0600, Andreas Dilger wrote:
>> 
>> The fix to e2fsck for this issue has been around for a long time,
>> AFAIK.  It was only needed in the kernel while the broken mke2fs was
>> in wide use, and before a fixed e2fsck was available.
> 
> The mke2fs in question was fixed in e2fsprogs 1.37, over five years
> ago.  Mizuma-san, why are you using such an __ancient__ mke2fs?  It
> would seem that instead of fixing the kernel, the better thing to do
> is to fix your version of e2fsprogs.

I think you are missing the point.  I don't think it matters which mke2fs is in use.  The problem is that ext3_iget() has a workaround for this 5-year-old mke2fs bug that is actively causing a loss of xattr data if lost+found is reallocated.

> I certainly don't see the point of fixing making any changes in ext4
> to accomodate such a change, since e2fsprogs which is that old won't
> support ext4 file system features anyway.

There is no patch to ext4, which never had the workaround (this is a clear difference between ext3_iget() and ext4_iget()).  That was because we knew ext4 would not be in use on these old filesystems and there was no point to include the workaround.

Cheers, Andreas





