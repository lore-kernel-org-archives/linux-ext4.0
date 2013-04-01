From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Mon, 01 Apr 2013 11:00:33 -0500
Message-ID: <5159AF21.1050805@redhat.com>
References: <87d2uese6t.fsf@openvz.org> <5159A55B.1090302@redhat.com> <20130401153952.GE4731@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130401153952.GE4731@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/1/13 10:39 AM, Theodore Ts'o wrote:
> On Mon, Apr 01, 2013 at 10:18:51AM -0500, Eric Sandeen wrote:
>> I'd add:
>>
>> 3) Why do we have a "nodelalloc" mount option at all?
>>
>> but then I thought:
>>
>> Is it also this bad when using the ext4 driver to run an ext3 fs?
> 
> Yes, and I there would be a similar performance problem if you are
> using the ext3 file system driver, since ext3_*_writepage() also ends
> up calling block_write_full_page() which will also result in the
> writes happening with WRITE_SYNC.

> The main reason why we keep nodelalloc at this point is bug-for-bug
> compatibility with ext3 file systems --- basically, for users who are
> using this as a workaround for the O_PONIES issue instead of fixing
> their applications to use fsync() appropriately.

Sorry for getting off the original thread here, but IMHO these are
2 different things:

nondelalloc behavior makes sense for ext3, but:
-o nodelalloc mount options don't make sense for ext4.

> So another question is how much do we care about exact emulation of
> ext3's behaviour for those distributions who wish to use ext4 file
> system driver for ext2 and ext3 file systems?
>
> One of the reasons for keeping nodealloc mode was the argument was
> that it removing it wouldn't really allow us to remove that much
> complexity from ext4.

IMHO we should keep the mode for ext2/3, but lose the ext4 option.
It'd just be one less row in the ext4 test matrix.

-Eric

>  But adding a nodealloc specific ext4_writepages
> pages would result in adding a huge amount of complexity, and my first
> reaction is that it's really not worth the code maintenance headache.
> Dmitry, is there a reason why you are especially worried about the
> performace of nodelalloc mode?
> 
> 	       	      	       	   	- Ted
> 

