From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sat, 23 Oct 2010 18:00:05 +0200
Message-ID: <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
	<20101022172536.GP3127@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51234 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab0JWQAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Oct 2010 12:00:07 -0400
Received: by qyk12 with SMTP id 12so365930qyk.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Oct 2010 09:00:06 -0700 (PDT)
In-Reply-To: <20101022172536.GP3127@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 22, 2010 at 7:25 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Oct 22, 2010 at 03:33:29PM +0200, Bernd Schubert wrote:
>>
>> is is really a good idea to allow the filesystem to mount if somethi=
ng like
>> that comes up? I really would prefer if mount would abort.
>>
>> Oct 22 12:37:36 vm7 kernel: [ 1227.814294] LDISKFS-fs warning (devic=
e sfa0074): ldiskfs_clear_journal_err: Filesystem error recorded from p
>> revious mount: IO failure
>> Oct 22 12:37:36 vm7 kernel: [ 1227.814314] LDISKFS-fs warning (devic=
e sfa0074): ldiskfs_clear_journal_err: Marking fs in need of filesystem
>> =A0check.
>>
>> (please ignore "ldiskfs", it was just renamed to that by Lustre, but=
 is
>> ext4 based as in RHEL5.5, so 2.6.32-ish).
>
> Did you try running e2fsck first? =A0If it detects the error after
> running the journal, it will run the file system check right then and
> there. =A0If it doesn't, it's a bug. =A0If you're not running e2fsck
> first, and the filesystem had previously detected inconsistencies, th=
e
> long-standing tradition is to allow that, since root should know what
> it's doing.
>
> And there are times when you do want to mount a filesystem with known
> errors; for example, in the case of the root file system, we have
> always allowed a read-only mount to continue, so that we can run
> e2fsck without requiring a rescue CD 99% of the time.
>


Ted,

IMHO, and I've said it before, the mount flag which Bernd requests
already exists, namely 'errors=3D',
both as mount option and as persistent default, but it is not enforced
correctly on mount time.
If an administrator decides that the correct behavior when error is
detected is abort or remount-ro,
what's the sense it letting the filesystem mount read-write without
fixing the problem?
I realize that the umount/mount may have fixed things by "unrolling"
the last transaction,
but still, the state of ERROR_FS with read-write mount, seems to be
inconsistent the the defined errors behavior.
root can always use errors=3Dcontinue mount to override this restrictio=
n.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
