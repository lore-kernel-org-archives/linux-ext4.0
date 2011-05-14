From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4 master branch)
Date: Sat, 14 May 2011 13:16:25 +0300
Message-ID: <21756A13-BE43-4B46-BDC9-F5C456476FFC@gmail.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com> <20110513145608.GA21165@thunk.org> <4DCD4D5E.6050307@redhat.com> <BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com> <20110513224949.GB21165@thunk.org> <BANLkTimA4JYROuQqe0+7UF7_Ti5rhZRrtA@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33030 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1ENKQR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 May 2011 06:16:17 -0400
In-Reply-To: <BANLkTimA4JYROuQqe0+7UF7_Ti5rhZRrtA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Sent from my iPhone

On 14/05/2011, at 10:11, Amir Goldstein <amir73il@gmail.com> wrote:

> On Sat, May 14, 2011 at 1:49 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Fri, May 13, 2011 at 08:25:02PM +0300, Amir Goldstein wrote:
>>>
>>> After xfstests failed to build on Ubuntu 10.10, I followed the
>>> advice omitted by the build script to run "make install-qa", to
>>> solve the problem.  It took me a while to figure exactly where I
>>> should run the command, but in the end I pulled the xfsprogs tree,
>>> ran "make; make install; make install-qa" and from there on things
>>> were looking better.
>>
>> I did that, but fsstress doesn't pull in the needed xfs/xfs_fs.h
>> header file.  So it still dies.
>>
>>                                                - Ted
>>
>
> Well, anyway, the regression has to be from commit  21f97697:
>
> ext4: remove unnecessary [cm]time update of quota file
>
> because before that commit ext4_quota_off() was too short to
> have a bug at ext4_quota_off+0x42/0xd0.
>
> Jan, where are you? don't make me debug this...

So I guess that Jan's patch is missing
If (!inode)
     goto out;

So much for writing patches from my mobile ;-)

>
> Amir.
