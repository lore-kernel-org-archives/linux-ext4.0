From: Jan Kara <jack@suse.cz>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
 been remounted readonly
Date: Wed, 24 Feb 2010 17:56:46 +0100
Message-ID: <20100224165646.GL3687@quack.suse.cz>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
 <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
 <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
 <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
 <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
 <16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
 <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
 <20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
 <877hq2tyg8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>, hch@lst.de,
	viro@zeniv.linux.org.uk
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0BXQ4j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 11:56:39 -0500
Content-Disposition: inline
In-Reply-To: <877hq2tyg8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 24-02-10 19:01:27, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> The fact is that I've been able to reproduce the problem on LVM block
> >> devices, and sd* block devices so it's definitely not a loop device
> >> specific problem.
> >> 
> >> By the way, I tried several other things other than "echo s
> >> >/proc/sysrq_trigger" I tried multiple sync followed with a one minute
> >> "sleep",
> >> 
> >> "echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
> >> changes" but doesn't stops them.
> >   Strange. When I use sync(1) in your script and use /dev/sda5 instead of a
> > /dev/loop0, I cannot reproduce the problem (was running the script for
> > something like an hour).
> Theoretically some pages may exist after rw=>ro remount
> because of generic race between write/sync, And they will be written
> in by writepage if page already has buffers. This not happen in ext4
> because. Each time it try to perform writepages it try to start_journal
> and this result in EROFS.
> The race bug will be closed some day but new one may appear again.
  OK, I see that in theory a process can open file for writing after
fs_may_remount_ro() before MS_RDONLY flag gets set. That could be really
nasty. But by no means we should solve this VFS problem by spilling error
messages from the filesystem. Especially because block_write_full_page can
fail from a number of legal reasons (ENOSPC, EDQUOT, EIO) and we don't want
to pollute logs with such stuff.
  BTW: This isn't the race Camille could see because he did all the writes,
then sync and then remount-ro...

  Al, Christoph, do I miss something or there is really nothing which
prevents a process from opening a file after the fs_may_remount_ro() check
in do_remount_sb()?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
