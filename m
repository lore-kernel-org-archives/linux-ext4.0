From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V7 00/23] ext4: Add inline data support
Date: Fri, 07 Dec 2012 09:34:24 +0800
Message-ID: <50C147A0.4070109@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma> <20121206173022.GE30273@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:42956 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932169Ab2LGBe2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2012 20:34:28 -0500
In-Reply-To: <20121206173022.GE30273@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 12/07/2012 01:30 AM, Theodore Ts'o wrote:
> Hi Tao,
> 
> I've been going over the patch series, and one of the things that I
> started thinking about was whether we really needed the inline_data
> flag, strictly speaking.  After all, the information will be in the
> extended attribute space in the inode table, so it's relatively cheap
> to search the ibody looking for the extended attribute, and then to
> cache that information in a state flag.  That might be a useful thing
> to do, so I'd welcome your comments about whether you think this would
> be a good idea.
I was thinking of this, but that would make e2fsck hard to tell whether
the inline data is OK or not. Currently, we can make sure it is inline
data if both the flag and the "system.data" are set correctly. Without
this flag, So what do you think we should do in e2fsck? Having said
that, yes, in the kernel side, there are only 3 places using/checking
this flag and it can be removed easily.
> 
> But this brought up a bigger issue, which is the one downside of doing
> this is the potential locking overhead before fetching the information
> out of the extended attribute --- and that's when I realized the
> locking is currently *missing*.  At the moment, the VFS layer takes
> i_mutex before calling the per-filesystem extended attribute
> functions, and that takes care of the locking.  However, the inline
> data patches call ext4_xattr_ibody_find() and ext4_xattr_ibody_set()
> directly, and they are not taking the i_mutex first.
> 
> Hence, we have potential races between the a process setting an
> userspace extended attribute, or selinux setting a security.* xattr,
> and the new code which tries reading or writing inline data.
I think ext4_inode->xattr_sem should protect us? When we do xattr
corresponding operation, we just do
down_write/read(&EXT4_I(inode)->xattr_sem), so we should be fine with
this type of operation. Am I missing something here?

Thanks
Tao
> 
> Could you take a look at this, please?
> 
> Many thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

