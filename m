From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH] ext3/4: fix uninitialized bs in
 ext3/4_xattr_set_handle()
Date: Wed, 14 May 2008 15:54:30 -0700
Message-ID: <20080514155430.a6b7da8f.akpm@linux-foundation.org>
References: <4827B878.50903@oracle.com>
	<20080512170254.f79fe869.akpm@linux-foundation.org>
	<4828FD68.40608@oracle.com>
	<200805141256.43272.agruen@suse.de>
	<20080514160035.GD28594@kroah.com>
	<20080514102809.3fc190f0.akpm@linux-foundation.org>
	<20080514223003.GJ7054@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: greg@kroah.com, agruen@suse.de, tiger.yang@oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080514223003.GJ7054@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 14 May 2008 18:30:03 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, May 14, 2008 at 10:28:09AM -0700, Andrew Morton wrote:
> > 
> > It's in -mm and I just added the "Cc:stable" tag to it.
> 
> This patch has both ext3 and ext4 changes in it, so Andrew, I'm
> assuming that you'll push it directly to Linus in the near future?

Yes, today.

> That's why I didn't suck it into the ext4 tree....

Yup.  Usually I have to split these things up but this time I decided
to leave it as a single patch.  Not sure why, really.
