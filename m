From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Wed, 13 Mar 2013 16:43:18 +0800
Message-ID: <20130313084318.GA11553@gmail.com>
References: <20130311185423.GA15478@thunk.org>
 <20130311210201.GA940@wallace>
 <20130311212239.GD15478@thunk.org>
 <alpine.LFD.2.00.1303120838170.7128@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1303121020590.7128@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1303121502240.7128@dhcp-1-104.brq.redhat.com>
 <20130312161913.GA4959@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42964 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3CMI17 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2013 04:27:59 -0400
Received: by mail-pb0-f47.google.com with SMTP id rp2so784060pbb.34
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 01:27:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130312161913.GA4959@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 12:19:13PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 12, 2013 at 03:11:23PM +0100, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > So there is indeed a problem with the mentioned commit
> >=20
> > 67a5da564f97f31c4054d358e00b34d7ee570da5
> >=20
> > Due to the bug in that code is has exactly the opposite result -
> > with this commit we will _never_ zero out blocks instead of creatin=
g
> > uninitialized extents. In other words, we will always create
> > uninitialized extent.
>=20
> Whoops.  I even remember how this bug happened.  Originally
> max_zeroout was in file system blocks, and it was suggested that we
> change this to use units of kilobytes instead.  Unfortunately, this
> change wasn't done completely.  :-(
>=20
> > This can be easily fixed by the following patch (which makes the
> > warning go away), but it brings up a question whether this "optimiz=
ation"
> > was worth it in the first place since noone noticed that it had exa=
ctly
> > the opposite effect than it should have had :)
>=20
> Well, I had noticed that random AIO workloads resulted in the extent
> tree getting far more fragmented than I had expected.  (See previous
> discusisons about how we really need to improve our ability to merge
> empty leaf and index nodes in the extent tree.)

Agree, we could do better in merging extent tree.  I will take a look a=
t
it, but, sorry, my plate is too full recently.  So it has a low priorit=
y.

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
