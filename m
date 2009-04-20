From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Mon, 20 Apr 2009 14:15:14 +0200
Message-ID: <1240229714.6469.33.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com>
	 <1239910921.21233.98.camel@think.oraclecorp.com>
	 <20090417180906.GA8363@amit-x200.pnq.redhat.com>
	 <20090417201342.GF26479@mit.edu>
	 <20090418060312.GA10943@amit-x200.pnq.redhat.com>
	 <1240039701.6298.12.camel@marge.simson.net>
	 <20090419062448.GA13272@amit-x200.pnq.redhat.com>
	 <1240218437.7005.27.camel@marge.simson.net>
	 <20090420092604.GB14699@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amit Shah <amit.shah@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50203 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754918AbZDTMPV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 08:15:21 -0400
In-Reply-To: <20090420092604.GB14699@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-04-20 at 11:26 +0200, Jan Kara wrote:
> On Mon 20-04-09 11:07:17, Mike Galbraith wrote:
> > All journal modes seem subject to bad throughput under heavy pressu=
re,
> > though data=3Dordered seems much less likely to suffer for some rea=
son.
> > Major difference _seems_ to be that write()+largefile induces very =
much
> > swap activity.

>   My rough guess is that this depends on the VM writeout behavior. In
> ordered mode, we forcibly writeout all the dirty data on a transactio=
n
> commit which happens every 5 seconds so they don't accumulate that mu=
ch.

Aha.

> In other journaling modes we don't do that and decisions about writeo=
ut
> (probably how much pdflush manages to write in background vs. how muc=
h
> VM throttles the process to do the writeback itself) cause variances =
in
> the run time. But this is just a guess. You could gather blktraces of
> slow and fast runs and then look if the amount of IO done by differen=
t
> processes significantly differs. If Chris has merged by improvements =
to
> Seekwatcher, then you could nicely visualize this (hmm, that doesn't =
seem
> to be the case so I'm attaching the diff and a helper script - see co=
mments
> in the beginning of the script and command helps for usage).

Not necessary methinks.  Actually _reading_ the proggy instead of just
glancing at it...

@@ -178,7 +178,7 @@ int do_write_chunks(char *target, int *f
        unsigned long long remain =3D len;
        char *zeros;

-       zeros =3D calloc(1, len);
+       zeros =3D calloc(1, data);
=EF=BB=BF
I assume that was a booboo.=20

	-Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
