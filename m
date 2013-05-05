From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: fix return value
Date: Sat, 4 May 2013 20:40:21 -0600
Message-ID: <3CC14044-0A69-48EA-90C7-CF173F6A8A42@dilger.ca>
References: <1367643954-31340-1-git-send-email-vapier@gentoo.org> <20130504235503.GC5948@thunk.org> <201305042058.55976.vapier@gentoo.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:43672 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3EECkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 May 2013 22:40:23 -0400
Received: by mail-da0-f50.google.com with SMTP id i23so1330118dad.9
        for <linux-ext4@vger.kernel.org>; Sat, 04 May 2013 19:40:22 -0700 (PDT)
In-Reply-To: <201305042058.55976.vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-05-04, at 18:58, Mike Frysinger <vapier@gentoo.org> wrote:
> On Saturday 04 May 2013 19:55:03 Theodore Ts'o wrote:
>> On Sat, May 04, 2013 at 01:05:54AM -0400, Mike Frysinger wrote:
>>> The ext2fs_test_block_bitmap_range2 func is not a void, so make sure we
>>> return a value.  I picked EINVAL as it looks like what other things in
>>> this func use.
>>> 
>>> URL: http://bugs.gentoo.org/467986
>>> Reported-by: Vicente Olivert Riera <vincent@gentoo.org>
>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> 
>> This is already fixed in e2fsprogs's git repository, in commit
>> 0d89e5acea9.
> 
> ok, the use of "master" and "next" is weird.  i was using the normal "master" 
> branch which is apparently out of date.

I'd have to agree. It would be great if master was merged from maint more often so that patches would apply to either.

Cheers, Andreas