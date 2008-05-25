From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Sun, 25 May 2008 15:32:11 -0400
Message-ID: <20080525193211.GA24328@infradead.org>
References: <20080522175020t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080522175020t-sato@mail.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> +	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
> +		return ERR_PTR(-EBUSY);
> +
> +	sb = get_super_without_lock(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		put_super(sb);
> +		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +		return sb;
> +	}

The BD_FREEZE_OP flag in the block_device already prevents multiple
freezes for a singe block device, so there is no need for this
additional check and the get_super_without_lock helper.

>  	down(&bdev->bd_mount_sem);

And with that flag bd_mount_sem is also obsolete for preventing the
multiple freeze operations.  We still need investigate what
synchronization we need vs unmount which also takes bd_mount_sem without
every having document what it exactly protects.

