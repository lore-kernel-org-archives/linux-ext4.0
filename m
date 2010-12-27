From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Mon, 27 Dec 2010 19:34:01 +0100
Message-ID: <AANLkTi=iiGXziDgKS0-eOdwz8fNkVLyCH8pUcLUFLTJX@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<AANLkTikXAFV6SjWT1gdsR9jZkV+zHr-eFZ0NVFrSEQdg@mail.gmail.com>
	<AANLkTin6U1HRR3R8N9hLzkKbtEcG8RMSxLgtS84ZyCOC@mail.gmail.com>
	<AANLkTim4JYmP1ECRzHzM90ZWA2NgEt5RSCN9nn0QJDC0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41216 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0L0SeC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 13:34:02 -0500
In-Reply-To: <AANLkTim4JYmP1ECRzHzM90ZWA2NgEt5RSCN9nn0QJDC0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Don't you agree it's undesirable to lose meta-data?
>
> Yes I agree. you can have my vote for "it's nice to have this",
> but the fact that we did without it for so long must mean something...

I'm not sure it means something positive.

> Anyway, you need to convince someone to implement it
> (unless you do it yourself), some developers to review it
> and the maintainers to accept it, so unless you come up with 'a real
> world problem',
> the busy FS developers will not be bothered to accept 'the fix'.
> Accepting new API's has a huge price of testing them and maintaining them
> every release, so don't take the resistance personally.
>
> Now let's say that you decide to focus on the problem of:
> 'safe editor save to a file which is not owned by you but writable by you'.
> You may want to look for a specific editor which has 'safe save' functionality
> (maybe LibreOffice?) and query the developers if they would like the new feature
> and if they would support your proposal.
>
> That is the way kernel development works - and for good reasons.

I agree in general you need a good use case. But AFAIK FS devs are
aware of many apps not doing it the right way. So I expected them to
have a FAQ entry that shows what this right way is.
Ted says a huge performance hit is involved, but nobody has been able
to tell why yet.

There's also the problem of not having permission to create a temp file.

Olaf

Olaf
