From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: clarify ext4_error message in
 ext4_mb_generate_buddy_error()
Date: Tue, 8 Jul 2014 15:16:40 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407081500340.2180@localhost.localdomain>
References: <1404602162-16730-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1407080855520.2180@localhost.localdomain> <20140708125454.GA22156@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-566441263-1404825403=:2180"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140708125454.GA22156@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-566441263-1404825403=:2180
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 8 Jul 2014, Theodore Ts'o wrote:

> Date: Tue, 8 Jul 2014 08:54:54 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, stable@vger.kernel.org
> Subject: Re: [PATCH] ext4: clarify ext4_error message in
>     ext4_mb_generate_buddy_error()
> 
> On Tue, Jul 08, 2014 at 09:03:48AM +0200, Lukáš Czerner wrote:
> > 
> > It is a bit better, even though strictly speaking it's not
> > right, because it is not block bitmap alone, but rather aggregation
> > of block bitmap and preallocations. But for the user this is really
> > an implementation detail they do not need to worry about I guess.
> 
> Actually, no, because the preallocations aren't reflected in the
> in-block bitmap.

But the "bitmap" argument we're getting in ext4_mb_generate_buddy() is
not just the original on disk bitmap, is it ? It's aggregation of the on
on disk block bitmap and preallocation (this is done in
ext4_mb_init_cache()). Or am I missing something ?

> 
> And, oh sh*t, I wonder if that's the cause of the
> ext4_mb_generate_buddy().  We don't need the buddy bitmaps to allocate
> out of the preallocations, and it's not needed by
> ext4_mb_mark_diskspace_used().  If the buddy bitmaps have been pushed
> out of the page cache between when the blocks were originally
> preallocated and when we try to use some preallocated blocks, and then
> we have a race between ext4_mb_mark_diskspace_used() and
> ext4_mb_buddy_generate(), that could explain the discrepancy between
> the block group descriptors and the loaded buddy bitmap.

ext4_mb_generate_buddy() is run under the group lock and the actual
ext4_set_bits() in ext4_mb_mark_diskspace_used as well. And again in
ext4_mb_generate_buddy() we do take into account preallocations
which will be marked as used in the buddy bitmap.

> 
> If this is what's going on, it doesn't explain why we hacen't been
> seeing this until post 3.15, though....
> 
> 				- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-566441263-1404825403=:2180--
