From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Atomic file data replace API
Date: Mon, 27 Dec 2010 19:20:23 +0200
Message-ID: <AANLkTim4JYmP1ECRzHzM90ZWA2NgEt5RSCN9nn0QJDC0@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<AANLkTikXAFV6SjWT1gdsR9jZkV+zHr-eFZ0NVFrSEQdg@mail.gmail.com>
	<AANLkTin6U1HRR3R8N9hLzkKbtEcG8RMSxLgtS84ZyCOC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44665 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab0L0RUY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 12:20:24 -0500
In-Reply-To: <AANLkTin6U1HRR3R8N9hLzkKbtEcG8RMSxLgtS84ZyCOC@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 5:53 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> On Mon, Dec 27, 2010 at 2:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> So as I wrote you on the previous thread, in Ext4 you can probably
>
> FS-specific code should of course be avoided in normal apps.
>
>> It is a more granular version of the exchangedata() BSD API mentioned
>> in the previous thread:
>> http://www.manpagez.com/man/2/exchangedata/
>>
>> So the atomic update is: write(tempfd); fdatasync(tempfd);
>> exchangedata(tempfd, fd)
>
> Except exchangedata is not (widely) implemented?

Not in Linux anyway.

> Don't you agree it's undesirable to lose meta-data?

Yes I agree. you can have my vote for "it's nice to have this",
but the fact that we did without it for so long must mean something...

Anyway, you need to convince someone to implement it
(unless you do it yourself), some developers to review it
and the maintainers to accept it, so unless you come up with 'a real
world problem',
the busy FS developers will not be bothered to accept 'the fix'.
Accepting new API's has a huge price of testing them and maintaining them
every release, so don't take the resistance personally.

Now let's say that you decide to focus on the problem of:
'safe editor save to a file which is not owned by you but writable by you'.
You may want to look for a specific editor which has 'safe save' functionality
(maybe LibreOffice?) and query the developers if they would like the new feature
and if they would support your proposal.

That is the way kernel development works - and for good reasons.

Amir.
