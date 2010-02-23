From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [ANNOUNCE] Online Hierarchical Storage Manager (OHSM v1.2)
Date: Tue, 23 Feb 2010 20:19:56 +0530
Message-ID: <ea11fea31002230649r4b82e508n3fce3723ced0931f@mail.gmail.com>
References: <ea11fea31002222148u4abe8235q4bb7ef855044b508@mail.gmail.com>
	<20100223142735.GB7699@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, ohsm-devel@lists.sourceforge.net,
	kernelnewbies@nl.linux.org
To: Jan Kara <jack@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f177.google.com ([209.85.223.177]:58570 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0BWOuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 09:50:17 -0500
Received: by iwn7 with SMTP id 7so3132053iwn.4
        for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 06:50:16 -0800 (PST)
In-Reply-To: <20100223142735.GB7699@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 23, 2010 at 7:57 PM, Jan Kara <jack@ucw.cz> wrote:
> =A0Hello Manish,
>
>> =A0 =A0We are pleased to announce the first official functional rele=
ase of Online
>> Hierarchical Storage Manager (OHSM v1.2). =A0This is a RFC release a=
nd
>> not yet aimed at mainline inclusion.
>>
>> OHSM is a tool to manage and move data across various class of stora=
ge.
>> It can help users to selectively place and move data across tiers su=
ch
>> as SSD, Raid 10, Raid 6 based on the attributes of the data. OHSM
>> supports background movement of data
>> without any visible change in a files namespace to users and user ap=
plications.
>> OHSM is built as an external module with recompilation required for
>> ext4. The current version of OHSM is based upon kernel 2.6.32.2
>>
>> This release includes 3 core kernel patches:
>>
>> 1) An initial ext4 patch to adjust ext4's block allocation to use a
>> preferred block range per Ted
>> Tso's Dec 2008 write-up
>> (http://markmail.org/message/qp7zjhhdzxum7rfn). =A0This patch is not
>> ohsm specific.
>> 2) A ohsm specific ext4 patch to provide callouts to the ohsm module=
=2E
>> 3) The ohsm module itself
>>
>> The source code for OHSM v1.2 is freely distributable under GPL.
>> The latest stable OHSM v1.2 is available at :
>> http://sourceforge.net/projects/ohsm/files/OHSMv1.2.tar.gz/download
>> Sources are available as git repository at :
>> git://ohsm.git.sourceforge.net/gitroot/ohsm/ohsm
> =A0Looking at the code, the code deciding where to put a given file i=
sn't
> really tied to ext4, is it?
Hi Jan,

ext4 was our default choice to get started, because of the ioctls
provided by Akira and since e4defrag already exists it was much easier
for us to refer. Though we have tried to keep the OHSM code as
independant as possible so that it would be possible to support other
filesystems in future too.

> =A0Using pathnames to decide where to put files is ... natural but it=
 has
> its downsides. For example your code in build_path() is racy because =
the
> directory hiearchy can change while you climb the tree - not mentioni=
ng the
> fact that the static buffer of 4096 for pathname is ugly and implemen=
ting
> that simple walk recursively isn't good either. Kernel already has a =
d_path
> function for constructing path in at least somewhat reliable way.

Thanks a lot for your feedback. We have fixed some bugs recently to
get rid of static allocations so they will go away. I will have a look
at d_path().

> =A0Anyway I suggest you have a look at Tomoyo which implements pathna=
me based
> security module so that you can avoid mistakes they did...

Sure, will do. Definitely it will help us learn more and make the code
base better.

Thanks -
Manish

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
>



--=20
Thanks -
Manish
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[$\*.^ -- I miss being one of them
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
