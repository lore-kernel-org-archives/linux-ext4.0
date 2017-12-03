From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: Testing Ext4 encryption with fstests
Date: Sun, 3 Dec 2017 14:22:10 +0800
Message-ID: <20171203062210.GA2775@eguan.usersys.redhat.com>
References: <2008991.n3x73QCyP8@localhost.localdomain>
 <20171203024449.foyydafswblqceou@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:45156 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbdLCGWS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Dec 2017 01:22:18 -0500
Received: by mail-pg0-f50.google.com with SMTP id m25so6220572pgv.12
        for <linux-ext4@vger.kernel.org>; Sat, 02 Dec 2017 22:22:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171203024449.foyydafswblqceou@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Sat, Dec 02, 2017 at 09:44:49PM -0500, Theodore Ts'o wrote:
> On Sat, Dec 02, 2017 at 08:44:29AM +0530, Chandan Rajendra wrote:
...
> 
> generic/466 and generic/468 are new tests that are failing on the
> standard 4k config as well as the encrypt case.  On my todo list to
> look at more closely and triage.

I've sent a patch to fix generic/468 failure on Nov. 15th, would you
please take a look and review it?

ext4: fix fdatasync(2) after fallocate(2) operation
https://patchwork.ozlabs.org/patch/838141/

Thanks,
Eryu
