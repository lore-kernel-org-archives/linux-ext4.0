From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Sat, 14 May 2011 10:11:55 +0300
Message-ID: <BANLkTimA4JYROuQqe0+7UF7_Ti5rhZRrtA@mail.gmail.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
	<20110513145608.GA21165@thunk.org>
	<4DCD4D5E.6050307@redhat.com>
	<BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com>
	<20110513224949.GB21165@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1ENHL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 May 2011 03:11:57 -0400
In-Reply-To: <20110513224949.GB21165@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 14, 2011 at 1:49 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, May 13, 2011 at 08:25:02PM +0300, Amir Goldstein wrote:
>>
>> After xfstests failed to build on Ubuntu 10.10, I followed the
>> advice omitted by the build script to run "make install-qa", to
>> solve the problem. =A0It took me a while to figure exactly where I
>> should run the command, but in the end I pulled the xfsprogs tree,
>> ran "make; make install; make install-qa" and from there on things
>> were looking better.
>
> I did that, but fsstress doesn't pull in the needed xfs/xfs_fs.h
> header file. =A0So it still dies.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

Well, anyway, the regression has to be from commit  21f97697:

ext4: remove unnecessary [cm]time update of quota file

because before that commit ext4_quota_off() was too short to
have a bug at ext4_quota_off+0x42/0xd0.

Jan, where are you? don't make me debug this...

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
