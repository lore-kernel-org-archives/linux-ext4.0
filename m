From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] test: add f_mke2fs_baddisk
Date: Wed, 07 Dec 2016 17:50:03 +0300
Message-ID: <87fulz3ias.fsf@dmlp.sw.ru>
References: <1481116459-8770-1-git-send-email-dmonakhov@openvz.org> <20161207141941.vs6zt5wblze34u23@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34532 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbcLGOuO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2016 09:50:14 -0500
Received: by mail-qk0-f194.google.com with SMTP id y205so48556567qkb.1
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2016 06:50:07 -0800 (PST)
In-Reply-To: <20161207141941.vs6zt5wblze34u23@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> On Wed, Dec 07, 2016 at 05:14:18PM +0400, Dmitry Monakhov wrote:
>> Check what mke2fs will return non zero error on broken device.
>> 
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
> Most developers don't run "make check" as root.  So at minimum the
> test should check to see if it is running as root, or be able to deal
> with dmsetup failing due to permissions check.
You right. There are number of reasons why dmsetup may fail (kernel
is too old, no kernel compiled w/o DM). I'll send updated version.
>
> I wouldn't object if there was some environment variable, say SUDO or
> DOROOT, which, if set, would prefix the commands which require root
> with $DOROOT such that if the developer is willing to enable running
> specific commands as root, that was allowed for the regression test.
>
> Alternatively the long-term plan that I have is to allow pathnames to
> be specified using a URL-like scheme, e.g.;
>
>    unix://path/to/filename
>    test://unix/path/to/filename
>
> Which would allow us to define a proper test mock I/O manager that
> would allow for these sorts of tests without requiring root.
>
> Cheers,
>
> 					- Ted
