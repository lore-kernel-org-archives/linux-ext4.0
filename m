From: Christoph Hellwig <hch@infradead.org>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Fri, 17 Aug 2012 17:05:27 -0400
Message-ID: <20120817210527.GA22716@infradead.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060110.GA28786@localhost>
 <20120817131558.GA11439@thunk.org>
 <20120817174841.GA4519@infradead.org>
 <20120817203438.GA573@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	ext4 hackers <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56088
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab2HQVF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 17:05:29 -0400
Content-Disposition: inline
In-Reply-To: <20120817203438.GA573@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 17, 2012 at 04:34:38PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 17, 2012 at 01:48:41PM -0400, Christoph Hellwig wrote:
> > 
> > Can you submit this for xfstests?
> > 
> 
> This is actually something I wanted to ask you guys about.  There are
> a series of ext4-specific tests that I could potentially add, but I
> wasn't sure how welcome they would be in xfstests.  Assuming that
> ext4-specific tests would be welcome, is there a number range for
> these ext4-specific tests that I should use?

Dave actually has an outstanding series to move tests from the toplevel
directory to directories for categories.  We already have a lot of
btrfs-specific tests that have a separate directory, as well as xfs
specific ones, ext4 would just follow this model.  For this specific
test it actually seems fairly generic except for the commit interval,
so I'd love to run it for all filesystems, just setting the interval for
ext4.

> BTW, we have an extension to xfstests that we've been using inside
> Google where Google-internal tests have a "g" prefix (i.e., g001,
> g002, etc.).  That way we didn't need to worry about conflicts between
> newly added upstream xfstests, and ones which were added internally.
> Would it make sense to start using some kind of prefix such as "e001"
> for ext2/3/4 specific tests?

Can you take a look at Dave's series if that helps you?  I haven't
really reviewed it much myself yet, but I'll try to get to it ASAP.

