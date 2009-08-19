From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Rare xfsqa test failure
Date: Wed, 19 Aug 2009 10:28:04 -0500
Message-ID: <4A8C1A04.1090501@redhat.com>
References: <E1MdNJu-0006uc-GX@closure.thunk.org> <20090818170705.GI5931@webber.adilger.int> <20090818214218.GK28560@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37889 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751795AbZHSP2I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 11:28:08 -0400
In-Reply-To: <20090818214218.GK28560@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Aug 18, 2009 at 11:07:05AM -0600, Andreas Dilger wrote:
>>> EXTENTS:
>>> (65-80): 60720-60735, (81-222 [uninit]): 1181574-1181715, (223-229): 1181716-118
>>> 1722
>>> debugfs:  
>>>
>>> So it looks like there's a race which can cause ext4 to somehow miss an
>>> i_size update.
>> Are you sure it is a failure to update i_size, or is it possibly an
>> fallocate that extends the block count beyond i_size?
> 
> Look at the EXTENTS report from debugfs; blocks 81-222 are
> uninitialized from an fallocate, but block 223-229 are initialized.
> 
> 	      	      		     	   - Ted

This was from test 013?

If so, that calls ltp's fsstress, which does not call fallocate nor
posix_fallocate.  It only does preallocation on xfs via the old
xfs-specific ioctl (though I suppose we should add it...)

-Eric
