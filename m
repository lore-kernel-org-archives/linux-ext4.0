From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Sun, 27 Feb 2011 20:19:13 -0800
Message-ID: <AANLkTikrte4o6QkzMZbNENjFut-Nf9XpLXjAkP88BG2r@mail.gmail.com>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
 <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca> <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
 <AANLkTim0XZe2=3AWw4Ydb8F7BQGCf+=FyjKoyadc+3yw@mail.gmail.com>
 <20110207232343.GA26289@thunk.org> <AANLkTikj9qdFJfD+c09V9duTPq_soRv_UsuBgutRHEQt@mail.gmail.com>
 <AANLkTimUhDQAcacCf8gyLn76k+RgRNs52AJbbMmpaaox@mail.gmail.com> <20110228014548.GO2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41660 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1B1ETe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 23:19:34 -0500
Received: by qyg14 with SMTP id 14so3031351qyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Feb 2011 20:19:34 -0800 (PST)
In-Reply-To: <20110228014548.GO2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 27, 2011 at 5:45 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Feb 26, 2011 at 01:35:05PM -0800, Manish Katiyar wrote:
>>
>> Is there anything else that I need to do to get this merged in your =
tree ?
>>
>
> I've added the patch with the following explanation:
>
> ext4: fix missing iput of root inode for some mount error paths
>
> This assures that the root inode is not leaked, and that sb->s_root i=
s
> NULL, which will prevent generic_shutdown_super() from doing extra
> work, including call sync_filesystem, which ultimately results in
> ext4_sync_fs() getting called with an uninitialized struct super,
> which is the cause of the crash noted in Kernel Bugzilla #26752.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D26752
>
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
>
> Sorry for the delay, but this patch was held up pending my tracingg
> through the code and understanding why this really fixed BZ #26752.
> In the future, adding a bit more detail in the commit log will help m=
e
> process the patch faster, since I won't have to reproduce your
> analysis.
>
> Also, just quoting a BZ number without going into more detail risks m=
y
> putting it the patch on my "to analyze --- when I have access to
> network" queue if I happen to come across it while on an airplane. =A0=
:-)

Hi Ted,

Thanks a lot.  That was my first bugfix :-), will keep that in mind in =
future.
--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
