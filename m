From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 7/7] libext2fs: enforce the block group descriptor size in ext2fs_open()
Date: Wed, 1 Aug 2012 13:45:32 -0700
Message-ID: <CD3F0352-A252-4427-AE7B-F71160BF77BC@whamcloud.com>
References: <20120628024356.GB17989@thor.bakeyournoodle.com> <1343684862-13181-1-git-send-email-tytso@mit.edu> <1343684862-13181-7-git-send-email-tytso@mit.edu> <B4B1A06B-F856-4248-8A7E-3BFF8F3E7267@whamcloud.com> <20120731200918.GF32228@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"tony@bakeyournoodle.com" <tony@bakeyournoodle.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58308 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2HAVSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 17:18:06 -0400
Received: by yenl2 with SMTP id l2so7838444yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2012 14:18:05 -0700 (PDT)
In-Reply-To: <20120731200918.GF32228@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-31, at 13:09, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jul 31, 2012 at 11:38:47AM -0700, Andreas Dilger wrote:
>>> +    /* Enforce the block group descriptor size */
>>> +    if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) {
>>> +        if (fs->super->s_desc_size != EXT2_MIN_DESC_SIZE_64BIT) {
>> 
>> It doesn't necessarily make sense to limit this to the minimum size, only that it is at least the minimum size. 
> 
> I'm not at all convinced that the ext2fs library will do the right
> thing if the block group size is larger than what we expect.  At the
> very least we need to make sure it is a power of two, but even so I'd
> want to audit the code and do some experiments before I would hang my
> hat on this actually working correctly...

I'm pretty sure that we've always checked that it is a power-of-two value. The problem with this change is that it makes it much harder to increase the size again in the future .

It would definitely need another feature flag, but it isn't clear without more investigation (that i can't do on my phone) if a COMPAT flag would be enough (which we would likely have anyway if we needed a larger descriptor) or if we need a more restrictive feature flag. 

Cheers, Andreas