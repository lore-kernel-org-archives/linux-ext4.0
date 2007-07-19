From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Date: Wed, 18 Jul 2007 20:41:55 -0700
Message-ID: <20070719034155.GE32734@ca-server1.us.oracle.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com,
	dgc@sgi.com, michael.kerrisk@gmx.net
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070713184625.GB12156@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 14, 2007 at 12:16:25AM +0530, Amit K. Arora wrote:
> After a successful call, subsequent writes are guaranteed not to fail because
> of lack of disk space.
  
If a write to an unwritten region requires a node split, that could result
in the allocation of new meta data which obviously could fail if the disk is
truly full.

Granted that's unlikely to happen but maybe we should be conservative and
say something like:

"After a successful call, subsequent writes are guaranteed to never require
allocation of file data." ?
        --Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
