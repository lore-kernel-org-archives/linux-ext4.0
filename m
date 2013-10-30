From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH] ext4: drop unsed reclen variable from ext4_add_dirent_to_inline()
Date: Wed, 30 Oct 2013 21:02:35 +0400
Message-ID: <CAG5DWoi5DRCTos8-9aiLVEMf9SFc293nPj4bS0Sq6EdGsOqeYw@mail.gmail.com>
References: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
	<20131030145523.GD3305@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Azat Khuzhin <a3at.mail@gmail.com>,
	open list <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41625 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3J3RCg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Oct 2013 13:02:36 -0400
In-Reply-To: <20131030145523.GD3305@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 30, 2013 at 6:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 19, 2013 at 12:17:30AM +0400, Azat Khuzhin wrote:
>> Functions that need in it, already calculate reclen from namelen by
>> themselves:
>> - ext4_find_dest_de()
>> - ext4_insert_dentry()
>>
>> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
>
> Applied, thanks.

Thank you!
But there is a typo in subject, s/unsed/unused/ could you fix or it,
or tell me, and I will resend it?

Thanks!

>
>                                         - Ted



-- 
Respectfully
Azat Khuzhin
