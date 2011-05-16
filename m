From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Mon, 16 May 2011 12:59:56 +0300
Message-ID: <BANLkTi=i+BT7k_0G5f=amqjSo+mFjeZ+BQ@mail.gmail.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
	<20110513145608.GA21165@thunk.org>
	<4DCD4D5E.6050307@redhat.com>
	<BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com>
	<20110513224949.GB21165@thunk.org>
	<BANLkTimA4JYROuQqe0+7UF7_Ti5rhZRrtA@mail.gmail.com>
	<21756A13-BE43-4B46-BDC9-F5C456476FFC@gmail.com>
	<20110516094324.GA5344@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47846 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1EPJ76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 05:59:58 -0400
In-Reply-To: <20110516094324.GA5344@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 12:43 PM, Jan Kara <jack@suse.cz> wrote:
> On Sat 14-05-11 13:16:25, Amir Goldstein wrote:
>> Sent from my iPhone
>>
>> On 14/05/2011, at 10:11, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> >On Sat, May 14, 2011 at 1:49 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> >>On Fri, May 13, 2011 at 08:25:02PM +0300, Amir Goldstein wrote:
>> >>>
>> >>>After xfstests failed to build on Ubuntu 10.10, I followed the
>> >>>advice omitted by the build script to run "make install-qa", to
>> >>>solve the problem. =A0It took me a while to figure exactly where =
I
>> >>>should run the command, but in the end I pulled the xfsprogs tree=
,
>> >>>ran "make; make install; make install-qa" and from there on thing=
s
>> >>>were looking better.
>> >>
>> >>I did that, but fsstress doesn't pull in the needed xfs/xfs_fs.h
>> >>header file. =A0So it still dies.
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 - Ted
>> >>
>> >
>> >Well, anyway, the regression has to be from commit =A021f97697:
>> >
>> >ext4: remove unnecessary [cm]time update of quota file
>> >
>> >because before that commit ext4_quota_off() was too short to
>> >have a bug at ext4_quota_off+0x42/0xd0.
>> >
>> >Jan, where are you? don't make me debug this...
>>
>> So I guess that Jan's patch is missing
>> If (!inode)
>> =A0 =A0 goto out;
> =A0Exactly, that is it. I cannot trigger the problem anymore with the=
 patch.
> I just wonder how come you've spotted the problem because test 232 do=
es not
> trigger the problem for me -

It does not surprise me.
As I wrote earlier, my system (Ubuntu 11.4) is behaving strange.
Some tests fail the fsck at the end, because the filesystem fails to um=
ount
immediately after the test (lsof shows nothing and manual umount succee=
ds).
It's probably the cause for 232 test to fail (even after the crash was =
fixed)
and the cause for quotaoff to be called without quotaon in test 232 on
my system.

> it is triggered when you run quotaoff without
> running quotaon and that does not happen with test 232.. Anyway, with=
 the
> attached patch running quotaoff on filesystem without quotas turned o=
n
> works fine whereas previously it oopsed.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
