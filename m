From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Limit number of reserved gdt blocks on small
 fs
Date: Mon, 02 Mar 2015 11:27:11 -0600
Message-ID: <54F49D6F.7080509@redhat.com>
References: <1425056428-22598-1-git-send-email-lczerner@redhat.com> <54F48A7F.2090204@redhat.com> <alpine.LFD.2.00.1503021740510.30128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbbCBR1N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2015 12:27:13 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22HRCrT021612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 2 Mar 2015 12:27:13 -0500
In-Reply-To: <alpine.LFD.2.00.1503021740510.30128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/2/15 11:08 AM, Luk=E1=9A Czerner wrote:
> On Mon, 2 Mar 2015, Eric Sandeen wrote:

=2E..

>> Some extra "making sure" in the above sentence.  ;)
>=20
> Right, I'll fix that.
>=20
>>
>>>                    reserved_gdt_blocks is small enough. If the user
>>> +	 * specifies non-default values he can still run into this issue
>>> +	 * but we do not want to make that mistake by default.
>>> +	 *
>>> +	 * Magic numbers:
>>> +	 * - At block count smaller than 32768, journal will be 1024 bloc=
k
>>> +	 *   blocks long which would not be enough by default.
>>> +	 * - 64 reserved gtd blocks is maximum number we can fit into sai=
d
>>
>> gtd?  (gdt?  gdb?)
>=20
> Oh yes...
>=20
> I'll try to use it consistently.

thanks :)

>>
>>> +	 *   journal by default (flex_bg_count * 4 + rsv_gdb)
>>
>> This is a little confusing; "flex_bg_count" isn't a thing, and it se=
ems to
>> say that the reserved blocks depend on the number of reserved blocks=
?
>=20
> Does it ? It says that number of journal credits depend on the
> number of reserved gdt blocks, or maybe I am missing something.
>=20
> flex_bg_count is a number of groups in flex group, I'll try to come
> up with a better name.

It just looks like a variable name; it's one that doesn't exist, so it'=
s
not clear what you're talking about.

>>
>> I'm curious, why does this matter only for 1k blocks, and not, say 2=
k blocks?
>=20
> That's because of the way we compute the number of reserved GDT
> blocks. The number of GDT blocks depends on the number of block
> groups, which depends on the number of blocks in the file system.
> And with 1k file system we have much more blocks. In fact we have:
>=20
> - twice as many blocks as with 2k file system
> - four times the block groups
>=20
> And we can also fit only half of the number of group descriptors
> into a single block which means that we need twice as many blocks
> per block group.
>=20
> Which means that with 1k file system we need 8 times as many gdt
> blocks as with 2k fs and 2048 times more gdt blocks as with 4k with
> the same setup.
>=20
>>
>>> +	 */
>>> +	if ((fs->blocksize =3D=3D 1024) && (ext2fs_blocks_count(sb) < 327=
68) &&
>>> +	    (rsv_gdb > 64))
>>> +		rsv_gdb =3D 64;
>>> +
>>>  	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
>>>  		rsv_gdb =3D EXT2_ADDR_PER_BLOCK(sb);
>>>  #ifdef RES_GDT_DEBUG
>>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>>> index aeb852f..e9edd3b 100644
>>> --- a/misc/mke2fs.c
>>> +++ b/misc/mke2fs.c
>>> @@ -3076,6 +3076,34 @@ int main (int argc, char *argv[])
>>>  		}
>>>  		if (!quiet)
>>>  			printf("%s", _("done\n"));
>>> +
>>> +		/*
>>> +		 * In online resize we require a huge number of journal
>>> +		 * credits mainly because of the reserved_gdt_blocks. The
>>> +		 * exact number of journal credits needed is:
>>> +		 * flex_gd->count * 4 + reserved_gdb
>>> +		 *
>>> +		 * Warn user if we will not have enough credits to resize
>>> +		 * the file system online.
>>> +		 */
>>> +		if (fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE=
)
>>> +		{
>>> +			unsigned int credits;
>>> +
>>> +			/*
>>> +			* This is the amount we're allowed to use for a
>>> +			* single handle in a transaction
>>> +			*/
>>> +			journal_blocks /=3D 8;
>>
>> This seems a little dangerous; if someone decides to use journal_blo=
cks
>> later in the function, it might be unexpectedly smaller.
>>
>>> +			credits =3D (1 << fs_param.s_log_groups_per_flex) * 4 +
>>> +				  fs->super->s_reserved_gdt_blocks;
>>> +			if (credits > journal_blocks) {
>>
>> so maybe just scale this by 8, i.e. "if (credits > journal_blocks/8)=
"
>=20
> Fair enough, I'll change that.
>=20
>>
>> And actually, I find myself wondering if this same calculation can b=
e used
>> in calc_reserved_gdt_blocks, rather than using the magic numbers?
>=20
> Unfortunately it can not. At the time we're calculating number of gdt
> blocks we have no idea how big the journal will be.
>=20
> And at the time we already know how big the journal will be we
> already have blocks allocated for the resize_inode so we can not
> just simply change s_reserved_gdt_blocks here.

Ugh.  That sounds like a mess.

But it feels like we need centralized functions or macros that express =
the
relationships between these values, rather than sprinkling "* 4" and "i=
f 1024"
around.  It seems to have the potential to get out of sync, but I've on=
ly
given it cursory thought...

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
