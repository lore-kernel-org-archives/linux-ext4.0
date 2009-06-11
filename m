From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 preallocation corruption with truncate
Date: Wed, 10 Jun 2009 20:17:29 -0400
Message-ID: <20090611001729.GA7170@mit.edu>
References: <1244676537.5256.27.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sandeen@redhat.com
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50327 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018AbZFKARg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2009 20:17:36 -0400
Content-Disposition: inline
In-Reply-To: <1244676537.5256.27.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2009 at 04:28:57PM -0700, Mingming wrote:
> We have seen data lost issue after a file being preallocated, write,
> then truncated. 
> 
> Ted could we send this fix to stable asap? Thanks.

Aneesh had already sent this patch to linux-ext4, and I've already
sent a pull request of all of the accumulated ext4 fixes to Linus.
Once Linus pulls it into mainline, I'll assemble the set of fixes that
that need to go to stable, and send it off to stable@kernel.org.

						- Ted
