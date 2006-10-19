From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem
 corruption
Date: Thu, 19 Oct 2006 11:04:11 -0500
Message-ID: <4537A1FB.6030601@redhat.com>
References: <45369869.60400@redhat.com> <20061018214022.GJ3509@schatzie.adilger.int> <4536A31F.5050604@redhat.com> <20061018222449.GK3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:5334 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1946149AbWJSQET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Oct 2006 12:04:19 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061018222449.GK3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 18, 2006  16:56 -0500, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>> The directory leaf data is kept in
>>> the page cache and there is a helper function ext2_check_page() to mark
>>> the page "checked".  That means the page only needs to be checked once
>>> after being read from disk, instead of each time through readdir.
>> ah, sure.  Hm...  well, this might be a bit of a performance hit if it's
>> checking cached data... let me think on that.
> 
> Well, having something like "ext3_dir_bread()" that verifies the leaf block
> once if (!uptodate()) would be almost the same as ext2 with fairly little
> effort.  It would help performance in several places, at the slight risk
> of not handling in-memory corruption after the block is read...

How about just tweaking the existing ext3_bread so that it lets the
caller know whether or not it found an uptodate buffer?  Seems
conceivable that more than just the dir code might want to do a data
sanity check, based on if this is a fresh read or not.

Could maybe even change the *err argument to a *retval; negative on
errors, else 0 == not read (found uptodate), 1 == fresh read (not found
uptodate).  Or is that too much overloading...

-Eric
