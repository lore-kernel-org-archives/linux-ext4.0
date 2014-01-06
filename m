From: Sandeep Joshi <sanjos100@gmail.com>
Subject: Re: process hangs in ext4_sync_file
Date: Mon, 6 Jan 2014 20:38:05 +0530
Message-ID: <CAEfL3K=TZYW0GQgqUBPjaL1T4y8tEG-Kxkdn2_gv+N_rdK3fLg@mail.gmail.com>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
	<CAEfL3K=vEaZ+-pj=QCogJvcvf0xgsEsAT9DX8eExMjSiNmcNLQ@mail.gmail.com>
	<20140106143203.GA13648@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38493 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAFPIG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jan 2014 10:08:06 -0500
Received: by mail-ig0-f176.google.com with SMTP id k19so7440071igc.3
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jan 2014 07:08:06 -0800 (PST)
In-Reply-To: <20140106143203.GA13648@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 6, 2014 at 8:02 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jan 06, 2014 at 03:58:58PM +0530, Sandeep Joshi wrote:
>> I reported a problem with process hanging in ext4 sync on a SSD a few weeks ago
>> See this thread http://www.spinics.net/lists/linux-ext4/msg40369.html
>>
>> That was on a SSD with discard option enabled.  I was asked to turn
>> that off which I did and never hit the issue again.
>>
>> Today I saw the same problem on an ext4 filesystem mounted on a loop
>> device.  The stack is *identical*.
>
> What model SSD are you using?  This looks like the we're just waiting
> for the SSD to acknowledge that the write has been completed.  This
> really smells like a case of a crappy SSD....
>
>                                         - Ted

Ted,

Forgot to mention that in this case the loop device was on a hard
device on my laptop.
No SSD involved in this failure.

-Sandeep
