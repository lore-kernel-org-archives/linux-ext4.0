From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] reflink: more tests
Date: Thu, 10 Dec 2015 08:34:49 -0800
Message-ID: <20151210163449.GA15774@infradead.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
 <20151208062904.21871.30589.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
	hch@infradead.org, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151208062904.21871.30589.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The new 849 fails reliably on btrfs, which makes me wonder if either
the test is doing something wrong, or the btrfs whole file clone
behavior is broken, which wouldn't be very reasuring.  I didn't have
time to look into why it's failing yet.
