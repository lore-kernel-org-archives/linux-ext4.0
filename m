From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Mon, 19 Aug 2013 16:31:30 -0700
Message-ID: <CALCETrVagghw-6bTsRCAt1rdENjpqALOKkg42c154Zs77Jh7Hw@mail.gmail.com>
References: <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
 <20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
 <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard> <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
 <20130815071141.GQ6023@dastard> <20130815074531.GA2147@quack.suse.cz>
 <20130815212826.GS6023@dastard> <alpine.DEB.2.02.1308191621130.30740@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	xfs@oss.sgi.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
To: David Lang <david@lang.hm>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1308191621130.30740@nftneq.ynat.uz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 19, 2013 at 4:23 PM, David Lang <david@lang.hm> wrote:
> On Fri, 16 Aug 2013, Dave Chinner wrote:
>
>> The problem with "not exported, don't update" is that files can be
>> modified on server startup (e.g. after a crash) or in short
>> maintenance periods when the NFS service is down. When the server is
>> started back up, the change number needs to indicate the file has
>> been modified so that clients reconnecting to the server see the
>> change.
>>
>> IOWs, even if the NFS server is not up or the filesystem not
>> exported we still need to update change counts whenever a file
>> changes if we are going to tell the NFS server that we keep them...
>
>
> This sounds like you need something more like relctime rather than noctime,
> something that updates the time in ram, but doesn't insist on flushing it to
> disk immediatly, updating when convienient or when the file is closed.
>
> David Lang

I guess my patches could be extended to do this.  In their current
form, when a pte dirty bit is transferred to a page (via page_mkclean
or unmap), the address_space is marked as needed a cmtime update.  I
could add a mode in which even the normal write syscall path sets that
bit instead of immediately updating the timestamp.  This could be a
nice speedup to non-mmap writers.

To avoid breaking things, things like fsync would need to force a
cmtime flush -- I doubt it would be okay for write; fsync; write;
fsync to leave the timestamp matching the first write.

I'd rather get comments on the current form of my patches and maybe
get them merged before looking at even more far-reaching extensions,
though.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
