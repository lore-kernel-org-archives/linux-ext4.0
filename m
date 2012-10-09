From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] libext2fs: optimize rb_test_bit
Date: Tue, 9 Oct 2012 15:55:00 -0400
Message-ID: <20121009195500.GA17429@thunk.org>
References: <1349408695-11661-1-git-send-email-tytso@mit.edu>
 <1349408695-11661-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1210080952390.25096@localhost>
 <alpine.LFD.2.00.1210081016160.25096@localhost>
 <20121008181753.GA20682@thunk.org>
 <alpine.LFD.2.00.1210090836370.11244@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54737 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2JJIQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2012 04:16:05 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210090836370.11244@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 09, 2012 at 09:18:45AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> So what about this ? It has to be tested to see if it really is as
> effective. Let me know what do you think.

Here is the results of my patches, running e2fsck on an empty 3T file s=
ystem;

Pass 1: Memory used: 672k/32232k (423k/250k), time:  1.15/ 1.14/ 0.00
Pass 2: Memory used: 672k/63692k (423k/250k), time:  0.01/ 0.00/ 0.01
Peak memory: Memory used: 672k/63692k (424k/249k), time:  1.94/ 1.92/ 0=
=2E01
Pass 3A: Memory used: 672k/63692k (423k/250k), time:  0.00/ 0.00/ 0.00
Pass 3: Memory used: 672k/63692k (423k/250k), time:  0.00/ 0.00/ 0.00
Pass 4: Memory used: 672k/772k (422k/251k), time:  3.67/ 3.66/ 0.00
Pass 5: Memory used: 824k/772k (422k/403k), time:  3.83/ 3.82/ 0.00
/mnt/foo.img: 11/201326592 files (0.0% non-contiguous), 12687388/805306=
368 blocks
Memory used: 824k/772k (422k/403k), time:  9.49/ 9.41/ 0.01
9.41user 0.01system 0:09.59elapsed 98%CPU (0avgtext+0avgdata 65636maxre=
sident)k
0inputs+1552outputs (0major+2198minor)pagefaults 0swaps

And here is running e2fsck on a 3T file system with your patches:

Pass 1: Memory used: 672k/32232k (423k/250k), time:  1.20/ 1.19/ 0.01
Pass 2: Memory used: 672k/63692k (423k/250k), time:  0.00/ 0.00/ 0.01
Peak memory: Memory used: 672k/63692k (423k/250k), time:  2.02/ 1.98/ 0=
=2E03
Pass 3A: Memory used: 672k/63692k (423k/250k), time:  0.00/ 0.00/ 0.00
Pass 3: Memory used: 672k/63692k (423k/250k), time:  0.00/ 0.00/ 0.00
Pass 4: Memory used: 672k/772k (422k/251k), time:  5.66/ 5.64/ 0.00
Pass 5: Memory used: 896k/772k (422k/475k), time:  4.04/ 4.02/ 0.01
/mnt/foo.img: 11/201326592 files (0.0% non-contiguous), 12687388/805306=
368 blocks
11.65user 0.04system 0:11.89elapsed 98%CPU (0avgtext+0avgdata 65640maxr=
esident)k
0inputs+1552outputs (0major+1706minor)pagefaults 0swaps


I had tried this approach before, and saw a similar performance
characteristics, so here this didn't come as a huge surprise.

----------------

Here is the results of my patches running e2fsck on a roughly
half-empty file system that holds lots of kernel build trees:

Pass 1: Memory used: 2076k/2780k (1957k/120k), time:  2.78/ 0.95/ 0.15
Pass 2: Memory used: 3528k/2828k (2488k/1041k), time:  2.05/ 0.19/ 0.21
Peak memory: Memory used: 4276k/2828k (3129k/1148k), time:  4.92/ 1.16/=
 0.36
Pass 3A: Memory used: 4276k/2828k (3128k/1149k), time:  0.00/ 0.00/ 0.0=
0
Pass 3: Memory used: 4276k/2596k (2488k/1789k), time:  0.00/ 0.00/ 0.00
Pass 4: Memory used: 4276k/644k (645k/3632k), time:  0.12/ 0.12/ 0.00
Pass 5: Memory used: 4276k/0k (645k/3632k), time:  1.42/ 0.99/ 0.02
kbuild: 204690/5242880 files (1.9% non-contiguous), 9843555/20971520 bl=
ocks
Memory used: 4276k/0k (645k/3632k), time:  6.51/ 2.29/ 0.38
2.29user 0.45system 0:06.60elapsed 41%CPU (0avgtext+0avgdata 8664maxres=
ident)k
329872inputs+56outputs (0major+2511minor)pagefaults 0swaps

Here are the results with your patch:

Pass 1: Memory used: 2080k/2780k (1957k/124k), time:  2.81/ 0.99/ 0.14
Pass 2: Memory used: 3532k/2828k (2487k/1045k), time:  2.10/ 0.21/ 0.22
Peak memory: Memory used: 4276k/2828k (3128k/1149k), time:  5.00/ 1.22/=
 0.37
Pass 3: Memory used: 4276k/2596k (2487k/1790k), time:  0.00/ 0.00/ 0.00
Pass 4: Memory used: 4276k/644k (645k/3632k), time:  0.14/ 0.15/ 0.00
Pass 5: Memory used: 4276k/0k (645k/3632k), time:  1.64/ 1.18/ 0.04
Memory used: 4276k/0k (645k/3632k), time:  6.83/ 2.56/ 0.41
2.57user 0.46system 0:06.91elapsed 43%CPU (0avgtext+0avgdata 8668maxres=
ident)k
329872inputs+56outputs (0major+2512minor)pagefaults 0swaps

----------------

Here are the timing results of e2freefrag on the empty 3T file system
image using my patch:

8.25user 0.01system 0:08.28elapsed 99%CPU (0avgtext+0avgdata 1708maxres=
ident)k
0inputs+0outputs (0major+475minor)pagefaults 0swaps

and here are the results using your patch:

10.27user 0.00system 0:10.30elapsed 99%CPU (0avgtext+0avgdata 1708maxre=
sident)k
0inputs+0outputs (0major+474minor)pagefaults 0swaps


So anyway, that's why I chose the approach I did.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
