From: Chris Worley <worleys@gmail.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against
	power failures.
Date: Wed, 1 Jul 2009 12:07:49 -0600
Message-ID: <f3177b9e0907011107q17507be5icae2c1105faf4800@mail.gmail.com>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	fs-team@google.com
To: Shaozhi Ye <yeshao@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:63207 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZGASHr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 14:07:47 -0400
In-Reply-To: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 30, 2009 at 5:27 PM, Shaozhi Ye<yeshao@google.com> wrote:
> Hi there,
>
> We are planing to evaluate the reliability and integrity of ext4
> against power failures and will post the results when its done.
> Please find attached design document and let me know if you have any
> suggestions for features to test or existing benchmark tools which
> serve our purpose.

This looks like a very valuable project.  I do lack understanding of
how certain problems that very much need to be tested will be tested.
>From your pdf:

       "Data loss: The client thinks the server has A while the server
does not."

I've been wondering how you test to assure that data committed to the
disk is really committed?

Ext4 receives the callback saying the data is committed; you need to
somehow log what it thinks has been committed and then cut power
without any time passing from the moment the callback was invoked,
then check the disk upon reboot to assure the data made it by
comparing it with the log.

I just don't see a method to test this, but it is so critically important.

Chris
>
> Thank you!
>
> --
> Shaozhi Ye
> Software Engineer Intern from UC Davis
> Cluster Management Team
> http://who/yeshao
>
