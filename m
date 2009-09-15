From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/3][RFC] add a message in mount/remount/umount for ext2/ext3/ext4
Date: Tue, 15 Sep 2009 10:15:58 -0500
Message-ID: <4AAFAFAE.2090801@redhat.com>
References: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, akpm@linux-foundation.org, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZIOPQC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Sep 2009 11:16:02 -0400
In-Reply-To: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Toshiyuki Okajima wrote:
> Hi Ted, Andrew and all.
> 
> Under the current implementation, we cannot know in the system log 
> (/var/log/messages) when the filesystem (ext2/ext3/ext4) is unmounted.
> For enterprise users, they often want to observe certain filesystems'
> actions (mount/unmount) in the system log. Besides, by the system log, 
> we occasionally wants to know whether a certain filesystem has been
> unmounted or not at the time when a problem happens.
> 
> The following patch series implement above demand. 
> Please apply it.

If this is really a common requirement, perhaps we should at least
consider putting it in the vfs, in  vfs_kern_mount(),
generic_shutdown_super(), and do_remount_sb().

That way we'll have common behavior and less replicated code; nothing in
this patch series is unique to ext[234] as far as I can tell.

sb->s_type->name could be used to print the fs type in a generic message.

-Eric

> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> ---
>  fs/ext2/super.c |   16 ++++++++++++++++
>  fs/ext3/super.c |   32 +++++++++++++++++++++++---------
>  fs/ext4/super.c |   30 ++++++++++++++++++++++--------
>  3 files changed, 61 insertions(+), 17 deletions(-)
> 
> Regards,
> Toshiyuki Okajima
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

