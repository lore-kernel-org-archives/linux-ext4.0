From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 devel interlock meeting minutes (Sept. 20, 2006)
Date: Thu, 21 Sep 2006 08:48:40 -0400
Message-ID: <20060921124840.GH12542@thunk.org>
References: <45117477.1030000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:10901 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751163AbWIUMvG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Sep 2006 08:51:06 -0400
To: Avantika Mathur LTC <mathur@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <45117477.1030000@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 20, 2006 at 10:03:51AM -0700, Avantika Mathur LTC wrote:
> - Alexandre is waiting for feedback from Ted on e2fsprogs patches.  Plan 
> to discuss and review through the mailing list.

My posting from earlier this week was a result of reviewing the
clusterfs patches, althoguh perhaps I should have been more explicit
about my complaints:

*) In appropriate namespace leakage (all new functions that are
visible should have the ext2fs_ prefix)

*) Interfaces that expose the on-disk extent format, and will
therefore require changing (and thus breaking) the API and ABI when we
add support for 48-bit or 64-bit extent patches.  

I was trying to be a bit more constructive, though, and have been in
the midst of reimplementing a better interface.  Although if Alexandre
has time in the next week or two, things might go faster if I can just
explain what I want the new interface to look like and he can
implement it.  :-)

						- Ted

