From: Amir Goldstein <amir73il@gmail.com>
Subject: Failure in quotaon with kernel 2.6.39 (Was: Regression with ext4 in
 kernel 2.6.39-rc7?)
Date: Thu, 26 May 2011 16:01:00 +0300
Message-ID: <BANLkTinumSvCD8PJPaC5XK24RMSAbm7WXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49893 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab1EZNBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 May 2011 09:01:02 -0400
Received: by eyx24 with SMTP id 24so279002eyx.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 May 2011 06:01:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 12:59 PM, Amir Goldstein <amir73il@gmail.com> w=
rote:
> On Mon, May 16, 2011 at 12:43 PM, Jan Kara <jack@suse.cz> wrote:
>>
>> =A0Exactly, that is it. I cannot trigger the problem anymore with th=
e patch.
>> I just wonder how come you've spotted the problem because test 232 d=
oes not
>> trigger the problem for me -
>
> It does not surprise me.
> As I wrote earlier, my system (Ubuntu 11.4) is behaving strange.
> Some tests fail the fsck at the end, because the filesystem fails to =
umount
> immediately after the test (lsof shows nothing and manual umount succ=
eeds).
> It's probably the cause for 232 test to fail (even after the crash wa=
s fixed)
> and the cause for quotaoff to be called without quotaon in test 232 o=
n
> my system.
>
>> it is triggered when you run quotaoff without
>> running quotaon and that does not happen with test 232.. Anyway, wit=
h the
>> attached patch running quotaoff on filesystem without quotas turned =
on
>> works fine whereas previously it oopsed.

So my quota tests (219 and 232) still fail (zero output from repquota)
and I realized 2 things:

1. they don't fail with kernel 2.6.38 (Ubuntu 11.4 shipped kernel)

2. what seems to fail is quotaon:

amir@qalab:~/xfstests$ sudo quotaon /mnt/test/scratch
quotaon: using /mnt/test/scratch/aquota.user on /dev/sda8
[/mnt/test/scratch]: No such process
quotaon: Quota format not supported in kernel.

Which also explains why quotaoff was called without quotaon in my
original bug report.

amir@qalab:~/xfstests$ quotaon -V
Quota utilities version 4.00-pre1.
Compiled with: USE_LDAP_MAIL_LOOKUP EXT2_DIRECT HOSTS_ACCESS
ALT_FORMAT RPC RPC_SETQUOTA BSD_BEHAVIOUR
Bugs to jack@suse.cz

Any suggestions?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
