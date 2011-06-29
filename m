From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC] Journal credits debugging (Was: Re: Bug#615998: ...)
Date: Wed, 29 Jun 2011 10:10:44 +0300
Message-ID: <BANLkTi=xXtnsBECOdSsC4_1bgnCrwsMb6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
	"Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Sean Ryle <seanbo@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46385 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1F2HKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 03:10:45 -0400
Received: by wwe5 with SMTP id 5so930399wwe.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jun 2011 00:10:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 29, 2011 at 1:57 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 28-06-11 14:30:55, Moffett, Kyle D wrote:
>> This is really helpful to me, but it's deviated a bit from solving
>> the original bug. =A0Based on the last log that I generated showing =
that
>> the error occurs in journal_stop(), what else should I be testing?
> =A0I was looking at it for a while but so far I have no idea...
>

Hi Jan,

I would like to suggest an approach that may help us track down these
sort of bugs more easily.

Add a new class_id argument to ext4_handle_dirty_metadata() and collect
statistics of used credits per class_id.

There are only so many types of journaled objects:
SUPER, GDT, BB, IB, ITB, IND, EXT, DATA, XATTR, QUOT...
So it shouldn't be a problem to save the statistics per handle.

If you look at struct jbd2_journal_handle, you will find a bunch of h_c=
ow_XXX
fields intended as COW debugging counters.
We may as well turn these fields into a generic counters array, which c=
an
be used by either COW debugging or credits debugging code.

This should be simple enough to implement and should provide
a more detailed report when buffer credits have run out.

However, if we are going to modify all call sites of
ext4_handle_dirty_metadata(),
it would be wise to also add an object_id (or a better name) argument
that will provide
the group no. or inode no. or quota type, or any other id relevant for
classification.

We can use this information, along with where, line, handle, ino,
block_nr, buffer_credits
and create a stable trace point in __ext4_handle_dirty_metadata().

Sorry for writing emails instead of patches...
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
