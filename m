From: Phil Susi <psusi@ubuntu.com>
Subject: Re: Unused block group, but all blocks not free?
Date: Wed, 20 May 2015 11:15:59 -0400
Message-ID: <555CA52F.3010109@ubuntu.com>
References: <555BDEF4.1020704@ubuntu.com> <20150520151007.GK2871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34098 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbETPRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2015 11:17:16 -0400
Received: by qkgx75 with SMTP id x75so33825717qkg.1
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2015 08:17:15 -0700 (PDT)
In-Reply-To: <20150520151007.GK2871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/20/2015 11:10 AM, Theodore Ts'o wrote:
> Have you checked to see if the metadata for other block groups are
> taking up space in the block group.  This can happen when using the
> flex_bg layout.  (And without flex_bg, then *all* block groups will
> always have blocks in use, for their own metadata blocks.)

That was my first thought and no, they aren't.  The metadata is in bg 0 
and bg 32, not 25.  Even still, when the metadata is there, shouldn't 
the allocation bitmap mark those blocks as in use rather than be 
uninitialized?

