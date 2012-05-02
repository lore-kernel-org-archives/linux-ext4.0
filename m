From: Ken Sumrall <ksumrall@google.com>
Subject: Re: [PATCH] Support systems without posix_memalign() and memalign()
Date: Wed, 2 May 2012 13:01:35 -0700
Message-ID: <CAJr8W+i3vjmVw5Bxh5pDveuXvkC_q6YkayuA8SfF=kjSLqEFAg@mail.gmail.com>
References: <1335983451-30160-1-git-send-email-tytso@mit.edu>
	<C93BF332-FFF4-45E1-811D-6E641F54C9BD@dilger.ca>
	<20120502194058.GA18002@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51748 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2EBUBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 16:01:37 -0400
Received: by eekc41 with SMTP id c41so319540eek.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 May 2012 13:01:36 -0700 (PDT)
In-Reply-To: <20120502194058.GA18002@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I thought this patch enabled O_DIRECT functionality on the Mac:

  http://sourceforge.net/tracker/index.php?func=3Ddetail&aid=3D3140289&=
group_id=3D2406&atid=3D102406

___
Ken


On Wed, May 2, 2012 at 12:40 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, May 02, 2012 at 12:52:06PM -0600, Andreas Dilger wrote:
>>
>> Won't this cause e.g. the 16kB/64kB blocksize regression tests to
>> fail on MacOS? =A0I've been assuming that the memalign functionality
>> is only necessary for O_DIRECT, which isn't even working on MacOS,
>> so it is enough to just return an unaligned memory chunk and it
>> will work for normal buffered IO on MacOS.
>
> Hmm, good point. =A0What we should probably do is fix things so we on=
ly
> try to use ext2fs_get_memalign() if we are doing O_DIRECT in the firs=
t
> place, since can be be overhead using ext2fs_memalign if it's not
> needed, especially if we are using valloc().
>
> I don't want to leave ext2fs_get_memalign doing something which isn't
> as the function is documented, even if it's good enough for our
> current needs and it will just work today. =A0That leaves behind an
> accident waiting to happen later on --- for example if some progam
> uses ext2fs_get_memalign() for some use other than what we currently
> assume that it will be used for...
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
