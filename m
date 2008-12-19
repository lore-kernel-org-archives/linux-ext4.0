From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which
 can be used by file systems
Date: Fri, 19 Dec 2008 14:15:23 +0900
Message-ID: <494B2DEB.7080107@jp.fujitsu.com>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu> <20081217153940.GA6495@atrey.karlin.mff.cuni.cz> <4949DC6D.3050908@jp.fujitsu.com> <20081218131222.GB13580@duck.suse.cz>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47321 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYLSFPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2008 00:15:36 -0500
In-Reply-To: <20081218131222.GB13580@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.

Jan Kara wrote:
 >   Hello,
 >
<SNIP>
 > > Which of the following do you mean:
 > > 1) If using a spinlock in client_releasepage() is only for mount/umount,
 > >  this implementation is not wise.
 > > 2) There is the fact that a spinlock is necessary for blkdev_releasepage().
 > > This fact prevents us from making various implementations of
 > > client_releasepage().
 > > (Without a spinlock, we can implement a client_releasepage() which can release
 > > the buffers with a sleep. As a result, it may enable more buffers release than
 > > before.)
 > >
 > > There is the fact that a filesystem can be mounted on several places,
 > > and the lock mechanism is absolutely necessary for this fact.
 >   This is the thing I was wondering about. Why exactly is the spinlock
 > necessary for blkdev_releasepage()? I understand we have to protect
 > reading client_releasepage() pointer because it could change but my point
 > was that it changes only during mount / umount.

There are 2 purposes of this lock.
1) The race between filesystem's mount and umount.
(So that a filesystem can be mounted on several places concurrently.)
------------------------------------------------------------------
Without this lock, there is a possibility that the pointer of
ei->client_releasepage becomes NULL by umount.
As a result, a special releasepage for its filesystem is not used even if its
filesystem has been mounted.
------------------------------------------------------------------

2) The race between the usage of blkdev_releasepage() and umount.
------------------------------------------------------------------
Without this lock, there is a possibility that the pointer of
ei->client_releasepage becomes NULL by umount.
As a result, the process which calls blkdev_releasepage() may experience a page
  fault. Because blkdev_releasepage() refers the value ei->client_releasepage
and then calls it as a function.

But even if the pointer is not NULL, there is a possibility that a filesystem
which has it has been unmounted. Besides, there is a possibility that the
module of the filesystem has been unloaded. In this case, something wrong
can happen.
(Example: While a filesystem is being unmounted, one of its resources can be
touched by using the ei->client_releasepage of the filesystem by
the side of calling blkdev_releasepage.)
------------------------------------------------------------------

Therefore some lock mechanisms are necessary to solve the races.

Regards,
Toshiyuki Okajima

