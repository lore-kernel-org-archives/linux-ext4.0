From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
Date: Mon, 14 Mar 2011 11:40:26 +0100
Message-ID: <AANLkTi=w2uV_Gy3zOapQishk_qqskQz72p2fnQMQZczx@mail.gmail.com>
References: <4D6221B8.9040303@gmail.com>
	<4D6F5473.2070709@gmail.com>
	<20110303213903.GL15097@dastard>
	<20110314102426.GA29888@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, xfs@oss.sgi.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40620 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1CNKyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 06:54:33 -0400
In-Reply-To: <20110314102426.GA29888@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/3/14 Christoph Hellwig <hch@infradead.org>:
> On Fri, Mar 04, 2011 at 08:39:03AM +1100, Dave Chinner wrote:
>> WTF? =A0Why does append mode have any effect on whether we can punch
>> holes in a file or not? There's no justification for adding this in
>> the commit message. Why is it even in a patch that is for checking
>> immutable inodes? What is the point of adding it, when all that will
>> happen is people will switch to XFS_IOC_UNRESVSP which has never had
>> this limitation?
>
> xfs_ioc_space unconditionally rejects inodes with S_APPEND set for
> all preallocation / hole punching ioctls. =A0This might be overzealou=
s for
> preallocations not changing the size, or just extending i_size, but i=
t's
> IMHO entirely correct for hole punching.
>

xfs_ioc_space is in the ioctl path, but we are talking about the
fallocate path. Both of them calls the xfs_change_file_space, isnt'it?
However we are agree about hole punching, the patch is already in
Linus's git tree.

Marco
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
