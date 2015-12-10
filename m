From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] reflink: more tests
Date: Thu, 10 Dec 2015 11:14:29 -0800
Message-ID: <20151210191429.GN10580@birch.djwong.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
 <20151208062904.21871.30589.stgit@birch.djwong.org>
 <20151210163449.GA15774@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
	tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
	Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151210163449.GA15774@infradead.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 10, 2015 at 08:34:49AM -0800, Christoph Hellwig wrote:
> The new 849 fails reliably on btrfs, which makes me wonder if either
> the test is doing something wrong, or the btrfs whole file clone
> behavior is broken, which wouldn't be very reasuring.  I didn't have
> time to look into why it's failing yet.

Huh.  Works reliably for /me; could you send me the output from 849?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
