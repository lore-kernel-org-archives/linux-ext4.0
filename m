From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Wed, 21 Apr 2010 10:42:11 +0200
Message-ID: <20100421084211.GB22741@bolzano.suse.de>
References: <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Valerie Aurora <vaurora@redhat.com>, dwmw2@infradead.org,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0DUImN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 04:42:13 -0400
Content-Disposition: inline
In-Reply-To: <20100420213450.GM11723@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 20, Jamie Lokier wrote:

> Miklos Szeredi wrote:
> > On Mon, 19 Apr 2010, Valerie Aurora wrote:
> > > I don't recall there being any technical reason not to look up the
> > > real inode number.  I just wrote it that we because I was lazy.  So I
> > > like returning the directory's d_ino better than a single magic
> > > number, but I'd at least like to try returning the real inode number
> > > too.
> > 
> > Note, "struct dirent" doesn't have d_dev, so you really can't return
> > the "real" inode number, that's on a different filesystem and just a
> > random number in the context of the the readdir in question.
> 
> Agree.  Does this inappropriate inode number for the union mount's
> st_dev happen with stat() on the actual files too?  That could be bad.

No, for stat() you do a lookup and that is returning the correct dentry/inode
for the filesystem the name is on.

We just return the the fallthru directory entries to give userspace an offset
that they can seekdir() to.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
