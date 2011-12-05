From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Mon, 5 Dec 2011 12:09:05 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112051144530.4911@dhcp-27-109.brq.redhat.com>
References: <20111201070052.GA29708@july> <alpine.LFD.2.00.1112051106070.4911@dhcp-27-109.brq.redhat.com> <CAH9JG2WrrO105AeSwoZ9DCt3dyvqYuoefVZZJhx1YgHAFrTpCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, tm@tao.ma,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH9JG2WrrO105AeSwoZ9DCt3dyvqYuoefVZZJhx1YgHAFrTpCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 5 Dec 2011, Kyungmin Park wrote:

> On 12/5/11, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Thu, 1 Dec 2011, Kyungmin Park wrote:
> >
> >> From: Kyungmin Park <kyungmin.park@samsung.com>
> >>
> >> Now trim information doesn't stored at disk so every boot time. it's
> >> cleared.
> >> and do the trim all disk groups.
> >> But assume that it's already trimmed at previous time so don't need to
> >> trim it again. So set the intial state as trimmed.
> >
> > Hi,
> >
> > I am sorry, but from the code and comments I have seen, I do not think
> > it does make sense to change that behaviour. I agree that discarding the
> > whole file system after the mount might not be necessarily needed, but
> > on the other hand, you can never assume that the blocks were already
> > trimmed, since it most likely will not be true.
> >
> > I think that the bigger problem is "running fitrim at boot time" which
> > does not make sense to me, because you'll be perfectly fine leaving this
> > up to the cron (or something similar). Also when you're booting you need
> > to be done ASAP so why to bother with other unnecessary operations ?
> 
> Okay please ignore the boot time, but still first trim operation needs
> to be considered.
> Unlike the pc world, the phone is turned off/on frequently. at that
> time it trims all block again.

I am not sure that this is entirely true. I am turning off my pc way to
more often than my phone. But it might be just me. Also some problem
might be mounting/umounting your external flash when you plug your
phone to the pc. So I can see than the mobile world probably requires
some solution. Not sure what it should be though.

> I know it's not hurt the flash life time, but want to avoid to useless
> trim operation on flash.

Actually, with those chap flash cards I think that it might hurt its
life time, when you're doing discard way too often. But it really
depends on the wear-leveling algorithms it uses internally.

> 
> Yes, the best solution is that trim information is also stored at disk.
> Can you confirm the idea? store the trim information at bg_flags at
> struct ext4_block_desc?

I do not like the idea very much. I would rather find some "smart" way
to overcome this problem, than adding more on disk format
incompatibilities.

We know that the performance problem starts to appear when the flash
does not have enough space to write new blocks without moving old
fragments of the erase block to the new position. It essentially means
that there is not enough "free" space which is the space which is free
and which has not been used since the last discard.

We know the size of the flash (from the user space), we also know the
number of kilobytes written to the file system in case of ext4
(/sys/fs/ext4/<device>/lifetime_write_kbytes) and if we can track the
change between fitrim calls we can more-or-less determine how much
"free" space is there on the flash available to efficiently write new
block. That said, I think that some user space heuristic can be applied
to determine when is the right time tu run fitrim again and it might
significantly help to solve the problem. Some experimenting has to be
done though, to get some numbers.

Also note that you do not have to run fitrim on the whole file system.
It can be run on the part of the file system as well. though the result
might differ between the file systems (some migh discard more blocks
than requested because it is efficient to do so, or really hard to do
differently).

The idea would require some more thoughts, but what is your opinion
about this approach ? Note that it can be done purely from user space.

Thanks!
-Lukas

> 
> Thank you,
> Kyungmin Park
> >
> > The funniest thing about this patch is (no offense, really) that you've
> > solved the problem of "fitrim slowing down the boot process" by changing
> > kernel logic to assume something which will most likely be false, instead
> > of just *not* doing boot time fitrim at the first place, because this is
> > exactly what will happen with this patch.
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> >> index e2d8be8..97ef342 100644
> >> --- a/fs/ext4/mballoc.c
> >> +++ b/fs/ext4/mballoc.c
> >> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb,
> >> ext4_group_t group)
> >>  		goto err;
> >>  	}
> >>  	mark_page_accessed(page);
> >> +
> >> +	/*
> >> +	 * TRIM information is not stored at disk so set the initial
> >> +	 * state as trimmed. Since previous time it's already trimmed all
> >> +	 */
> >> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);
> >>  err:
> >>  	ext4_mb_put_buddy_page_lock(&e4b);
> >>  	return ret;
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > --
> >
> 

-- 
