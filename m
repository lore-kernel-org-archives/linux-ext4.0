From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Thu, 19 Aug 2010 11:03:20 +0900
Message-ID: <17214.1282183400@jrobl>
References: <eVJmW-3Lf-15@gated-at.bofh.it> <eVJmW-3Lf-19@gated-at.bofh.it> <fdNs6-5F1-7@gated-at.bofh.it> <fdVfY-pv-23@gated-at.bofh.it> <fe6Ep-cD-13@gated-at.bofh.it> <fiCPo-73x-17@gated-at.bofh.it> <fiMc1-6ip-7@gated-at.bofh.it> <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz, agruen@suse.de,
	viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>
To: 7eggert@gmx.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Bodo Eggert:
> Do a hardlink if you can create a hard link, otherwise use a fresh inode
> and use that for the next hardlink(s).

Exactly.
That's the approach aufs takes for whiteout and its brothers.


J. R. Okajima
