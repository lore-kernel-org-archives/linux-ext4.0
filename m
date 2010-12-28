From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Atomic file data replace API
Date: Tue, 28 Dec 2010 14:06:03 -0500
Message-ID: <4D1A351B.5080604@redhat.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>	<20101228025937.GE10149@thunk.org> <AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0L1TGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Dec 2010 14:06:07 -0500
In-Reply-To: <AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/28/2010 12:27 PM, Olaf van der Spek wrote:
> On Tue, Dec 28, 2010 at 3:59 AM, Ted Ts'o<tytso@mit.edu>  wrote:
>> On Mon, Dec 27, 2010 at 12:51:54PM +0100, Olaf van der Spek wrote:
>>> Since the introduction of ext4, some apps/users have had issues with
>>> file corruption after a system crash. It's not a bug in the FS AFAIK
>>> and it's not exclusive to ext4.
>>> Writing a temp file, fsync, rename is often proposed.
>>> But how does one preserve meta-data, including file owner?
>> What's the use case where preserving file ownership matters?
> Why is it you ignore most of the question and only challenge a tiny bit?
> I can't think of a problem case right now, but I sure can't guarantee
> always resetting file owner is never a problem.
>
> Olaf


I really think that you have missed the point of this list.

This list is for either developers (those who have downloaded the free code and 
work on it) or others who want to move things forward concretely.

Perfectly fine to contribute ideas, but if you are not a coder or do not have 
the time or inclination to work on things yourself, you have to be *really* 
convincing.

We continually get bombarded with ideas, wish list items, etc so we are not 
lacking in work to do.

If you cannot explain the use case, you will not get any buy in...

Regards,

Ric

