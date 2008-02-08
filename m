From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 8 Feb 2008 19:48:25 +0900
Message-ID: <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@MIT.EDU>, <linux-ext4@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Ted wrote:
> And I do agree that we probably should just implement this in
> filesystem independent way, in which case all of the filesystems that
> support this already have super_operations functions
> write_super_lockfs() and unlockfs().
> 
> So if this is done using a new system call, there should be no
> filesystem-specific changes needed, and all filesystems which support
> those super_operations method functions would be able to provide this
> functionality to the new system call.

OK I would like to implement the freeze feature on VFS
as the filesystem independent ioctl so that it can be
available on filesystems that have already had write_super_lockfs()
and unlockfs().
The usage for the freeze ioctl is the following.
  int ioctl(int fd, int FIFREEZE, long *timeval);
    fd:file descriptor of mountpoint
    FIFREEZE:request cord for freeze
    timeval:timeout period (second)

And the unfreeze ioctl is the following.
  int ioctl(int fd, int FITHAW, NULL);
    fd:file descriptor of mountpoint
    FITHAW:Request cord for unfreeze

I think we need the timeout feature which thaws the filesystem
after lapse of specified time for a fail-safe in case the freezer
accesses the frozen filesystem and causes a deadlock.
I intend to implement the timeout feature on VFS.
(This is realized by registering the delayed work which calls
thaw_bdev() to the delayed work queue.)

Any comments are very welcome.

Cheers, Takashi
