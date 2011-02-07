From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Mon, 7 Feb 2011 15:31:41 -0800
Message-ID: <AANLkTikj9qdFJfD+c09V9duTPq_soRv_UsuBgutRHEQt@mail.gmail.com>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
 <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca> <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
 <AANLkTim0XZe2=3AWw4Ydb8F7BQGCf+=FyjKoyadc+3yw@mail.gmail.com> <20110207232343.GA26289@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60493 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1BGXcW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 18:32:22 -0500
Received: by qyj19 with SMTP id 19so1934466qyj.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Feb 2011 15:32:03 -0800 (PST)
In-Reply-To: <20110207232343.GA26289@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 7, 2011 at 3:23 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Jan 29, 2011 at 09:40:34PM -0800, Manish Katiyar wrote:
>>
>> Any feedback on this ?
>
> The patch looks good, but it doesn't fix bug #26752.
>
> The root cause of that bug is the fact that ext4_sync_fs() and
> ext4_put_super() assumes that sbi has been initialized.

Hmm.. Actually I was looking at generic_super_shutdown() which I
thought would call ext4_put_super() only if sb->root is set, and since
I was setting sb->root explicitly to NULL in my patch in case of
failures.

-- 
Thanks -
Manish
