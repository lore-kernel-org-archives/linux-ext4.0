From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] nowait aio: Return if cannot get hold of i_rwsem
Date: Wed, 1 Mar 2017 07:37:07 -0800
Message-ID: <20170301153707.GB30631@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-3-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170228233610.25456-3-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
