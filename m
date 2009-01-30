From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Fri, 30 Jan 2009 17:33:53 -0500
Message-ID: <87f94c370901301433x3e22892n5fddbb0804bddc4@mail.gmail.com>
References: <49829A1D.5090002@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49829A1D.5090002@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 30, 2009 at 1:11 AM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> Hi,
>
> I have rewritten ext4 online defrag patches based on the comments from Ted.
> In the new defrag, create donor inode in the user space instead of kernel space,
> and then allocate contiguous blocks to it with fallocate().
> In kernel space, exchange the blocks between target inode and donor inode,
> and then copy the file data of target inode to donor inode every 64MB.
> The EXT4_IOC_DEFRAG ioctl becomes simpler than the old one,
> so it may be useful for other purposes.
>
> #define EXT4_IOC_DEFRAG                 _IOW('f', 15, struct move_extent)
>

Do we want the ioctl name to be specific to defrag?  I thought Ted's
goal was to make it more generic?  I can also envision this same ioctl
being implemented by other file systems so EXT4 seems an inappropriate
prefix.

Thoughts?

> struct move_extent {
>        int org_fd;             /* original file descriptor */
>        int dest_fd;            /* destination file descriptor */
>        ext4_lblk_t start;      /* logical offset of org_fd and dest_fd */
>        ext4_lblk_t len;        /* exchange block length */
> };

I would also like to see .dest_fd changed to .donor_fd.

I would like to see the ABI be more flexible and have .start be broken
into 2 fields:

.start_orig
.start_donor

And I don't think they should be of type ext4_lblk_t.  Something more
generic seems appropriate.

Thoughts?

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
