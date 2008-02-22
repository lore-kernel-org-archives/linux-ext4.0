From: Philip Spencer <pspencer@fields.utoronto.ca>
Subject: Re: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Fri, 22 Feb 2008 10:46:06 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0802221042270.9109@fields.fields.utoronto.ca>
References: <47BDF6C9.8090009@redhat.com> <20080222131622.GK20118@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fileserver.fields.utoronto.ca ([128.100.216.10]:50116 "EHLO
	fileserver.fields.utoronto.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759284AbYBVQXU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 11:23:20 -0500
In-Reply-To: <20080222131622.GK20118@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> This looks good, but I assume that the bug was caused by some race
> condition where if you try to call dm_task_get_info() while some other
> process is creating or removing a snapshot, dm_task_get_info() is
> returning some kind of EAGAIN, or some other "Try again; we're busy"
> error, right?
>
> If that is the case, can you try to find out what error is being
> returned?  It may be the right thing to do is to check to see if we
> are getting a "resource is locked; try again in a sec" error message,
> and retry the dm_task_get_info(), instead of just returning a failure.
>
> Thanks!!

[ A copy of my posting to RH Bugzilla]

I (the original poster) know very little about either e2fsprogs or 
device-mapper, and had originally just assumed it would be normal for the 
info field to be null after a call to DM_DEVICE_DEPS if there were no 
dependents, but now after a quick look at the sources I see that the info 
field "dmi" inside the task structure is just what is returned by the 
ioctl, so it does appear to me now that some sort of error occurred, and 
that otherwise it would have returned a non-null dmi with a zero "exists" 
flag inside it.

Correct me if I'm wrong, but it seems that:

   -- No point in retrying dm_task_get_info(); it is just unpacking the
     "dmi" structure returned by the previous dm_task_run call, which is null.
     It is in dm_task_run that the error occurred.

   -- The code in dm_task_run seems to already take care of retrying EAGAIN
      conditions.

   -- One obvious other type of race condition would be if the device were
      removed in between the task creation and call to dm_task_run. In that
      case, Eric's patch seems to do exactly the right thing -- no point in
      continuing if the device is gone anyway.

   -- But, I don't think that's the race condition we're seeing. A gdb
      printout of the task structure shows

  {type = 7, dev_name = 0x2aaaaace3e10 "vg1-snapweb-cow", head = 0x0,
   tail = 0x0, read_only = 0, event_nr = 0, major = -1, minor = -1, uid = 0,
   gid = 6, mode = 432, dmi = {v4 = 0x0, v1 = 0x0}, newname = 0x0,
   message = 0x0, geometry = 0x0, sector = 0, no_flush = 0, no_open_count = 0,
   skip_lockfs = 0, suppress_identical_reload = 0, uuid = 0x0}

This is associated to the snapshot volume "snapweb" which was being backed 
up at the time. Timestamps on the backup logs indicate that my backup 
script moved on to the next filesystem 30 seconds AFTER the segfault, so, 
unless something really slowed down the system so that deallocation of the 
snapweb volume took a full 30 seconds, it does not appear that the 
segfault occurred during the unmounting and deallocating of snapweb.

I also don't understand why major/minor are -1 in the above structure; is 
that normal?

- Philip

--------------------------------------------+-------------------------------
Philip Spencer  pspencer@fields.utoronto.ca | Director of Computing Services
Room 336        (416)-348-9710  ext3036     | The Fields Institute for
222 College St, Toronto ON M5T 3J1 Canada   | Research in Mathematical Sciences

On Fri, 22 Feb 2008, Theodore Tso wrote:

> On Thu, Feb 21, 2008 at 04:10:17PM -0600, Eric Sandeen wrote:
>> This is for RH Bugzilla #433857:
>> rpc.mountd segfaults due to uninitialized value in e2fsprogs devname.c
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=433857
>>
>> which did some very helpful analysis & provided a patch.
>>
>> This patch is based on that, but checks all the devicemapper calls,
>> and does some goto error handling / unwrapping, in the same style as
>> the device-mapper lib code itself.
>
> 						- Ted
>
