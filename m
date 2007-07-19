From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Date: Thu, 19 Jul 2007 17:58:25 -0600
Message-ID: <20070719235825.GY5992@schatzie.adilger.int>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com> <20070719034155.GE32734@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, dgc@sgi.com,
	michael.kerrisk@gmx.net
To: Mark Fasheh <mark.fasheh@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070719034155.GE32734@ca-server1.us.oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 18, 2007  20:41 -0700, Mark Fasheh wrote:
> On Sat, Jul 14, 2007 at 12:16:25AM +0530, Amit K. Arora wrote:
> > After a successful call, subsequent writes are guaranteed not to fail
> > because of lack of disk space.
>   
> If a write to an unwritten region requires a node split, that could result
> in the allocation of new meta data which obviously could fail if the disk is
> truly full.
> 
> Granted that's unlikely to happen but maybe we should be conservative and
> say something like:
> 
> "After a successful call, subsequent writes are guaranteed to never require
> allocation of file data." ?
>         --Mark

In the worst case, the unwritten extent could be zero-filled before the write
is done, so no exent split is needed.  We discussed this recently for the
ext4 fallocate, but didn't consider it important enough to hold the code.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

