From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: lockdep warnings - possible circular locking
Date: Tue, 30 Aug 2011 12:55:58 +0200
Message-ID: <CA+icZUWoEEBQke2moQpr_XQNQ-wySSuN9-bssS8yAt2yBJT0bg@mail.gmail.com>
References: <CABqxG0e6EXfDUEeno6e70Orgye+0EGq6x7qsFJ2q8Og3vt+aiA@mail.gmail.com>
	<4E5CAD18.1020907@tao.ma>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave Young <hidave.darkstar@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36381 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1H3Kz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 06:55:59 -0400
In-Reply-To: <4E5CAD18.1020907@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2011 at 11:27 AM, Tao Ma <tm@tao.ma> wrote:
> Hi Dave,
> On 08/30/2011 05:09 PM, Dave Young wrote:
>> Hi,
>>
>> I got following lockdep warnings, ext4 related?
> This is already reported by many guys. Ted has a fix for it.
> Please search the mail with subject
> [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
>
> Thanks
> Tao
>>

[ CC Theodore Ts'o ]

Updated Kernel Bug #41682 with your informations.

- Sedat -

[1] https://bugzilla.kernel.org/show_bug.cgi?id=41682
