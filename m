From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 17:51:22 +0530
Message-ID: <CAKLKtzeo1x+0Kxd0+29yqvXh4FBiS+p=T7b1-BWb6HXH5e1hhQ@mail.gmail.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
	<1339411562-17100-2-git-send-email-saugata.das@stericsson.com>
	<1339414891.2401.12.camel@sauron.fi.intel.com>
	<20120611122736.GA14051@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	Arnd Bergmann <arnd.bergmann@linaro.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36889 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2FLMVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2012 08:21:23 -0400
Received: by ghrr11 with SMTP id r11so3291580ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2012 05:21:23 -0700 (PDT)
In-Reply-To: <20120611122736.GA14051@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11 June 2012 17:57, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 11, 2012 at 02:41:31PM +0300, Artem Bityutskiy wrote:
>>
>> Word "context" is very generic and it is widely used various things,=
 and
>> I believe we should try to avoid overloading this term and obfuscati=
ng
>> the I/O stack with various functions and other identifiers like
>> "get_context()". This would hurt readability. It is fine to use it
>> withing the UFS-specific code, but not globally withing the kernel c=
ode.
>>
>> I do not really have good name candidates, but even "ufscontext" is
>> already better than just "context". Or "iocontext" ? Or just "ufsdat=
a" ?
>
> Before we try naming it, can we get some more details about exactly
> how context in the eMMC context works?
>
> It appears to be a way of grouping related writes together (yes?) but
> at what granularity? =A0What are the restrictions at the device level=
?
>

Yes, the idea is to group the read, write requests for a file to a
common context so that MMC can optimize the performance.

There is no restriction on the number of blocks which can be added in
the context. However, MMC restricts the number of contexts to 15. So,
potentially, multiple file system contexts will map to single MMC
context.

> The proof-of-concept patches seem to use the inode number as a way of
> trying to group related writes, but what about at a larger level than
> that? =A0For example, if we install a RPM or deb package where all of
> the files will likely be replaced together, should that be given the
> same context?

In this patch, context is used at file level based on inode number.
So, in the above example, multiple contexts will be used for the
directory, file updates during RPM installation.

>
> How likely does it have to be that related blocks written under the
> same context must be deleted at the same time for this concept to be
> helpful?

There is no restriction that related blocks within the MMC context
needs to be deleted together

> If we have a context where it is the context assumption does
> not hold (example: a database where you have a random access
> read/write pattern with blocks updated in place) how harm will it be
> to the device format if those blocks are written under the same
> context?
>

MMC context allows the data blocks to be overwritten or randomly access=
ed

> The next set of questions we need to ask is how generalizable is this
> concept to devices that might be more sophisticated than simple eMMC
> devices. =A0If we're going to expose something all the way out to the
> file system layer, it would be nice if it worked on more than just
> low-end flash devices, but also on more sophisticated devices as well=
=2E
>

This context mechanism will be used on both UFS and MMC devices. If
there are some alternate suggestions on what can be used as context
from file system perspective, then please  suggest.


> Regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
