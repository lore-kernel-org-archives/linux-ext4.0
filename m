From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 20:25:02 +0300
Message-ID: <BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
	<20110513145608.GA21165@thunk.org>
	<4DCD4D5E.6050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55864 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745Ab1EMRZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 13:25:04 -0400
In-Reply-To: <4DCD4D5E.6050307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 6:25 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 5/13/11 9:56 AM, Ted Ts'o wrote:
>> On Fri, May 13, 2011 at 12:17:03PM +0300, Amir Goldstein wrote:
>>>
>>> Can anyone try to reproduce the error with xfstest 005 and the cras=
h
>>> with xfstest 232?
>>
>> Xfstest #5 broke because of a change in the VFS, which now allows up
>> to 40 nested symlinks. =A0So that's a matter of your xfstests being =
too
>> old.
>>
>> The version of xfstests I've been using on my KVM box is too old to
>> have test 232, so I haven't been able to test it. =A0I've been tryin=
g to
>> use a newer version of xfstests, but xfstests doesn't build on eithe=
r
>> Ubuntu 10.04 (LTS), Debian stable, or Debian unstable, due to the us=
e
>> of newer XFS ioctl's and xfsctl's that aren't defined in the system
>> header files. =A0The fact that it doesn't work on Ubuntu LTS and Sta=
ble
>> is not that surprising, I suppose, but I was a bit disappointed that
>> it doesn't work on Debian unstable.
>
> I missed that bug report :) =A0If you can send me the details of the
> failures we can probably add configure tests for any new ioctls
> that are causing build failures.
>
>> Since I don't have a Fedora system handy --- which header file are
>> things like "struct xfs_flock64" supposed to be defined these days?
>
> Hm, well, on my Fedora system, /usr/include/xfs/xfs_fs.h, from xfspro=
gs-devel.
>
> I don't think that has changed in a very long time...
>
> I also package an xfsprogs-qa-devel which has some additional pieces =
in
> it to support xfstests. =A0Debian could do the same ... "make install=
-qa"
> in xfsprogs puts those bits into the root.
>

After xfstests failed to build on Ubuntu 10.10,  I followed the advice =
omitted
by the build script to run "make install-qa", to solve the problem.
It took me a while to figure exactly where I should run the command,
but in the end I pulled the xfsprogs tree, ran "make; make install;
make install-qa"
and from there on things were looking better.

Amir.

> -Eric
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
