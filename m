From: jon ernst <jonernst07@gmail.com>
Subject: Re: [1/1] handle e2image offset value better
Date: Sat, 11 Jan 2014 20:08:29 +0000
Message-ID: <CAGW2f1FTQss1JcWiajsJQ4_XK8rbKRrghvQP8s970gTX21g-Vw@mail.gmail.com>
References: <CAGW2f1ES7Gji4hXEeMzCSdH3VabXU7SeD-4cg4GL6K9ArugwHw@mail.gmail.com>
	<20140111184343.GA20583@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44856 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKUIa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Jan 2014 15:08:30 -0500
Received: by mail-qa0-f53.google.com with SMTP id cm18so4616452qab.40
        for <linux-ext4@vger.kernel.org>; Sat, 11 Jan 2014 12:08:30 -0800 (PST)
In-Reply-To: <20140111184343.GA20583@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 11, 2014 at 6:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Jan 05, 2014 at 04:42:42AM +0000, jon ernst wrote:
>> current e2image cannot handle offset value as 0.
>>
>> For example,
>> e2image -aro   0 /dev/sda7 ~/e2image7
>> will return usage()
>> but
>> e2image -aro   1 /dev/sda7 ~/e2image7
>> is fine.
>
> I'm not seeing a problem;
>
>     cp /dev/null /tmp/foo.img
>     mke2fs -t ext4 -F /tmp/foo.img 100
>     e2image -aro 0 /tmp/foo.img /tmp/bar.img
>
Yes, agree. Actually I meant to send test like this:

e2image -aro 0 /tmp/foo.img

This will return usage(). As you mentioned, only "non-zero" argument
makes sense. I agree too.





> Is working just fine for me.
>
> Looking at your patch, I don't think it's correct.  We only want to go
> into "move mode" when the user has specified a single argument, and
> either the source or destination is non-zero, and of course this
> really only makes sense when we are in raw mode.
>
> That's what the code is currently doing.  If I were going to make any
> changes, I'd probably change the criteria so that we check to see if
> the source and destination offset is identical (since then it's just a
> no-op), and we should probably enforce the restriction that we only
> allow move mode when the user has specified both the -a and the -r
> option.  (Otherwise, they will destroy the data on their file system,
> which is probably not the result they were looking for.)

I tested, this restriction is there.

Thank you for your response.
Sorry for useless patch.

Jon
>
> Regards,
>
>                                                 - Ted
