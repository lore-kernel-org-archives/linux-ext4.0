From: Zhang Huan <zhhuan@gmail.com>
Subject: Re: potential memory leak on transaction commit
Date: Tue, 15 Mar 2011 14:39:08 +0800
Message-ID: <AANLkTi=ZPGd6scA8u3eSCzq1jgZWZdxs0p4p5knd2bN5@mail.gmail.com>
References: <alpine.LFD.2.02.1103081849430.6414@zhanghuan.nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36541 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1COGjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 02:39:24 -0400
Received: by qwk3 with SMTP id 3so196619qwk.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 23:39:23 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.02.1103081849430.6414@zhanghuan.nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I would like to know if there is more comment on this?

On Tue, Mar 8, 2011 at 19:40, Zhang Huan <zhhuan@gmail.com> wrote:
> Hi all,
>
> There is potential memory leak of journal head in function
> jbd2_journal_commit_transaction. The problem is that JBD2 will not
> reclaim the journal head of commit record if error occurs or journal =
is
> abotred.
>
> I use the following script to reproduce this issue, on a RHEL6 system=
=2E I
> found it very easy to reproduce with async commit enabled.
>
> mount /dev/sdb /mnt -o journal_checksum,journal_async_commit
> touch /mnt/xxx
> echo offline > /sys/block/sdb/device/state
> sync
> umount /mnt
> rmmod ext4
> rmmod jbd2
>
> Removal of the jbd2 module will make slab complaining that
> "cache `jbd2_journal_head': can't free all objects".
>
>
> Here is my fix for this issue. The commit record should be reclaimed =
no
> matter error occurs or not.
>
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index f3ad159..37a973a 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -105,6 +105,8 @@ static int journal_submit_commit_record(journal_t=
 *journal,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec now =3D current_kernel_tim=
e();
>
> + =C2=A0 =C2=A0 =C2=A0 *cbh =3D NULL;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_journal_aborted(journal))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
>
> @@ -808,7 +810,7 @@ wait_for_iobuf:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__jbd2_journal_abort_hard(journal);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 if (!err && !is_journal_aborted(journal))
> + =C2=A0 =C2=A0 =C2=A0 if (cbh)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D journa=
l_wait_on_commit_record(journal, cbh);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0JBD2_FEA=
TURE_INCOMPAT_ASYNC_COMMIT) &&
>
>
>
> PS: Just out of curiosity, why would journal_submit_commit_record ret=
urn a
> value of 1 instead of an error number if get descriptor buffer is fai=
led.
>
>
> Zhang Huan
>

Zhang Huan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
