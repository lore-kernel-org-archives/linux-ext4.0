From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [dm-devel] [PATCH 0/3] freeze feature ver 1.8
Date: Tue, 1 Jul 2008 18:12:32 +0900
Message-ID: <6B16FAEFB450496A9AA95BFF27BD6AE6@nsl.ad.nec.co.jp>
References: <20080630212005t-sato@mail.jp.nec.com> <20080630135433.GA22522@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <akpm@linux-foundation.org>, <viro@ZenIV.linux.org.uk>,
	<axboe@kernel.dk>, <mtk.manpages@googlemail.com>,
	<linux-kernel@vger.kernel.org>, <xfs@oss.sgi.com>,
	<dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: "Alasdair G Kergon" <agk@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080630135433.GA22522@agk.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Alasdair G Kergon wrote:
>> Currently, ext3 in mainline Linux doesn't have the freeze feature which
>> suspends write requests.  So, we cannot take a backup which keeps
>> the filesystem's consistency with the storage device's features
>> (snapshot and replication) while it is mounted.
>> In many case, a commercial filesystem (e.g. VxFS) has
>> the freeze feature and it would be used to get the consistent backup.
>> If Linux's standard filesytem ext3 has the freeze feature, we can do it
>> without a commercial filesystem.
>
> Is the following a fair summary?

Yes, you are right.
We'd like to use the freeze feature without device-mapper/LVM.

> 1. Some filesystems have a freeze/thaw feature.  XFS exports this to
> userspace directly through a couple of ioctls, but other filesystems
> don't.  For filesystems on device-mapper block devices it is exported to
> userspace through the DM_DEV_SUSPEND ioctl which LVM uses.
>
> 2. There is a desire to access this feature from userspace on non-XFS
> filesystems without having to use device-mapper/LVM.
>
> Alasdair

Cheers, Takashi 
