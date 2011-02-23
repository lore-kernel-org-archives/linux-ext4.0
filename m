From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 05:44:27 +0100
Message-ID: <20110223044427.GM21917@bitwizard.nl>
References: <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:19067 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753462Ab1BWEo3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 23:44:29 -0500
Content-Disposition: inline
In-Reply-To: <20110222221304.GH2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 05:13:04PM -0500, Ted Ts'o wrote:
> On Tue, Feb 22, 2011 at 09:32:28AM -0700, Andreas Dilger wrote:
> > 
> > Any idea what the hash size does to memory usage?  I wonder if we
> > can scale this based on the directory count, or if the memory usage
> > is minimal (only needed in case of tdb) then just make it the
> > default. It definitely appears to have been a major performance
> > boost.
> 
> Yeah, that was my question.  Your patch adds a magic number which
> probably works well on your machine (and I'm not really worried if
> someone has less than 1G --- here's a quarter kid, buy your self a
> real computer :-).  But I wonder if we should be using a hash size
> which is sized automatically depending on available memory or file
> system size.

I fully agree that having "magic numbers" in the code is a bad thing.
A warning sign. 

I don't agree with your argument that 1G RAM should be considered
minimal. There are storage boxes (single-disk-nas systems) out there
that run on a 300MHz ARM chip and have little RAM. Some of them use
ext[234].

For example: http://iomega.nas-central.org/wiki/Main_Page

64Mb RAM. I'm not sure wether that CPU is capable of virtual memory.

I just mentioned this one because a friend brought one into my office
last week. I don't think it happens to run Linux. On the other hand,
some of the "competition" do run Linux.

As to the "disadvantage" of using a large hash value: 

As far as I can see, the library just seeks to that position in the
tdb file. With 32-bit file offsets (which is hardcoded into tdb), that
means the penalty is 4*hash_size of extra disk space. So with my
currently suggested value that comes to 4Mb.

As my current tdb database amounts to 1.5Gb I think the cost is
acceptable.

With the number of keys up to 1 million, we can expect a speedup of
1M/131 = about 7500. Above that we won't gain much anymore. 

This is assuming that we have a next-to-perfect hash function. In fact
we don't because I see about a 30% hash bucket usage. And I surely
think my fsck has used over 1M of the keys....

I just tested the hash function: I hashed the first 10 million numbers
and got 91962 unique results (out of a possible 99931). That's only
about 10%. That's a lot worse than what e2fsck is seeing. And this is
the simplest case to get right.

Here is my test program. 

#include <stdio.h>
#include <stdlib.h>
typedef unsigned int u32;

/* This is based on the hash algorithm from gdbm */
static unsigned int default_tdb_hash(unsigned char *key)
{
        u32 value;      /* Used to compute the hash value.  */
        u32   i;        /* Used to cycle through random values. */

        /* Set the initial value from the key size. */
        for (value = 0x238F13AF * 4, i=0; i < 4; i++)
                value = (value + (key[i] << (i*5 % 24)));

        return (1103515243 * value + 12345);
}



int main (int argc, char **argv)
{
  int i; 
  int max = 1000000; 

  if (argc > 1) max = atoi (argv[1]);
  for (i=0;i < max;i++) {
    printf ("%u %u\n", i, default_tdb_hash ((unsigned char *)&i) % 99931);
  }
  exit (0);
}

and here is the commandline I used to watch the results.

./a.out 10000000 | awk '{print $2}' | sort | uniq -c |sort -n  | less

It seems my "prime generator" program is wrong too. I had thought to
choose a prime with 99931, but apparently it's not prime. (13*7687).
Which, for hashing should not be too bad, but I'll go look for a
prime and check again. Ok. Hash bucket usage shot up: 16%. 

I just "designed" a new hash function, based on the "hash" page on
wikipedia.


static unsigned int my_tdb_hash(unsigned char *key)
{
        u32 value;      /* Used to compute the hash value.  */
        u32   i;        /* Used to cycle through random values. */

        /* Set the initial value from the key size. */
        for (value = 0, i=0; i < 4; i++)
                value = value * 256 + key[i] + (value >> 24) * 241;

        return value;
}


It behaves MUCH better than the "default_tdb_hash" in that it has 100%
bucket usage (not almost, but exaclty 100%). It's not that hard to get
right.

The "hash" at the end (times BIGPRIME + RANDOMVALUE) in the original
is redundant. It only serves to make the results less obvious to
humans, but there is no computer-science relevant reason.

I'll shoot off an Email to the TDB guys as well. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
