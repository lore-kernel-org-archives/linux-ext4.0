From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: Issues with a rather unusual configured NFS server
Date: Sat, 07 Sep 2013 22:44:00 +0200
Message-ID: <522B9010.8070902@gmx.de>
References: <52075E01.7030506@gmx.de> <20130812143640.GF4596@quack.suse.cz> <20130813215313.GH17781@fieldses.org> <20130827180655.GE14809@fieldses.org> <521E318C.7040401@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Linux NFS mailing list <linux-nfs@vger.kernel.org>,
	"user-mode-linux-devel@lists.sourceforge.net"
	<user-mode-linux-devel@lists.sourceforge.net>,
	linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3IGUoH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Sep 2013 16:44:07 -0400
Received: from [92.224.45.65] ([92.224.45.65]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LtZfc-1W1TZg10ey-010s6Y for
 <linux-ext4@vger.kernel.org>; Sat, 07 Sep 2013 22:44:05 +0200
In-Reply-To: <521E318C.7040401@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/28/2013 07:21 PM, Toralf F=C3=B6rster wrote:
> On 08/27/2013 08:06 PM, J. Bruce Fields wrote:
>> On Tue, Aug 13, 2013 at 05:53:14PM -0400, bfields wrote:
>>> On Mon, Aug 12, 2013 at 04:36:40PM +0200, Jan Kara wrote:
>>>> On Sun 11-08-13 11:48:49, Toralf F=C3=B6rster wrote:
>>>>> so that the server either crashes (if it is a user mode linux ima=
ge) or at least its reboot functionality got broken
>>>>> - if the NFS server is hammered with scary NFS calls using a fuzz=
y tool running at a remote NFS client under a non-privileged user id.
>>>>>
>>>>> It can re reproduced, if
>>>>> 	- the NFS share is an EXT3 or EXT4 directory
>>>>> 	- and it is created at file located at tempfs and mounted via lo=
op device
>>>>> 	- and the NFS server is forced to umount the NFS share
>>>>> 	- and the server forced to restart the NSF service afterwards
>>>>> 	- and trinity is used
>>>>>
>>>>> I could find a scenario for an automated bisect. 2 times it broug=
ht this commit=20
>>>>> commit 68a3396178e6688ad7367202cdf0af8ed03c8727
>>>>> Author: J. Bruce Fields <bfields@redhat.com>
>>>>> Date:   Thu Mar 21 11:21:50 2013 -0400
>>>>>
>>>>>     nfsd4: shut down more of delegation earlier
>>>
>>> Thanks for the report.  I think I see the problem--after this commi=
t
>>> nfs4_set_delegation() failures result in nfs4_put_delegation being
>>> called, but nfs4_put_delegation doesn't free the nfs4_file that has
>>> already been set by alloc_init_deleg().
>>>
>>> Let me think about how to fix that....
>>
>> Sorry for the slow response--can you check whether this fixes the
>> problem?
>>
> Yes.
>=20
> With the attached patch the problem can't be reproduced any longer wi=
th
> the prepared test case and current git kernels.
>=20
>> --b.
>>
>> commit 624a0ee0375940ce4aa36330b0b5a70af6d2b6f5
>> Author: J. Bruce Fields <bfields@redhat.com>
>> Date:   Thu Aug 15 16:55:26 2013 -0400
>>
>>     nfsd4: fix leak of inode reference on delegation failure
>>    =20
>>     This fixes a regression from 68a3396178e6688ad7367202cdf0af8ed03=
c8727
>>     "nfsd4: shut down more of delegation earlier".
>>    =20
>>     After that commit, nfs4_set_delegation() failures result in
>>     nfs4_put_delegation being called, but nfs4_put_delegation doesn'=
t free
>>     the nfs4_file that has already been set by alloc_init_deleg().
>>    =20
>>     This can result in an oops on later unmounting the exported file=
system.
>>    =20
>>     Note also delaying the fi_had_conflict check we're able to retur=
n a
>>     better error (hence give 4.1 clients a better idea why the deleg=
ation
>>     failed; though note CONFLICT isn't an exact match here, as that'=
s
>>     supposed to indicate a current conflict, but all we know here is=
 that
>>     there was one recently).
>>    =20
>>     Reported-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
>>     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
>>
>> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
>> index eb9cf81..0874998 100644
>> --- a/fs/nfsd/nfs4state.c
>> +++ b/fs/nfsd/nfs4state.c
>> @@ -368,11 +368,8 @@ static struct nfs4_delegation *
>>  alloc_init_deleg(struct nfs4_client *clp, struct nfs4_ol_stateid *s=
tp, struct svc_fh *current_fh)
>>  {
>>  	struct nfs4_delegation *dp;
>> -	struct nfs4_file *fp =3D stp->st_file;
>> =20
>>  	dprintk("NFSD alloc_init_deleg\n");
>> -	if (fp->fi_had_conflict)
>> -		return NULL;
>>  	if (num_delegations > max_delegations)
>>  		return NULL;
>>  	dp =3D delegstateid(nfs4_alloc_stid(clp, deleg_slab));
>> @@ -389,8 +386,7 @@ alloc_init_deleg(struct nfs4_client *clp, struct=
 nfs4_ol_stateid *stp, struct sv
>>  	INIT_LIST_HEAD(&dp->dl_perfile);
>>  	INIT_LIST_HEAD(&dp->dl_perclnt);
>>  	INIT_LIST_HEAD(&dp->dl_recall_lru);
>> -	get_nfs4_file(fp);
>> -	dp->dl_file =3D fp;
>> +	dp->dl_file =3D NULL;
>>  	dp->dl_type =3D NFS4_OPEN_DELEGATE_READ;
>>  	fh_copy_shallow(&dp->dl_fh, &current_fh->fh_handle);
>>  	dp->dl_time =3D 0;
>> @@ -3044,22 +3040,35 @@ static int nfs4_setlease(struct nfs4_delegat=
ion *dp)
>>  	return 0;
>>  }
>> =20
>> -static int nfs4_set_delegation(struct nfs4_delegation *dp)
>> +static int nfs4_set_delegation(struct nfs4_delegation *dp, struct n=
fs4_file *fp)
>>  {
>> -	struct nfs4_file *fp =3D dp->dl_file;
>> +	int status;
>> =20
>> -	if (!fp->fi_lease)
>> -		return nfs4_setlease(dp);
>> +	if (fp->fi_had_conflict)
>> +		return -EAGAIN;
>> +	get_nfs4_file(fp);
>> +	dp->dl_file =3D fp;
>> +	if (!fp->fi_lease) {
>> +		status =3D nfs4_setlease(dp);
>> +		if (status)
>> +			goto out_free;
>> +		return 0;
>> +	}
>>  	spin_lock(&recall_lock);
>>  	if (fp->fi_had_conflict) {
>>  		spin_unlock(&recall_lock);
>> -		return -EAGAIN;
>> +		status =3D -EAGAIN;
>> +		goto out_free;
>>  	}
>>  	atomic_inc(&fp->fi_delegees);
>>  	list_add(&dp->dl_perfile, &fp->fi_delegations);
>>  	spin_unlock(&recall_lock);
>>  	list_add(&dp->dl_perclnt, &dp->dl_stid.sc_client->cl_delegations);
>>  	return 0;
>> +out_free:
>> +	put_nfs4_file(fp);
>> +	dp->dl_file =3D fp;
>> +	return status;
>>  }
>> =20
>>  static void nfsd4_open_deleg_none_ext(struct nfsd4_open *open, int =
status)
>> @@ -3134,7 +3143,7 @@ nfs4_open_delegation(struct net *net, struct s=
vc_fh *fh,
>>  	dp =3D alloc_init_deleg(oo->oo_owner.so_client, stp, fh);
>>  	if (dp =3D=3D NULL)
>>  		goto out_no_deleg;
>> -	status =3D nfs4_set_delegation(dp);
>> +	status =3D nfs4_set_delegation(dp, stp->st_file);
>>  	if (status)
>>  		goto out_free;
>> =20
>>
>=20
>=20

Today I run latest git tree with a patched UML (this patch + one for xt=
erm issues) and got 2 times a core dump
when I fuzzy test an UML machine with a nearly identical scenario as al=
ready described but just shutdowned
both UML images instead of shooting one of it in the head.

I'll probably need time to figure out a test case, but just as a pre-in=
fo here's the back trace:

tfoerste@n22 ~ $ gdb --core=3D/mnt/ramdisk/core /usr/local/bin/linux-v3=
=2E11-7550-g768c9d3 -n -batch -ex bt

warning: core file may not match specified executable file.
[New LWP 7470]
[New LWP 7479]
[New LWP 7477]
[New LWP 7478]
Core was generated by `/usr/local/bin/linux-v3.11-7550-g768c9d3 earlypr=
intk ubda=3D/home/tfoerste/virtua'.
Program terminated with signal 6, Aborted.
#0  0xb77be424 in __kernel_vsyscall ()
#0  0xb77be424 in __kernel_vsyscall ()
#1  0x083aada5 in kill ()
#2  0x0807163d in uml_abort () at arch/um/os-Linux/util.c:93
#3  0x08071925 in os_dump_core () at arch/um/os-Linux/util.c:138
#4  0x080613a7 in panic_exit (self=3D0x85b1518 <panic_exit_notifier>, u=
nused1=3D0, unused2=3D0x85e76e0 <buf.15920>) at arch/um/kernel/um_arch.=
c:240
#5  0x0809a398 in notifier_call_chain (nl=3D0x0, val=3D0, v=3D0x85e76e0=
 <buf.15920>, nr_to_call=3D-2, nr_calls=3D0x0) at kernel/notifier.c:93
#6  0x0809a4e3 in __atomic_notifier_call_chain (nr_calls=3D<optimized o=
ut>, nr_to_call=3D<optimized out>, v=3D<optimized out>, val=3D<optimize=
d out>, nh=3D<optimized out>) at kernel/notifier.c:182
#7  atomic_notifier_call_chain (nh=3D0x85e76c4 <panic_notifier_list>, v=
al=3D0, v=3D0x85e76e0 <buf.15920>) at kernel/notifier.c:191
#8  0x08408628 in panic (fmt=3D0x0) at kernel/panic.c:128
#9  0x081131c9 in shrink_dcache_for_umount_subtree (dentry=3D0x428028f0=
) at fs/dcache.c:941
#10 0x08113948 in shrink_dcache_for_umount (sb=3D0x463b8000) at fs/dcac=
he.c:1002
#11 0x08101677 in generic_shutdown_super (sb=3D0x463b8000) at fs/super.=
c:404
#12 0x08102395 in kill_anon_super (sb=3D0x0) at fs/super.c:875
#13 0x081d3ff8 in nfs_kill_super (s=3D0x0) at fs/nfs/super.c:2598
#14 0x0810153a in deactivate_locked_super (s=3D0x463b8000) at fs/super.=
c:294
#15 0x081015d1 in deactivate_super (s=3D0x463b8000) at fs/super.c:319
#16 0x08119c0c in mntfree (mnt=3D<optimized out>) at fs/namespace.c:891
#17 mntput_no_expire (mnt=3D0x0) at fs/namespace.c:929
#18 0x0811b195 in SYSC_umount (flags=3D<optimized out>, name=3D<optimiz=
ed out>) at fs/namespace.c:1335
#19 SyS_umount (name=3D134633856, flags=3D2) at fs/namespace.c:1305
#20 0x080618e2 in handle_syscall (r=3D0x498be5d4) at arch/um/kernel/ska=
s/syscall.c:35
#21 0x08073c0d in handle_trap (local_using_sysemu=3D<optimized out>, re=
gs=3D<optimized out>, pid=3D<optimized out>) at arch/um/os-Linux/skas/p=
rocess.c:198
#22 userspace (regs=3D0x498be5d4) at arch/um/os-Linux/skas/process.c:43=
1
#23 0x0805e65c in fork_handler () at arch/um/kernel/process.c:160
#24 0x00000000 in ?? ()



--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
