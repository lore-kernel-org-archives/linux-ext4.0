From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Date: Thu, 12 Nov 2015 04:51:15 -0800
Message-ID: <20151112125115.GA28822@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
 <20151112090756.GA25685@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
	tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
	Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112090756.GA25685@infradead.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 12, 2015 at 01:07:56AM -0800, Christoph Hellwig wrote:
> Looks fine:
> 
> Acked-by: Christoph Hellwig <hch@lst.de>

Actually I take this back.  I had though this was the existing series
with my fixes, but this one still incorrectly assumes that if reflink
works dedup works as well, leading to lots of false failures on nfs.
