From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 4/4] e2fsck: regression tests for INCOMPAT_MMP feature
Date: Fri, 23 Sep 2011 17:51:57 -0600
Message-ID: <324442E2-9768-41F8-AF0D-0B6C1F96AB97@whamcloud.com>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com> <1316821124-7461-4-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48895 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1IWXwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 19:52:01 -0400
Received: by gyg10 with SMTP id 10so2925282gyg.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Sep 2011 16:52:01 -0700 (PDT)
In-Reply-To: <1316821124-7461-4-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-23, at 5:38 PM, Andreas Dilger wrote:
> Add tests for the MMP feature - creating a filesystem with mke2fs
> and MMP enabled, enable/disable MMP with tune2fs, disabling the
> e2fsck MMP flag with tune2fs after a failed e2fsck, and e2fsck
> checking and fixing a corrupt MMP block.
> 
> The MMP tests need to be run from a real disk, not tmpfs, because
> tmpfs doesn't support O_DIRECT reads, which MMP uses to ensure
> that reads from the MMP block are not filled from the page cache.
> Using a local disk does not slow down the tests noticably, since
> they wait to detect if the MMP block is being modified.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> #
> # ERROR: trailing whitespace
> # #19: FILE: tests/f_mmp/expect.1:13:
> # +Superblock backups stored on blocks: $
> #
> # ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF-8
> # #22: FILE: tests/f_mmp/expect.1:16:
> # +Allocating group tables: 0/21/2   done
> #                              ^

Sigh, my bad.  I installed an automatic git prepare_commit_msg hook that
runs checkpatch.pl against the patch, but it doesn't like the format of
the expect output (which is not C code and probably should be ignored).

Please delete this stuff out of the comments, or I can resubmit if you want.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



