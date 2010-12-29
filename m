From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Atomic file data replace API
Date: Wed, 29 Dec 2010 11:20:17 +0200
Message-ID: <AANLkTik-6cWLKiaho_aBNY_G85nkZaeJPnkj=RmVLgvx@mail.gmail.com>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
	<20101228025937.GE10149@thunk.org>
	<AANLkTikOxXgeFKtY-1u0NAjH3ofJVxCFK-xAghjk83aR@mail.gmail.com>
	<4D1A351B.5080604@redhat.com>
	<AANLkTimKy7+cYfPKKywS3FvaJMt2OYApYY8dR81uGHTN@mail.gmail.com>
	<4D1A6663.8000307@redhat.com>
	<AANLkTinu91KkrZHBU4HHkt1TJ6eEt+Zmht=vMiOuHuAf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ric Wheeler <rwheeler@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinu91KkrZHBU4HHkt1TJ6eEt+Zmht=vMiOuHuAf@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 29, 2010 at 12:58 AM, Olaf van der Spek
<olafvdspek@gmail.com> wrote:
> On Tue, Dec 28, 2010 at 11:36 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
>> I think that various developers have answered this for you several times.
>
> Not really, unfortunately. Haven't seen a single link to code that
> shows how to do it properly.
> Temp file, fsync, rename is often mentioned but that skips the
> preserving meta-data part and this part, which you also skipped:
> One use case would be updating a file in a safe way when you have
> write access to that file but not to anything else.
>

I think it is safe to say that the *only* option you have now is "temp
file, fsync, rename".
There is no "generic atomic file data replace API in Linux", though it
is available via
private ioctl for XFS and EXT4.

You have started a bit of a storm with your previous thread, which
doesn't help you
much in moving forward in the current thread (previous thread is still
more popular).
I suggest that you humbly swallow you need to know WHY is it hard to implement
non-durable atomic API and focus your attention on the very achievable
data replace API.

IMHO, implementing atomic swap_inodes_data operation shouldn't be difficult
in most file systems (only implementation is simple, but testing and
maintaining
is not to be taken lightly).
Something along the lines of:
1. aquire inodes write/truncate locks
2. start transaction
3. check/update quota limits
4. swap inodes i_data content
5. invalidate (or swap?) inodes page caches
6. mark inodes dirty
7. end transaction & release locks

The real challenge would be to get everyone to agree on a common API
and carve it in stone to the kernel's ABI (is it just swap_inodes_data?
maybe also swap_inode_data_ranges? what about some options?)

Also, as wacky and (some say) faulty the UNIX permissions models is,
current systems have grown old with it, and even 'improving' the behavior
of some applications, may wake up sleeping monsters, so it will not
be done until enough people have pointed out security or usability
issues, which could not be solved otherwise.

In other words, until you find an *application* that wants to allow other
user to modify the content of a file and preserve it's metadata and ownership.
And unless that application cannot find a better way to achieve what it wanted
to do in the first place, or unless that application already has a
large install base
which suffers from *a problem*, you will not have proven *the need*.

Maybe preserving privileged extended attributes is *a need*.
I wouldn't know myself.

Amir.
