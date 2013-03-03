From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 09/10] xfstest: add defragmentation stress tests for ext4
Date: Mon, 4 Mar 2013 00:43:42 +0800
Message-ID: <20130303164342.GB30459@gmail.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
 <1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, dchinner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62050 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3CCQ2i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2013 11:28:38 -0500
Content-Disposition: inline
In-Reply-To: <1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 20, 2013 at 02:42:14PM +0400, Dmitry Monakhov wrote:
> Perform various regression tests for ext4defrag  subsystem
> 
>  299'th Test1: Defragment file while other task does direct AIO

Hi Dmitry,

I couldn't run this testcase in my sandbox.  I got the following error
message.

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0
MKFS_OPTIONS  -- /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda2 /mnt/sda2

299      [not run] /usr/local/bin/fio too old
Not run: 299
Passed all 0 tests

My fio version is fio-2.0.14-23-g9c63.  It seems that there are some
errors in fio config file.

Regards,
                                                - Zheng
