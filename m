From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [PATCH 0/5] ext4: RFC: Encryption
Date: Wed, 23 Jul 2014 15:39:20 -0700
Message-ID: <CA+POJK27qZeLsPu+zLDU+GmpGiY715_M1hdVxPJap9SUmydt4Q@mail.gmail.com>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
	<20140723222506.GA29033@amd.pavel.ucw.cz>
	<20140723223459.GA29197@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, hch@infradead.org,
	lczerner@redhat.com, "Theodore Ts'o" <tytso@mit.edu>,
	Tyler Hicks <tyhicks@canonical.com>,
	Serge Hallyn <serge.hallyn@canonical.com>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63569 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbaGWWjV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2014 18:39:21 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so5806204igb.8
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2014 15:39:21 -0700 (PDT)
In-Reply-To: <20140723223459.GA29197@amd.pavel.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 3:34 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2014-07-24 00:25:06, Pavel Machek wrote:
>> Hi!
>> > This patchset proposes a method for encrypting in EXT4 data read and
>> > write paths. It's a proof-of-concept/prototype only right
>> > now. Outstanding issues:
>> >
>> >  * While it seems to work well with complex tasks like a parallel
>> >    kernel build, fsx is pretty good at reliably breaking it in its
>> >    current form. I think it's trying to decrypt a page of all zeros
>> >    when doing a mmap'd write after an falloc. I want to get feedback
>> >    on the overall approach before I spend too much time bug-hunting.
>
>> Can I keep just a subtree (/home/pavel/.ssh) encrypted?
>
> Ok, as far as I can tell no, this is whole filesystem encryption for
> now. I guess encrypting based on some attribute is planned...?

Correct; that's TBD as part of the LSS discussion next month. You can see
it wouldn't be that far-fetched to add an xattr to the parent directory that
specifies the key sig to use. It's just that unexpected things can happen
with hard links.
