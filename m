From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] common/rc: improve _require_metadata_journaling() for
 ext4
Date: Fri, 19 Aug 2016 12:56:04 -0400
Message-ID: <20160819165604.GB1903@localhost.localdomain>
References: <20160818144253.GA14069@localhost.localdomain>
 <20160818152620.GC27776@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, fstests@vger.kernel.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160818152620.GC27776@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> 
> I think this can be done by the new helper _exclude_scratch_mount_option
> which was introduced recently, e.g.
> 
_exclude_scratch_mount_option "noload"

This function would be better named if it didn't include "_scratch", since
it isn't scratch-specific.  That would make it easier for the occasional
contributor/reader to recognize it for what it is at a glance.

Also, its header comment references MKFS_OPTIONS rather than MOUNT_OPTIONS.

Thanks,
Eric

> 
> Thanks,
> Eryu
