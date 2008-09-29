From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 09:45:31 -0500
Message-ID: <48E0EA0B.7000701@sandeen.net>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net> <20080929143749.GA13286@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Takashi Sato <t-sato@yk.jp.nec.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:14066 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYI2Opd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Sep 2008 10:45:33 -0400
In-Reply-To: <20080929143749.GA13286@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Sep 29, 2008 at 09:36:04AM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
>>>> I think that your concern is that the freezer cannot recognize the occurrence
>>>> of a timeout and it continues the backup process and the backup data is
>>>> corrupted finally.
>>> What timeout should happen?  the freeze ioctl must not return until the
>>> filesystem is a clean state and all writes are blocked.
>> The suggestion was that *UN*freeze would return ETIMEDOUT if the
>> filesystem had already unfrozen itself, I think.  That way you know that
>> the snapshot you just took is worthless, at least.
> 
> But why would the filesystem every unfreeze itself?  That defeats the
> whole point of freezing it.

I agree.  Was just trying to clarify the above point.

But there have been what, 12 submissions now, with the unfreeze timeout
in place so it's a persistent theme ;)

Perhaps a demonstration of just how easy (or not easy) it is to deadlock
a filesystem by freezing the root might be in order, at least.

And even if it is relatively easy, I still maintain that it is the
administrator's role to not inflict damage on the machine being
administered.  There are a lot of potentially dangerous tools at root's
disposal; why this particular one needs a nanny I'm still not quite sure.

-Eric
