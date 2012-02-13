From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] ext4: expand commit callback
Date: Mon, 13 Feb 2012 16:50:57 -0700
Message-ID: <4FC52D3C-E489-43A7-96BB-433D0E8F15CB@whamcloud.com>
References: <y> <1319626156-2444-1-git-send-email-bobijam@whamcloud.com> <20120213210225.GA21641@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bobi Jam <bobijam@whamcloud.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60434 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2BMXvD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 18:51:03 -0500
Received: by iacb35 with SMTP id b35so5196388iac.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 15:51:02 -0800 (PST)
In-Reply-To: <20120213210225.GA21641@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-13, at 2:02 PM, Ted Ts'o wrote:
> On Wed, Oct 26, 2011 at 06:49:16PM +0800, Bobi Jam wrote:
>> The per-commit callback is now used by mballoc code to manage free
>> space bitmaps after deleted blocks have been released. This patch
>> expand it to contain multiple different callbacks.
>> 
>> Signed-off-by: Bobi Jam <bobijam@whamcloud.com>
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> Thanks, applied.
> 
> Note: since this callback is called *after* the commit is completed,
> we can't really use this to do things like compute metadata checksums
> or update atimes more efficiently, since those sorts of things have to
> happen *before* we actually finish up the commit.

Right, though a similar commit callback (using the same infrastructure)
could be added before the commit is started.

There is already the buffer_head callback that OCFS is using for their
data checksums, which is called before the transaction commit.  I haven't
looked at that closely enough to know whether the ext4 metadata checksums
could use it (e.g. if it can handle different metadata block types with
different checksum chunks and locations).

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




