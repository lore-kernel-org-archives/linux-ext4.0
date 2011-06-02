From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Thu, 2 Jun 2011 13:52:12 +0900
Message-ID: <BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
References: <20101118130630.GJ6178@parisc-linux.org>
	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	<20101118141957.GK6178@parisc-linux.org>
	<20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<4CE59C9E.6050902@teksavvy.com>
	<1290177488-sup-6540@think>
	<4CE68F80.7000607@teksavvy.com>
	<20101119145748.GB27919@infradead.org>
	<4CE695FF.20601@teksavvy.com>
	<20101207092749.GA26100@infradead.org>
	<1291740643-sup-2494@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Lord <kernel@teksavvy.com>,
	James Bottomley <james.bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Chris Mason <chris.mason@oracle.com>,
	Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291740643-sup-2494@think>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 8, 2010 at 1:52 AM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Christoph Hellwig's message of 2010-12-07 04:27:49 -050=
0:
>> On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
>> > >I really hate to rely on this third party hearsay (from all sides=
), and
>> > >have implement TRIM support in qemu now. =A0I'll soon install win=
7 and
>> > >will check out the TRIM patters myself.
>> >
>> > Excellent!
>>
>> I did a Windows 7 installation under qemu today, and the result is:
>
> Great, thanks for testing this.
>
>>
>> =A0- it TRIMs the whole device early during the installation
>> =A0- after that I see a constant stream of small trims during the
>> =A0 =A0installation. =A0It's using lots of non-contiguous ranges in =
a single
>> =A0 =A0TRIM command, with sizes down to 8 sectors (4k) for a single =
range.
>> =A0- after installation there's is some background-trimming going on
>> =A0 =A0even when doing no user interaction with the VM at all.

Hi Lukas,

Now FITRIM is based on user interaction. So how about to implement the
AUTO batched discard at kernel level?
Idea is same as windows, make a single thread and iterate the
superblocks and call the trim.

here's pseudo codes.

1. generate the trim thread.
2. iterate the superblocks by iterate_supers() at fs/super.c
3. check the queue which support the discard feature or not.
blk_queue_discard(q)
4. wait on events
5. call the sb->trim (need to re-introduce it)

The difficult things are how to define the events and how to trigger
the trim thread.
e.g., notified from block layer, called from filesystem and so on.

How do you think?

Thank you,
Kyungmin Park

>> =A0- removing files leads to an instant stream of TRIMs, again vecto=
red
>> =A0 =A0and of all sizes down to 4k. =A0Note that the TRIMs are a lot=
 more
>> =A0 =A0instant than even with btrfs and -o discard, which delays mos=
t
>> =A0 =A0TRIMs until doing a sync.
>
> Btrfs will do some small trims right when the block is freed, especia=
lly
> in fsync heavy workloads but this is a suboptimal thing I want to fix=
=2E
>
> The code tries to gather a whole transaction worth of trims and do th=
em
> after the commit is done.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
