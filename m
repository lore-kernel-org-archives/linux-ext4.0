From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Date: Thu, 12 Nov 2015 01:07:56 -0800
Message-ID: <20151112090756.GA25685@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hch@infradead.org, david@fromorbit.com, fstests@vger.kernel.org,
	xfs@oss.sgi.com, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151111192628.15056.6451.stgit@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Looks fine:

Acked-by: Christoph Hellwig <hch@lst.de>

some of the free block range stuff might need minor fixups for certain
file systems later, but I'd rather do this once all the patches are
merged.
