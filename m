From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 14:29:49 -0400
Message-ID: <20080521182949.GL8581@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz> <20080521110324.668048e0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080521110324.668048e0.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> 
> afaik there is no need to enable this feature if the machine (actually
> the disks) are on a UPS, yes?

Yes, as long as you're confident that there won't be a kernel
bug/regression causing a lockup while the server is under severe
memory pressure while doing lots of fsync's, file creations, renames,
etc.  And as long as your 100% confident that UPS's will never fail,
janitors will never accidentally hit the Emergency Power Office
switch, and so on.

							- Ted
