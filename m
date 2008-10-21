From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: status of the ext3/jbd error handling enhancement patches
Date: Tue, 21 Oct 2008 15:24:47 +0900
Message-ID: <48FD75AF.6080507@hitachi.com>
References: <48FC081D.60306@hitachi.com>
    <20081019221331.ddf6b8c2.akpm@linux-foundation.org>
    <20081020124145.GB10698@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	adilger@sun.com, jack@suse.cz, sandeen@redhat.com
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59967 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYJUGY4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Oct 2008 02:24:56 -0400
In-Reply-To: <20081020124145.GB10698@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> On Sun, Oct 19, 2008 at 10:13:31PM -0700, Andrew Morton wrote:
> 
>>>  #jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
>>>  jbd-fix-error-handling-for-checkpoint-io.patch
>>>  ext3-add-checks-for-errors-from-jbd.patch
>>>  jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
>>>
>>>They improve filesystem corruption problem and it is needed by
>>>mission critical systems.
>>>
>>>Could you tell me what is your concern (you commented, "double-check
>>>this") ?  Are there something that I can help?  For example, I can
>>>provide some SystemTap scripts to help tests.
>>
>>I forget my reasons for that - would need to go back and review the
>>discussions when the patch was first merged.
>>
>>One of the above patches (I forget which) breaks the build because it
>>expects the presence of Al Viro's VFS tree, and that hasn't been merged
>>yet.  I need to wait and see if that merge will be happening (seems
>>unlikely) and if not, rework the patch against mainline.

I see.  Thank you for your work.

> Strange; I don't recall any of the ext4 variants of the error handling
> patches requiring Al's VFS tree.  And I thought all of them have been
> merged into Linus's tree at this point.

I checked Al's VFS tree and I found commit
6ac465f99b29f74ca5a62bc32a8772985d9a071b changes codes near where
one of my patch changes (in ext3/ext4_quota_on()), but not the same code.

> Kawai-san, could you double check and see if I processed all of your
> patches and pushed them to Linus?  I was pretty sure I had...

I confirmed that all of my ext4/jbd2 patches have been merged into
mainline.  Thank you very much!

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

