From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Date: Thu, 12 Nov 2015 09:36:35 -0800
Message-ID: <20151112173635.GA9247@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
 <20151112090756.GA25685@infradead.org>
 <20151112125115.GA28822@infradead.org>
 <20151112173427.GC2217@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
	fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112173427.GC2217@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 12, 2015 at 09:34:27AM -0800, Darrick J. Wong wrote:
> Bleargh, _require_*_dedupe forgot to check for ENOTTY output, so all the dedupe
> tests should have _notrun.
> 
> Also, generic/806 was calling the wrong _require.
> 
> I'll start renumbering tests; Christoph, did you see anything else?

Looks fine so far otherwise.
