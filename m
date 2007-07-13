From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6][TAKE7] manpage for fallocate
Date: Fri, 13 Jul 2007 19:57:23 +0530
Message-ID: <20070713142723.GC27291@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070713140651.GO31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	michael.kerrisk@gmx.net, tytso@mit.edu, cmm@us.ibm.com,
	suparna@in.ibm.com, adilger@clusterfs.com
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:44085 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbXGMO1R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 10:27:17 -0400
Content-Disposition: inline
In-Reply-To: <20070713140651.GO31489@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 14, 2007 at 12:06:51AM +1000, David Chinner wrote:
> On Fri, Jul 13, 2007 at 06:16:01PM +0530, Amit K. Arora wrote:
> > Following is the modified version of the manpage originally submitted by
> > David Chinner. Please use `nroff -man fallocate.2 | less` to view.
> > 
> > This includes changes suggested by Heikki Orsila and Barry Naujok.
> 
> Can we get itemised change logs for all these patches from now on?

Sure.
 
> > .TH fallocate 2
> > .SH NAME
> > fallocate \- allocate or remove file space
> 
> If fallocate is just being used for allocating space this is wrong.
> maybe - "manipulate file space" instead?

Yes, it needs to be changed.
 
> dd> .TP
> > .B FALLOC_RESV_SPACE
> > provides the same functionality as
> > .B FALLOC_ALLOCATE
> > except it does not ever change the file size. This allows allocation
> > of zero blocks beyond the end of file and is useful for optimising
> 
> "of zeroed blocks"

Ok.

--
Regards,
Amit Arora

> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
