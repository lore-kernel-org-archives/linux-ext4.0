From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [V4] misc: copy extended attributes in populate_fs
Date: Tue, 9 Sep 2014 09:03:29 -0400
Message-ID: <20140909130329.GE24855@thunk.org>
References: <1405010678-993-1-git-send-email-ross.burton@intel.com>
 <20140728012909.GA19632@thunk.org>
 <CAJTo0LYSjRtoN29_VmKv=CxyCJpwaywqfqOegZPFnWbV1+96ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Burton, Ross" <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45873 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbaIINDf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Sep 2014 09:03:35 -0400
Content-Disposition: inline
In-Reply-To: <CAJTo0LYSjRtoN29_VmKv=CxyCJpwaywqfqOegZPFnWbV1+96ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2014 at 11:20:34AM +0100, Burton, Ross wrote:
> 
> Thanks Ted.
> 
> I see that you merged before 1.42.12 was released but this didn't make
> 1.42.12.  Will it be in 1.42.13, or is it waiting for a 1.43.0
> release?

It's on the master branch, which means it's waiting on 1.43.  It's
very likely that 1.42.12 will be last maint branch release, and that
1.43.0 will be releasing relatively soon with inline data and metadata
checksum support.  There are a number of patches still in the review
queue and some additional testing we need to do before we can release
1.43, though.

Cheers,

						- Ted
