From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] JBD: release checkpoint journal heads through try_to_release_page
 when the memory is exhausted
Date: Tue, 28 Oct 2008 11:46:27 +0900
Message-ID: <49067D03.6080609@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>	<20081020160249.ff41f762.akpm@linux-foundation.org>	<20081023174101.85b59177.toshi.okajima@jp.fujitsu.com> <20081027142657.2120aa3f.akpm@linux-foundation.org>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081027142657.2120aa3f.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Andrew.
Thank you for your useful comment.

Andrew Morton wrote:
 > (added linux-fsdevel)
 >
 > On Thu, 23 Oct 2008 17:41:01 +0900
 > Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
<SNIP>
 > > I managed to build a shrinker callback function for the journal_head slab cache.
 > > > This code size is less than before but the logic of it seems to be more complex
 > > >  than before.
 > > > However, I haven't got any troubles while I am testing some easy load operations
 > > > on the fixed kernel.
 > > > But I think a system may hang up if concurrently several journal_head shrinker
 > > > are executed.
 > > > So, I will retry to build more appropriate fix.
 >
 > yeah, that's not very pretty either, is it?
Yes...
I realized fixing only within buffer_head or jbd needs a more complex code.

 > > > Please give me comments if you have a nicer idea.
 > Stepping back a bit...
 >
 > The basic problem is, I believe, that some client of the blockdev
 > (ext3) is adding metadata to the blockdev's data structures
 > (buffer_heads) but we have no means by which the blockdev code can call
 > back into that client requesting that the metadata be released, yes?
Yes.

 > We can fix the problem which you've identified by adding a means for
 > the blockdev code (def_blk_aops.releasepage()) to call back into ext3,
 > yes?
Yes.

At first, I tried to fix by using only filesystem approach.
  - ver.1: fixing in buffer_head
  - ver.2: adding shrinker of journal_head (for releasing buffer_head)
But these approaches become complex code.
So, we should fix the essence of the problem.

 > If so, how do we do that?
 >
 > I seem to recall that there's code somewhere in the tree which does
 > things like taking a copy of bdev->address_space_operations and
 > reinstalling that, and overwriting selected fields, and then arranging
 > somehow for the old value to be reinstalled when the client releases
 > the blockdev.  That's plain nasty.
uh-huh.

I try to fix this problem again by using your approach,
blkdev_register_releasepage/blkdev_unregister_releasepage().

Best Regards,
Toshiyuki Okajima

