From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Date: Mon, 7 May 2007 15:21:04 -0700
Message-ID: <20070507222103.GJ8181@schatzie.adilger.int>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070507135825.f8545a65.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 07, 2007  13:58 -0700, Andrew Morton wrote:
> Final point: it's fairly disappointing that the present implementation is
> ext4-only, and extent-only.  I do think we should be aiming at an ext4
> bitmap-based implementation and an ext3 implementation.

Actually, this is a non-issue.  The reason that it is handled for extent-only
is that this is the only way to allocate space in the filesystem without
doing the explicit zeroing.  For other filesystems (including ext3 and
ext4 with block-mapped files) the filesystem should return an error (e.g.
-EOPNOTSUPP) and glibc will do manual zero-filling of the file in userspace.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

