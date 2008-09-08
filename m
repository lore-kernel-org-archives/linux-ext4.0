From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 8 Sep 2008 13:11:19 -0400
Message-ID: <20080908171119.GB22521@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754969AbYIHRLj@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080908205337t-sato@mail.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
> The timeout feature is added to "freeze ioctl" to solve a deadlock
> when the freezer accesses a frozen filesystem. And new ioctl
> to reset the timeout period is added to extend the timeout period.
> For example, the freezer resets the timeout period to 10 seconds every 5
> seconds.  In this approach, even if the freezer causes a deadlock by
> accessing the frozen filesystem, it will be solved by the timeout
> in 10 seconds and the freezer will be able to recognize that
> at the next reset of timeout period.

And as with all previous posting I still fundamentally disagree about
the need of this functionality.  We don't need a timeout for freezing.
