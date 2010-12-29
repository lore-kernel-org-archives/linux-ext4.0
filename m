From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Wed, 29 Dec 2010 18:12:19 +0100
Message-ID: <AANLkTi=UCqBzFuUnK5CFCo=YG4q0G51GKRr2BCeeZahv@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<20101228025937.GE10149@thunk.org>
	<AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
	<4D1A351B.5080604@redhat.com>
	<AANLkTimKy7+cYfPKKywS3FvaJMt2OYApYY8dR81uGHTN@mail.gmail.com>
	<4D1A6663.8000307@redhat.com>
	<AANLkTinu91KkrZHBU4HHkt1TJ6eEt+Zmht=vMiOuHuAf@mail.gmail.com>
	<AANLkTik-6cWLKiaho_aBNY_G85nkZaeJPnkj=RmVLgvx@mail.gmail.com>
	<AANLkTim-LOGxfrGV-S4iKQhzpdqMQ9GyqGWzvkxyx0NA@mail.gmail.com>
	<4D1B542F.9070506@ontolinux.com>
	<AANLkTinV6Wx_8+gH0zMc7Av7z_LmyOQFbnmiek5oU1ku@mail.gmail.com>
	<4D1B6217.6020300@ontolinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63777 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0L2RMV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Dec 2010 12:12:21 -0500
In-Reply-To: <4D1B6217.6020300@ontolinux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 29, 2010 at 5:30 PM, Christian Stroetmann
<stroetmann@ontolinux.com> wrote:
>> I'm talking about the code for temp file, fsync, rename. Not about
>> O_ATOMIC code.
>
> Maybe you have not understood the hints: It doesn't matter anymore about
> what you are talking unless you present code.

What code?

>>>> Each app makes it's own decision about what API to use. Supporting
>>>> atomic stuff doesn't change the behaviour of existing apps.
>>>
>>> Wrong, we are talking here in the first place about general atomic FS
>>> operations. And to guarantee atomicity you have to change general FS
>>> functions in such a way that in the end all other applications are
>>> affected,
>>
>> Why's that?
>
> read the paragraph as a whole

I have. Still wondering why.
