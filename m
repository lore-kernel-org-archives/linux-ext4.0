From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Wed, 11 Jul 2007 10:05:16 +0100
Message-ID: <20070711090516.GC18301@infradead.org>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070701225543.GW31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	xfs@oss.sgi.com
To: David Chinner <dgc@sgi.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761828AbXGKJFk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070701225543.GW31489@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 02, 2007 at 08:55:43AM +1000, David Chinner wrote:
> Given the current behaviour for posix_fallocate() in glibc, I think
> that retaining the same error semantic and punting the cleanup to
> userspace (where the app will fail with ENOSPC anyway) is the only
> sane thing we can do here. Trying to undo this in the kernel leads
> to lots of extra rarely used code in error handling paths...

Agreed, looks like we should stay with the user has to clean up behaviour.
