From: Vivek Haldar <haldar@google.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Mon, 26 Mar 2012 15:26:28 -0700
Message-ID: <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
	<A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
	<20120324031357.GA5690@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, tim.c.chen@linux.intel.com
To: Andi Kleen <ak@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61837 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2CZW02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Mar 2012 18:26:28 -0400
Received: by iagz16 with SMTP id z16so8840680iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 26 Mar 2012 15:26:28 -0700 (PDT)
In-Reply-To: <20120324031357.GA5690@tassilo.jf.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andi --

I realized the problem soon after the original patch, and submitted
another patch to make these per cpu  counters.

http://patchwork.ozlabs.org/patch/124213/

However, looks like that fell through the cracks.

Andreas, Ted --  could you please take a look at that patch?

Andi --  perhaps you could patch it in  and check if  you still see
the hot cache line?

On Fri, Mar 23, 2012 at 8:13 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> The patch only disables the statistics counting, but not the sysfs
>> files that will now report bogus statistics. =A0I don't disagree wit=
h
>> disabling these stats, but if you are disabling the accounting you
>> should also comment out the functions in fs/ext4/super.c that are
>> printing out these statistics.
>
> Aware of that -- that is why it was just a RFC.
> The choice is between per cpu counters or completely removing them.
> I would prefer the later.
>
> -Andi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Regards,
Vivek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
