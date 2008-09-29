From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 10:37:49 -0400
Message-ID: <20080929143749.GA13286@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48E0E7D4.1090409@sandeen.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 29, 2008 at 09:36:04AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
> >> I think that your concern is that the freezer cannot recognize the occurrence
> >> of a timeout and it continues the backup process and the backup data is
> >> corrupted finally.
> > 
> > What timeout should happen?  the freeze ioctl must not return until the
> > filesystem is a clean state and all writes are blocked.
> 
> The suggestion was that *UN*freeze would return ETIMEDOUT if the
> filesystem had already unfrozen itself, I think.  That way you know that
> the snapshot you just took is worthless, at least.

But why would the filesystem every unfreeze itself?  That defeats the
whole point of freezing it.

