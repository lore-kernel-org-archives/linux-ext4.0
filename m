From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Mon, 19 Apr 2010 16:53:22 +0200
Message-ID: <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu>
References: <1271372682-21225-10-git-send-email-vaurora@redhat.com> <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell>
Cc: jblunck@suse.de, jamie@shareable.org, dwmw2@infradead.org,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20100419142315.GA2688@shell> (message from Valerie Aurora on
	Mon, 19 Apr 2010 10:23:15 -0400)
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 19 Apr 2010, Valerie Aurora wrote:
> I don't recall there being any technical reason not to look up the
> real inode number.  I just wrote it that we because I was lazy.  So I
> like returning the directory's d_ino better than a single magic
> number, but I'd at least like to try returning the real inode number
> too.

Note, "struct dirent" doesn't have d_dev, so you really can't return
the "real" inode number, that's on a different filesystem and just a
random number in the context of the the readdir in question.

Thanks,
Miklos
