From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem size
Date: Tue, 1 Feb 2011 16:57:51 -0500
Message-ID: <AANLkTimRMnceeWpTy6A3h_pEYLq_meAwjOHNOojmhuJR@mail.gmail.com>
References: <1296587912-16756-1-git-send-email-lczerner@redhat.com> <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34030 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1BAV6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 16:58:11 -0500
Received: by iwn9 with SMTP id 9so6964544iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Feb 2011 13:58:11 -0800 (PST)
In-Reply-To: <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 1, 2011 at 3:37 PM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-02-01, at 12:18, Lukas Czerner wrote:
>> +Optionally, the
>> +.I filesystem-size
>> +parameter may be suffixed by one of the following the units
>> +designators: 'b', 's', 'K', 'M', or 'G',
>> +for blocks count, 512 byte sectors, kilobytes, megabytes, or gigaby=
tes,
>> +respectively.
>
> My reading of parse_num_blocks() shows that 'T' is also accepted as a=
 suffix for terabytes, which I was otherwise going to suggest be added,=
 since this is the normal size for filesystems today. =A0It might be wo=
rthwhile _briefly_ mentioning here that these are binary/power-of-two v=
alues and not decimal values, instead of the rant further below.
>
> Minor technical nit - the proper metric value is lower-case 'k' for k=
ilo, though the upper-case 'M', 'G', and 'T' are correct for mega-, gig=
a-, and terabytes.

<pedantic>
If they are powers of 2, they are: kibibytes, mebibytes, gibibytes,
and tebibytes.

See the chart on the right of: http://en.wikipedia.org/wiki/Kibibyte

Many linux tools have already moved to these names and abbreviations.
(TiB not TB, etc.)
<\pedantic>

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
