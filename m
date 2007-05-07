From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Date: Mon, 7 May 2007 15:38:56 -0700
Message-ID: <20070507153856.d56a5133.akpm@linux-foundation.org>
References: <20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426181332.GD7209@amitarora.in.ibm.com>
	<20070503213133.d1559f52.akpm@linux-foundation.org>
	<20070507113753.GA5439@schatzie.adilger.int>
	<20070507135825.f8545a65.akpm@linux-foundation.org>
	<20070507222103.GJ8181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966662AbXEGWjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 18:39:40 -0400
In-Reply-To: <20070507222103.GJ8181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 7 May 2007 15:21:04 -0700
Andreas Dilger <adilger@clusterfs.com> wrote:

> On May 07, 2007  13:58 -0700, Andrew Morton wrote:
> > Final point: it's fairly disappointing that the present implementation is
> > ext4-only, and extent-only.  I do think we should be aiming at an ext4
> > bitmap-based implementation and an ext3 implementation.
> 
> Actually, this is a non-issue.  The reason that it is handled for extent-only
> is that this is the only way to allocate space in the filesystem without
> doing the explicit zeroing.  For other filesystems (including ext3 and
> ext4 with block-mapped files) the filesystem should return an error (e.g.
> -EOPNOTSUPP) and glibc will do manual zero-filling of the file in userspace.

hrm, spose so.

It can be a bit suboptimal from the layout POV.  The reservations code will
largely save us here, but kernel support might make it a bit better.

Totally blowing pagecache could be a problem.  Fixable in userspace by
using sync_file_range()+fadvise() or O_DIRECT, but I bet it doesn't.
