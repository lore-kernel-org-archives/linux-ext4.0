From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
 Hole Test Routines
Date: Wed, 18 May 2011 18:41:51 -0700
Message-ID: <20110519014149.GA11278@noexit.corp.google.com>
References: <4DD43300.6010908@linux.vnet.ibm.com>
 <20110519013144.GF32466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35230 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1ESBml (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 21:42:41 -0400
Content-Disposition: inline
In-Reply-To: <20110519013144.GF32466@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 19, 2011 at 11:31:44AM +1000, Dave Chinner wrote:
> > +#
> > +# This test is successful when the following conditions are met:
> > +#  - ls shows that the number of blocks occupied by the file
> > +#    has decreased by the number of blocks punched out.
> 
> There's no guarantee that a filesystem will punch the number of
> blocks you expect.

	Cluster allocated filesystems like ocfs2 are certainly going to
punch some multiple of clusters, not exact blocks.  Eg if the hole is
punched in the middle of a cluster.

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

			http://www.jlbec.org/
			jlbec@evilplan.org
