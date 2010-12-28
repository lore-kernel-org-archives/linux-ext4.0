From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Tue, 28 Dec 2010 23:25:42 +0100
Message-ID: <AANLkTimKy7+cYfPKKywS3FvaJMt2OYApYY8dR81uGHTN@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<20101228025937.GE10149@thunk.org>
	<AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
	<4D1A351B.5080604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0L1WZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 17:25:44 -0500
In-Reply-To: <4D1A351B.5080604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 8:06 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> I really think that you have missed the point of this list.
>
> This list is for either developers (those who have downloaded the free code
> and work on it) or others who want to move things forward concretely.

Maybe.

> Perfectly fine to contribute ideas, but if you are not a coder or do not
> have the time or inclination to work on things yourself, you have to be
> *really* convincing.
>
> We continually get bombarded with ideas, wish list items, etc so we are not
> lacking in work to do.

I understand.

> If you cannot explain the use case, you will not get any buy in...

I assumed that preserving file owner would be a normal feature and
would not require additional explanation.
One use case would be updating a file in a save way when you have
write access to that file but not to anything else.

Also, according to Ted, a lot of app devs get saving a file in a safe
way wrong. So I'm asking what the recommended way to do it is. Is that
strange?

Olaf
