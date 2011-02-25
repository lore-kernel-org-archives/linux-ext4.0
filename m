From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 23:24:33 +0200
Message-ID: <AANLkTi=j2LCgORZPdusuCEvo55Bed6CVJp0yFwEy7dGa@mail.gmail.com>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
	<1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca>
	<CE75B187-E5BB-444E-9256-4DBF96B6DCDA@mit.edu>
	<AANLkTinYzZo+uxjZhO8VKu88UfBJ3RZQhfQK5qaHPwh-@mail.gmail.com>
	<20110225190436.GZ2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63566 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1BYVYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 16:24:34 -0500
Received: by qwd7 with SMTP id 7so1555326qwd.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Feb 2011 13:24:34 -0800 (PST)
In-Reply-To: <20110225190436.GZ2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 9:04 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Feb 25, 2011 at 08:05:43PM +0200, Amir Goldstein wrote:
>>
>> I like your design. very KISS indeed.
>> I am just wondering why should BIGALLOC be INCOMPAT and not RO_COMPA=
T?
>> After all, ro mount doesn't allocate and RO_COMPAT features are so m=
uc
>> =A0nicer...
>
> I can try to make it be RO_COMPAT, but one thing my design changes is
> that a block group will contain 32768 allocation blocks; so assuming =
a
> 4k blocks, instead of a block group containing a maximum of 32,768 4k
> blocks comprising 128 MB, a block group would now contain 32,768 1M
> blocks, or 32 GiB, or 8,388,608 4k blocks.
>
> I'm pretty sure that existing kernels have superblock sanity checks
> that will barf if they see this. =A0Still, yeah, I can try allocating
> this as a ROCOMPAT feature, and later on, if people really care, they
> can patch older kernels so they won't freak out when they see a
> BigAlloc file system and can thus successfully mount it read-only.
>
> (Right now existing kernels will complain when s_blocks_per_group is
> greater than blocksize*8.)
>

no problem. just rename s_blocks_per_group to s_bigblocks_per_group
to be compatible with old kernels.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
