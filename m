From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: recursive mtime patches
Date: Thu, 14 Apr 2011 10:12:26 +0300
Message-ID: <BANLkTi=NDb0U0z1C4UEE2oHvE8fVBVDp=Q@mail.gmail.com>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
	<20110412154830.GF5246@quack.suse.cz>
	<BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
	<20110413213937.GB4648@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55260 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab1DNHM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 03:12:27 -0400
Received: by gxk21 with SMTP id 21so597357gxk.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 00:12:27 -0700 (PDT)
In-Reply-To: <20110413213937.GB4648@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 12:39 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 13-04-11 21:16:40, Amir Goldstein wrote:
>> On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote:
>> > modification stamps have possibly larger race windows but I haven'=
t really
>> > tried how much (I just know that even mtime races are not that har=
d to
>> > trigger if you try). So it really depends on how big reliability d=
o you
>> > expect and I personally don't find much value in just rescanning a=
nd
>> > checking for mtime after a crash. Reading all the data and doing c=
hecksum
>> > certainly has more value but at a high cost.
>> >
>>
>> What do you thing about the approach to store recursively modified d=
ir inodes in
>> a journal "modified inode descriptor block" and update the recursive=
 mtime of
>> those dirs on journal recovery?
> =A0The trouble is you don't know the number of directories that may n=
eed
> to have timestamp updated - you find that out only as you travel upwa=
rds.
> So it's hard to reserve any fixed space for this.
>

True, but you can save *so* many inode numbers in just one descriptor
block and in case of an overflow, we can just pass a hint to the top le=
vel
application to do a full directory scan, so I hardly see that as a big =
problem.

I did not check how the "journal guided RAID resync" patches deal
with the same issue, but they store all modified data block numbers
in descriptor blocks, which is a lot more than just modified inodes.

>> I would also consider to use a mount option rec_mtime and then just
>> store recursive
>> mtime in the directory's inode mtime instead of an extended attribut=
e.
>> That doesn't break any contract with user space, it's just a re-inte=
rpretation
>> of the dir modification notion.
> =A0It breaks POSIX specification - POSIX pretty much specifies when m=
time is
> supposed to be changed - so I'm not sure we really want to do that...

I disagree, POSIX doesn't forbid a user space daemon from touching dire=
ctory
inodes and updating their mtime. The rec_mtime feature should be treate=
d as
a little kernel "daemon" which propagates information to user space by =
touching
recursively modified directories.


>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
