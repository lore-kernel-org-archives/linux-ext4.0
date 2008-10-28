From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Implement generic freeze feature
Date: Mon, 27 Oct 2008 23:15:33 -0700
Message-ID: <20081027231533.96c42a78.akpm@linux-foundation.org>
References: <20081027215855t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081027215855t-sato@mail.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 27 Oct 2008 21:58:54 +0900 Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> -void thaw_bdev(struct block_device *bdev, struct super_block *sb)
> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  {
> +	int error = 0;
> +
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (!bdev->bd_fsfreeze_count) {
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return -EINVAL;

This would be a programming error, yes?

If so, a WARN_ON is more appropriate than a silent runtime error.

> +	}
