From: Michael Rubin <mrubin@google.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against
	power failures.
Date: Wed, 1 Jul 2009 11:31:12 -0700
Message-ID: <532480950907011131o7e9fc8bdn64002f130cc9615d@mail.gmail.com>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
	 <f3177b9e0907011107q17507be5icae2c1105faf4800@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shaozhi Ye <yeshao@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:25392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZGASbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 14:31:12 -0400
In-Reply-To: <f3177b9e0907011107q17507be5icae2c1105faf4800@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 1, 2009 at 11:07 AM, Chris Worley<worleys@gmail.com> wrote:
> On Tue, Jun 30, 2009 at 5:27 PM, Shaozhi Ye<yeshao@google.com> wrote:
> This looks like a very valuable project. =A0I do lack understanding o=
f
> how certain problems that very much need to be tested will be tested.
> From your pdf:
>
> =A0 =A0 =A0 "Data loss: The client thinks the server has A while the =
server
> does not."
>
> I've been wondering how you test to assure that data committed to the
> disk is really committed?

What we are trying to capture is what the users perceives and can
expect in our environment. This is not an attempt to know the moment
the OS can guarantee the data is stored persistently. I am not sure if
that's feasible to do with write caching drives today.

This experiment's goal as of now is not to know the exact moment in
time "when the data is committed". It has two goals. The first to
assure ourselves there is no strange corner case making ext4 behave
worse or unexpectedly compared to ext2 in the rare event of a power
failure. And to deliver expectations to our users on the
recoverability of data after the event.

=46or now we are employing a client server model for network exported
sharing in this test. In that context the App doesn't have a lot of
methods to know when the data is committed. I know of O_DIRECT, fsync,
etc. Given these current day interfaces what can the network client
apps expect?

After we have results we will try to figure out if we need to develop
new interfaces or methods to improve the situation and hopefully start
sending patches.

> I just don't see a method to test this, but it is so critically impor=
tant.

I agree.

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
