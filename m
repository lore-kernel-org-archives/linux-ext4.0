From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Tue, 28 Dec 2010 18:27:17 +0100
Message-ID: <AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<20101228025937.GE10149@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101228025937.GE10149@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 28, 2010 at 3:59 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Dec 27, 2010 at 12:51:54PM +0100, Olaf van der Spek wrote:
>> Since the introduction of ext4, some apps/users have had issues with
>> file corruption after a system crash. It's not a bug in the FS AFAIK
>> and it's not exclusive to ext4.
>> Writing a temp file, fsync, rename is often proposed.
>> But how does one preserve meta-data, including file owner?
>
> What's the use case where preserving file ownership matters?

Why is it you ignore most of the question and only challenge a tiny bit?
I can't think of a problem case right now, but I sure can't guarantee
always resetting file owner is never a problem.

Olaf
