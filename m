From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Thu, 22 Apr 2010 19:30:55 +0900
Message-ID: <1731.1271932255@jrobl>
References: <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de> <20100421092235.GB13114@shareable.org>
Cc: Jan Blunck <jblunck@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
	Valerie Aurora <vaurora@redhat.com>, dwmw2@infradead.org,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100421092235.GB13114@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Jamie Lokier:
> Hmm.  I smell potential confusion for some otherwise POSIX-friendly
> userspaces.
	:::
> This plays into inotify, where you have to know if you are monitoring
> every directory that contains a link to a file, to know if you need to
> monitor the file itself directly instead.

Addition to the inode number of fallthru/readdir, hardlink in union
mount may be a problem. If you open a hardlinked file for writing or
try chmod it, the internal copyup will happen and the hardlink will be 
destroyed. For instance, when fileA and fileB are hardlinked on the
lower layer, and the contents of fileA is modifed (copyup happens). You
will not see the latest contents via fileB.
And the IN_CREATE event may be fired to the parent dir if you monitor
it, I am afraid.

(I have pointed out this issue before, but the posted document didn't
seem to contain about it)


J. R. Okajima
