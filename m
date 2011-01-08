From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sat, 8 Jan 2011 22:28:01 +0200
Message-ID: <AANLkTinCE=+E1O6XRiHO12GvEfYaXfJS2F+FORLa=Te7@mail.gmail.com>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
	<AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
	<4D1F6244.7050203@redhat.com>
	<AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
	<20110107052613.GE2857@thunk.org>
	<AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com>
	<AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com>
	<AANLkTin0d-=F2ifrmZOEJiD8tywdLCx_NuOfy=TqkJCm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60527 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1AHU2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Jan 2011 15:28:02 -0500
Received: by qwa26 with SMTP id 26so18760934qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 08 Jan 2011 12:28:01 -0800 (PST)
In-Reply-To: <AANLkTin0d-=F2ifrmZOEJiD8tywdLCx_NuOfy=TqkJCm@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 8, 2011 at 12:12 AM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Fri, Jan 7, 2011 at 11:07 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Fri, Jan 7, 2011 at 9:41 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>>> On Fri, Jan 7, 2011 at 7:26 AM, Ted Ts'o <tytso@mit.edu> wrote:
>>>> Am I missing something? =A0The kernel stores up to 3k worth of dat=
a, on
>>>> a 4k block file system. =A0Whereas e2fsck patch blindly assume 2k =
worhth
>>>> of data regardless of the block size. =A0The kernel patch looks ok=
, but
>>>> the e2fsprogs patch seems badly broken....
>>
>> So it's not badly broken, it copies blocksize-2K, which is clumsily
>> written like this:
>> + =A0 =A0 =A0 int len =3D ctx->fs->blocksize - 2*SUPERBLOCK_OFFSET;
>>
>> After that, only 4K block and 8K block will have a leftover,
>> which will be copied from journal sb+1K to ext4 sb+1K.
>> Yes, 2K blocks - no message buffer for you!
>>
>> The reason I am only copying 2K and throwing the extra K is this:
>> print_message_buffer() is called from check_super_block(),
>> *after* journal recovery, which was executed either by e2fsck itself
>> or (and more likely in a errors=3Dremount-ro situation) by ext4
>> on read-only mount.
>> In the latter case, the extra K must be discarded, so I saw no reaso=
n
>> to write special code for the first case.
>> Neither did I find a good reason to complicate the recording code
>> and limit it to record only blocksize-2K.
>>
>>
>
> Ted,
>
> I have a suggestion how to use the wasted extra K.
>
> As I pointed out in the past, the first/last_error_xxx statistics are=
 most
> likely to be lost in errors=3Dpanic and errors=3Dremount-ro (journal
> recovery will override super block)
> If you record this information in the last K of journal sb (even copy
> the entire ext4 sb),
> you can then override ext4 sb with the most up-to-date error stats
> after journal recovery.
>
> Amir.
>

Ted,

I just realize you did implement save&update of super block s_error_xxx=
 fields.
However, I wonder if it is not a bug to call ext4_commit_super() from
save_error_info()
to commit the s_error_xxx fields in the first place.

The super block buffer is most likely participating in the current
transaction and should
not be committed to disk.

The alleged bug is likely to be hidden by the fact that the super
block has most likely
participated also in the last committed transaction, so a valid
version of it will most
likely override the invalid version.

I can imagine there could be a corner case, though, when committing
the super block
a head of transaction commit will result in inconsistencies.

Am I missing something?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
