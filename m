From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] jbd2: don't write superblock when unmounting an ro filesystem
Date: Mon, 30 Jul 2012 10:49:39 -0500
Message-ID: <5016AD13.2030804@redhat.com>
References: <500F1C28.8010800@redhat.com> <alpine.LFD.2.00.1207261110230.27130@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab2G3Ptn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 11:49:43 -0400
In-Reply-To: <alpine.LFD.2.00.1207261110230.27130@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/26/12 4:24 AM, Luk=C3=A1=C5=A1 Czerner wrote:
> On Tue, 24 Jul 2012, Eric Sandeen wrote:
>=20
>> Date: Tue, 24 Jul 2012 17:05:28 -0500
>> From: Eric Sandeen <sandeen@redhat.com>
>> To: ext4 development <linux-ext4@vger.kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Subject: [PATCH] jbd2: don't write superblock when unmounting an ro =
filesystem
>>
>> This sequence:
>>
>> # truncate --size=3D65536 fsfile
>> # losetup --offset 65536 /dev/loop0 fsfile=20
>> # mkfs.ext4 /dev/loop0=20
>> # losetup -d /dev/loop0
>> # mount -o loop,ro,offset=3D65536 fsfile  mnt/
>> # umount mnt
>> # dmesg | tail
>=20
> Hi Eric,
>=20
> I am having hard time understanding what the sequence should be
> doing. I actually can not reproduce it, because I can not create the
> file system on such loop device because it seems like the size of
> /dev/loop0 is zero, which makes sense considering that you set
> offset to 65536 in the 65536 sized file.

sorry, that must have been a cut & paste error.  :(

The offset was leftover from trying to match the original reporter's ca=
se.  This simpler test shows the same problem:

 1014  truncate --size=3D2g fsfile
 1015  mkfs.ext4 fsfile
 1016  mount -o loop,ro fsfile mnt
 1017  umount mnt
 1018  dmesg | tail

[  417.631105] EXT4-fs (loop0): mounted filesystem with ordered data mo=
de. Opts: (null)
[  417.639183] SELinux: initialized (dev loop0, type ext4), uses xattr
[  420.903970] Buffer I/O error on device loop0, logical block 262144
[  420.910448] lost page write due to I/O error on loop0
[  420.915662] JBD2: Error -5 detected when updating journal superblock=
 for loop0-8.

> Also, is the use of lo device really needed ? We can create the file
> system on the file itself right ? Moreover, when I do that I can see
> that the journal is not created because the device (file) is too
> small, maybe it have something to do with the problem ?
>=20
> Anyway, maybe I am missing something, but I do not understand what
> kind of problem are you reproducing there.
>=20
> -Lukas
>=20
>>
>> results in an IO error when unmounting the RO filesystem:
>>
>> [  312.386074] SELinux: initialized (dev loop1, type ext4), uses xat=
tr
>> [  318.020828] Buffer I/O error on device loop1, logical block 19660=
8
>> [  318.027024] lost page write due to I/O error on loop1
>> [  318.032088] JBD2: Error -5 detected when updating journal superbl=
ock for loop1-8.
>>
>> This behavior changed with:
>>
>> commit 24bcc89c7e7c64982e6192b4952a0a92379fc341
>> Author: Jan Kara <jack@suse.cz>
>> Date:   Tue Mar 13 15:41:04 2012 -0400
>>
>>     jbd2: split updating of journal superblock and marking journal e=
mpty
>>
>> which lost some of the magic in jbd2_journal_update_superblock() whi=
ch
>> used to test for a journal with no outstanding transactions.
>>
>> I'm not sure if the following is quite the right approach, but it fi=
xes
>> it for me.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> p.s. no idea why this only happens if I use a loop device with an of=
fset!
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index e9a3c4c..987ec76 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1354,6 +1354,11 @@ static void jbd2_mark_journal_empty(journal_t=
 *journal)
>> =20
>>  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
>>  	read_lock(&journal->j_state_lock);
>> +	/* Is it already empty? */
>> +	if (sb->s_start =3D=3D 0) {
>> +		read_unlock(&journal->j_state_lock);
>> +		return;
>> +	}
>>  	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
>>  		  journal->j_tail_sequence);
>> =20
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
