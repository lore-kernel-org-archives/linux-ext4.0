From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
Date: Wed, 3 Dec 2008 21:04:41 +0530
Message-ID: <20081203153441.GD9481@skywalker>
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de> <20081202203315.GA20858@mit.edu> <4935D4C0.7050601@x2a.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jonathan Bastien-Filiatrault <joe@x2a.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:40457 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYLCPgN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 10:36:13 -0500
Content-Disposition: inline
In-Reply-To: <4935D4C0.7050601@x2a.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2008 at 07:37:20PM -0500, Jonathan Bastien-Filiatrault wrote:
> Theodore Tso wrote:
> 
> > Hmm...  really?  Was the error message ENOSPC, or something else?
> >
> I can confirm I get a ENOSPC on open/creat. Here is the relevant output
> from strace touch test:
> 
> open("test", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = -1 ENOSPC (No
> space left on device)
> 

Can you make sure you have the below patch in the kernel.

c001077f4003fa75793bb62979baa6241dd8eb19

commit c001077f4003fa75793bb62979baa6241dd8eb19
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Aug 19 22:19:50 2008 -0400

ext4: Fix bug where we return ENOSPC even though we have plenty of inodes

-aneesh
