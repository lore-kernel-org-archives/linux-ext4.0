From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Mon, 27 Feb 2012 11:35:38 -0500
Message-ID: <4F4BB0DA.2060906@ubuntu.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com> <4F47A2BC.50307@ubuntu.com> <alpine.LFD.2.00.1202241550520.13074@dhcp-27-109.brq.redhat.com> <4F47B32B.5020006@ubuntu.com> <alpine.LFD.2.00.1202241710190.13074@dhcp-27-109.brq.redhat.com> <4F47BF60.2080303@ubuntu.com> <alpine.LFD.2.00.1202270807030.5597@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:17897 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2B0Qfk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 11:35:40 -0500
In-Reply-To: <alpine.LFD.2.00.1202270807030.5597@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/27/2012 2:39 AM, Lukas Czerner wrote:
> I think that no one would ever install their file system on thinly
> provisioned storage just with dd. That's just stupid.

It could be on an SSD.  It also could have been transferred with e2image 
or similar imaging tools.  While foolish to use dd, correcting that 
foolishness seems to be the point of e2fsck -E discard.  If you could 
always rely on parts of the disk being discarded when they should, then 
you wouldn't need e2fsck to do it would you?

> I have never said anything about the block group containing zeros. You
> do not even have this guarantee when using discard command.

You do with some disks, and sparse image files.  My point was that the 
uninitialized flag is no guarantee that the blocks are discarded.  If 
e2fsck -E discard is to clean up blocks that *should* be discarded, but 
( for whatever reason ) aren't, then that should include uninitialized 
groups.

> I am not really sure how this is relevant to the e2fsck doing discard. I
> just said that *if* the block group is market as UNINIT, then it was not
> used by the file system from the time of mke2fs, hence there should be
> nothing to reclaim.

There is something to reclaim if it was not discarded at mkfs time. 
Think of an SSD that was formatted before mke2fs supported discard, and 
had previously been dirtied by another fs.

> However this would only make sense to do in kernel, because in e2fsck it
> would not actually speed up anything until the next e2fsck call. But by
> that time the groups might be initialized again. To do this in kernel we
> would have to check whether the group is actually empty when freeing
> blocks, or freeing inodes. That code is not there, and I am not sure if
> it is worth the hassle (it might be), so I think that this patch is fine
> as it is.

If it may be a good idea to to have the kernel do this in the future, 
then wouldn't it be prudent to allow for it now?

