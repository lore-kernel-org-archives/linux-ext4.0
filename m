From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Mon, 19 Apr 2010 14:30:28 +0100
Message-ID: <20100419133028.GA3631@shareable.org>
References: <1271372682-21225-8-git-send-email-vaurora@redhat.com> <1271372682-21225-9-git-send-email-vaurora@redhat.com> <1271372682-21225-10-git-send-email-vaurora@redhat.com> <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Woodhouse <dwmw2@infradead.org>,
	Valerie Aurora <vaurora@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:56950 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0DSNal (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 09:30:41 -0400
Content-Disposition: inline
In-Reply-To: <20100419132344.GI10776@bolzano.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Blunck wrote:
> On Mon, Apr 19, David Woodhouse wrote:
> 
> > On Mon, 2010-04-19 at 14:40 +0200, Jan Blunck wrote:
> > > On Thu, Apr 15, Valerie Aurora wrote:
> > > 
> > > > Add support for fallthru directory entries to ext2.
> > > > 
> > > > XXX - Makes up inode number for fallthru entry
> > > > XXX - Might be better implemented as special symlinks
> > > 
> > > Better not. David Woodhouse actually convinced me of moving away from the
> > > special symlink approach. The whiteouts have been implemented as special
> > > symlinks before.
> > 
> > I certainly asked whether you really need a real 'struct inode' for
> > whiteouts, and suggested that they should be represented _purely_ as a
> > dentry with type DT_WHT.
> > 
> > I don't much like the manifestation of that in this patch though,
> > especially with the made-up inode number. (ISTR I had other
> > jffs2-specific objections too, which I'll dig out and forward).
> 
> Yes, this patches still have issues that Val and me are aware off. I can't
> remember anything jffs2-specific though.
> 
> We return that inode number because we don't want to lookup the name on the
> other filesystem during readdir. Therefore returning DT_UNKNOWN to let the
> userspace decide if it needs to stat the file was the easiest workaround. I
> know that POSIX requires d_ino and d_name but on the other hand it does not
> require anything more on how long d_ino is valid.

Although the lifetime of d_ino might very, I know some programs (not
public) that will break if they see a d_ino which is wrongly matching
the st_ino of another file somewhere on the same st_dev.  They will
assume the name is a hard link to the other file, without calling
stat(), which I think is a reasonable assumption and a useful optimisation.

So the made-up d_ino should at least be careful to not match an inode
number of another file which has a stable st_ino.

Why not zero for d_ino?

-- Jamie

