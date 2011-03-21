From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] ext4: handle errors in ext4_clear_blocks()
Date: Mon, 21 Mar 2011 06:23:36 +0200
Message-ID: <AANLkTi=3bdCC5=EPPUC_DNsq9pHMtJ2CSciTrRwZ4fcH@mail.gmail.com>
References: <AANLkTi=zteq96AQ54f3qo29dRGCmMhwtR4BzKPXQLt0W@mail.gmail.com>
	<20110321013749.GE4135@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36530 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1CUEXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 00:23:37 -0400
Received: by qyg14 with SMTP id 14so4755128qyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 21:23:36 -0700 (PDT)
In-Reply-To: <20110321013749.GE4135@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 3:37 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 01, 2011 at 02:28:26PM +0200, Amir Goldstein wrote:
>> +out_err:
>> + =A0 =A0 ext4_std_error(inode->i_sb, err);
>> + =A0 =A0 return err;
>
> Umm, you do realize this function will mark the file system as dirty,
> and possibly remount the file system read-only, or panic the system,
> right?

I am counting on that. In fact I think we should not allow snapshots
and errors=3Dcontinue,
otherwise we just as good (bad) as LVM snapshot that vanishes when it
runs out of space.

>
> That's appropriate for normal journal failures (since there's no
> recovering from them), but if you're proposing that a simple lack of
> free blocks when doing a COW operation will result in a ENOSPC, all a
> malicious userspace application needs to do to potentially bring the
> system down is to attempt to unlink or truncate a file while COW
> snapshots are enabled.....

It's not that easy to cause ENOSPC during COW.
s_snapshot_r_blocks has blocks reserved for COW,
but I do want the fs to freeze if that reservation somehow runs out.
The reservation is based on metadata size estimation, calculated
for no of used inodes no of dirs and no of used blocks. It may fall
short when there are very many hard links or very long file names,
resulting in lots of directory blocks and when all of them are COWed.

short in many hard links

>
> Do you really want me to include this patch? =A0I think you may want =
to
> rethink how you want to handle this case....

I do, because when errors=3Dremount-ro, this function emmits lots of
"journal has aborted" errors, which are of no useful to anyone...

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
