From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel
Date: Wed, 23 May 2012 12:44:18 -0600
Message-ID: <FD07D2CC-DAAF-4A3B-BEB7-F25DDF4A8ECF@whamcloud.com>
References: <1337776849-1138-1-git-send-email-adilger@whamcloud.com> <1337797871-19357-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42295 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2EWSoW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2012 14:44:22 -0400
Received: by dady13 with SMTP id y13so10114776dad.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 May 2012 11:44:22 -0700 (PDT)
In-Reply-To: <1337797871-19357-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-23, at 12:31 PM, Andreas Dilger wrote:
> Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
> to be driven by Makefile rules instead of by a script loop.  This
> allows the tests to be run in parallel like a build and reduces
> testing time significantly.

Sigh,
as Murphy would have it, I noticed a buglet in the patch after I
sent it (using "continue" instead of "exit 0" for non-existent
tests given to "test_one").  New patch to follow soon.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




