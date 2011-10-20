From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Latency writing to an mlocked ext4 mapping
Date: Wed, 19 Oct 2011 22:59:55 -0700
Message-ID: <CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
	<ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
	<CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
	<CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45831 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1JTF74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 01:59:56 -0400
In-Reply-To: <CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 7:17 PM, Andy Lutomirski <luto@amacapital.net> =
wrote:
> On Wed, Oct 19, 2011 at 6:15 PM, Andy Lutomirski <luto@amacapital.net=
> wrote:
>> On Wed, Oct 19, 2011 at 6:02 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>> What kernel are you using? =A0A change to keep pages consistent dur=
ing writeout was landed not too long ago (maybe Linux 3.0) in order to =
allow checksumming of the data.
>>
>> 3.0.6, with no relevant patches. =A0(I have a one-liner added to the=
 tcp
>> code that I'll submit sometime soon.) =A0Would this explain the late=
ncy
>> in file_update_time or is that a separate issue? =A0file_update_time
>> seems like a good thing to make fully asynchronous (especially if th=
e
>> file in question is a fifo, but I've already moved my fifos to tmpfs=
).
>
> On 2.6.39.4, I got one instance of:
>
> call_rwsem_down_read_failed ext4_map_blocks ext4_da_get_block_prep
> __block_write_begin ext4_da_write_begin ext4_page_mkwrite do_wp_page
> handle_pte_fault handle_mm_fault do_page_fault page_fault
>
> but I'm not seeing the large numbers of the ext4_page_mkwrite trace
> that I get on 3.0.6. =A0file_update_time is now by far the dominant
> cause of latency.

The culprit seems to be do_wp_page -> file_update_time ->
mark_inode_dirty_sync.  This surprises me for two reasons:

 - Why the _sync?  Are we worried that data will be written out before
the metadata?  If so, surely there's a better way than adding latency
here.

 - Why are we calling file_update_time at all?  Presumably we also
update the time when the page is written back (if not, that sounds
like a bug, since the contents may be changed after something saw the
mtime update), and, if so, why bother updating it on the first write?
Anything that relies on this behavior is, I think, unreliable, because
the page could be made writable arbitrarily early by another program
that changes nothing.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
