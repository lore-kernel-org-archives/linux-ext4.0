From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 08:32:55 -0400
Message-ID: <20080521123255.GG8581@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080521112224.GD5028@ucw.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 21, 2008 at 01:22:25PM +0200, Pavel Machek wrote:
> 
> Ok, Andrew, is this enough to get barrier patch applied and stop
> corrupting data in default config, or do you want some more testing?

It is for me; I think we have to enable barriers for ext3/4, and then
work to improve the overhead in ext4/jbd2.  It's probably true that
the vast majority of systems don't run under conditions similar to
what Chris used to demonstrate the problem, but the default has to be
filesystem safety.  People who are sure they are extremely unlikely to
run into this problem can turn barriers off (and I suspect they won't
see that much difference in the most common workloads anyway).

    	      		    	     - Ted
