From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: optimize extent selection for block removal in case
 of hole punch
Date: Wed, 19 Jun 2013 19:15:35 +0530
Message-ID: <CAOiN93mMc1zG-YToRxVfbm8iDeeB6roJ_AZKcXJgGpfS+yn9xA@mail.gmail.com>
References: <519f7ba2.04fc440a.06c2.ffffd589@mx.google.com>
	<20130618154053.GF7359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: adilger@dilger.ca, ext4 development <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:53968 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3FSNpg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jun 2013 09:45:36 -0400
Received: by mail-qe0-f54.google.com with SMTP id ne12so3269740qeb.13
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jun 2013 06:45:35 -0700 (PDT)
In-Reply-To: <20130618154053.GF7359@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 18, 2013 at 9:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, May 24, 2013 at 08:09:17PM +0530, ashishsangwan2@gmail.com wrote:
>> From: Ashish Sangwan <a.sangwan@samsung.com>
>>
>> Both hole punch and truncate use ext4_ext_rm_leaf for removing
>> blocks. Currently we choose the last extent as the starting
>> point for removing blocks: ex = EXT_LAST_EXTENT(eh);
>> This is OK for truncate but for hole punch we can optimize the
>> extent selection as the path is already initialized.
>> We could use this information to select proper starting extent.
>> The code change in this patch will not affect truncate as for
>> truncate path[depth].p_ext will always be NULL.
>>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>
> Applied, thanks.
Hi Ted,

Sorry I cannot see the patch changes in ext4 dev branch.

Regards,
Ashish
>
>                                         - Ted
