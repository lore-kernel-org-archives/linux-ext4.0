From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Mon, 11 Jul 2011 13:01:49 +0300
Message-ID: <CAOQ4uxix-F51=w9Det-Oh=06ZkK9XHUbnQcM79HcrKZyKrw=zA@mail.gmail.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
	<CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
	<4E14CE15.90404@linux.vnet.ibm.com>
	<CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
	<2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca>
	<4E1614C1.1050209@linux.vnet.ibm.com>
	<CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
	<4E16639A.3060504@linux.vnet.ibm.com>
	<CAOQ4uxjZNduK5BtmwBnGoz=Gvr2C3twV5aPK2xhT0YSC29RYOg@mail.gmail.com>
	<20110710231337.GD5615@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39036 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1GKKBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jul 2011 06:01:51 -0400
Received: by wyg8 with SMTP id 8so2457714wyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 11 Jul 2011 03:01:50 -0700 (PDT)
In-Reply-To: <20110710231337.GD5615@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 11, 2011 at 2:13 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Jul 08, 2011 at 09:29:16AM +0300, Amir Goldstein wrote:
>>
>> Well, that really depends of the precise definition of "secure delet=
e".
>> If you agree with the "100% secure" interpretation, then your curren=
t patch
>> is "almost" correct.
>> I can see 2 things that are missing:
>> 1. ext4_unlink() will have to invoke ext4_truncate(0) directly just
>> like truncate system call does.
>> This is to prevent an attacker from keeping the protected file open
>> and preventing freeing
>> of it's data when the file is removed from the name space.
>
> Um, no. =A0This breaks Unix semantics, which is going to cause any ki=
nd
> of headaches, especially if someone sets the secure delete flag on a
> directory, and then a hapless application creates a file in said
> directory expecting standard Posix semantics.
>
> If the attacker has a handle on the file, he can just simply copy out
> the data to another file; if you're worried about someone who manages
> to open the file just 1 millisecond before you do the delete (as
> opposed 100 milliseconds, when he would have copy out the file), I
> don't think it's worth it.

Maybe it's an attacker and maybe the user just doesn't know if an appli=
cation
has a loose handle for this file.
In both cases, "truncate -s 0 mysecret && rm mysecret" would be more
full proof than "rm mysecret".
I do agree it makes more sense to do it with userspace tools in the fir=
st place.


>
>> 2. ext4_truncate() currently changes i_disksize first (and adds inod=
e
>> to orphan list)
>> and then frees the blocks. for 100% secure delete, you cannot change=
 i_disksize
>> before zeroing the blocks, so it has to be:
>> - zeroout range
>> - change i_disksize and add to orphan list
>> - free blocks
>
> What are you worried about here?

I am worried (but it doesn't keep me up at night) from orphan cleanup
after crash in the
middle of secure truncate.
Sure, if you boot with the same kernel, orphan cleanup will securely
truncate the rest
of the file, but another kernel may also non-securely truncate the
file and the accountant
will not know what hit him on judgement day.

Anyway, I don't care much for security nor for accountants, so no need
to convince me
one way or the other.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
