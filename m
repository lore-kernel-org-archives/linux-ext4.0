From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 6 Jun 2011 17:32:08 +0300
Message-ID: <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40959 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1FFOcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 10:32:10 -0400
Received: by wwa36 with SMTP id 36so3865441wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 07:32:09 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 6, 2011 at 4:08 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:
>>
>> MERGING
>> -------
>> These patches are based on Ted's current master branch + alloc_semp =
removal
>> patches. Although the alloc_semp removal is an independent (and in m=
y eyes
>> a good) change, it is also required by snapshot patches, to avoid ci=
rcular
>> locking dependency during COW allocations.
>>
>> Merging with Allison's punch holes patches should be straight forwar=
d, since
>> the hard part, namely Yongqiang's split extent refactoring patches, =
was
>> already merged by Ted.
>>
>> Merging with Ted's big alloc patches is going to be a bit more chall=
enging,
>> since big alloc patches make a lot of renaming and refactoring. Howe=
ver,
>> since has_snapshots and big_alloc features will never work together,
>> at least testing the code together is not a big concern.
>
> Hi Amir,
>
> what is the reason for the snapshots to never work with big_alloc ? J=
ust
> out of curiosity.
>

=46or one reason, a snapshot file format is currently an indirect file
and big_alloc
doesn't support indirect mapped files.
I am not saying it cannot be done, but if it does, there would be
several obstacles
to cross.

>>
>> TESTING
>> -------
>> Apart from the extensive testing for the snapshots feature functiona=
lity, we
>> also ran xfstests with snapshots and while taking a snapshot every 1=
 minute.
>
> Since a lot of the tests are actually shorter than one minute, you mi=
ss a
> lot of possible concurrent operations.

Yes, you are right.
Actually, we ran the 1 snapshot per minute test in parallel to
phoronix test suite,
which runs tests for several minutes on each iteration.
Mixing snapshots take during xfstests was never done properly, because
it needs to be run only when the filesystem is mounted.
There is a Google summer of project that is going to focus on that task=
=2E

> Is there any reason why not to do
> it more often ? Let's say every second ?
>

Sure, it could be done, but the freeze_fs every second will kill most o=
f the
tests and make them behave very differently then usual, so it would pro=
bably
be better to take snapshots more rarely than 1 second, but to randomize
the times of snapshot take, to try and hit and different concurrent ope=
rations
on different iterations.


>> More importantly, we ran xfstests with snapshots support disabled in=
 compile
>> time and with snapshot support enabled but without has_snapshot feat=
ure.
>> These xfstests were run with blocksize 1K and 4K and on X86 and X86_=
64.
>> The 1K blocksize tests are important for the alloc_semp removal patc=
hes.
>> No problems were found apart from one (test 225 hung), which is alre=
ady
>> existing in master branch.
>>
>> CREDITS
>> -------
>> The snapshots patches originate in my implementation of the Next3 fi=
lesystem
>> for CTERA networks.
>> The porting of the Next3 snapshot patches to ext4 patches is attribu=
ted to
>> Aditya Dani, Shardul Mangade, Piyush Nimbalkar and Harshad Shirwadka=
r from
>> the Pune Institute of Computer Technology (PICT).
>> The implementation of extents move-on-write, delayed move-on-write a=
nd much
>> of the cleanup work on these patches was carried out by Yongqiang Ya=
ng from
>> the Institute of Computing Technology, Chinese Academy of Sciences.
>>
>>
>> [PATCH RFC 01/30] ext4: EXT4 snapshots (Experimental)
>> [PATCH RFC 02/30] ext4: snapshot debugging support
>> [PATCH RFC 03/30] ext4: snapshot hooks - inside JBD hooks
>> [PATCH RFC 04/30] ext4: snapshot hooks - block bitmap access
>> [PATCH RFC 05/30] ext4: snapshot hooks - delete blocks
>> [PATCH RFC 06/30] ext4: snapshot hooks - move data blocks
>> [PATCH RFC 07/30] ext4: snapshot hooks - direct I/O
>> [PATCH RFC 08/30] ext4: snapshot hooks - move extent file data block=
s
>> [PATCH RFC 09/30] ext4: snapshot file
>> [PATCH RFC 10/30] ext4: snapshot file - read through to block device
>> [PATCH RFC 11/30] ext4: snapshot file - permissions
>> [PATCH RFC 12/30] ext4: snapshot file - store on disk
>> [PATCH RFC 13/30] ext4: snapshot file - increase maximum file size l=
imit to 16TB
>> [PATCH RFC 14/30] ext4: snapshot block operations
>> [PATCH RFC 15/30] ext4: snapshot block operation - copy blocks to sn=
apshot
>> [PATCH RFC 16/30] ext4: snapshot block operation - move blocks to sn=
apshot
>> [PATCH RFC 17/30] ext4: snapshot control
>> [PATCH RFC 18/30] ext4: snapshot control - fix new snapshot
>> [PATCH RFC 19/30] ext4: snapshot control - reserve disk space for sn=
apshot
>> [PATCH RFC 20/30] ext4: snapshot journaled - increase transaction cr=
edits
>> [PATCH RFC 21/30] ext4: snapshot journaled - implement journal_relea=
se_buffer()
>> [PATCH RFC 22/30] ext4: snapshot journaled - bypass to save credits
>> [PATCH RFC 23/30] ext4: snapshot journaled - trace COW/buffer credit=
s
>> [PATCH RFC 24/30] ext4: snapshot list support
>> [PATCH RFC 25/30] ext4: snapshot race conditions - concurrent COW op=
erations
>> [PATCH RFC 26/30] ext4: snapshot race conditions - tracked reads
>> [PATCH RFC 27/30] ext4: snapshot exclude - the exclude bitmap
>> [PATCH RFC 28/30] ext4: snapshot cleanup
>> [PATCH RFC 29/30] ext4: snapshot cleanup - shrink deleted snapshots
>> [PATCH RFC 30/30] ext4: snapshot rocompat - enable rw mount
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> --
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
