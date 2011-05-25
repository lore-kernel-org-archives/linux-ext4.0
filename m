From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Jbd: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 09:48:29 -0400
Message-ID: <20110525134829.GC8476@thunk.org>
References: <1306318841-8363-1-git-send-email-dingdinghua@nrchpc.ac.cn>
 <BANLkTik=B08XzLViSD10Z_bac6R5DqswmA@mail.gmail.com>
 <BANLkTim992S6+iGEN12NfcuOz-UOSe2prQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ding Dinghua <dingdinghua@nrchpc.ac.cn>, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59221 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab1EYNsd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 09:48:33 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTim992S6+iGEN12NfcuOz-UOSe2prQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 07:47:14PM +0800, Yongqiang Yang wrote:
> On Wed, May 25, 2011 at 7:37 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> > Hi,
> >
> > m/N means that there are N patches and this patch is the mst one. e.g.
> > 2/30 means the patch series contain 30 patches and this is the 2nd
> > one.
> >
> > When a patch is resent, you'd better send it with [PACH vm], where m
> > is the version number.
> Sorry,  two patches are different, please ignore comments above.

... and this is why it's a REALLY GOOD IDEA to make patch 2/2 have a
In-Reply-To: header that references the message id of patch 1/2.  It
avoids this sort of confusion.

And again, git format-patch and git send-email will do all of this
automatically for you...

						- Ted
