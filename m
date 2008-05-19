From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Mon, 19 May 2008 10:46:54 -0400
Message-ID: <20080519144654.GC15035@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org> <200805190926.41970.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jamie@shareable.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40495 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbYESOtt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2008 10:49:49 -0400
Content-Disposition: inline
In-Reply-To: <200805190926.41970.chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 19, 2008 at 09:26:41AM -0400, Chris Mason wrote:
> >
> > Didn't ext4 have some new checksum trick to avoid them?
> 
> I didn't think checksumming avoided barriers completely.  Just the barrier 
> before the commit block, not the barrier after.

Funny thing, I was looking in this over the weekend.  It currently
avoids barriers entirely if journal_async_commit is enabled (which is
not the default); if enabled, it effectively forces barrier=0.  This
is IMHO a bug.

I'm working on a patch where "barrier=1" will use a barrier before and
after, and "barrier=1,journal_async_commit" will use a barrier after.

       	   				    	     - Ted
