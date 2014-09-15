From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Remove any occurrence of ext4dev and test_fs
Date: Mon, 15 Sep 2014 16:41:50 -0500
Message-ID: <54175D1E.9090107@redhat.com>
References: <1392821835-12059-1-git-send-email-lczerner@redhat.com> <5304E243.6050700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbaIOVly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Sep 2014 17:41:54 -0400
In-Reply-To: <5304E243.6050700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/19/14 10:56 AM, Eric Sandeen wrote:
> On 2/19/14, 8:57 AM, Lukas Czerner wrote:
>> ext4dev is no longer supported by kernel so we really need to get rid of
>> it entirely from e2fsprogs.
>>
>> This patch removes any occurrence of ext4dev and test_fs flag from the
>> e2fsprogs tools with one exception. Out of paranoia we can still leave
>> the possibility to remove test_fs flag (EXT2_FLAGS_TEST_FILESYS) from
>> the file system using e2fsck by specifying clear_test_fs_flag option in
>> the e2fsck.config file.
> 
> Yes, I think this makes good sense.  While one could argue that
> test_fs may be used for some other purpose in the future, we have
> added a lot of fairly experimental code without making use of it,
> so I'd argue that it has no practical use going forward.
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>

Ted, any thoughts on this?

-Eric

