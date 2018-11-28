Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33453 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728747AbeK2DUT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 22:20:19 -0500
Reply-To: grendel@twistedcode.net
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Rainer Fiebig <jrf@mailbox.org>, linux-kernel@vger.kernel.org,
        "Andrey Jr. Melnikov" <temnota.am@gmail.com>,
        linux-ext4@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux> <20181128161033.GH31885@thunk.org>
From: Marek Habersack <grendel@twistedcode.net>
Message-ID: <80caa2dd-c630-d69b-9095-f68846e60515@twistedcode.net>
Date: Wed, 28 Nov 2018 17:18:00 +0100
MIME-Version: 1.0
In-Reply-To: <20181128161033.GH31885@thunk.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 28/11/2018 17:10, Theodore Y. Ts'o wrote:
> On Wed, Nov 28, 2018 at 04:56:51PM +0100, Rainer Fiebig wrote:
>>
>> If you still see the errors, at least the Ubuntu-kernel could be ruled out.
> 
> My impression is that some of the people reporting problems have been
> using stock upstream kernels, so I wasn't really worried about the
Also, the Ubuntu mainline kernel doesn't patch the kernel code, it merely uses Ubuntu configs to build the stock kerenel
(you can find the patches in e.g. http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.19.5/ at the top of the directory)

> Ubuntu kernel (although it could be something about the default
> configs that Ubuntu sets up).  What I was more wondering was whether
> there was something about userspace or default configs of Ubuntu.
> This isn't necessarily a *problem* per se; for examople, not that long
> ago some users were getting surprised when a problem showed up with an
> older version of the LVM2 userspace with newer upstream kernels.
> After a while, you learn to get super paranoid about making sure to
> rule out all possibilities when trying to debug problems that are only
> hitting a set of users.
> 
> 						- Ted
> 

marek
