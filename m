From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: clear uninit BG if allocating from new group
Date: Thu, 17 Sep 2015 22:19:09 -0500
Message-ID: <55FB82AD.4020302@redhat.com>
References: <55FB41CA.8010003@redhat.com>
 <20150917235524.GE10390@birch.djwong.org>
 <196754A4-210B-45E7-837A-7955780208E6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <esandeen@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbIRDTN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2015 23:19:13 -0400
In-Reply-To: <196754A4-210B-45E7-837A-7955780208E6@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/17/15 7:54 PM, Eric Sandeen wrote:
> On Sep 17, 2015, at 6:55 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>
>>> On Thu, Sep 17, 2015 at 05:42:18PM -0500, Eric Sandeen wrote:
>>> If resize2fs_get_alloc_block() allocates from a BLOCK_UNINIT
>>> group, nothing clears the UNINIT flag, so it is skipped when we
>>> go to write out modified bitmaps.  This leads to post-resize2fs
>>> e2fsck errors; used blocks in UNINIT groups, not marked in the
>>> block bitmap.
>>>
>>> This shamelessly cuts & pastes clear_block_uninit() into
>>> resize2fs.c, and my problem goes away.
>>
>> Hmm... which test was it that exhibited this error?
>>
> r_ext4_small_bg
> 
> Originally it was claimed that only a gcc change exposed it; I'm
> still trying to make sense of that. But the pre-resize image exhibits
> it with any recent resizefs when resized up to 2g as the test does.

I think the only reason the different gcc tweaked the bug is that the
test copies the e2fsck/e2fsck binary into the filesystem under test,
and the size changes depending on the compiler.

I can put up an fs image that exhibits it if you're curious...

-Eric

