From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 0/3][RFC] add a message in mount/remount/umount for
 ext2/ext3/ext4
Date: Wed, 16 Sep 2009 13:51:53 +0900
Message-ID: <20090916135153.9b49c58b.toshi.okajima@jp.fujitsu.com>
References: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
	<4AAFAFAE.2090801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, akpm@linux-foundation.org, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45333 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZIPE4C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 00:56:02 -0400
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8G4u44c016118
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 16 Sep 2009 13:56:05 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id A12C345DE7D
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:56:04 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 7133245DE79
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:56:04 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4A601E18011
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:56:04 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.249.87.106])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id EA89EE1800B
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:56:03 +0900 (JST)
In-Reply-To: <4AAFAFAE.2090801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,
Thanks for your comment.

On Tue, 15 Sep 2009 10:15:58 -0500
Eric Sandeen <sandeen@redhat.com> wrote:
> Toshiyuki Okajima wrote:
> > Hi Ted, Andrew and all.
> > 
> > Under the current implementation, we cannot know in the system log 
> > (/var/log/messages) when the filesystem (ext2/ext3/ext4) is unmounted.
> > For enterprise users, they often want to observe certain filesystems'
> > actions (mount/unmount) in the system log. Besides, by the system log, 
> > we occasionally wants to know whether a certain filesystem has been
> > unmounted or not at the time when a problem happens.
> > 
> > The following patch series implement above demand. 
> > Please apply it.
> 
> If this is really a common requirement, perhaps we should at least
> consider putting it in the vfs, in  vfs_kern_mount(),
> generic_shutdown_super(), and do_remount_sb().
Yes. I also thought it was appropriate that where this feature was implemented
was on VFS. But ext3/ext4 has already included the message mechanism which
operates when ext3/ext4 is mounted/remounted.

So, to achieve this feature easily, I have rearranged the message mechanism in
ext3/ext4 (ext2 is newly implemented).

> 
> That way we'll have common behavior and less replicated code; nothing in
> this patch series is unique to ext[234] as far as I can tell.
> 
> sb->s_type->name could be used to print the fs type in a generic message.

Thanks,
Toshiyuki Okajima
