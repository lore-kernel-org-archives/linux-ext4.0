From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 2 Aug 2011 20:52:56 +0300
Message-ID: <CAOQ4uxgKzpCp_xnr9Y+Fp3+N4GwTacGQYupGY_o+SFDZYjgiGQ@mail.gmail.com>
References: <CAOQ4uxiFaEvC0WpZH_bVp-Thhv0TMADNabd2pcr9pENfufDLoA@mail.gmail.com>
	<20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
	<20110802165757.GD2967@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Round Robinjp <roundrobinjp@yahoo.co.jp>,
	Andreas Dilger <aedilger@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33755 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab1HBRw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 13:52:58 -0400
Received: by wyg8 with SMTP id 8so8802wyg.19
        for <linux-ext4@vger.kernel.org>; Tue, 02 Aug 2011 10:52:57 -0700 (PDT)
In-Reply-To: <20110802165757.GD2967@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 2, 2011 at 7:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 03, 2011 at 01:07:08AM +0900, Round Robinjp wrote:
>> So that means I have thrown away some important part of
>> the filesystem when I did truncate -s 1G, isn't it?
>> Will things go wrong if I flash this 1G image to my eMMC
>> partition (without using Yongqiang's new 64bit resize patches)?
>> I need to understand whether Yongqiang's patch is absolutely
>> necessary for this purpose or just a good thing to have.
>
> This is one of the reasons why I originally suggested using zero_free
> and make_sparse to write the file system image. =A0It's a much, much,
> MUCH simpler way of handling things, and it doesn't require resizing
> the file system image, using truncate (and making sure you truncate t=
o
> the right size, etc.).
>
> With the method Amir talked about, it matters whether or not the file
> system is mounted when you use resize2fs, whether you have the latest
> resize patches, etc., etc.
>

I think it is fair to say that with if there are no constrains on the m=
ethods
used throughout the process, the zero_free + make_sparse is MUCH simple=
r.

However, my method is targeting an a-symmetric environment, where the
person or organization  responsible for generating the stock image
have unlimited
resources and knowledge, while the person or organization  responsible =
for
burning that image to hundreds of devices are less capable or bound to =
using old
legacy systems, who just know how to burn an image of size N.

Maybe Round can share more about the constrains of his environment.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
