From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem
 corruption
Date: Thu, 19 Oct 2006 17:43:35 -0500
Message-ID: <4537FF97.2010400@redhat.com>
References: <45369869.60400@redhat.com> <20061018214022.GJ3509@schatzie.adilger.int> <4536A31F.5050604@redhat.com> <20061018222449.GK3509@schatzie.adilger.int> <4537A1FB.6030601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28842 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1946603AbWJSWno (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Oct 2006 18:43:44 -0400
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <4537A1FB.6030601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
>> Well, having something like "ext3_dir_bread()" that verifies the leaf block
>> once if (!uptodate()) would be almost the same as ext2 with fairly little
>> effort.  It would help performance in several places, at the slight risk
>> of not handling in-memory corruption after the block is read...
> 
> How about just tweaking the existing ext3_bread so that it lets the
> caller know whether or not it found an uptodate buffer?  Seems
> conceivable that more than just the dir code might want to do a data
> sanity check, based on if this is a fresh read or not.
> 
> Could maybe even change the *err argument to a *retval; negative on
> errors, else 0 == not read (found uptodate), 1 == fresh read (not found
> uptodate).  Or is that too much overloading...

I played around with this a little bit today, and it seems to have some
tangible results.  A fairly unsophisticated test of running "find" over
my whole root filesystem 10 times :) with and without re-checking cached
directory entries, yielded about a 10% speedup when skipping the re-checks.

Is this something we want to do?  Are we comfortable with only checking
directory entries the first time they are read from disk?

-Eric
