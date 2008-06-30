From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Sun, 29 Jun 2008 17:01:52 -0700
Message-ID: <20080629170152.aa769918.akpm@linux-foundation.org>
References: <20080624160056t-sato@mail.jp.nec.com>
	<20080624150925.765155f0.akpm@linux-foundation.org>
	<7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp>
	<20080627115727.149dcb2e.akpm@linux-foundation.org>
	<C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Takashi Sato" <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
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

On Mon, 30 Jun 2008 08:13:07 +0900 "Takashi Sato" <t-sato@yk.jp.nec.com> wrote:

> > It's much better to use NULL here rather than literal zero because the
> > reader of this code can then say "ah-hah, we're passing in a pointer". 
> > Whereas plain old "0" could be a pointer or a scalar.
> 
> The second argument's type of freeze_bdev() is "long", not pointer as below.
> struct super_block *freeze_bdev(struct block_device *, long timeout_msec);

oh, ok, I goofed, sorry.

> So "0" is reasonable, isn't it?

yup.
