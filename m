From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/8 v3] ext4: extent status tree (step 1)
Date: Mon, 19 Nov 2012 13:28:59 +0800
Message-ID: <20121119052859.GA22442@gmail.com>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
 <20121119031725.GA24414@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jeff.liu@oracle.com, hughd@google.com,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	lczerner@redhat.com, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:43252 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2KSFQ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 00:16:29 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so586716dak.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Nov 2012 21:16:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121119031725.GA24414@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 18, 2012 at 10:17:25PM -0500, Theodore Ts'o wrote:
> On Fri, Oct 26, 2012 at 09:23:37PM +0800, Zheng Liu wrote:
> > Hi all,
> > 
> > Here is the v3 of extent status tree.  In this version, the biggest change is
> > the i_es_lock (a rwlock_t) instead of i_data_sem, which is introduced to protect
> > extent status tree.  Moreover I improve the SEEK_DATA/SEEK_HOLE.  In previous
> > version, the unwritten extent is as a data, and now it will lookup page cache to
> > determine it as a data or a hole.  When it has some data at the given range, the
> > unwritten extent will be as a data.  Otherwise, it will be as a hole.  Other
> > changes contain some bug fixes.
> 
> I don't think I ack'ed this patch series earlier; my apologies.  In
> any case (with the comment fixup we discussed earlier), It's currently
> queued for the next merge window.

Thanks. :-)

BTW, I am trying to implement the second step of extent status tree,
which will track all extent status for an inode.  After that, some
improvements will be added, such as extent-level locking, etc.

Regards,
                                                - Zheng
