From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Wed, 13 Jun 2012 19:44:35 +0000
Message-ID: <201206131944.35351.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206122007.28514.arnd.bergmann@linaro.org> <20120612204128.GF12161@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: "Ted Ts'o" <tytso@mit.edu>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120612204128.GF12161@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 12 June 2012, Ted Ts'o wrote:
> On Tue, Jun 12, 2012 at 08:07:28PM +0000, Arnd Bergmann wrote:
> > Right. The danger here is that the context support was described in
> > the standard first, while none of the devices seem to even be
> > smart enough to make use of the information we put in there. Once
> > operating systems start putting some data in there, at least
> > some manufacturers will start making use of that data to optimize
> > the accesses, but it's very unlikely that they will tell us exactly
> > what they are doing. Having code in ext4 that uses the contexts will
> > at least make it more likely that the firmware optimizations are
> > based on ext4 measurements rather than some other file system or
> > operating system.
> >
> > From talking with the emmc device vendors, I can tell you that ext4
> > is very high on the list of file systems to optimize for, because
> > they all target Android products.
> 
> Well, I have a contact at SanDisk where I can discuss things under
> NDA, if that will help.  He had reached out to me specifically because
> of ext4 and Android --- he's the guy that I invited to give a talk at
> the LSF workshop last year.

Well, the Linaro storage team is in close contact with Alex Lemberg
from Sandisk, Luca Porzio from Micron and Hyojin Jeong from Samsung,
and we discussed this patch in our meeting two weeks ago and on
our Linaro mailing lists before that.

I have a good feeling about that work relationship, and they
all understand the needs of the Linux file systems, but my impression
is also that with an NDA in place we would not be able to put any
better implementation into the Linux kernel that makes use of hw
details of one of the manufacturers. Also note that the eMMC standard
is intentionally written in an abstract way to give the hardware
manufacturers the option to provide better implementations over time,
e.g. when new devices start using large amounts of cache, or replace
NAND flash with phase change memory or other technologies.

That said, I think it is rather clear what the authors of the spec
had in mind, and there is only one reasonable implementation given
current flash technology: You get something like a log structured
file system with 15 contexts, where each context writes to exactly
one erase block at a given time. This is not all that different
from how eMMC/SD/USB works already without context support, the main
difference being that the context normally gets picked based on the
LBA of the write in segments between 512KB and 16MB. Because the number
of active contexts is smaller than the number of total segments in
the device, the device keeps an LRU list of something between 5 and
30 segments.

Letting the file system pick the context number based on information
it has about the contents rather than the LBA should reduce the amount
of garbage collection if there is a stronger correlation between life
times of data written to the same context than there is between
life times of data written to adjacent LBA numbers.

The trouble with this is of course that getting the file system to
do a really good job at picking the context numbers is a harder
task than coming up with a block allocation scheme that just gets
it right for devices without context ID support ;-).

I think using the inode number is a reasonable fit. Using the
inode number of the parent directory might be more appropriate
but it breaks with hard links and cross-directory renames (we
must not use the same LBA with conflicting context numbers,
or flush the old context inbetween).

	Arnd
