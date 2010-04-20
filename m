From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Tue, 20 Apr 2010 22:34:50 +0100
Message-ID: <20100420213450.GM11723@shareable.org>
References: <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Aurora <vaurora@redhat.com>, jblunck@suse.de,
	dwmw2@infradead.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:56600 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab0DTVfK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Apr 2010 17:35:10 -0400
Content-Disposition: inline
In-Reply-To: <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Miklos Szeredi wrote:
> On Mon, 19 Apr 2010, Valerie Aurora wrote:
> > I don't recall there being any technical reason not to look up the
> > real inode number.  I just wrote it that we because I was lazy.  So I
> > like returning the directory's d_ino better than a single magic
> > number, but I'd at least like to try returning the real inode number
> > too.
> 
> Note, "struct dirent" doesn't have d_dev, so you really can't return
> the "real" inode number, that's on a different filesystem and just a
> random number in the context of the the readdir in question.

Agree.  Does this inappropriate inode number for the union mount's
st_dev happen with stat() on the actual files too?  That could be bad.

-- Jamie
