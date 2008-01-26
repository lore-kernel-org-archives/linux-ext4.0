From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch for 2.6.25 queue
Date: Sat, 26 Jan 2008 12:14:31 -0500
Message-ID: <20080126171431.GC13231@mit.edu>
References: <20080126113849.GA18602@skywalker> <20080126170331.GB13231@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Y Tso <theotso@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51993 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752995AbYAZRO7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 12:14:59 -0500
Content-Disposition: inline
In-Reply-To: <20080126170331.GB13231@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 26, 2008 at 12:03:31PM -0500, Theodore Tso wrote:
> This patch hunk causes a failure due to a botched brelse->put_bh
> conversion, but removing it isn't the right fix.

Err, sorry, the above should read, "This patch hunk FIXES a failure"...

and if it wasn't clear, I was responsible for the initial botched
conversion.  :-)

       	  	 	      		      - Ted
