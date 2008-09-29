From: jim owens <jowens@hp.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 18:08:55 -0400
Message-ID: <48E151F7.5050408@hp.com>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net> <20080929143749.GA13286@infradead.org> <48E0EA0B.7000701@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37016 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYI2WJC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2008 18:09:02 -0400
In-Reply-To: <48E0EA0B.7000701@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
 > Christoph Hellwig wrote:
 >> But why would the filesystem every unfreeze itself?  That defeats the
 >> whole point of freezing it.
 >
 > I agree.  Was just trying to clarify the above point.
 >
 > But there have been what, 12 submissions now, with the unfreeze timeout
 > in place so it's a persistent theme ;)
 >
 > Perhaps a demonstration of just how easy (or not easy) it is to deadlock
 > a filesystem by freezing the root might be in order, at least.
 >
 > And even if it is relatively easy, I still maintain that it is the
 > administrator's role to not inflict damage on the machine being
 > administered.  There are a lot of potentially dangerous tools at root's
 > disposal; why this particular one needs a nanny I'm still not quite sure.

Since this patch hit fsdev, there have been an equal number
of supporters and opponents of the timeout.

I'm not opposed to the timeout on the API, but I don't think
it is needed if we have a system configurable timeout (default
is no timeout) that can be changed by an admin.

My experience is that a timeout is not needed protect against
a stupid admin or against software bugs.

The justification for a timeout as far as I am concerned
is so the admin can log in and reset hung hardware.  If we
think there is no chance of forcing the external device that
went to sleep to respond so the system can continue to be used,
then I don't think a timeout has any valid use.

My timeout desire is based on some past SAN behavior and
I'm OK if people argue those devices should just be fixed.
But we argued the same thing and were ignored because bad
device behavior did not stop people from buying them.

jim
