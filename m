From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 15 Feb 2008 08:24:08 -0600
Message-ID: <47B5A088.6050801@redhat.com>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp> <20080208132657.GE3120@webber.adilger.int> <20080208145911.GA4257@infradead.org> <79B050214DA541F9A8B193C7AACC3C7B@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@MIT.EDU>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbYBOOYY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 09:24:24 -0500
In-Reply-To: <79B050214DA541F9A8B193C7AACC3C7B@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Takashi Sato wrote:
> Hi,
> 
> Christoph Hellwig wrote:
>> On Fri, Feb 08, 2008 at 08:26:57AM -0500, Andreas Dilger wrote:
>>> You may as well make the common ioctl the same as the XFS version,
>>> both by number and parameters, so that applications which already
>>> understand the XFS ioctl will work on other filesystems.
>> Yes.  In facy you should be able to lift the implementations of
>> XFS_IOC_FREEZE and XFS_IOC_THAW to generic code, there's nothing
>> XFS-specific in there.
> 
> According to Documentation/ioctl-number.txt,
> XFS_IOC_XXXs (_IOWR('X', aa, bb)) are defined for XFS like below.
> From Documentation/ioctl-number.txt:
> ----------------------------------------------------------------------------
> Code    Seq#    Include File            Comments
> ========================================================
> :                 :
> 'X'     all     linux/xfs_fs.h
> ----------------------------------------------------------------------------

It also says:

'f'     00-1F   linux/ext2_fs.h

and yet include/linux.h has:

#define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
#define	FS_IOC_SETFLAGS			_IOW('f', 2, long)

as generic vfs ioctls.  These ioctls started out as
EXT2_IOC_SETFLAGS/EXT2_IOC_GETFLAGS but they were generically useful,
other filesystems picked them up, and they were "elevated" to the vfs.

> So XFS_IOC_FREEZE and XFS_IOC_THAW cannot be lifted to generic code simply.

It would be a simple matter of changing the documentation, I think.

> I think we should create new generic numbers for freeze and thaw
> like FIBMAP as followings.
> linux/fs.h:
> #define FIFREEZE _IO(0x00,3)
> #define FITHAW   _IO(0x00,4)
> 
> And xfs_freeze calls XFS_IOC_FREEZE with a magic number 1, but what is 1?

Looks like it's called "level" but it's probably a holdover, it doesn't
look like it's used.

> Instead, I'd like the sec to timeout on freeze API in order to thaw
> the filesystem automatically.  It can prevent a filesystem from staying
> frozen forever.
> (Because a freezer may cause a deadlock by accessing the frozen filesystem.)

I'm still not very comfortable with the timeout; if you un-freeze on a
timer, how do you know that the work for which you needed the fileystem
frozen is complete?  How would you know if your snapshot was good if
there's a possibility that the fs unfroze while it was being taken?

Thanks,
-Eric

> Any comments are very welcome.
> 
> Cheers, Takashi 
> 
