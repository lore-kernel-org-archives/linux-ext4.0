From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Wed, 4 Feb 2009 07:25:19 -0500
Message-ID: <87f94c370902040425w40c716eei51e90e87ee45afa0@mail.gmail.com>
References: <49829A1D.5090002@rs.jp.nec.com>
	 <87f94c370901301433x3e22892n5fddbb0804bddc4@mail.gmail.com>
	 <49894CD4.4060000@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49894CD4.4060000@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Akira,

On Wed, Feb 4, 2009 at 3:07 AM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> Hi Greg,
>
> Greg Freemyer wrote:
>>
>> On Fri, Jan 30, 2009 at 1:11 AM, Akira Fujita <a-fujita@rs.jp.nec.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> I have rewritten ext4 online defrag patches based on the comments from
>>> Ted.
>>> In the new defrag, create donor inode in the user space instead of kernel
>>> space,
>>> and then allocate contiguous blocks to it with fallocate().
>>> In kernel space, exchange the blocks between target inode and donor
>>> inode,
>>> and then copy the file data of target inode to donor inode every 64MB.
>>> The EXT4_IOC_DEFRAG ioctl becomes simpler than the old one,
>>> so it may be useful for other purposes.
>>>
>>> #define EXT4_IOC_DEFRAG                 _IOW('f', 15, struct move_extent)
>>>
>>
>
> I see.  Does EXT4_IOC_MOVE_EXT sound better for you?
>
> #define EXT4_IOC_MOVE_EXT             _IOW('f', 15, struct move_extent)

I like it better, but a core developer should weigh in.

>> Do we want the ioctl name to be specific to defrag?  I thought Ted's
>> goal was to make it more generic?  I can also envision this same ioctl
>> being implemented by other file systems so EXT4 seems an inappropriate
>> prefix.
>
> Other filesystems (e.g. xfs, btrfs) have their own defrag ioctl,
> and ext2/3 can not use this ioctl because they do not handle
> extent file, though.

I don't want ext2/3 to share any kernel code.  I do hope that
userspace code could eventually be written to exercise
EXT4_IOC_MOVE_EXT type functionality for all 3 filesystems.

Do we really need a new ioctl for each one?

> What kind of advantage do you think by moving this ioctl
> to vfs layer?

I only got interested in this code because I started monitoring the
OHSM project (http://code.google.com/p/fscops/).

They don't need defrag, but they do need the functionality of
EXT4_IOC_MOVE_EXT.  They are currently writing their code around ext2
and have a proof of concept implementation almost ready.   Each time
they add a filesystem (ext3, ext4, etc.) they will need to have a way
to trigger the block re-org from userspace.  Having a single ioctl
that can be expanded to handle more and more underlying filesystems
would benefit them.

Equally important if other users of EXT4_IOC_MOVE_EXT come along, they
may want it to be more filesystem generic.as well.

>> Thoughts?
>>
>>> struct move_extent {
>>>       int org_fd;             /* original file descriptor */
>>>       int dest_fd;            /* destination file descriptor */
>>>       ext4_lblk_t start;      /* logical offset of org_fd and dest_fd */
>>>       ext4_lblk_t len;        /* exchange block length */
>>> };
>>
>> I would also like to see .dest_fd changed to .donor_fd.
>>
>> I would like to see the ABI be more flexible and have .start be broken
>> into 2 fields:
>>
>> .start_orig
>> .start_donor
>>
>> And I don't think they should be of type ext4_lblk_t.  Something more
>> generic seems appropriate.
>>
> OK, I broke .start into .orig_start and .donor_start
> and changed the entry type from ext4_lblk_t to __u64.
> The new move_extent structure is as follows:
>
> struct move_extent {
>         int orig_fd;            /* original file descriptor */
>         int donor_fd;           /* donor file descriptor */
>         __u64 orig_start;       /* logical start offset in block for orig */
>         __u64 donor_start;      /* logical start offset in block for donor
> */
>         __u64 len;              /* exchange block length */
> };
>
> Any comments?

I like that much better.  With OHSM as an example, this gives them the
flexibility to re-org a large file even if there is not enough
freespace to alloc a full redundant copy.

> Regards,
> Akira Fujita
>

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
