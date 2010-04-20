From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Tue, 20 Apr 2010 22:40:43 +0100
Message-ID: <20100420214043.GN11723@shareable.org>
References: <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Blunck <jblunck@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:37601 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab0DTVkt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Apr 2010 17:40:49 -0400
Content-Disposition: inline
In-Reply-To: <20100419142315.GA2688@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora wrote:
> On Mon, Apr 19, 2010 at 04:12:48PM +0200, Jan Blunck wrote:
> > On Mon, Apr 19, Jamie Lokier wrote:
> > 
> > > Jan Blunck wrote:
> > > > On Mon, Apr 19, David Woodhouse wrote:
> > > > 
> > > > > On Mon, 2010-04-19 at 14:40 +0200, Jan Blunck wrote:
> > > > > > On Thu, Apr 15, Valerie Aurora wrote:
> > > > > > 
> > > > > > > Add support for fallthru directory entries to ext2.
> > > > > > > 
> > > > > > > XXX - Makes up inode number for fallthru entry
> > > > > > > XXX - Might be better implemented as special symlinks
> > > > > > 
> > > > > > Better not. David Woodhouse actually convinced me of moving away from the
> > > > > > special symlink approach. The whiteouts have been implemented as special
> > > > > > symlinks before.
> > > > > 
> > > > > I certainly asked whether you really need a real 'struct inode' for
> > > > > whiteouts, and suggested that they should be represented _purely_ as a
> > > > > dentry with type DT_WHT.
> > > > > 
> > > > > I don't much like the manifestation of that in this patch though,
> > > > > especially with the made-up inode number. (ISTR I had other
> > > > > jffs2-specific objections too, which I'll dig out and forward).
> > > > 
> > > > Yes, this patches still have issues that Val and me are aware off. I can't
> > > > remember anything jffs2-specific though.
> > > > 
> > > > We return that inode number because we don't want to lookup the name on the
> > > > other filesystem during readdir. Therefore returning DT_UNKNOWN to let the
> > > > userspace decide if it needs to stat the file was the easiest workaround. I
> > > > know that POSIX requires d_ino and d_name but on the other hand it does not
> > > > require anything more on how long d_ino is valid.
> > > 
> > > Although the lifetime of d_ino might very, I know some programs (not
> > > public) that will break if they see a d_ino which is wrongly matching
> > > the st_ino of another file somewhere on the same st_dev.  They will
> > > assume the name is a hard link to the other file, without calling
> > > stat(), which I think is a reasonable assumption and a useful optimisation.
> > > 
> > > So the made-up d_ino should at least be careful to not match an inode
> > > number of another file which has a stable st_ino.
> > > 
> > > Why not zero for d_ino?
> > > 
> > 
> > Hmm, why not. Or even the ino of the directory we are reading from ...
> 
> I don't recall there being any technical reason not to look up the
> real inode number.  I just wrote it that we because I was lazy.  So I
> like returning the directory's d_ino better than a single magic
> number, but I'd at least like to try returning the real inode number
> too.

I thought of zero because Bash and GNU Readline both check d_ino != 0
to decide if an entry is valid.

On reflection, that is why zero must _not_ be used :-)

-- Jamie
