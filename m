From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How to use new "native 4k sector sized" HDD with ext4
Date: Tue, 30 Oct 2012 09:36:54 -0500
Message-ID: <508FE606.9040405@redhat.com>
References: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com> <20121030142245.GB5972@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>, adilger@dilger.ca,
	Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2J3OhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 10:37:08 -0400
In-Reply-To: <20121030142245.GB5972@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/30/12 9:22 AM, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 06:27:52PM +0530, Ashish Sangwan wrote:
>>
>> In mkfs.xfs there is option "-s", using which, one can set the sector size.
>> What is the use case of this option?
>>
>> Also, such option is not present for ext4. So, apart from aligining the
>>  partition on multiple of 8 sector numbers do we have to do something else
>>  for using 4k sectors?
> 
> The equivalent option for ext4 is -b (which we call the block size).
> It defaults to 4k for all but the very smallest file systems, where
> space efficiency (especially if you are storing a large number of
> small files on say, a 1.44 megabyte floppy) becomes more important.
> For file system smaller than 512mb, we use the smallest possible block
> size supported by ext2/3/4, which is 1k.  (This is configurable; see
> /etc/mke2fs.conf; "small" file systems are ones smaller than 512mb,
> while "floppy" file systems are ones smaller than 4mb.  You can change
> the defaults in the configuration file, or you can specify explicit
> settings via the command-line options as documented in the mke2fs man
> page.

One thing I noticed is that if mkfs.ext4 self-selects a block size based
on device size, it ignores the physical block size and does not warn
about it:

# mkfs.ext4 /dev/sde
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
...

For tiny filesystems, performance is probably not a big deal though.

>> Is there any way to make sure that ext4 is indeed using 4k sectors?
> 
> You can use dumpe2fs to look at the file system parameters.  The
> confusion here is caused by the fact that xfs uses sector size where
> ext 2/3/4 follows the BSD Fast File System convention of using the
> terminology of "block size".

Well, xfs uses both, actually.

       -b block_size_options
              This option  specifies  the  fundamental  block  size
              of the filesystem. 

       -s sector_size
              This  option  specifies  the  fundamental sector size
              of the filesystem. 

but the man page doesn't do a great job of describing when one or
the other comes into play.

> XFS supports using the minimum sector size of 512 bytes by default
> since it means that if you are store large number of small files
> (i.e., only one or two 512 byte sectors), there is less wasted space.

The bigger issue here is on XFS is that even for a 4k block size fs,
XFS will issue some 512 IOs.  That's why there's a separate switch
and separate heuristics for bumping it up on 4k devices - separate
from the block size itself.

-Eric 

