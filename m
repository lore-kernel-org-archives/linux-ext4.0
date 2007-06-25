From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Mon, 25 Jun 2007 15:52:39 -0600
Message-ID: <20070625215239.GK5181@schatzie.adilger.int>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756820AbXFYVw4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070625134500.GE1951@amitarora.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 25, 2007  19:15 +0530, Amit K. Arora wrote:
> +#define FA_FL_DEALLOC	0x01 /* default is allocate */
> +#define FA_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
> +#define FA_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */

In XFS one of the (many) ALLOC modes is to zero existing data on allocate.
For ext4 all this would mean is calling ext4_ext_mark_uninitialized() on
each extent.  For some workloads this would be much faster than truncate
and reallocate of all the blocks in a file.

In that light, please change the comment to /* default is keep existing data */
so that it doesn't imply this is only for DEALLOC.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
