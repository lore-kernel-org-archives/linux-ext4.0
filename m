From: Christoph Hellwig <hch@lst.de>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been remounted readonly
Date: Tue, 2 Mar 2010 10:34:31 +0100
Message-ID: <20100302093431.GB5106@lst.de>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com> <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com> <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com> <20100222223252.GA13882@atrey.karlin.mff.cuni.cz> <20100222230552.GB13882@atrey.karlin.mff.cuni.cz> <16F918FB-F45D-478E-9358-550BB39E277E@sun.com> <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com> <20100223135531.GA7699@atrey.karlin.mff.cuni.cz> <877hq2tyg8.fsf@openvz.org> <20100224165646.GL3687@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>, hch@lst.de,
	viro@zeniv.linux.org.uk
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40160 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0CBJfZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 04:35:25 -0500
Content-Disposition: inline
In-Reply-To: <20100224165646.GL3687@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 24, 2010 at 05:56:46PM +0100, Jan Kara wrote:
>   OK, I see that in theory a process can open file for writing after
> fs_may_remount_ro() before MS_RDONLY flag gets set. That could be really
> nasty.

Not just in theory, but also in practice.  We can easily hit this under
load with XFS.

> But by no means we should solve this VFS problem by spilling error
> messages from the filesystem.

Exactly.

>   Al, Christoph, do I miss something or there is really nothing which
> prevents a process from opening a file after the fs_may_remount_ro() check
> in do_remount_sb()?

No, there is nothing.  We really do need a multi-stage remount read-only
process:

 1) stop any writes from userland, that is opening new files writeable
 2) stop any periodic writeback from the VM or filesystem-internal
 3) write out all filesystem data and metadata
 4) mark the filesystem fully read-only

