From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on percpu_counter_batch
Date: Fri, 26 Aug 2011 07:48:52 -0400
Message-ID: <A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
References: <20110826072622.406d3395@kryten> <20110826072927.5b4781f9@kryten>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger.kernel@dilger.ca, eric.dumazet@gmail.com, tj@kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110826072927.5b4781f9@kryten>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Aug 25, 2011, at 5:29 PM, Anton Blanchard wrote:

>=20
> When testing on a 1024 thread ppc64 box I noticed a large amount of
> CPU time in ext4 code.
>=20
> ext4_has_free_blocks has a fast path to avoid summing every free and
> dirty block per cpu counter, but only if the global count shows more
> free blocks than the maximum amount that could be stored in all the
> per cpu counters.
>=20
> Since percpu_counter_batch scales with num_online_cpus() and the maxi=
mum
> amount in all per cpu counters is percpu_counter_batch * num_online_c=
pus(),
> this breakpoint grows at O(n^2).

I understand why we would want to reduce this number.   Unfortunately, =
the
question is what do we do if all 1024 threads try to do buffered writes=
 into
the file system at the same instant, when we have less than 4 megabytes
of space left?

The problem is that we can then do more writes than we have space, and
we will only find out about it at write back time, when the process may=
 have
exited already -- at which point data loss is almost inevitable.  (We c=
ould
keep the data in cache and frantically page the system administrator to
delete some files to make room for dirty data, but that's probably not =
going
to end well=85.)

What we can do if we must clamp this threshold is to also increase the
threshold at which we shift away from delayed allocation.  We'll then
allocate each block at write time, which does mean more CPU and=20
less efficient allocation of blocks, but if we're down to our last 4 me=
gabytes,
there's probably not much we can do that will be efficient as far as
block layout anyway=85.

-- Ted
