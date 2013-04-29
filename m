From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded call to ext4_es_remove_extent in
 punch hole
Date: Mon, 29 Apr 2013 14:10:42 +0530
Message-ID: <CAOiN93msfJPVkE4OfodsBne5P7Ui7O0EfSdavbWK_-aZ-4crUA@mail.gmail.com>
References: <1367037053-1893-1-git-send-email-ashish.sangwan2@gmail.com>
	<20130427052809.GA25185@gmail.com>
	<CAOiN93n2pM0d9O=wON=nAJNxj3T3XRBfpUk4SOvgg4=3NsvcYA@mail.gmail.com>
	<20130427071109.GA25329@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ashish Sangwan <ashishsangwan2@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	wenqing.lz@taobao.com, Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46308 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3D2Ikn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 04:40:43 -0400
Received: by mail-qa0-f42.google.com with SMTP id dx4so926201qab.15
        for <linux-ext4@vger.kernel.org>; Mon, 29 Apr 2013 01:40:43 -0700 (PDT)
In-Reply-To: <20130427071109.GA25329@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 27, 2013 at 12:41 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Sat, Apr 27, 2013 at 12:20:22PM +0530, Ashish Sangwan wrote:
>> >The commit
>> > log is right before we use extent status tree to track all extent
>> > information.  In dev branch of ext4 tree, we track all extent status in
>> > status tree.  So we need to remove extent from status tree in punch
>> > hole.
>> I was of the opinion that filemap_write_and_wait_range will remove the
>> extent from status tree if its still there.
>> ok, I will check the dev branch.
>
> Ah, please bear with me.  In mainline kernel 3.9-rcX, we have used
> status tree to track all extent status.  You could also check 3.9-rcX
> kernel.  Please let me know if I miss something.
Hi Zheng,

Ok, I understood your point.
Currently, after step 2 of extent status tree, it houses _all_ the
extents and not just delayed extents.
This patch is not required now.

Regards,
Ashish
>
> Thanks,
>                                                 - Zheng
