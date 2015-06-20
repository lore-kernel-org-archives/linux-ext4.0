From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH v2] debugfs/set_fields: fix several errors and add assertions
Date: Sat, 20 Jun 2015 15:30:18 +0300
Message-ID: <CALYGNiPG5c_QVVKPgc6gFM59Styx2Lxn97SMPB=38JWYzgp0NQ@mail.gmail.com>
References: <20150225094728.14523.52763.stgit@buzz>
	<20150620020158.GD29480@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35755 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbFTMaU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jun 2015 08:30:20 -0400
Received: by lbbwc1 with SMTP id wc1so85933301lbb.2
        for <linux-ext4@vger.kernel.org>; Sat, 20 Jun 2015 05:30:18 -0700 (PDT)
In-Reply-To: <20150620020158.GD29480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 20, 2015 at 5:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Feb 25, 2015 at 12:47:28PM +0300, Konstantin Khlebnikov wrote:
>> Fix copy-n-paste errors:
>> * remove duplicate "lastcheck" and "min_extra_isize"
>> * fix pointer for "first_error_line" and "last_error_line"
>> * remove superblock field "inodes_count" from inode fields
>> * add null-termination for mmp_fields
>>
>> Add assertions for catching such errors in the future.
>> Mark true aliases with flag "FLAG_ALIAS" and suppress assert for them.
>>
>> v2: check tables in unit test "debugfs/tst_set_fields"
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>
> Applied, thanks.   Apologies for the delay.

No problem. Thanks.

I have a somehow related question: do you interested in project quota in ext4?

It seems I could revisit that task once again.
This time I could make it completely compatible with XFS. Looks like
last time all
objections were about my attempt of making overall behaviour more useful.

--
Konstantin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
