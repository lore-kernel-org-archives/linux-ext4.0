From: Jan Kara <jack@suse.cz>
Subject: Re: Sync does not flush to disk!?
Date: Fri, 8 Jun 2012 16:16:11 +0200
Message-ID: <20120608141611.GE21080@quack.suse.cz>
References: <4FD1CB8A.9080805@shiftmail.org>
 <20120608223332.5fe49193@notabene.brown>
 <4FD202CD.7000309@turmel.org>
 <4FD204B0.3000204@shiftmail.org>
 <20120608141139.GD21080@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.de>,
	linux-raid <linux-raid@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2FHOQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 10:16:13 -0400
Content-Disposition: inline
In-Reply-To: <20120608141139.GD21080@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-06-12 16:11:39, Jan Kara wrote:
> On Fri 08-06-12 15:57:04, Asdo wrote:
> > On 06/08/12 15:49, Phil Turmel wrote:
> > >
> > >To put it another way:  You can't safely access ext filesystems via
> > >raw devices in two systems.  The kernel cache won't be synchronized,
> > >and you almost certainly *will* corrupt the contents.
> > 
> > Thanks both of you for your explanations
> > 
> > I might say that it seems to me a bad design: never before I saw a
> > cache that is not updated by writes.
> > Here the cache content is *older* than the data on the real devices!?
> > if it was *newer*, there are known cases (writeback cache not
> > flushed yet), but *older*... never seen.
>   Well, the problem is in inconsistency of caches. There is one cache -
> page cache - used by filesystems to read & write file data which is
> addressed by inode, offset. And there is another cache caching the whole
> device addressed by device, offset. It would be too costly to keep both
> these caches consistent and most people don't care so we don't.
> 
>   BTW, if you configured KVM to use direct IO or virt IO when accessing the
> devices (a good idea anyway), you wouldn't have the problems either.
  Hmm, I didn't notice you actually keep the fs mounted on host when
starting the guest. That is really asking for trouble - host's data that is
cached in memory (and I'm not speaking just about data but more importantly
also allocation information etc.) will not be update when guest changes the
filesystem so the filesystem will get almost certainly corrupted.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
