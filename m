From: Dave Chinner <david@fromorbit.com>
Subject: Re: IO error semantics
Date: Mon, 18 Jan 2010 23:24:37 +1100
Message-ID: <20100118122437.GF7264@discord.disaster>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com> <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz> <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755423Ab0ARMYs@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100118060518.GA9151@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 18, 2010 at 05:05:18PM +1100, Nick Piggin wrote:
> On Mon, Jan 18, 2010 at 04:18:47PM +1100, Nick Piggin wrote:
> > We also need to remove some ClearPageUptodate calls I think (simila=
r
> > issues), so keep those in mind too. Unfortunately it looks like the=
re
> > are also a lot of filesystem specific tests of PageUptodate... but =
you
> > could also move those under the new compatibility s_flag.
> >=20
> > I don't know of a really good way to inject and test filesystem err=
ors.
> > Make request failures causes most fs to quickly go readonly or have
> > bigger problems. If you're careful like try to only fail read IOs f=
or
> > data, or only fail write IOs not involved in integrity or journal
> > operations, then test programs just tend to abort pretty quickly. D=
oes
> > anyone know of anything more systematic?
>=20
> This might be a good time to bring up IO error behaviour again. I got
> into some debates I think on Andi's hwpoison thread a while back, but
> probably not appropriate thread to find a real solution to this.
>=20
> The problem we have now is that IO error semantics are not well defin=
ed.
> It is hard to even enumerate all the issues.
>=20
> read IOs
>   how to retry? appropriate defaults should happen at the block layer=
 I
>   think. Should retry behaviour be tunable by the mm/fs, or should th=
at
>   be coded explicitly as submission retry loops? Either way does impl=
y
>   there is either similar defaults for all types (or maybe classes) o=
f
>   drivers, or some way to query/set this.

It's more complex than that - there are classes of errors to
consider as well. e.g transient vs permanent.

Transient is from stuff like FC path failures - failover can take up
to 240s to occur, and then the IO will generally complete
successfully.  Permanent errors are those that involve data loss e.g
bad sectors on single disks or on degraded RAID devices.

The action to take is generally different for different error
classes - transient errors can be retried later, while permanent
errors won't change no matter how many retries you do.  IOWs, we'll
need help from the block layer to enable us to determine the error
class we are dealing with.

>   It would be nice to be able to set fs/driver behaviour from userspa=
ce
>   too, in a generic (not driver or fs specific way). But defaults sho=
uld
>   be reasonable and similar between all, I guess.

I don't think generic handling is really possible - filesystems may
have different ways of recovering e.g. duplicate copies of data or
metadata or internal ECC that can be used to recovery the bad
region. Also, depending where the error occurs, the filesystem might
need to shutdown to be repaired....

> write IOs
>   This is more interesting. How to handle write IO errors. In my opin=
ion
>   we must not invalidate the data before an IO error is returned to
>   somebody (whether it be fsync or a synchronous write syscall).

We already pass the error via mapping_set_error() calls when the
error occurs and checking in it filemap_fdatawait_range().  However,
where we check the error we've lost all context and what range the
error occurred on. I don't see any easy way to track such an
error for later invalidation except maybe by a new radix tree tag.
That would allow later invalidation of only the specific range the
error was reported from.

>   Any
>   earlier and the app just gets RAW consistency randomly violated. An=
d I
>   think it is important to treat IO errors as transparently as possib=
le
>   until the error can be detected.
>=20
>   I happen to think that actually we should go further and not
>   invalidate the data at all. This makes implementation simpler, and
>   also allows us to retry writes like we can retry reads. It's also
>   problematic to throw out errors at that point because *sync syscall=
s
>   coming from elsewhere could result in loss of error reporting (thin=
k,
>   sys_sync).

The worst problem with this is what happens when you can't write
back to the filesystem because of IO errors, but you still allow more
incoming writes? It's not far from IO error to running out of memory
and deadlocking....

>   If we go this way, we probably need another syscall and fs helper c=
all
>   to invalidate the dirty data when we give up on retries. truncate_r=
ange
>   probably not appropriate because it is much harder to implement and
>   maybe we want to try to get at the most recent data that is on disk=
=2E

=46irst we need to track what needs invalidating...

>   Also do we need to think about O_SYNC or -o sync type of writes tha=
t
>   are implemented via writeback cache? We could invalidate the dirtie=
d
>   cache ASAP, which would leave a window where a concurrent read can =
see
>   first new, then old data. It would also kind of break the above sch=
eme
>   in case the pagecache was already dirty via a descriptor without
>   O_SYNC. It might just make sense to leave the pagecache dirty. Eith=
er
>   way it should be documented I think.

How to handle this comes down to the type of error that occurred. In
the case of permanent error, the second read after the invalidation
probably should return EIO because you have no idea whether what is on
disk is the old, the new, some combination of the two or some other
random or stale garbage....

> Do we even care enough to bother thinking about this now? (serious qu=
estion)

It's a damn hard problem and many of the details are filesystem
specific. However, if we want high grade reliability from our
systems then we have to tackle these problems at some point in time.

=46WIW, I started to document some of what I've just been talking
(from a XFS metadata reliability context) about a year and a half
ago. The relevant section is here:

http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corr=
uption#Exception_Handling

Though the entire page is probably somewhat relevant.  I only got as
far as documenting methods for handling transient and permanent read
errors, and the TODO includes handling:

	- Transient write error
	- Permanent write error
	- Corrupted data on read
	- Corrupted data on write (detected during guard calculation)
	- I/O timeouts
	- Memory corruption

If we want to handle these sort of errors, I think first we've got
to understand what we have to do. A rough outline of the approach I
was taking to the above document was:

	- work out how to detect each type of error effectively
	- determine strategies of how to report each type of error
	- find the best way to recovery from the error
	- work out what additional information was needed on disk
	  to enable successful recovery from the error.
	- work out what addition functionality was required from
	  the lower layers to allow reliable detection and recovery
	  to =E3=81=BDccur.

In the case of reporting data errors through pagecache paths, I'd add:

	- determine if the error can be handled in a generic way
	- work out how filesystem specific handlers can be invoked
	  for those that can do filesystem level recovery
	- work out how to consistently report the same result after
	  an error.

There's plenty more I could write, but I need to sleep now....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
