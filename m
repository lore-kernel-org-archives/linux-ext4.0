From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 09:36:04 -0500
Message-ID: <48E0E7D4.1090409@sandeen.net>
References: <20080908205337t-sato@mail.jp.nec.com>
	<20080908171119.GB22521@infradead.org>
	<48DBFD42.6030307@redhat.com>
	<D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
	<20080929141326.GA31781@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, Takashi Sato <t-sato@yk.jp.nec.com>,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080929141326.GA31781@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
>> I think that your concern is that the freezer cannot recognize the occurrence
>> of a timeout and it continues the backup process and the backup data is
>> corrupted finally.
> 
> What timeout should happen?  the freeze ioctl must not return until the
> filesystem is a clean state and all writes are blocked.

The suggestion was that *UN*freeze would return ETIMEDOUT if the
filesystem had already unfrozen itself, I think.  That way you know that
the snapshot you just took is worthless, at least.

I'm still not really sold on the timeout, but I think the above was the
intent.

-Eric
