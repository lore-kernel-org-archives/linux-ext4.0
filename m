From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] ext4: fix how i_version is modified and turn it on by
 default V2
Date: Tue, 15 May 2012 21:17:16 +0300
Message-ID: <4FB29DAC.3020801@panasas.com>
References: <1337092396-3272-1-git-send-email-josef@redhat.com> <20120515175308.GB1907@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, <tytso-3s7WtUTddSA@public.gmane.org>,
	<jack-AlSwsSmVLrQ@public.gmane.org>
To: Josef Bacik <josef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120515175308.GB1907-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 05/15/2012 08:53 PM, Josef Bacik wrote:

> On Tue, May 15, 2012 at 10:33:16AM -0400, Josef Bacik wrote:
>> This makes MS_I_VERSION be turned on by default.  Ext4 had been
>> unconditionally doing i_version++ in a few cases anway so the mount =
option
>> was kind of silly.  This patch also removes the update in mark_inode=
_dirty
>> and makes all of the cases where we update ctime also do inode_inc_=D7=
=91.
>> file_update_time takes care of the write case and all the places whe=
re we
>> update iversion are protected by the i_mutex so there should be no e=
xtra
>> i_lock overhead in the normal non-exported fs case.  Thanks,
>>
>=20
> Ok did some basic benchmarking with dd, I ran
>=20
> dd if=3D/dev/zero of=3D/mnt/btrfs-test/file bs=3D1 count=3D10485760
> dd if=3D/dev/zero of=3D/mnt/btrfs-test/file bs=3D1M count=3D1000
> dd if=3D/dev/zero of=3D/mnt/btrfs-test/file bs=3D1M count=3D5000
>=20
> 3 times with the patch and without the patch.  With the worst case sc=
enario
> there is about a 40% longer run time, going from on average 12 second=
s to 17
> seconds. =20


do you mean that the "with the patch" is 40% slower then "without the p=
atch"
	in the same "bs=3D1 count=3D10485760 test" ?

Then count me clueless. Do you understand this difference?

The way I read your patch the inode is copied and written to disk exact=
ly the
same number of times, as before. Only that now i_version is also update=
d
together with ctime and/or mtime. What is the fundamental difference th=
en?
Is it just that i_version++ in-memory operation?

> With the other two runs they are the same runtime with the 1 megabyte
> blocks.  So the question is, do we care about this worst case since a=
ny sane
> application developer isn't going to do writes that small?  Thanks,

> Josef
Thanks
Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
