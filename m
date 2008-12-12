From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't overwrite allocation_context ac_status
Date: Fri, 12 Dec 2008 12:59:22 -0500
Message-ID: <20081212175922.GC26085@mit.edu>
References: <1228914463-12716-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47231 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756760AbYLLR71 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 12:59:27 -0500
Content-Disposition: inline
In-Reply-To: <1228914463-12716-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 10, 2008 at 06:37:43PM +0530, Aneesh Kumar K.V wrote:
> We can call ext4_mb_check_limits even after successfull
> allocation. Make sure we don't overwrite ac_status.
> This fix the below lockdep warning

So the ext4_mb_check_limits() function isn't that well documented, but
one of the things it is supposed to do is to make sure that blocks
comprising the extent that was found is in fact still available.  This
check patches this out.   Are we sure this does the right thing?

      	      	   	      	      - Ted
