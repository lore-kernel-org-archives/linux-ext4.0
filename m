From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: Reporting project quota usage?
Date: Thu, 17 Mar 2016 09:47:44 +0800
Message-ID: <CAPTn0cBgrUGG+8iAb=wfUke4g8AWBB3tHV25YFuA5FF05we8Aw@mail.gmail.com>
References: <20160316052906.GA23610@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:32802 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967098AbcCQBrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2016 21:47:45 -0400
Received: by mail-vk0-f45.google.com with SMTP id k1so85125954vkb.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2016 18:47:44 -0700 (PDT)
In-Reply-To: <20160316052906.GA23610@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I sent a patch of quota tool to Jan Kara ccing you. With that patch,
project quota
of ext4 can be reported. However, that patch needs a lot of improvement.

That patch can be found here too:

https://github.com/ddn-lixi/project_quota_ext4_utils/blob/master/quota-tools.git/patches/project_quota_support_for_quota-tools.patch

Regards,
Li Xi

On Wed, Mar 16, 2016 at 1:29 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Am I missing something, or do we currently don't have a way to report
> project quota usage with ext4?  The support doesn't appear to be in
> quota tools, and xfs_quota doesn't work without changes because it
> only tries to operate on XFS file systems.
>
> Thanks,
>
>                                                 - Ted
