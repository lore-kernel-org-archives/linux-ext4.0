From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsprogs: Avoid infinite loop in ext2fs_find_block_device()
Date: Thu, 3 Nov 2011 11:27:54 -0400
Message-ID: <121461D1-4A28-4B65-960D-7549D2782FFA@mit.edu>
References: <4EB23889.1010807@whamcloud.com> <4EB2A983.6070203@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>, Niu <niu@whamcloud.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:56488 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab1KCP15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Nov 2011 11:27:57 -0400
In-Reply-To: <4EB2A983.6070203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 3, 2011, at 10:47 AM, Eric Sandeen wrote:

> 
> My only concern would be that depth 5 isn't totally unreasonable in real life, and this causes it to silently stop searching, right?
> Would there be much harm in making the limit much higher, to be fairly sure that it has wandered off into the weeds?

Agreed, the kernel currently uses a limit of 8.  And we should use a #define for this in lib/ext2fs/ext2fsP.h, and use it for both finddev.c and lib/ext2fs/namei.c.

-- Ted

