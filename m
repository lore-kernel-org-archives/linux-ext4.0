From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Thu, 9 Oct 2008 06:18:09 -0400
Message-ID: <20081009101809.GA1319@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com>
	<20080908171119.GB22521@infradead.org>
	<48DBFD42.6030307@redhat.com>
	<D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
	<20080929141326.GA31781@infradead.org>
	<48E0E7D4.1090409@sandeen.net>
	<20080929143749.GA13286@infradead.org>
	<48E0EA0B.7000701@sandeen.net>
	<0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com,
	Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Oleg Nesterov <oleg@tv-sign.ru>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
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

On Thu, Oct 09, 2008 at 07:12:17PM +0900, Takashi Sato wrote:
> I think we need the timeout for the case someone dirties so much data
> with mmap, hence the freeze process is swapped out and cannot unfreeze.

That is not supposed to happen.  That's why write blocks early on a
frozen filesystem (the shared mmap write path is currently missing the
check, but that's a rather small patch)
