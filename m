Return-Path: <SRS0=k8Ev=N4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729750AbeKQM5n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 17 Nov 2018 07:57:43 -0500
Date: Sat, 17 Nov 2018 10:42:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 00/19] block: support multi-page bvec
Message-ID: <20181117024209.GD8872@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181116140314.GA7735@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116140314.GA7735@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 16, 2018 at 03:03:14PM +0100, Christoph Hellwig wrote:
> It seems like bi_phys_segments is still around of this series.
> Shouldn't it be superflous now?

Even though multi-page bvec is supported, the segment number doesn't
equal to the actual bvec count yet, for example, one bvec may be too
bigger to be held in one single segment.


Thanks,
Ming
