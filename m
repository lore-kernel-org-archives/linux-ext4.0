From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Unify inode flags bit and inode flags.
Date: Mon, 12 Dec 2011 10:41:41 +0800
Message-ID: <4EE569E5.40805@tao.ma>
References: <1323655189-3417-1-git-send-email-tm@tao.ma> <20111212024000.GA12433@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49882 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752756Ab1LLClr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Dec 2011 21:41:47 -0500
In-Reply-To: <20111212024000.GA12433@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/12/2011 10:40 AM, Ted Ts'o wrote:
> On Mon, Dec 12, 2011 at 09:59:49AM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In order to make atomic set/get of inode flags, we create a enum of
>> different inode flags. Now when we add a new inode flag(e.g inline data),
>> we have to add both the 'enum' and the 'define' and calculate the value
>> of 'define' by ourselves. This is a bit boring and error-prune.
>> So this patch just unify these 2 fields.
> 
> This was deliberate.  The problem is these flags also have to be in
> sync with the hex values defined in include/linux/fs.h (and in some
> other file systems' header files), not to mention the definitions in
> e2fsprogs.
> 
> This is because the lsattr and chattr command was originally defined
> originally for ext2/3, but then other file systems (reiserfs, xfs,
> btrfs, etc) decided they would also use the same ioctls and userspace
> commands.  So we have partial overlap of these flags, and when we
> define new flags we have to be a little careful to make sure we
> coordinate between all of the places where these flags are defined.
> 
> So the fact that this is also an ABI is why I don't want to use an
> enum and to calculate the values from that.
Fair enough.
Thanks for the detailed explanation.

Tao
