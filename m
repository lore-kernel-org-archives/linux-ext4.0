From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Wed, 5 May 2010 03:03:05 +0200
Message-ID: <q2x18730dc51005041803jf31e911et6a3e92b2be31e2f6@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
	 <87eihr4f24.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@halobates.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:58540 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab0EEBDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 21:03:09 -0400
Received: by bwz25 with SMTP id 25so2593400bwz.28
        for <linux-ext4@vger.kernel.org>; Tue, 04 May 2010 18:03:06 -0700 (PDT)
In-Reply-To: <87eihr4f24.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 4, 2010 at 9:55 PM, Andi Kleen wrote:
> "Amir G." writes:
>>
>> Since the snapshot support patches do not fall into standard patch
>> categories (feature/bug fix),
>
> What is it then?

It is in fact a rather big feature, that is, built-in snapshot support for Ext3.
However, since I did not expect such a big feature to be added to Ext3
in its current state of development,
I chose to introduce the feature as a new f/s which was branched from Ext3.

>
>> I would like to request your advise on the best way to move forward
>> with code review.
>
> The typical way to get code review is to post patches to the mailing
> list.
>
> However do it in smaller batches if you have a lot of them.
>

Very well, I will do that. I just figured there's not much sense in
reviewing the patches before
reading the basic design concepts in the wiki.

Thanks,
Amir.
