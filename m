From: Adrian Palmer <adrian.palmer@seagate.com>
Subject: Re: [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other generic
 file systems)
Date: Sun, 15 Feb 2015 22:02:19 -0700
Message-ID: <CAKdFiL6Gv8OGhoT6hhhAyjpzaWYxdFNMh3u0fnepVo3wh7kTkw@mail.gmail.com>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
	<CAKdFiL6XVxq-mjJd2TMkoEyE4kss5yTfWGKyeY-EZa2NDyLwFw@mail.gmail.com>
	<03D7D1CF-D733-44E1-9F88-D68878D447BF@dilger.ca>
	<CAKdFiL6Y0O=WTgaOQB9jaOQyVwRdnsKFc8GmNFL38WP5t-dWcw@mail.gmail.com>
	<CAB-428=Mx8kqym601rHvdbvYkWMbdKYtoJJuAV0EN1U5JU23Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Alireza Haghdoost <haghdoost@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAB-428=Mx8kqym601rHvdbvYkWMbdKYtoJJuAV0EN1U5JU23Mw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

That is a an issue that is on deck to explore further.  The DM needs
to manage each disk independently, but aggregate them and present it
as 1 vdev.  The trick to be figured out is in how it mixes the disks
in a ZBD aware way.  Stripes of 256Mib are easily handled, but
impractical.  Stripes of 128k are practical, but not easily handled.

I see the changes that we're exploring/implementing as working on both
an SMR drive and a conventional drive.  ZBD does not require SMR, so
the superblock and group descriptor changes should not affect
conventional drives.  In fact, the gd will mark the bg as a
conventional zone by default, but can still use the ZBD changes
(forward-write and defragmentation) without the writepointer
information.

EXT4 will need to be forward-write only as per SMR/ZBD.  If working
with a combination of drives with small stripe sizes, re-writes would
work on one drive (conventional) but not the other (SMR).  The bulk of
the change would need to be in the DM, and will likely not bleed over
to the FS.  The exception I can see is that the bg size may need to
increase to accommodate multiple zones on multiple SMR drives (768MiB
or 1GiB BGs for RAID5).  The DM would be responsible for aggregating
the REPORT_ZONE data before presenting it to the FS (which would
behave as normally expected).  Of note, the standard requires zone
size as a power of 2, so a 3-disk RAID5 may violate that on
implementation.  RAID0 has similar constraints, and RAID1 can
operating in the same paradigm with no changes to zone information.

So, in short, the DM would have to be modified to pass the aggregated
zone information up to EXT4.  I don't see much divergence in the
proposed redesign of EXT4.


Adrian Palmer
Firmware Engineer II
R&D Firmware
Seagate, Longmont Colorado
720-684-1307


On Sun, Feb 15, 2015 at 1:27 PM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
>>> I think one of the important design decisions that needs to be made
>>> early on is whether it is possible to directly access some storage
>>> that can be updated with small random writes (either a separate flash
>>> LUN on the device, or a section of the disk that is formatted for 4kB
>>> sectors without SMR write requirements).
>>
>> This would be nice, but I looking more generally to what I call
>> 'single disk' systems.  Several more complicated FSs use a separate
>> flash drive for this purpose, but ext4 expects 1 vdev, and thus only
>> one type of media (agnostic).  We have hybrid HDD that have flash on
>> them, but the lba space isn't separate, so the FS or the DM couldn't
>> very easily treat them as 2 devices.
>>
>
> Adrian,
> What if vdev that has been exposed to ext4 composed out of md device
> instead of regular block device ? In other words, how do you see that
> these changes in EXT4 file system apply on software RAID array of SMR
> drives ?
>
> --Alireza
