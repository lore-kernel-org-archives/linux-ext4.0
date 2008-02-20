From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Wed, 20 Feb 2008 12:46:57 -0600
Message-ID: <47BC75A1.10605@redhat.com>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759011AbYBTSrT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 13:47:19 -0500
In-Reply-To: <20080219050945.GU25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> The big news here is that extents branch is sufficiently finished that
> I've promoted it to the next branch.

Hey, that's great news.  :)

Out of curiosity; what is the plan for behavior when finding symlinks
with the extents flag set?  Last I checked e2fsprogs-interim, they got
clobbered.  Is that on the TODO before extents support goes "live?"

Thanks,
-Eric
