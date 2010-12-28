From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Atomic file data replace API
Date: Tue, 28 Dec 2010 17:36:19 -0500
Message-ID: <4D1A6663.8000307@redhat.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>	<20101228025937.GE10149@thunk.org>	<AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>	<4D1A351B.5080604@redhat.com> <AANLkTimKy7+cYfPKKywS3FvaJMt2OYApYY8dR81uGHTN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0L1WgX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Dec 2010 17:36:23 -0500
In-Reply-To: <AANLkTimKy7+cYfPKKywS3FvaJMt2OYApYY8dR81uGHTN@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/28/2010 05:25 PM, Olaf van der Spek wrote:
> On Tue, Dec 28, 2010 at 8:06 PM, Ric Wheeler<rwheeler@redhat.com>  wrote:
>> I really think that you have missed the point of this list.
>>
>> This list is for either developers (those who have downloaded the free code
>> and work on it) or others who want to move things forward concretely.
> Maybe.
>
>> Perfectly fine to contribute ideas, but if you are not a coder or do not
>> have the time or inclination to work on things yourself, you have to be
>> *really* convincing.
>>
>> We continually get bombarded with ideas, wish list items, etc so we are not
>> lacking in work to do.
> I understand.
>
>> If you cannot explain the use case, you will not get any buy in...
> I assumed that preserving file owner would be a normal feature and
> would not require additional explanation.
> One use case would be updating a file in a save way when you have
> write access to that file but not to anything else.
>
> Also, according to Ted, a lot of app devs get saving a file in a safe
> way wrong. So I'm asking what the recommended way to do it is. Is that
> strange?
>
> Olaf

I think that various developers have answered this for you several times.

As a suggestion, if you are not a kernel developer, show us specifically a bit 
of application code that demonstrates something that you want to have work 
differently.

Test it with power failure (buy an external e-sata or USB disk and pull power 
while running your app).

Ric

