From: Philip Spencer <pspencer@fields.utoronto.ca>
Subject: Re: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Fri, 22 Feb 2008 13:10:40 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0802221305410.11313@lpc1.fields.utoronto.ca>
References: <47BDF6C9.8090009@redhat.com> <20080222131622.GK20118@mit.edu>
 <47BEE420.8030105@redhat.com> <20080222154404.GP20118@mit.edu>
 <47BEF575.40908@redhat.com> <20080222163331.GQ20118@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fileserver.fields.utoronto.ca ([128.100.216.10]:55816 "EHLO
	fileserver.fields.utoronto.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbYBVSLe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 13:11:34 -0500
In-Reply-To: <20080222163331.GQ20118@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You know what -- I went back and double-checked all the logs, and somehow
or other I must have recorded a timestamp wrong as 3:19:21 instead of 
3:19:51.

The segfault did in fact happen at 3:19:51 a.m. which is exactly the same 
time as my backup script moved on to the next filesystem.

So, it occurred during the unmount and lvremove of the snapshot volume.
It is, then, entirely expected that the device-mapper routines would 
return an error if the device no longer existed when the task was run.

My apologies for mixing up the timestamps! And no bug in device-mapper, 
just the one in e2fsprogs whch segfaulted in this circumstance instead of 
dropping the device from its list. Having it fail outright, and not list 
the device at all, is the correct behaviour for this situation -- just as 
if the device had already been removed before the blkid routines were run.

- Philip

On Fri, 22 Feb 2008, Theodore Tso wrote:

> On Fri, Feb 22, 2008 at 10:16:53AM -0600, Eric Sandeen wrote:
>> From a quick chat with agk, it sounds like outright failure is
>> appropriate.  Sounds like most of the calls fail for reasons like ENOMEM
>> (but it might be nice if it returned that, eh?)
>
> So the question then is why is it that Phillip was able to seeing
> failures when he was creating and deleting snapshots?
>
> I don't mind having blkid return a failure, but it may not fix
> Phillip's scenario which he listed in BZ #433857; yeah, he won't have
> a core dump, which is good, but it might mean that some or all of the
> dm volumes disappear from the blkid results.
>
> 							- Ted
>

--------------------------------------------+-------------------------------
Philip Spencer  pspencer@fields.utoronto.ca | Director of Computing Services
Room 336        (416)-348-9710  ext3036     | The Fields Institute for
222 College St, Toronto ON M5T 3J1 Canada   | Research in Mathematical Sciences
