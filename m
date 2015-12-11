From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] reflink: more tests
Date: Thu, 10 Dec 2015 16:07:57 -0800
Message-ID: <20151211000757.GA7499@infradead.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
 <20151208062904.21871.30589.stgit@birch.djwong.org>
 <20151210163449.GA15774@infradead.org>
 <20151210191429.GN10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
	fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151210191429.GN10580@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 10, 2015 at 11:14:29AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 10, 2015 at 08:34:49AM -0800, Christoph Hellwig wrote:
> > The new 849 fails reliably on btrfs, which makes me wonder if either
> > the test is doing something wrong, or the btrfs whole file clone
> > behavior is broken, which wouldn't be very reasuring.  I didn't have
> > time to look into why it's failing yet.
> 
> Huh.  Works reliably for /me; could you send me the output from 849?

--- tests/generic/849.out	2015-12-09 15:31:50.492879152 +0000
+++ /root/xfstests/results//generic/849.out.bad	2015-12-11
00:02:25.154347175 +0000
@@ -1,6 +1,7 @@
 QA output created by 849
 Create the original files
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-849/file1
-dc881c004745c49f7f4e9cc766f57bc8  TEST_DIR/test-849/file2
+eb34153e9ed1e774db28cbbe4090a449  TEST_DIR/test-849/file2
 dc881c004745c49f7f4e9cc766f57bc8  TEST_DIR/test-849/file2.chk
 Compare against check files
+file2 and file2.chk do not match
