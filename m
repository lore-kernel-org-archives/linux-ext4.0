From: Xiang Wang <xiangw@google.com>
Subject: Re: fsck errors encountered when applying patch "ext4: fix BUG when
	calling ext4_error with locked block group"
Date: Wed, 25 Feb 2009 10:33:49 -0800
Message-ID: <d5ca277e0902251033l6a67abd3vd9deb08f52f5f3c6@mail.gmail.com>
References: <d5ca277e0902201531g6e32691cweda3fd8f6d1dbbff@mail.gmail.com>
	 <20090221012908.GC12966@mini-me.lan>
	 <532480950902201737j5162125teea57eedbd01873f@mail.gmail.com>
	 <20090221015026.GD12966@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Michael Rubin <mrubin@google.com>, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com,
	Curt Wohlgemuth <curtw@google.com>,
	Chad Talbott <ctalbott@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:9202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZBYSd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 13:33:56 -0500
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n1PIXpnn019161
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 18:33:52 GMT
Received: from wf-out-1314.google.com (wff28.prod.google.com [10.142.6.28])
	by zps36.corp.google.com with ESMTP id n1PIXnFH030911
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 10:33:49 -0800
Received: by wf-out-1314.google.com with SMTP id 28so151286wff.29
        for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 10:33:49 -0800 (PST)
In-Reply-To: <20090221015026.GD12966@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Ted,

Good news!
You are right! Taking the two commits as you suggested cleared our
bug. Thank you very much for pointing that out.

We may still be back-porting patches for a while until our internal
tree catches up with 2.6.29 or 2.6.30.
But we definitely will be much more careful in taking patches.

Thanks,
Xiang

On Fri, Feb 20, 2009 at 5:50 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Feb 20, 2009 at 05:37:35PM -0800, Michael Rubin wrote:
>> We know. Our qualifying process is not the most light weight and the
>> kernel moves fast. Normally we take a snapshot and qualify it, tryin=
g
>> to take upstream patches when we can and then also publishing bugs w=
e
>> find. The problem is that with ext4 still undergoing active dev we
>> want to be able to keep our ext4 portion of the tree as up to date a=
s
>> possible.
>
> I understand, and it's not a burden to answer questions like this. =A0=
I
> was just pointing out the effort that it will likely take to backport
> the percpu counter patches, since you will need to scan the your
> sources and make sure the behavioural changes in percpu_counter_sum
> isn't going to cause problems for you elsewhere, and that this sort o=
f
> thing is probably going to get harder as time goes by, not easier. =A0=
I
> know how painful it can be, since I've been having a hard time
> backporting fixes to the 2.6.27 stable tree.
>
> The good news is that ext4 development is settling down, so if you
> manage to take another snapshot around 2.6.29 or 2.6.30, I suspect
> life will be much easier (at least as far as backporting patches for
> ext4 is concerned.)
>
> Best regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
