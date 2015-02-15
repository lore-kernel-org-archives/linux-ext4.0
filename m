From: Alireza Haghdoost <haghdoost@gmail.com>
Subject: Re: [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other generic
 file systems)
Date: Sun, 15 Feb 2015 14:27:20 -0600
Message-ID: <CAB-428=Mx8kqym601rHvdbvYkWMbdKYtoJJuAV0EN1U5JU23Mw@mail.gmail.com>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
 <CAKdFiL6XVxq-mjJd2TMkoEyE4kss5yTfWGKyeY-EZa2NDyLwFw@mail.gmail.com>
 <03D7D1CF-D733-44E1-9F88-D68878D447BF@dilger.ca> <CAKdFiL6Y0O=WTgaOQB9jaOQyVwRdnsKFc8GmNFL38WP5t-dWcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Adrian Palmer <adrian.palmer@seagate.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKdFiL6Y0O=WTgaOQB9jaOQyVwRdnsKFc8GmNFL38WP5t-dWcw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>> I think one of the important design decisions that needs to be made
>> early on is whether it is possible to directly access some storage
>> that can be updated with small random writes (either a separate flash
>> LUN on the device, or a section of the disk that is formatted for 4kB
>> sectors without SMR write requirements).
>
> This would be nice, but I looking more generally to what I call
> 'single disk' systems.  Several more complicated FSs use a separate
> flash drive for this purpose, but ext4 expects 1 vdev, and thus only
> one type of media (agnostic).  We have hybrid HDD that have flash on
> them, but the lba space isn't separate, so the FS or the DM couldn't
> very easily treat them as 2 devices.
>

Adrian,
What if vdev that has been exposed to ext4 composed out of md device
instead of regular block device ? In other words, how do you see that
these changes in EXT4 file system apply on software RAID array of SMR
drives ?

--Alireza
