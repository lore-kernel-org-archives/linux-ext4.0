From: jim owens <jowens@hp.com>
Subject: Re: [RESEND] [PATCH] lseek: change i_mutex usage.
Date: Thu, 15 Jan 2009 10:36:37 -0500
Message-ID: <496F5805.3000502@hp.com>
References: <6.0.0.20.2.20090115163853.07056ed0@172.19.0.2> <20090115132252.GZ29283@parisc-linux.org> <20090115142113.GD30522@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matthew Wilcox <matthew@wil.cx>,
	Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090115142113.GD30522@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Thu, Jan 15, 2009 at 06:22:52AM -0700, Matthew Wilcox wrote:
>> Of course if you have multiple threads, they will share a struct file,
>> and you're updating f_pos and f_version without locking.  Maybe that's
>> OK, but it's soemthing you didn't discuss.
> 
> f_pos is updated by sys_write(), and friends without locking, so we're
> fine on that front, or at least no worse off.  SUSv3 doesn't seem to
> say one way or another what should happen if two threads try to
> write() to a file at the same time using the same file descriptor in
> terms of whether or not f_pos gets updated intelligently.  We've opted
> for speed over determinism already.
> 
> Zero'ing out f_version is fine to do without locking.  It's only used
> so we know that we need to revalidate in the readdir() case so that we
> know it's pointing at a valid directory pointer.
> 
> That being said, I do see a race in fs/ext*/dir.c, but i_mutex locking
> isn't the problem and it's not going to save us.  ext[234]_readdir()
> uses f_pos through the routine, even between calls that might block;
> so if one thread is randomly calling seekdir() (or lseek() directly)
> while another read is calling readdir(), ext[234]_readdir() could get
> potentially very confused.  If someone wants to take a look at it,
> that would be great.  Otherwise I'll put it on my low-priority queue
> of things to look at.
> 
>> I think it's the only reason to have the mutex here.  Otherwise we could
>> simply use i_size_read() in generic_file_llseek_unlocked() and there
>> would be no need for a mutex at all.
> 
> That's a good point.  Maybe I'm missing something, but I'm not sure we
> need the mutex in generic_file_llseek() at all.

I'm not arguing against this.  Just pointing out what
I suspect Jamie was thinking about and what a difference
3 months makes to the patch author :)

Subject:[RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
http://marc.info/?l=linux-fsdevel&m=122335627224515

...that ended with Linus rightly saying users expecting to
do stuff like that are insane.

*However*, we should remember that any time you remove locks
from a path, you run the risk the lock was providing some
unplanned consistency and removing it will increase the window
for unexpected behavior.  And maybe finding more buggy apps
is good or bad only depending on your point of view.

jim
