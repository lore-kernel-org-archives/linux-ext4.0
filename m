From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 0/3][RFC] add a message in mount/remount/umount for
 ext2/ext3/ext4
Date: Wed, 16 Sep 2009 13:55:43 +0900
Message-ID: <20090916135543.3cc0b0b5.toshi.okajima@jp.fujitsu.com>
References: <20090915152039.fdca8936.toshi.okajima@jp.fujitsu.com>
	<20090915152044.2e4b941f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45484 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZIPE7w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 00:59:52 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8G4xstb017642
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 16 Sep 2009 13:59:54 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 720AB45DE54
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:59:54 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 442BC45DE53
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:59:54 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0D3DFE38004
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:59:54 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B5E221DB8042
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 13:59:53 +0900 (JST)
In-Reply-To: <20090915152044.2e4b941f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew,
Thanks for your comment.

On Tue, 15 Sep 2009 15:20:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 15 Sep 2009 15:20:39 +0900
> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> 
> > Hi Ted, Andrew and all.
> > 
> > Under the current implementation, we cannot know in the system log 
> > (/var/log/messages) when the filesystem (ext2/ext3/ext4) is unmounted.
> > For enterprise users, they often want to observe certain filesystems'
> > actions (mount/unmount) in the system log. Besides, by the system log, 
> > we occasionally wants to know whether a certain filesystem has been
> > unmounted or not at the time when a problem happens.
> > 
> 
> I don't think we want to make random printks a part of the kernel
> ABI like this.
Yes.

However, the message of the mount is already included in ext3/ext4.
So, I think it is no problem that the message of the umount which is opposite
operation of the mount is added. And it is natural, I think.

> 
> I understand that it's practical and easy for people to parse the logs
> in a local ad-hoc manner such as this, but...  ugh.
> 
> If there's a userspace requirement for notification when filesystems
> are mounted and unmounted then fine, let's look at that.  What is the
> detailed requirement?  What info do we want to see?  What is an
> appropriate way of delivering that info?  kobject_uevent() looks like a
> suitable place to start.
> 
> 
> That being said, there is perhaps a case to made for being more verbose
> when filesystems are mounted and unmounted.  But yes, doing that in the
> VFS for all filesystems sounds better.  This might upset people who
> have thousands of NFS autmounts though.

Sample case (this feature is required):
  A filesystem detects its corruption. A user asks me why the filesystem
  has been corrupted. The user send me a material to examine why it happens.
  The material is the system log. He cannot send me any other materials.
  Because his machine does mission critical jobs, so he doesn't want to stop
  it. Therefore only by the system log I have to examine why it happens.

  Whenever I solve such a problem, I want the time stamp which is made
  when the filesystem is mounted/unmounted.
  If this feature is included, I can easily understand whether the filesystem
  is mounted or not in a certain time zone by checking the time stamps.

  For example:
   If he restored the filesystem at a certain time, I can judge whether
   he left the filesystem mounted or not by this feature.
  (If he left the filesystem mounted, the filesystem was corrupted by his
   restoration operation.)

Thanks,
Toshiyuki Okajima
