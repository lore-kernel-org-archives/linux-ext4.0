From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: recursive mtime patches
Date: Wed, 13 Apr 2011 21:16:40 +0200
Message-ID: <BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
	<20110412154830.GF5246@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41260 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1DMTQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 15:16:41 -0400
Received: by qwk3 with SMTP id 3so500966qwk.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2011 12:16:40 -0700 (PDT)
In-Reply-To: <20110412154830.GF5246@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi,
>
> On Mon 11-04-11 16:37:57, Amir Goldstein wrote:
>> Do you have an uptodate version of your recursive mtime patches?
>> The only version I can find online is the original series from 2007.
> =A0I've put latest version (against 2.6.37) to
> http://beta.suse.com/private/jack/recursive_mtime/
>

Thanks, I'll see if we can use it for our application.

>> I am interested in the patches for indexdb-like application,
>> so persistence after crash is also important for my use case.
>> Your patches would require the application to perform a full
>> directory scan after crash, right?
> =A0OK, it depends. Currently, even mtime updates are not reliable (da=
ta can
> be written to a file while mtime update is not yet committed). =A0Rec=
ursive

Yes, good point.

> modification stamps have possibly larger race windows but I haven't r=
eally
> tried how much (I just know that even mtime races are not that hard t=
o
> trigger if you try). So it really depends on how big reliability do y=
ou
> expect and I personally don't find much value in just rescanning and
> checking for mtime after a crash. Reading all the data and doing chec=
ksum
> certainly has more value but at a high cost.
>

What do you thing about the approach to store recursively modified dir =
inodes in
a journal "modified inode descriptor block" and update the recursive mt=
ime of
those dirs on journal recovery?

I would also consider to use a mount option rec_mtime and then just
store recursive
mtime in the directory's inode mtime instead of an extended attribute.
That doesn't break any contract with user space, it's just a re-interpr=
etation
of the dir modification notion.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
