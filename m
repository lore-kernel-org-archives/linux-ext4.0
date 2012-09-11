From: Terry <td3201@gmail.com>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Tue, 11 Sep 2012 12:07:14 -0500
Message-ID: <CAHSRzpCFs1GdcMkNcXpoN0Q5MnGwQuonETTv8k9kELZwSe=sWw@mail.gmail.com>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
	<20120910024709.GA3439@thunk.org>
	<CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com>
	<CAHSRzpDATS+yMDyw6Wts2DMjyDpJx0rVB5M8QLpKxPFUwHWzXA@mail.gmail.com>
	<CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com>
	<CAHSRzpC1SKr08yS0EvEAkS4JpoiAfZ0ab+PHkZwED02mrVbc-A@mail.gmail.com>
	<CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com>
	<20120911170041.GB763@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38634 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab2IKRHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2012 13:07:15 -0400
Received: by lagy9 with SMTP id y9so476868lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2012 10:07:14 -0700 (PDT)
In-Reply-To: <20120911170041.GB763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 11, 2012 at 12:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> You haven't said what kernel you are using, but this really does look
> like storage device issue.  You mentioned this was a RHEL cluster?
> Have you considered opening a support ticket with Red Hat?
>
> Regards,
>
>                                         - Ted

I just did that. RHEL 6.3 with kernel 2.6.32-279.5.2.el6.x86_64
