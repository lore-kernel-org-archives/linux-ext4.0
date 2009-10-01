From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 3/3][RFC](Repost) ext4: add a message in remount/umount
 for ext4
Date: Thu, 01 Oct 2009 12:20:17 +0900
Message-ID: <4AC41FF1.7060703@jp.fujitsu.com>
References: <20090930154931.ef2a4760.toshi.okajima@jp.fujitsu.com> <20090930172220.GL24383@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger@sun.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43499 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbZJADUU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 23:20:20 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n913KMYW017882
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Thu, 1 Oct 2009 12:20:22 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id B5E4E45DE51
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 12:20:22 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 521E845DE4F
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 12:20:22 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 20A52E38006
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 12:20:22 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 722831DB8040
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 12:20:21 +0900 (JST)
In-Reply-To: <20090930172220.GL24383@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, thank you for your comment.

Theodore Tso wrote:
 > On Wed, Sep 30, 2009 at 03:49:31PM +0900, Toshiyuki Okajima wrote:
 > > > From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
 > > >
 > > > ext4 doesn't log a record of having unmounted the filesystem. And ext4 doesn't
 > > > log a record when the filesystem is remounted also with read-only. Therefore
 > > > in the system log, we cannot judge whether or not at the certain time this
 > > > filesystem user touches it.
 > > > For enterprise users, they often want to know when a certain filesystem is
 > > > mounted/remounted/unmounted.
 > > >
 > > > So, we output the message to the system log when the filesystem is
 > > > remounted/unmounted.
 > > >
 > > > Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
 >
 > The question of whether this should be at the VFS layer is still an
 > open one, I think.  It is true that ext3 and ext4 does print some
I am recognizing it. But I think I have already explained its answer as follows:
  - A print mechanism has already been included at mount time.
  - The umount operation is opposite "mount operation". Therefore I think
    it is no problem that we add the print mechanism at the umount time.

 > filesystem specific information, but that could be handled via a new
 > method function in struct super_ops:
 >
 >        mount_msg(struct super *sb, char *buf, int buflen)
 >
However, I have noticed that the purpose of ext3/ext4 messages at mount time
is for specific information but not for a general purpose by this comment.

So, I think I should rearrange this feature into the VFS layer.
I try to reimplement it later.

Thanks,
Toshiyuki Okajima

