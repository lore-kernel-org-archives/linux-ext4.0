From: Florian Weimer <fweimer@bfk.de>
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe width, writes in storage
Date: Thu, 03 Sep 2009 14:26:55 +0000
Message-ID: <823a74w1cg.fsf@mid.bfk.de>
References: <20090828064449.GA27528@elf.ucw.cz>
	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>
	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>
	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com>
	<m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755625AbZICO2k@vger.kernel.org>
In-Reply-To: <4A9FCF6B.1080704@redhat.com> (Ric Wheeler's message of "Thu\, 03 Sep 2009 10\:15\:07 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

* Ric Wheeler:

> Note that even without MD raid, the file system issues IO's in file
> system block size (4096 bytes normally) and most commodity storage
> devices use a 512  byte sector size which means that we have to updat=
e
> 8 512b sectors.

Database software often attempts to deal with this phenomenon
(sometimes called "torn page writes").  For example, you can make sure
that the first time you write to a database page, you keep a full copy
in your transaction log.  If the machine crashes, the log is replayed,
first completely overwriting the partially-written page.  Only after
that, you can perform logical/incremental logging.

The log itself has to be protected with a different mechanism, so that
you don't try to replay bad data.  But you haven't comitted to this
data yet, so it is fine to skip bad records.

Therefore, sub-page corruption is a fundamentally different issue from
super-page corruption.

BTW, older textbooks will tell you that mirroring requires that you
read from two copies of the data and compare it (and have some sort of
tie breaker if you need availability).  And you also have to re-read
data you've just written to disk, to make sure it's actually there and
hit the expected sectors.  We can't even do this anymore, thanks to
disk caches.  And it doesn't seem to be necessary in most cases.

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
