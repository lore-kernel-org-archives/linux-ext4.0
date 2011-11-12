From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH v2] ext4: expand commit callback
Date: Fri, 11 Nov 2011 22:50:53 -0700
Message-ID: <315DE858-FDCD-49BD-8E4E-0EAD0D389B96@whamcloud.com>
References: <4EBA4CC1.5020605@whamcloud.com> <20111109101707.GA3639@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bobi Jam <bobijam@whamcloud.com>, Theodore Tso <tytso@MIT.EDU>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35090 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1KLFu5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Nov 2011 00:50:57 -0500
Received: by gyc15 with SMTP id 15so3560226gyc.19
        for <linux-ext4@vger.kernel.org>; Fri, 11 Nov 2011 21:50:57 -0800 (PST)
In-Reply-To: <20111109101707.GA3639@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-09, at 3:17 AM, Christoph Hellwig wrote:
> On Wed, Nov 09, 2011 at 05:49:53PM +0800, Bobi Jam wrote:
>> This patch has been rebased on v3.2-rc1-91.
>> 
>> The per-commit callback was used by mballoc code to manage free
>> space bitmaps after deleted blocks have been released. This patch
>> expand it to contain multiple different callbacks.
> 
> It fails to explain why you do it, both in text and by sending it
> together with a patch that actually makes use of it.

We discussed this patch previously on the ext4 concall.  The code is
being restructured to allow multiple commit callbacks to be registered.

The block freeing code in ext4 is being modified in the patch to use
the updated commit callback.  This is used to mark deleted blocks as
available for allocation after the journal transaction has committed.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



