From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Tue, 11 Sep 2012 13:00:41 -0400
Message-ID: <20120911170041.GB763@thunk.org>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
 <20120910024709.GA3439@thunk.org>
 <CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com>
 <CAHSRzpDATS+yMDyw6Wts2DMjyDpJx0rVB5M8QLpKxPFUwHWzXA@mail.gmail.com>
 <CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com>
 <CAHSRzpC1SKr08yS0EvEAkS4JpoiAfZ0ab+PHkZwED02mrVbc-A@mail.gmail.com>
 <CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Terry <td3201@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50087 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758954Ab2IKRAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2012 13:00:48 -0400
Content-Disposition: inline
In-Reply-To: <CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You haven't said what kernel you are using, but this really does look
like storage device issue.  You mentioned this was a RHEL cluster?
Have you considered opening a support ticket with Red Hat?

Regards,

					- Ted
