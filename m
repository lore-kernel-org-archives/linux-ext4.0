From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded call to ext4_es_remove_extent in
 punch hole
Date: Sat, 27 Apr 2013 15:11:09 +0800
Message-ID: <20130427071109.GA25329@gmail.com>
References: <1367037053-1893-1-git-send-email-ashish.sangwan2@gmail.com>
 <20130427052809.GA25185@gmail.com>
 <CAOiN93n2pM0d9O=wON=nAJNxj3T3XRBfpUk4SOvgg4=3NsvcYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	wenqing.lz@taobao.com, Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:62228 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3D0Gxo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Apr 2013 02:53:44 -0400
Received: by mail-da0-f53.google.com with SMTP id n34so2216232dal.40
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 23:53:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOiN93n2pM0d9O=wON=nAJNxj3T3XRBfpUk4SOvgg4=3NsvcYA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 27, 2013 at 12:20:22PM +0530, Ashish Sangwan wrote:
> >The commit
> > log is right before we use extent status tree to track all extent
> > information.  In dev branch of ext4 tree, we track all extent status in
> > status tree.  So we need to remove extent from status tree in punch
> > hole.
> I was of the opinion that filemap_write_and_wait_range will remove the
> extent from status tree if its still there.
> ok, I will check the dev branch.

Ah, please bear with me.  In mainline kernel 3.9-rcX, we have used
status tree to track all extent status.  You could also check 3.9-rcX
kernel.  Please let me know if I miss something.

Thanks,
                                                - Zheng
