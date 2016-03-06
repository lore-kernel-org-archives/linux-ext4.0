From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v3 5/5] Add project ID support for chattr/lsattr
Date: Sun, 6 Mar 2016 08:13:58 +0800
Message-ID: <CAPTn0cDTxZD66xjDKZiB9BsrR25p24D+oqRY8MZS7_f6yAtzPw@mail.gmail.com>
References: <1452589008-18750-1-git-send-email-lixi@ddn.com>
	<1452589008-18750-6-git-send-email-lixi@ddn.com>
	<20160301042458.GD9772@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33894 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcCFAN7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:13:59 -0500
Received: by mail-vk0-f43.google.com with SMTP id e185so87044017vkb.1
        for <linux-ext4@vger.kernel.org>; Sat, 05 Mar 2016 16:13:58 -0800 (PST)
In-Reply-To: <20160301042458.GD9772@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Teb, sorry for my late reply.

We are improving the patches internally. But it was on a different branch.
And I am rebasing it to master branch. I will push the patch series again
in a few hours.

Regards,
Li Xi

On Tue, Mar 1, 2016 at 12:24 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jan 12, 2016 at 05:56:48PM +0900, Li Xi wrote:
>> Chattr and lsattr can be used to set or get project ID:
>> chattr -p <project id> file
>> lsattr -p file
>>
>> Signed-off-by: Li Xi <lixi@ddn.com>
>> Signed-off-by: Wang Shilong <wshilong@ddn.com>
>> ---
>>  lib/e2p/Makefile.in |   11 +++++++++--
>>  lib/e2p/e2p.h       |    2 ++
>>  misc/chattr.1.in    |    7 +++++++
>>  misc/chattr.c       |   33 +++++++++++++++++++++++++++++++--
>>  misc/lsattr.1.in    |    5 ++++-
>>  misc/lsattr.c       |   18 ++++++++++++++++--
>>  6 files changed, 69 insertions(+), 7 deletions(-)
>
> Hi, this patch is missing the new files for fgetproject.c and
> fsetproject.c.   Can you resend them, please?
>
>                                                 - Ted
