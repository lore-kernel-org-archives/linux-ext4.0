From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Tue, 28 Dec 2010 23:58:21 +0100
Message-ID: <AANLkTinu91KkrZHBU4HHkt1TJ6eEt+Zmht=vMiOuHuAf@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<20101228025937.GE10149@thunk.org>
	<AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
	<4D1A351B.5080604@redhat.com>
	<AANLkTimKy7+cYfPKKywS3FvaJMt2OYApYY8dR81uGHTN@mail.gmail.com>
	<4D1A6663.8000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D1A6663.8000307@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 28, 2010 at 11:36 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> I think that various developers have answered this for you several times.

Not really, unfortunately. Haven't seen a single link to code that
shows how to do it properly.
Temp file, fsync, rename is often mentioned but that skips the
preserving meta-data part and this part, which you also skipped:
One use case would be updating a file in a safe way when you have
write access to that file but not to anything else.

> As a suggestion, if you are not a kernel developer, show us specifically a
> bit of application code that demonstrates something that you want to have
> work differently.

I will.

> Test it with power failure (buy an external e-sata or USB disk and pull
> power while running your app).

The current code?
I think I'll use a VM instead of an external disk. ;)

Olaf
