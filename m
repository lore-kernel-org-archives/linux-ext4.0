From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Tue, 12 Mar 2013 12:19:13 -0400
Message-ID: <20130312161913.GA4959@thunk.org>
References: <20130311185423.GA15478@thunk.org>
 <20130311210201.GA940@wallace>
 <20130311212239.GD15478@thunk.org>
 <alpine.LFD.2.00.1303120838170.7128@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1303121020590.7128@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1303121502240.7128@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52881 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706Ab3CLQTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 12:19:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303121502240.7128@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 03:11:23PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> So there is indeed a problem with the mentioned commit
>=20
> 67a5da564f97f31c4054d358e00b34d7ee570da5
>=20
> Due to the bug in that code is has exactly the opposite result -
> with this commit we will _never_ zero out blocks instead of creating
> uninitialized extents. In other words, we will always create
> uninitialized extent.

Whoops.  I even remember how this bug happened.  Originally
max_zeroout was in file system blocks, and it was suggested that we
change this to use units of kilobytes instead.  Unfortunately, this
change wasn't done completely.  :-(

> This can be easily fixed by the following patch (which makes the
> warning go away), but it brings up a question whether this "optimizat=
ion"
> was worth it in the first place since noone noticed that it had exact=
ly
> the opposite effect than it should have had :)

Well, I had noticed that random AIO workloads resulted in the extent
tree getting far more fragmented than I had expected.  (See previous
discusisons about how we really need to improve our ability to merge
empty leaf and index nodes in the extent tree.)

It will be worthwhile to fix this bug and then see how much remains of
extent tree fragmentation problem once this is fixed....

Thanks for the catch!  When you have a chance, could you resend with a
commit description?

> However it still does not resolve the issue completely, because even
> without the zeroout we should have had reserved enough metadata
> blocks to cover the extent split. I still need to investigate
> a little bit further.

Yep, agreed.  Sounds like there is more than one bug hiding here.

     	      	     	  	   	     - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
