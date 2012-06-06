From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Wed, 6 Jun 2012 09:01:26 +0200
Message-ID: <1883708187.20120606090126@eikelenboom.it>
References: <471046920.20120604234941@eikelenboom.it> <20120605000356.GM29466@outflux.net> <1018371644.20120605224154@eikelenboom.it> <20120605210806.GB7182@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	<dm-devel@redhat.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120605210806.GB7182@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Ted,

Another thing that thought of that could be of interest, i think this was a ext3 converted to ext4 partition.
Don't know if that is true for the other reports as well though.

--
Sander

Tuesday, June 5, 2012, 11:08:06 PM, you wrote:

> On Tue, Jun 05, 2012 at 10:41:54PM +0200, Sander Eikelenboom wrote:
>> 
>> > Today I've finally managed to bisect this to here:
>> > [fd034a84e1ea5c8c8d159cd2089c32e792c269b0] ext4: split out ext4_free_blocks_after_init()
>> 
>> > If I revert all the "ext4:" patches in 3.2 up to and including that one,
>> > I get normal behavior again.

> This is excellent.  Thanks!  I'll take a deep look at that ocmmit to
> see what might be going on.

>> So somehow this only effects ext4 on DM (it's THE common factor in all reports) and fsck seems incapable of seeing the error (and thus repair it.)

> What's probably happening is it's only the in-memory copy of the
> bitmap which is getting corrupted, and because the file system is
> getting remounted read-only, the corrupted bitmap is not getting
> written back to disk.  (This is the whole point of remount-ro when fs
> corruptions are detected.  :-)

> Cheers,

>                                                 - Ted




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it
