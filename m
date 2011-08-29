From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Mon, 29 Aug 2011 21:54:39 +1000
Message-ID: <20110829215439.63353384@kryten>
References: <20110826072622.406d3395@kryten>
	<20110826072927.5b4781f9@kryten>
	<A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger.kernel@dilger.ca, eric.dumazet@gmail.com, tj@kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:56593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1H2Lym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Aug 2011 07:54:42 -0400
In-Reply-To: <A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

> I understand why we would want to reduce this number.
> Unfortunately, the question is what do we do if all 1024 threads try
> to do buffered writes into the file system at the same instant, when
> we have less than 4 megabytes of space left?
>=20
> The problem is that we can then do more writes than we have space, an=
d
> we will only find out about it at write back time, when the process
> may have exited already -- at which point data loss is almost
> inevitable.  (We could keep the data in cache and frantically page
> the system administrator to delete some files to make room for dirty
> data, but that's probably not going to end well=E2=80=A6.)
>=20
> What we can do if we must clamp this threshold is to also increase th=
e
> threshold at which we shift away from delayed allocation.  We'll then
> allocate each block at write time, which does mean more CPU and=20
> less efficient allocation of blocks, but if we're down to our last 4
> megabytes, there's probably not much we can do that will be efficient
> as far as block layout anyway=E2=80=A6.

Thanks for the explanation, I'll go back and take another look.

Anton
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
