From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Wed, 4 Feb 2009 09:51:07 -0500
Message-ID: <87f94c370902040651v388db0aak46d7843872d312ce@mail.gmail.com>
References: <49829A1D.5090002@rs.jp.nec.com>
	 <87f94c370901301433x3e22892n5fddbb0804bddc4@mail.gmail.com>
	 <49894CD4.4060000@rs.jp.nec.com> <20090204140911.GB14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090204140911.GB14762@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 4, 2009 at 9:09 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Feb 04, 2009 at 05:07:48PM +0900, Akira Fujita wrote:
>>> Do we want the ioctl name to be specific to defrag?  I thought Ted's
>>> goal was to make it more generic?  I can also envision this same ioctl
>>> being implemented by other file systems so EXT4 seems an inappropriate
>>> prefix.
>
> When I said generic I meant in terms of decomposing the functionality
> into multiple ioctls which each could be useful for multiple purposes.
> Not necessarily in terms of being used by other filesystem, because
> they will almost certainly have their own requirements.
>
> So for example, primitives like "allocate blocks for this inode from
> this region of the disk", or "don't allocate blocks for any inode in
> this region of disk", can be used for multiple things (such as on-line
> shrink), and not just defragmentation.
>
> I don't want to move this to the VFS layer, since it will involve huge
> amounts of time while people argue over generic issues regarding the
> interface.  Look at how long it took to settle on the FIEMAP
> interface; that's not an experience I care to repeat.

Convinced and request withdrawn.

Talking about this ioctl, can anyone say:

If the OHSM team implements a similar ioctl for ext2 and ext3 and
submits them for mainline at some point, do they have a chance of
being accepted or are ext2 and ext3 feature frozen?

Thanks
Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
