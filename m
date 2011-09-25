From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 4/4] e2fsck: regression tests for INCOMPAT_MMP feature
Date: Sun, 25 Sep 2011 00:04:14 -0600
Message-ID: <A094EB47-CDD0-4A72-8659-841FC9848BFD@whamcloud.com>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com> <1316821124-7461-4-git-send-email-adilger@whamcloud.com> <20110924185155.GG2779@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34055 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1IYGET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Sep 2011 02:04:19 -0400
Received: by gyg10 with SMTP id 10so3446295gyg.19
        for <linux-ext4@vger.kernel.org>; Sat, 24 Sep 2011 23:04:19 -0700 (PDT)
In-Reply-To: <20110924185155.GG2779@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-24, at 12:51 PM, Ted Ts'o wrote:
> On Fri, Sep 23, 2011 at 05:38:44PM -0600, Andreas Dilger wrote:
>> Add tests for the MMP feature - creating a filesystem with mke2fs
>> and MMP enabled, enable/disable MMP with tune2fs, disabling the
>> e2fsck MMP flag with tune2fs after a failed e2fsck, and e2fsck
>> checking and fixing a corrupt MMP block.
>> 
>> The MMP tests need to be run from a real disk, not tmpfs, because
>> tmpfs doesn't support O_DIRECT reads, which MMP uses to ensure
>> that reads from the MMP block are not filled from the page cache.
>> Using a local disk does not slow down the tests noticably, since
>> they wait to detect if the MMP block is being modified.
>> 
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> Applied, although I needed to refrob the test names.  The first
> character denotes not the test is for:
> 
> *) f_* tests are for e2fsck
> *) m_* tests are for tune2fs

You mean m_* for mke2fs and t_* for tune2fs, I think.

> *) u_* tests are for e2undofs
> 
> This allows someone to test mke2fs by running the command:

FYI, the reason that I ordered the MMP tests in that way is because it
makes sense to verify that mke2fs can create a filesystem with the MMP
feature before using a filesystem created by mke2fs with MMP to test if
e2fsck handles it correctly.

At this point, it is unlikely that there will be a problem with this in
the future, because the code is working today, and at worst it means that
the e2fsck f_mmp_* tests might incorrectly pass before m_mmp_* fails, or
something, so I don't insist on changing it back.

In any case, thanks for merging the patches.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



