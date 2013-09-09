From: Marc Meledandri <m.meledandri@gmail.com>
Subject: Re: Oops at shutdown: kernel BUG at fs/ext4/super.c:804!
Date: Mon, 9 Sep 2013 13:05:00 -0400
Message-ID: <CACFbnrwx6SHjyOzf4nU9tC4mn=YxxN8vNcwSe-90Z_1dQAKvEg@mail.gmail.com>
References: <CACFbnrxbjFPi4gW0Lt8WfSneHjtg-5J7np5ds18WWQesAQgocg@mail.gmail.com>
 <20130909162319.GG1612@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47675 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3IIRFb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Sep 2013 13:05:31 -0400
Received: by mail-pd0-f180.google.com with SMTP id y10so6395330pdj.25
        for <linux-ext4@vger.kernel.org>; Mon, 09 Sep 2013 10:05:30 -0700 (PDT)
In-Reply-To: <20130909162319.GG1612@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 9, 2013 at 12:23 PM, Jan Kara <jack@suse.cz> wrote:
> On Sun 08-09-13 18:28:40, Marc Meledandri wrote:
>> Been seeing this problem at shutdown on 3.10.x kernels.
>>
>> I saw a previous similar thread, but it seemed related to NFS whereas this is
>> affecting my raid device (dm-0).
>   Well, this is likely caused by inodes in filesystem on dm-0 being still
> held by someone. Are you exporting dm-0 via NFS? Because there have been
> recently bugs in NFS in this area (this patch should have fixed them:
> http://www.spinics.net/lists/kernel/msg1592640.html).
>
Thank you. I'd seen that patch, but don't have a remotely similar
configuration as specified in the STR. I also thought NFS was out of
the picture at that stage of the shutdown, but after re-reading the
patch notes, it looks like the earlier delegation may do the trick for
my standard NFS implementation as well. I'll test with this patch.
Looks hopeful.
